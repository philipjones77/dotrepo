# CPU smoke checks for the requested R spatial/GP oracle packages.
# Run with ordinary R startup so the user's configured libraries are available:
#   Rscript scripts/check-r-m-tier-oracles.R --output result.json
# Optional: --packages gstat,spacetime (for a focused rerun).
# This script installs nothing. Failure details go to stderr, not the JSON receipt.

args <- commandArgs(trailingOnly = TRUE)
option <- function(name, default = NULL) {
  index <- match(name, args)
  if (is.na(index)) return(default)
  if (index == length(args)) stop("Missing value for ", name)
  args[[index + 1L]]
}
if (!requireNamespace("jsonlite", quietly = TRUE)) stop("jsonlite is required to write the result")
output <- option("--output")
requested <- c("gstat", "spacetime", "fields", "geoR", "spBayes", "laGP", "hetGP", "GpGp", "GPvecchia", "inlabru", "INLA")
selected <- option("--packages")
if (!is.null(selected)) {
  selected <- strsplit(selected, ",", fixed = TRUE)[[1]]
  stopifnot(all(selected %in% requested))
  requested <- selected
}
Sys.setenv(OMP_NUM_THREADS = "2", OPENBLAS_NUM_THREADS = "2")
started <- format(Sys.time(), "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")

distance_matrix <- function(x, y = x) {
  sqrt(pmax(outer(rowSums(x^2), rowSums(y^2), "+") - 2 * tcrossprod(x, y), 0))
}
spatial_data <- function() {
  coords <- as.matrix(expand.grid(x = seq(0, 1, length.out = 4), y = seq(0, 1, length.out = 3)))
  values <- sin(2 * coords[, 1]) + cos(3 * coords[, 2])
  prediction <- matrix(c(.15, .25, .55, .65, .85, .35), ncol = 2, byrow = TRUE)
  covariance <- exp(-distance_matrix(coords) / .4) + diag(.1, nrow(coords))
  cross <- exp(-distance_matrix(prediction, coords) / .4)
  list(coords = coords, values = values, prediction = prediction,
       reference_mean = as.vector(cross %*% solve(covariance, values)))
}
regression_data <- function() {
  x <- seq(-1, 1, length.out = 20)
  data.frame(x = x, y = 1 + 2 * x + .02 * sin(seq_along(x)))
}
checks <- list(
  gstat = function() {
    d <- spatial_data()
    observations <- sp::SpatialPointsDataFrame(d$coords, data.frame(z = d$values))
    fit <- gstat::krige(z ~ 1, observations, sp::SpatialPoints(d$prediction),
                        model = gstat::vgm(1, "Exp", .4, .1), beta = 0, debug.level = 0)
    error <- max(abs(fit$var1.pred - d$reference_mean))
    stopifnot(error < 1e-8, all(is.finite(fit$var1.var)), all(fit$var1.var >= 0))
    list(probe = "Simple kriging agrees with a dense covariance solve", observations = 12,
         predictions = 3, maximum_mean_error = error)
  },
  spacetime = function() {
    points <- sp::SpatialPoints(cbind(x = c(0, 1), y = c(0, 1)))
    times <- as.POSIXct("2026-01-01", tz = "UTC") + (0:2) * 3600
    cube <- spacetime::STFDF(points, times, data.frame(z = 1:6))
    average <- stats::aggregate(cube, by = "space", FUN = mean)
    values <- as.numeric(average)
    stopifnot(length(values) == 3, max(abs(values - c(1.5, 3.5, 5.5))) < 1e-12)
    list(probe = "Space-time cube aggregation reproduces known spatial means", observations = 6,
         maximum_mean_error = max(abs(values - c(1.5, 3.5, 5.5))))
  },
  fields = function() {
    d <- spatial_data()
    y <- 1 + 2 * d$coords[, 1] - 3 * d$coords[, 2]
    fit <- fields::Tps(d$coords, y, lambda = .01)
    predicted <- as.vector(predict(fit, d$prediction))
    reference <- 1 + 2 * d$prediction[, 1] - 3 * d$prediction[, 2]
    error <- max(abs(predicted - reference))
    stopifnot(error < 1e-7)
    list(probe = "Thin-plate spline reproduces an affine surface", observations = 12,
         predictions = 3, maximum_mean_error = error)
  },
  geoR = function() {
    d <- spatial_data()
    geodata <- geoR::as.geodata(cbind(d$coords, z = d$values), coords.col = 1:2, data.col = 3)
    fit <- geoR::krige.conv(geodata, locations = d$prediction,
      krige = geoR::krige.control(type.krige = "sk", beta = 0, cov.model = "exponential",
                                  cov.pars = c(1, .4), nugget = .1),
      output = geoR::output.control(messages = FALSE))
    error <- max(abs(fit$predict - d$reference_mean))
    stopifnot(error < 1e-8, all(is.finite(fit$krige.var)), all(fit$krige.var >= 0))
    list(probe = "Simple kriging agrees with a dense covariance solve", observations = 12,
         predictions = 3, maximum_mean_error = error)
  },
  spBayes = function() {
    d <- spatial_data()
    y <- d$values
    set.seed(1409)
    fit <- spBayes::spLM(y ~ 1, coords = d$coords,
      starting = list(phi = 3, sigma.sq = 1, tau.sq = .1),
      tuning = list(phi = .1, sigma.sq = .05, tau.sq = .02),
      priors = list(beta.Norm = list(0, matrix(100)), phi.Unif = c(.5, 10),
                    sigma.sq.IG = c(2, 1), tau.sq.IG = c(2, .1)),
      cov.model = "exponential", n.samples = 50, verbose = FALSE)
    draws <- as.matrix(fit$p.theta.samples)
    stopifnot(nrow(draws) == 50, all(is.finite(draws)), all(draws > 0))
    recovered <- spBayes::spRecover(fit, start = 26, verbose = FALSE)
    stopifnot(all(is.finite(recovered$p.beta.recover.samples)))
    list(probe = "Spatial Bayesian regression samples covariance parameters and recovers coefficients",
         observations = 12, draws = 50, note = "Short runtime probe; does not assess MCMC convergence")
  },
  laGP = function() {
    x <- matrix(seq(0, 1, length.out = 12), ncol = 1)
    y <- sin(2 * pi * x[, 1])
    model <- laGP::newGP(x, y, d = .2, g = 1e-6, dK = TRUE)
    on.exit(laGP::deleteGP(model))
    predicted <- laGP::predGP(model, x, lite = TRUE)
    error <- max(abs(predicted$mean - y))
    stopifnot(error < .01, all(is.finite(predicted$s2)), all(predicted$s2 >= 0),
              is.finite(laGP::llikGP(model)))
    list(probe = "Native GP likelihood and near-interpolating predictions", observations = 12,
         maximum_mean_error = error)
  },
  hetGP = function() {
    x <- matrix(rep(seq(0, 1, length.out = 8), each = 3), ncol = 1)
    y <- sin(2 * pi * x[, 1]) + rep(c(-1, 0, 1), 8) * (.04 + .1 * x[, 1])
    model <- hetGP::mleHetGP(x, y, lower = .02, upper = 2, maxit = 60,
                            settings = list(checkHom = FALSE))
    predicted <- predict(model, matrix(seq(0, 1, length.out = 8), ncol = 1))
    stopifnot(all(is.finite(predicted$mean)), all(is.finite(predicted$sd2)),
              all(predicted$sd2 >= 0), all(is.finite(predicted$nugs)), all(predicted$nugs > 0))
    error <- max(abs(predicted$mean - sin(2 * pi * seq(0, 1, length.out = 8))))
    stopifnot(error < .25)
    list(probe = "Replicated heteroskedastic GP fit and positive predictive noise", observations = 24,
         unique_locations = 8, maximum_mean_error = error)
  },
  GpGp = function() {
    d <- spatial_data()
    parameters <- c(1, .4, .1)
    neighbours <- GpGp::find_ordered_nn(d$coords, nrow(d$coords) - 1)
    fit <- GpGp::vecchia_meanzero_loglik(parameters, "exponential_isotropic", d$values, d$coords, neighbours)
    covariance <- GpGp::exponential_isotropic(parameters, d$coords)
    reference <- -.5 * (length(d$values) * log(2 * pi) + as.numeric(determinant(covariance, logarithm = TRUE)$modulus) +
                         sum(d$values * solve(covariance, d$values)))
    error <- abs(fit$loglik - reference)
    stopifnot(is.finite(error), error < 1e-8)
    list(probe = "All-neighbour Vecchia likelihood agrees with a dense Gaussian likelihood",
         observations = 12, absolute_log_likelihood_error = error)
  },
  GPvecchia = function() {
    locations <- matrix(seq(0, 1, length.out = 10), ncol = 1)
    y <- sin(3 * locations[, 1])
    approximation <- GPvecchia::vecchia_specify(locations, m = 9)
    loglik <- GPvecchia::vecchia_likelihood(y, approximation, covparms = c(1, .4, .5), nuggets = .1)
    covariance <- GPvecchia::MaternFun(distance_matrix(locations), c(1, .4, .5)) + diag(.1, 10)
    reference <- -.5 * (10 * log(2 * pi) + as.numeric(determinant(covariance, logarithm = TRUE)$modulus) +
                         sum(y * solve(covariance, y)))
    error <- abs(loglik - reference)
    stopifnot(length(error) == 1, is.finite(error), error < 1e-7)
    list(probe = "All-neighbour Vecchia likelihood agrees with a dense Matern likelihood",
         observations = 10, absolute_log_likelihood_error = error)
  },
  inlabru = function() {
    d <- regression_data()
    fit <- inlabru::bru(y ~ x + Intercept(1), family = "gaussian", data = d,
                        options = list(verbose = FALSE, bru_verbose = 0, num.threads = "1:1"))
    coefficients <- fit$summary.fixed$mean
    stopifnot(length(coefficients) == 2, all(is.finite(coefficients)),
              max(abs(sort(coefficients) - c(1, 2))) < .05)
    list(probe = "INLA-backed Gaussian regression recovers known linear coefficients", observations = 20,
         maximum_coefficient_error = max(abs(sort(coefficients) - c(1, 2))))
  },
  INLA = function() {
    d <- regression_data()
    fit <- INLA::inla(y ~ 1 + x, family = "gaussian", data = d, num.threads = "1:1", verbose = FALSE)
    coefficients <- fit$summary.fixed$mean
    stopifnot(length(coefficients) == 2, all(is.finite(coefficients)),
              max(abs(coefficients - c(1, 2))) < .05)
    list(probe = "INLA native backend fits a Gaussian regression", observations = 20,
         maximum_coefficient_error = max(abs(coefficients - c(1, 2))))
  }
)

results <- lapply(requested, function(package) {
  began <- proc.time()[["elapsed"]]
  version <- tryCatch(unname(packageDescription(package, fields = "Version")), error = function(e) NA_character_)
  namespace_passed <- FALSE
  result <- tryCatch({
    loadNamespace(package)
    namespace_passed <- TRUE
    details <- checks[[package]]()
    list(passed = TRUE, details = details)
  }, error = function(e) {
    message(package, ": ", conditionMessage(e))
    list(passed = FALSE, note = "Check failed; inspect stderr for details")
  })
  c(list(package = package, version = version, namespace_passed = namespace_passed,
         elapsed_seconds = round(proc.time()[["elapsed"]] - began, 3)), result)
})
names(results) <- requested
passed <- all(vapply(results, function(result) isTRUE(result$passed), logical(1)))
receipt <- list(started_at = started, finished_at = format(Sys.time(), "%Y-%m-%dT%H:%M:%SZ", tz = "UTC"),
                r_version = as.character(getRversion()), passed = passed,
                scope = "CPU smoke checks on small synthetic datasets; no full statistical, convergence, performance, or GPU certification.",
                packages = results)
if (is.null(output)) {
  cat(jsonlite::toJSON(receipt, pretty = TRUE, auto_unbox = TRUE, na = "null"), "\n")
} else {
  jsonlite::write_json(receipt, output, pretty = TRUE, auto_unbox = TRUE, na = "null")
}
quit(status = if (passed) 0 else 1)

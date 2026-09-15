# CPU numerical checks for additional RF77 R oracles; installs nothing.
# Use ordinary R startup and explicitly select py313 with RETICULATE_PYTHON.
# Optional: --packages CVXR,autoFRK,loggle,deepspat --output receipt.json
args <- commandArgs(trailingOnly=TRUE)
option <- function(name, default=NULL) {
  index <- match(name,args)
  if(is.na(index)) return(default)
  if(index==length(args)) stop('Missing value for ',name)
  args[[index+1L]]
}
requested <- strsplit(option('--packages','CVXR,autoFRK,loggle,deepspat'),',',fixed=TRUE)[[1]]
stopifnot(all(requested %in% c('CVXR','autoFRK','loggle','deepspat')))
output <- option('--output')
stopifnot(requireNamespace('jsonlite',quietly=TRUE))
Sys.setenv(RETICULATE_USE_MANAGED_VENV='no')
results <- list()
probe <- function(package, expr) {
  if(!package %in% requested) return(invisible(NULL))
  tryCatch({
    stopifnot(requireNamespace(package,quietly=TRUE))
    metrics <- force(expr)
    results[[package]] <<- list(package=package,version=as.character(packageVersion(package)),status='passed',metrics=metrics)
  },error=function(e) {
    results[[package]] <<- list(package=package,status='failed',error=conditionMessage(e))
  })
}
probe('CVXR',{
  x <- CVXR::Variable(2)
  problem <- CVXR::Problem(CVXR::Minimize(CVXR::sum_squares(x-c(1,-1))),list(x>=0))
  fit <- CVXR::psolve(problem,solver='CLARABEL')
  optimum <- as.numeric(CVXR::value(x))
  stopifnot(length(optimum)==2L,max(abs(optimum-c(1,0)))<1e-4)
  list(probe='Two-variable constrained convex quadratic; analytic solution (1,0)',solution=optimum)
})
probe('autoFRK',{
  set.seed(42)
  loc <- cbind(runif(50),runif(50))
  y <- sin(2*pi*loc[,1])+cos(2*pi*loc[,2])+rnorm(50,sd=.1)
  fit <- autoFRK::autoFRK(Data=matrix(y),loc=loc)
  basis <- as.matrix(fit$G)
  stopifnot(nrow(basis)==50L,ncol(basis)>0L,all(is.finite(basis)))
  list(probe='50-point spatial rank selection using RF77 reference harness data',basis_shape=dim(basis))
})
probe('loggle',{
  set.seed(3)
  x <- matrix(rnorm(120),3,40)
  x[2,] <- x[2,]+.4*x[1,]
  checks <- lapply(c('likelihood','pseudo','space'),function(mode) {
    fit <- loggle::loggle(x,pos=c(10,20,30),h=.4,d=.2,lambda=.2,fit.type=mode,refit=TRUE,max.step=100,num.thread=1,print.detail=FALSE)
    stopifnot(length(fit$Omega)==3L)
    mins <- vapply(fit$Omega,function(o) {
      m <- as.matrix(o)
      stopifnot(all(is.finite(m)),max(abs(m-t(m)))<1e-6)
      min(eigen(m,symmetric=TRUE,only.values=TRUE)$values)
    },numeric(1))
    stopifnot(all(mins>0))
    list(mode=mode,minimum_eigenvalues=mins)
  })
  list(probe='Three-variable, 40-timepoint local graphical lasso; likelihood, pseudo and space modes with model refitting; 3 SPD precision estimates per mode',checks=checks)
})
probe('deepspat',{
  stopifnot(requireNamespace('deepspat',quietly=TRUE))
  set.seed(4)
  df <- data.frame(s1=runif(12),s2=runif(12))
  df$z <- sin(3*df$s1)+cos(2*df$s2)+rnorm(12,sd=.05)
  layers <- c(deepspat::AWU(r=4L,dim=1L,grad=10,lims=c(-.5,.5)),deepspat::AWU(r=4L,dim=2L,grad=10,lims=c(-.5,.5)))
  fit <- deepspat::deepspat_GP(z~s1+s2-1,data=df,g=~1,layers=layers,family='exp_nonstat',nsteps=1L)
  cost <- as.numeric(fit$Cost)
  warped <- as.matrix(fit$swarped_tf$numpy())
  stopifnot(is.finite(cost),identical(dim(warped),c(12L,2L)),all(is.finite(warped)),fit$nlayers==2L)
  list(package='deepspat',version=as.character(packageVersion('deepspat')),status='passed',probe='12-point nonstationary GP; two 4-basis axial-warp layers; 1 step per optimization phase',cost=cost,warped_shape=dim(warped),tensorflow=as.character(tensorflow::tf$`__version__`),python='py313',library='active')
})

payload <- jsonlite::toJSON(results,auto_unbox=TRUE,pretty=TRUE)
if(!is.null(output)) writeLines(payload,output)
cat(payload,'\n')
if(any(vapply(results,function(r) r$status!='passed',logical(1)))) quit(status=1)

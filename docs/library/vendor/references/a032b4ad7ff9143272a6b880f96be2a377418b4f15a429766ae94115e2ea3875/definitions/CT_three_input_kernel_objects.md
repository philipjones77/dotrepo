# Three-Input Kernel Objects (CT)

---

*Status*: WORKING
*Version*: v0.1
*Date*: 2026-03-17

Lightweight object note for newly instantiated three-input kernels that do not
yet belong in the older one-input or two-input catalogs.

## 1. `Stein4-E3SMM`

* `kernel_name`: Stein Euclidean-Euclidean-Euclidean Matérns kernel
* `call_notation`: `Stein4-E3SMM`
* `runtime_kernel_id`: `stein_three_euclidean`
* `aliases`: `Stein4-E3SMM`
* `domain_product_symbol`: `E^{d_1} x E^{d_2} x E^{d_3}`
* `input_arity`: 3
* `representation_ids`:
  * `RF-SPEC-01`
* `construction_summary`:
  additive Stein-style blockwise spectral terms with a shared outer power over
  three ordered Euclidean blocks
* `spectral_form`:

  `f(xi_1, xi_2, xi_3) = gamma * {`

  `eps_S1 (kappa_S1^2 + ||xi_1||^2)^{alpha_S1} +`

  `eps_S2 (kappa_S2^2 + ||xi_2||^2)^{alpha_S2} +`

  `eps_S3 (kappa_S3^2 + ||xi_3||^2)^{alpha_S3}`

  `}^{-nu}`

* `runtime_routes`:
  * `direct_quadrature`
  * `spectral_direct`
* `backend_support`:
  * NumPy
  * JAX
* `notes`:
  This entry extends the Stein SSMM family to a dedicated three-input
  Euclidean path without changing the existing one-input or two-input kernel
  catalogs.

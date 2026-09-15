// Build compatibility header for the upstream MKL CBLAS/LAPACK calls.
#pragma once
#include <cblas.h>
#include <lapacke.h>
static inline void rf77_dpotrf(const char* uplo, const int* n, double* a,
                              const int* lda, int* info) {
    *info = LAPACKE_dpotrf(LAPACK_COL_MAJOR, *uplo, *n, a, *lda);
}
static inline void rf77_dtrtrs(const char* uplo, const char* trans,
                              const char* diag, const int* n,
                              const int* nrhs, const double* a,
                              const int* lda, double* b,
                              const int* ldb, int* info) {
    *info = LAPACKE_dtrtrs(LAPACK_COL_MAJOR, *uplo, *trans, *diag,
                          *n, *nrhs, a, *lda, b, *ldb);
}
#define dpotrf_ rf77_dpotrf
#define dtrtrs_ rf77_dtrtrs

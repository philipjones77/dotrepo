#include <Eigen/Dense>
#include <armadillo>
#include <lapacke.h>
#include <cmath>
#include <iostream>

int main() {
    Eigen::Matrix2d a;
    a << 4, 1, 1, 3;
    Eigen::Vector2d b(1, 2);
    auto x = a.ldlt().solve(b).eval();
    if ((a * x - b).norm() > 1e-12) return 1;
    arma::mat aa = {{4, 1}, {1, 3}};
    arma::vec bb = {1, 2};
    arma::vec xx = arma::solve(aa, bb);
    if (arma::norm(aa * xx - bb) > 1e-12) return 2;
    double lap_a[] = {4, 1, 1, 3}, lap_b[] = {1, 2};
    lapack_int piv[2];
    if (LAPACKE_dgesv(LAPACK_ROW_MAJOR, 2, 1, lap_a, 2, piv, lap_b, 1)) return 3;
    for (int i = 0; i < 2; ++i)
        if (std::abs(lap_b[i] - x[i]) > 1e-12 || std::abs(xx[i] - x[i]) > 1e-12) return 4;
    std::cout << "Eigen Armadillo LAPACKE equivalent solves passed\n";
}

#include "headers\modulus.hpp"

unsigned int inverseModulus(unsigned int a, unsigned int m) {
    a %= m;

    if (a == 0) {
        return 0;
    };

    long long original_m = m;
    long long x0 = 1;
    long long x1 = 0;

    while (a > 1) {
        long long q = a / m;
        long long t = m;

        m = a % m;
        a = t;

        t = x1;
        x1 = x0 - q * x1;
        x0 = t;
    }

    if (x0 < 0) {
        x0 += original_m;
    }

    return static_cast<unsigned int>(x0);
};
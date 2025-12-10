#include <iostream>
#include <string>
#include <vector>
#include <sstream>
#include <iomanip>
#include <random>

#ifdef _WIN32
#include <windows.h>
#else
#include <chrono>

DWORD GetTickCount() {
    using namespace std::chrono;
    return static_cast<DWORD>(duration_cast<milliseconds>(steady_clock::now().time_since_epoch()).count());
}
#endif

struct LFSR_Params {
    uint32_t seed;
    uint32_t tap;
};

// Random device global para evitar overhead e inconsistencias
static std::random_device rd;

// Tabla limpia de polinomios primitivos para un LFSR de 32 bits (Fibonacci)
static constexpr uint32_t primitive_polynomials_32[] = {
    0x80000057, // x^32 + x^6 + x^4 + x^1 + 1
    0x8000001B, // x^32 + x^4 + x^3 + x^1 + 1
    0x8000000D, // x^32 + x^3 + x^2 + 1
    0xA3000000, // uno de los más usados en RNG hardware
    0xB4000000  // polinomio estándar
};

static constexpr unsigned int primes[] = {
    251, 241, 239, 233, 229, 227, 223, 211, 199, 197, 193,
    191, 181, 179, 173, 167, 163, 157, 151, 149, 139, 137,
    131, 127, 113, 109, 107, 103, 101,  97,  89,  83,  79,
     73,  71,  67,  61,  59,  53,  47,  43,  41,  37,  31,
     29,  23,  19,  17,  13,  11,   7,   5,   3
};

LFSR_Params generate_random_lfsr() {
    LFSR_Params p;

    uint32_t raw_seed = rd();
    if (raw_seed == 0) raw_seed = 1;
    p.seed = raw_seed | 1; 

    constexpr size_t count = sizeof(primitive_polynomials_32) / sizeof(uint32_t);
    p.tap = primitive_polynomials_32[rd() % count];

    return p;
}

int main() {
    auto LFSR = generate_random_lfsr();

    const unsigned int LFSR_SEED = LFSR.seed;
    const unsigned int LFSR_TAP = LFSR.tap;
    const unsigned int ROTATION_BITS = (rd() % 7) + 1;
    const unsigned int MODULUS = primes[ rd() % (sizeof(primes)/sizeof(unsigned int)) ];
    const unsigned int MULTIPLIER = ( rd() % (MODULUS - 2)) + 2;
}
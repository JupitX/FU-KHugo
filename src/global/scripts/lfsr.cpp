#include "headers\lfsr.hpp"

const uint32_t polynomials[] = {
    0x80000057,
    0x8000001B,
    0x8000000D,
    0xA3000000,
    0xB4000000
};

const unsigned int primes[] = {
    251, 241, 239, 233, 229, 227, 223, 211, 199, 197, 193,
    191, 181, 179, 173, 167, 163, 157, 151, 149, 139, 137,
    131, 127, 113, 109, 107, 103, 101,  97,  89,  83,  79,
    73,  71,  67,  61,  59,  53,  47,  43,  41,  37,  31,
    29,  23,  19,  17,  13,  11,   7,   5,   3
};

std::random_device random;

LFSRParameters LFSRRandom() {
    LFSRParameters LFSR;

    constexpr size_t count = sizeof(polynomials) / sizeof(uint32_t);
    uint32_t rawSeed = random();

    if (rawSeed == 0) {
        rawSeed = 1;
    }

    LFSR.seed = rawSeed | 1;
    LFSR.tap = polynomials[random() % count];

    return LFSR;
}

unsigned int LFSRNext(unsigned int &state, uint32_t tap) {
    unsigned int tappedBits = state & tap;

    state << 1;

    if (tappedBits != 0) {
        state ^= 0x04C11DB7;
    }

    return state;
}
#pragma once
#include <string>
#include <random>

struct LFSRParameters {
    uint32_t seed;
    uint32_t tap;
};

extern const uint32_t polynomials[5];
extern const unsigned int primes[53];
extern std::random_device random;

unsigned int LFSRNext(unsigned int &state, uint32_t tap);
LFSRParameters LFSRRandom();
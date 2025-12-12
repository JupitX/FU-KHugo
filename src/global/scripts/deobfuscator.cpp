#include "headers\rotation.hpp"
#include "headers\modulus.hpp"
#include "headers\lfsr.hpp"

#include <string>
#include <vector>
#include <windows.h>

std::string deobfuscate(
    const std::vector<uint8_t>& input,
    const std::vector<unsigned int>& keys,
    DWORD masterKey,
    const LFSRParameters& LFSR,
    unsigned int ROTBits,
    unsigned int multiplier) {

    std::string out;

    unsigned int state = masterKey ^ LFSR.seed;
    unsigned int invMultiplier = inverseModulus(multiplier, 256);

    for (size_t i = 0; i < input.size(); i++) {

        uint8_t val = input[i];

        val = static_cast<uint8_t>(val * invMultiplier);
        val = static_cast<uint8_t>(val - i);
        val = ROTL(val, ROTBits);

        unsigned int key = LFSRNext(state, LFSR.tap);
        val ^= (key & 0xFF);

        out.push_back(static_cast<char>(val));
    }

    return out;
}
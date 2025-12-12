#include "headers\obfuscator.hpp"
#include "headers\rotation.hpp"

std::vector<uint8_t> obfuscate(
    const std::string& input,
    std::vector<unsigned int>& keys,
    DWORD& masterKey,
    const LFSRParameters& LFSR,
    unsigned int ROTBits,
    unsigned int multiplier) {

    std::vector<uint8_t> output;

    masterKey = GetTickCount();
    unsigned int state = masterKey ^ LFSR.seed;

    for (size_t i = 0; i < input.size(); i++) {

        uint8_t val = (uint8_t)input[i];

        unsigned int key = LFSRNext(state, LFSR.tap);
        keys.push_back(key);

        val ^= (key & 0xFF);

        val = ROTR(val, ROTBits);

        val = static_cast<uint8_t>(val + i);

        val = static_cast<uint8_t>(val * multiplier);

        output.push_back(val);
    }

    return output;
}
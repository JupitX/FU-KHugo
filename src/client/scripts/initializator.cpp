#include "..\..\assets\obfuscated\obfuscatedString.hpp"
#include "..\..\global\scripts\headers\deobfuscator.hpp"

#include <iostream>

int main() {
    const std::vector<uint8_t> OBFUSCATED = data;
    const std::vector<unsigned int> KEYS = keys;
    const DWORD MASTERKEY = masterKey;
    const LFSRParameters LFSR = LFSR;
    const unsigned int ROTATION_BITS = ROTBits;
    const unsigned int MULTIPLIER = multiplier;

    std::string licenseServer = deobfuscate(OBFUSCATED, KEYS, MASTERKEY, LFSR, ROTATION_BITS, MULTIPLIER);
    std::cout << "IP: " << licenseServer;
}
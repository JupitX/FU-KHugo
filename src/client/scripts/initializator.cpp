#include "..\..\assets\obfuscated\obfuscatedString.hpp"
#include "..\..\global\scripts\headers\deobfuscator.hpp"

#include <iostream>

int main() {
    const std::vector<uint8_t> OBFUSCATED = data;
    const std::vector<uint32_t> KEYS = keys;
    const DWORD MASTERKEY = masterKey;
    const LFSRParameters shift = LFSR;
    const unsigned int ROTATION_BITS = ROTBits;
    const unsigned int MULTIPLIER = multiplier;

    std::string licenseServer = deobfuscate(OBFUSCATED, KEYS, MASTERKEY, shift, ROTATION_BITS, MULTIPLIER);
    std::cout << "IP: " << licenseServer << "\n";

    std::cout << "------------------------------\n";
    std::cout << "--- OBFUSCATION PARAMETERS ---\n";
    std::cout << "------------------------------\n\n";
    std::cout << "LFSR_SEED: " << std::hex << shift.seed << "\n";
    std::cout << "LFSR_TAP:  " << std::hex << shift.tap << "\n";
    std::cout << "ROTATION_BITS: " << ROTATION_BITS << "\n";
    std::cout << "MULTIPLIER: " << MULTIPLIER << "\n";

    std::cout << "------------------------------\n";
    std::cout << "------- INTEGRITY KEYS -------\n";
    std::cout << "------------------------------\n\n";
    std::cout << "KEYS: ";

    for (size_t i = 0; i < keys.size(); i++) {
        std::cout << std::hex << keys[i] << ",";
    }

    std::cout << "\n\n";

    std::cout << "------------------------------\n";
    std::cout << "--------- MASTER KEY ---------\n";
    std::cout << "------------------------------\n\n";
    std::cout << "Master Key: " << std::hex << masterKey << "\n";

    std::cout << "------------------------------\n";
    std::cout << "------ DEOBFUCATED DATA ------\n";
    std::cout << "------------------------------\n\n";
    std::cout << "CLEARTEXT: " << licenseServer << "\n";

}
#include "..\functions\headers\parseFunctions.hpp"
#include "headers\rotation.hpp"
#include "headers\obfuscator.hpp"
#include "headers\deobfuscator.hpp"
#include "headers\modulus.hpp"
#include "headers\lfsr.hpp"

#include <iostream>
#include <iomanip>
#include <string>
#include <vector>
#include <windows.h>

unsigned int mode = 0;
std::string input;
std::string file;
std::vector<unsigned int> keys;
DWORD masterKey;
uint32_t LFSRSeed;
uint32_t LFSRTap;
unsigned int ROTBits;
unsigned int multiplier;
std::string path;

int main(int argc, char* argv[]) {

    // ---------------------------------------------------------
    // OBTAINING OF ARGUMENTS
    // ---------------------------------------------------------

    for (int counter = 1; counter < argc; ++counter) {
        std::string argument = argv[counter];

        if (argument == "-o" || argument == "--obfuscate") {
            mode = 1;
        } else if (argument == "-d" || argument == "--deobfuscate") {
            mode = 2;
        } else if (argument == "-i" || argument == "--input") {
            input = argv[++counter];
        } else if (argument == "-f" || argument == "--file") {
            file = (std::string)argv[++counter];
        } else if (argument == "-k" || argument == "--keys") {
            std::string raw = argv[++counter];
            std::stringstream ss(raw);
            std::string piece;

            while(std::getline(ss, piece, ',')) {
                keys.push_back(std::stoul(piece));
            }

        } else if (argument == "-m" || argument == "--master") {
            masterKey = std::stoul(argv[++counter]);
        } else if (argument == "-s" || argument == "--seed") {
            LFSRSeed = static_cast<uint32_t>(std::stoul(argv[++counter]));
        } else if (argument == "-t" || argument == "--tap") {
            LFSRTap = static_cast<uint32_t>(std::stoul(argv[++counter]));
        } else if (argument == "-r" || argument == "--rotation") {
            ROTBits = static_cast<unsigned int>(std::stoul(argv[++counter]));
        } else if (argument == "-x" || argument == "--multiplier") {
            multiplier = static_cast<unsigned int>(std::stoul(argv[++counter]));  
        } else if (argument == "-e" || argument == "--export") {
            path = (std::string)argv[++counter];
        } else {
            std::cerr << "[!] ERROR: Argument" << argument << "not recognized";
            return 1;
        }
    }

    // ---------------------------------------------------------
    // VALIDATION OF ARGUMENTS
    // ---------------------------------------------------------

    bool hasInput = !input.empty();
    bool hasFile = !file.empty();
    bool hasPath = !path.empty();

    if (mode == 0) {
        std::cerr << "[!] ERROR: You must use -i/--obfuscate or -d/--deobfuscate.\n";
        return 1;
    }

    if (!hasInput && !hasFile) {
        std::cerr << "[!] ERROR: You must select -i or -f to operate with data.\n";
        return 1;
    }

    if (hasInput && hasFile) {
        std::cerr << "[!] ERROR: You cannot use -i and -f at the same time.\n";
        return 1;
    }

    // ---------------------------------------------------------
    // OBFUSCATION
    // ---------------------------------------------------------

    if (mode == 1) {
        if (!keys.empty() || masterKey || LFSRSeed || LFSRTap || ROTBits || multiplier) {
            std::cerr << "[!] ERROR: You cannot use deobfuscation parameters in obfuscation mode.\n";
            return 1;
        }
        
        if (input.empty()) {
            std::cerr << "[!] ERROR: Input cannot be empty";
        }

        auto LFSR = LFSRRandom();

        const unsigned int LFSR_SEED = LFSR.seed;
        const unsigned int LFSR_TAP = LFSR.tap;
        const unsigned int ROTATION_BITS = (random() % 7) + 1;
        const unsigned int MODULUS = primes[ random() % (sizeof(primes)/sizeof(unsigned int)) ];
        const unsigned int MULTIPLIER = ( random() % (MODULUS - 2)) + 2;
        const unsigned int MULTIPLIERINV = inverseModulus(MULTIPLIER, MODULUS);

        std::vector<uint8_t> data = obfuscate(input, keys, masterKey, LFSR, ROTATION_BITS, MULTIPLIER);
            
        std::cout << "------------------------------\n";
        std::cout << "--- OBFUSCATION PARAMETERS ---\n";
        std::cout << "------------------------------\n\n";
        std::cout << "LFSR_SEED: 0x" << std::hex << LFSR_SEED << std::dec << " // " << LFSR_SEED << "\n";
        std::cout << "LFSR_TAP:  0x" << std::hex << LFSR_TAP << std::dec << " // " << LFSR_TAP << "\n";
        std::cout << "ROTATION_BITS: " << ROTATION_BITS << "\n";
        std::cout << "MODULUS: " << MODULUS << "\n";
        std::cout << "MULTIPLIER: " << MULTIPLIER << "\n";
        std::cout << "INVERTED MULTIPLIER: " << MULTIPLIERINV << "\n\n";

        std::cout << "------------------------------\n";
        std::cout << "----- OBFUSCATED RESULTS -----\n";
        std::cout << "------------------------------\n\n";
        std::cout << "CLEARTEXT: " << input << "\n";
        std::cout << "CIPHERTEXT: ";

        for (size_t i = 0; i < data.size(); i++) {
        unsigned int v = static_cast<unsigned int>(static_cast<uint8_t>(data[i]));

        std::cout 
            << "0x"
            << std::uppercase
            << std::hex
            << std::setw(2)
            << std::setfill('0')
            << v;

        if (i != data.size() - 1)
            std::cout << ", ";
        }

        std::cout << "\n\n";

        std::cout << "------------------------------\n";
        std::cout << "------- INTEGRITY KEYS -------\n";
        std::cout << "------------------------------\n\n";
        std::cout << "KEYS: ";

        for (size_t i = 0; i < keys.size(); i++) {
            std::cout << "0x" << std::hex << keys[i] << std::dec << (i == keys.size() - 1 ? "" : ", ");
        }

        std::cout << "\n\n";

        std::cout << "------------------------------\n";
        std::cout << "--------- MASTER KEY ---------\n";
        std::cout << "------------------------------\n\n";
        std::cout << "Master Key (DWORD): " << masterKey << "\n";
        std::cout << "Master Key (Hex): 0x" << std::hex << masterKey << std::dec << "\n";

    }

    if (mode == 2) {

        if (keys.empty()) {
            std::cerr << "[!] ERROR: Missing -k / --keys.\n";
            return 1;
        }
        if (!masterKey) {
            std::cerr << "[!] ERROR: Missing -m / --master.\n";
            return 1;
        }
        if (!LFSRSeed) {
            std::cerr << "[!] ERROR: Missing -s / --seed.\n";
            return 1;
        }
        if (!LFSRTap) {
            std::cerr << "[!] ERROR: Missing -t / --tap.\n";
            return 1;
        }
        if (!ROTBits) {
            std::cerr << "[!] ERROR: Missing -r / --rotation.\n";
            return 1;
        }
        if (!multiplier) {
            std::cerr << "[!] ERROR: Missing -x / --multiplier.\n";
            return 1;
        }

        const unsigned int LFSR_SEED = LFSRSeed;
        const unsigned int LFSR_TAP = LFSRTap;
        const unsigned int ROTATION_BITS = ROTBits;
        const unsigned int MULTIPLIER = multiplier;

        LFSRParameters LFSR;
        LFSR.seed = LFSRSeed;
        LFSR.tap = LFSRTap;

        std::vector<uint8_t> data = parseHexString(input);

        std::string cleartext = deobfuscate(data, keys, masterKey, LFSR, ROTATION_BITS, MULTIPLIER);

        std::cout << "------------------------------\n";
        std::cout << "--- OBFUSCATION PARAMETERS ---\n";
        std::cout << "------------------------------\n\n";
        std::cout << "LFSR_SEED: 0x" << std::hex << LFSR_SEED << std::dec << " // " << LFSR_SEED << "\n";
        std::cout << "LFSR_TAP:  0x" << std::hex << LFSR_TAP << std::dec << " // " << LFSR_TAP << "\n";
        std::cout << "ROTATION_BITS: " << ROTATION_BITS << "\n";
        std::cout << "MULTIPLIER: " << MULTIPLIER << "\n";

        std::cout << "------------------------------\n";
        std::cout << "------- INTEGRITY KEYS -------\n";
        std::cout << "------------------------------\n\n";
        std::cout << "KEYS: ";

        for (size_t i = 0; i < keys.size(); i++) {
            std::cout << "0x" << std::hex << keys[i] << std::dec << (i == keys.size() - 1 ? "" : ", ");
        }

        std::cout << "\n\n";

        std::cout << "------------------------------\n";
        std::cout << "--------- MASTER KEY ---------\n";
        std::cout << "------------------------------\n\n";
        std::cout << "Master Key (DWORD): " << masterKey << "\n";
        std::cout << "Master Key (Hex): 0x" << std::hex << masterKey << std::dec << "\n";

        std::cout << "------------------------------\n";
        std::cout << "------ DEOBFUCATED DATA ------\n";
        std::cout << "------------------------------\n\n";
        std::cout << "CIPHERTEXT: " << input << "\n";
        std::cout << "CLEARTEXT: " << cleartext << "\n";
    }

    return 0;
}
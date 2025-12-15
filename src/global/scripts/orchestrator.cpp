#include "..\functions\headers\parseFunctions.hpp"
#include "headers\rotation.hpp"
#include "headers\obfuscator.hpp"
#include "headers\deobfuscator.hpp"
#include "headers\modulus.hpp"
#include "headers\lfsr.hpp"

#include <iostream>
#include <fstream>
#include <iomanip>
#include <string>
#include <vector>
#include <windows.h>
#include <filesystem>

unsigned int mode = 0;
std::string input;
std::string file;
std::vector<unsigned int> keys;
DWORD masterKey;
uint32_t LFSRSeed;
uint32_t LFSRTap;
unsigned int ROTBits;
unsigned int multiplier;
unsigned int modulus;
std::string path;

std::filesystem::path obfuscatedPath = std::filesystem::path("..") / ".." / "assets" / "obfuscated";

std::filesystem::path obfuscatedHeaderPath = std::filesystem::path(obfuscatedPath) / "obfuscatedString.hpp";
std::filesystem::path obfuscatedScriptPath = std::filesystem::path(obfuscatedPath) / "obfuscatedString.cpp";

int main(int argc, char* argv[]) {
    // ---------------------------------------------------------
    // OBTAINING OF ARGUMENTS
    // ---------------------------------------------------------

    for (int counter = 1; counter < argc; ++counter) {
        std::string argument = argv[counter];
        // ---------------- MODE ----------------
        if (argument == "-o" || argument == "--obfuscate") {
            mode = 1;
        }
        else if (argument == "-d" || argument == "--deobfuscate") {
            mode = 2;
        }

        // ---------------- INPUT / FILE ----------------
        else if ((argument == "-i" || argument == "--input") && counter + 1 < argc) {
            input = argv[++counter];  // hex string, luego parseHexString()
            continue;
        }
        else if ((argument == "-f" || argument == "--file") && counter + 1 < argc) {
            file = argv[++counter];
            continue;
        }

        // ---------------- KEYS ----------------
        else if ((argument == "-k" || argument == "--keys") && counter + 1 < argc) {
            std::string raw = argv[++counter];
            std::stringstream ss(raw);
            std::string piece;

            while (std::getline(ss, piece, ',')) {
                // limpiar espacios
                piece.erase(0, piece.find_first_not_of(" \t"));
                piece.erase(piece.find_last_not_of(" \t") + 1);

                keys.push_back(
                    static_cast<unsigned int>(std::stoul(piece, nullptr, 16))
                );
            }

            continue;
        }

        // ---------------- MASTER KEY ----------------
        else if ((argument == "-m" || argument == "--master") && counter + 1 < argc) {
            masterKey = static_cast<DWORD>(
                std::stoul(argv[++counter], nullptr, 16)
            );
            continue;
        }

        // ---------------- LFSR ----------------
        else if ((argument == "-s" || argument == "--seed") && counter + 1 < argc) {
            LFSRSeed = static_cast<uint32_t>(
                std::stoul(argv[++counter], nullptr, 16)
            );
            continue;
        }
        else if ((argument == "-t" || argument == "--tap") && counter + 1 < argc) {
            LFSRTap = static_cast<uint32_t>(
                std::stoul(argv[++counter], nullptr, 16)
            );
            continue;
        }

        // ---------------- ROTATION / MULTIPLIER ----------------
        else if ((argument == "-r" || argument == "--rotation") && counter + 1 < argc) {
            ROTBits = static_cast<unsigned int>(std::stoul(argv[++counter]));
            continue;
        }
        else if ((argument == "-x" || argument == "--multiplier") && counter + 1 < argc) {
            multiplier = static_cast<unsigned int>(std::stoul(argv[++counter]));
            continue;
        }

        // ---------------- EXPORT ----------------
        else if ((argument == "-e" || argument == "--export") && counter + 1 < argc) {
            path = argv[++counter];
            continue;
        } else if (argument == "--mod") {
            modulus = static_cast<unsigned int>(std::stoul(argv[++counter]));
            continue;
        }
        // ---------------- ERROR ----------------
        else {
            std::cerr << "[!] ERROR: Argument not recognized -> " << argument << "\n";
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
        const unsigned int MODULUS = 256;
        unsigned int MULTIPLIER = (random() % 128) * 2 + 1;
        const unsigned int MULTIPLIERINV = inverseModulus(MULTIPLIER, MODULUS);

        std::vector<uint8_t> data = obfuscate(input, keys, masterKey, LFSR, ROTATION_BITS, MULTIPLIER);
        
        std::vector<uint8_t> hexData;
        hexData.reserve(data.size());

        for (size_t i = 0; i < data.size(); i++) {
            hexData.push_back(static_cast<uint8_t>(data[i]));
        }
            
        std::cout << "------------------------------\n";
        std::cout << "--- OBFUSCATION PARAMETERS ---\n";
        std::cout << "------------------------------\n\n";
        std::cout << "LFSR_SEED: 0x" << std::hex << LFSR_SEED << std::dec << " // " << LFSR_SEED << "\n";
        std::cout << "LSR_TAP:  0x" << std::hex << LFSR_TAP << std::dec << " // " << LFSR_TAP << "\n";
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
            std::cout << ",";
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

        std::ofstream header(obfuscatedHeaderPath);
        std::ofstream script(obfuscatedScriptPath);

        header << "#pragma once\n";
        header << "\n";
        header << "#include <string>\n";
        header << "#include <vector>\n";
        header << "#include <cstdint>\n";
        header << "#include <windows.h>\n";
        header << "\n";
        header << "struct LFSRParameters {\n";
        header << "\tuint32_t seed;\n";
        header << "\tuint32_t tap;\n";
        header << "};\n";
        header << "\n";
        header << "extern const LFSRParameters LFSR;\n";
        header << "extern const unsigned int ROTBits;\n";
        header << "extern const unsigned int modulus;\n";
        header << "extern const unsigned int multiplier;\n";
        header << "extern const uint8_t input;\n";
        header << "extern const DWORD masterKey;\n";
        header << "extern const std::vector<unsigned int> keys;\n";

        script << "#include \"obfuscatedString.hpp\"\n";
        script << "\n";
        script << "#include <vector>\n";
        script << "\n";
        script << "const LFSRParameters LFSR {\n";
        script << "\t0x" << std::uppercase << std::hex << LFSR_SEED << ",\n";
        script << "\t0x" << std::uppercase << std::hex << LFSR_TAP << "\n";
        script << "};\n";
        script << "\n";
        script << "const unsigned int ROTBits = " << ROTATION_BITS << ";\n";
        script << "const unsigned int modulus = " << MODULUS << ";\n";
        script << "const unsigned int multiplier = " << std::dec << MULTIPLIER << ";\n";
        script << "const std::vector<uint8_t> data = {";

        for (size_t i = 0; i < hexData.size(); i++) {
            script << "0x"
                << std::uppercase
                << std::hex
                << std::setw(2)
                << std::setfill('0')
                << static_cast<int>(hexData[i]);

            if (i != hexData.size() - 1) {
                script << ",";
            }
        }

        script << "};\n";
        script << "const DWORD masterKey = 0x" << std::hex << masterKey << ";\n";
        script << "const std::vector<uint32_t> keys = {";

        for (size_t i = 0; i < keys.size(); i++) {
            script << "0x"
            << std::uppercase
            << std::hex
            << keys[i];

            if (i == keys.size() - 1) {
                script << "";
            } else {
                script << ",";
            }
        }

        script << "};";

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

        if ((multiplier & 1) == 0) {
            std::cerr << "[!] Multiplier must be odd for mod 256\n";
            exit(1);
        }


        const unsigned int LFSR_SEED = LFSRSeed;
        const unsigned int LFSR_TAP = LFSRTap;
        const unsigned int ROTATION_BITS = ROTBits;
        const unsigned int MULTIPLIER = multiplier;
        const unsigned int MODULUS = modulus;

        LFSRParameters LFSR;
        LFSR.seed = LFSRSeed;
        LFSR.tap = LFSRTap;

        std::vector<uint8_t> data = parseHexString(input);

        std::cout << "[DEBUG] parsed bytes = " << data.size() << "\n";

        for (size_t i = 0; i < data.size(); ++i) {
            std::cout << "0x"
                    << std::hex << std::setw(2) << std::setfill('0')
                    << (int)data[i]
                    << (i + 1 < data.size() ? ", " : "\n");
        }
        std::cout << std::dec;

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
#include "headers\rotation.hpp"
#include "headers\obfuscator.hpp"
#include "headers\deobfuscator.hpp"
#include "headers\modulus.hpp"
#include "headers\lfsr.hpp"

#include <iostream>
#include <string>
#include <vector>
#include <windows.h>

int main() {
    // JUST FOR NOW AT THE MOMENT

    std::string input_string;
    std::cout << "cleartext: ";
    std::getline(std::cin, input_string);

    if (input_string.empty()) {
        std::cout << "String cannot be empty." << std::endl;
        return 1;
    }

    // ------------------------------------

    auto LFSR = LFSRRandom();

    const unsigned int LFSR_SEED = LFSR.seed;
    const unsigned int LFSR_TAP = LFSR.tap;
    const unsigned int ROTATION_BITS = (random() % 7) + 1;
    const unsigned int MODULUS = primes[ random() % (sizeof(primes)/sizeof(unsigned int)) ];
    const unsigned int MULTIPLIER = ( random() % (MODULUS - 2)) + 2;
    const unsigned int MULTIPLIERINV = inverseModulus(MULTIPLIER, MODULUS);

    std::vector<unsigned int> generatedKeys;
    DWORD masterKey;
    std::vector<uint8_t> obfuscated_data = obfuscate(input_string, generatedKeys, masterKey, LFSR, ROTATION_BITS, MULTIPLIER);

    std::cout << "\n--- CODIGO C++ GENERADO (PARAMETROS DINAMICOS) ---\n\n";
    std::cout << "// ADVERTENCIA: Este codigo es unico. Los parametros y la clave maestra son necesarios para desofuscar.\n\n";

    std::cout << "// --- PARAMETROS DE OFUSCACION (COPIAR Y PEGAR) ---\n";
    std::cout << "#define LFSR_SEED 0x" << std::hex << LFSR_SEED << std::dec << " // " << LFSR_SEED << "\n";
    std::cout << "#define LFSR_TAP  0x" << std::hex << LFSR_TAP << std::dec << " // " << LFSR_TAP << "\n";
    std::cout << "#define ROTATION_BITS " << ROTATION_BITS << "\n";
    std::cout << "#define MODULUS " << MODULUS << "\n";
    std::cout << "#define MULTIPLIER " << MULTIPLIER << "\n";
    std::cout << "#define INV_MULTIPLIER " << MULTIPLIERINV << " // Inverso de MULTIPLIER mod MODULUS\n\n";

    std::cout << "// --- DATOS OFUSCADOS ---\n";
    std::cout << "// Datos ofuscados para: \"" << input_string << "\"\n";
    std::cout << "const std::vector<int> obfuscated_data = {";

    for (size_t i = 0; i < obfuscated_data.size(); i++) {
        std::cout << obfuscated_data[i] << (i == obfuscated_data.size() - 1 ? "" : ", ");
    }

    std::cout << "};\n\n";

    std::cout << "// --- CLAVES DE INTEGRAD (COPIAR Y PEGAR) ---\n";
    std::cout << "const std::vector<unsigned int> original_keys = {";

    for (size_t i = 0; i < generatedKeys.size(); i++) {
        std::cout << "0x" << std::hex << generatedKeys[i] << std::dec << (i == generatedKeys.size() - 1 ? "" : ", ");
    }

    std::cout << "};\n\n";

    std::cout << "================================================\n";
    std::cout << "== ¡IMPORTANTE! CLAVE MAESTRA GENERADA ==\n";
    std::cout << "================================================\n";
    std::cout << "Master Key (DWORD): " << masterKey << "\n";
    std::cout << "Master Key (Hex): 0x" << std::hex << masterKey << std::dec << "\n";
    std::cout << "================================================\n\n";
    std::cout << "// Para desofuscar, llama a la funcion de esta forma:\n";
    std::cout << "// DWORD master_key = " << masterKey << "; // O obtenla de forma segura\n";
    std::cout << "// std::string decrypted = deobfuscate_with_key(obfuscated_data, original_keys, master_key);\n\n";

    std::cout << "\n--- DEMOSTRACION LOCAL ---\n";
    std::string decrypted_string = deobfuscate(obfuscated_data, generatedKeys, masterKey, LFSR, ROTATION_BITS, MULTIPLIER);
    std::cout << "Desofuscando localmente con la clave maestra generada...\n";
    std::cout << "String original: \"" << input_string << "\"\n";
    std::cout << "String recuperado: \"" << decrypted_string << "\"\n";
    if (input_string == decrypted_string) {
        std::cout << "Resultado: ¡EXITO!\n";
    } else {
        std::cout << "Resultado: ¡FALLO!\n";
    }

    return 0;
}
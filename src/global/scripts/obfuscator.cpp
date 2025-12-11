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

unsigned int LFSRNext(unsigned int &state, uint32_t tap) {
    unsigned int msb = state & tap;
    state <<= 1;

    if (msb != 0) {
        state ^= 0x04C11DB7;
    }
    return state;
}


unsigned char ROTR(unsigned char value, unsigned int count) {
    count %= 8;

    return (value >> count) | (value << (8 - count));
};

unsigned char ROTL(unsigned char value, unsigned int count) {
    count %= 8;

    return (value << count) | (value >> (8 - count));
}

unsigned int mod_inverse(unsigned int a, unsigned int m) {
    a %= m;

    if (a == 0) {
        return 0;
    };

    long long original_m = m;
    long long x0 = 1;
    long long x1 = 0;

    while (a > 1) {
        long long q = a / m;
        long long t = m;

        m = a % m;
        a = t;

        t = x1;
        x1 = x0 - q * x1;
        x0 = t;
    }

    if (x0 < 0) {
        x0 += original_m;
    }

    return static_cast<unsigned int>(x0);
}

std::string deobfuscate_with_key(
    const std::vector<uint8_t>& obfuscated_data,
    const std::vector<unsigned int>& keys,
    DWORD masterKey,
    const LFSR_Params& LFSR,
    unsigned int ROTBits,
    unsigned int multiplier)
{
    std::string out;

    unsigned int state = masterKey ^ LFSR.seed;

    unsigned int invMultiplier = mod_inverse(multiplier, 256);

    for (size_t i = 0; i < obfuscated_data.size(); i++) {

        uint8_t val = obfuscated_data[i];

        val = (val * invMultiplier) & 0xFF;

        val = (val - i) & 0xFF;

        val = ROTL(val, ROTBits);

        unsigned int key = LFSRNext(state, LFSR.tap);

        val ^= (key & 0xFF);

        out.push_back((char)val);
    }

    return out;
}


std::vector<uint8_t> obfuscate_with_key(
    const std::string& input,
    std::vector<unsigned int>& keys,
    DWORD& masterKey,
    const LFSR_Params& LFSR,
    unsigned int ROTBits,
    unsigned int multiplier)
{
    std::vector<uint8_t> output;

    masterKey = GetTickCount();
    unsigned int state = masterKey ^ LFSR.seed;

    for (size_t i = 0; i < input.size(); i++) {

        uint8_t val = (uint8_t)input[i];

        unsigned int key = LFSRNext(state, LFSR.tap);
        keys.push_back(key);

        val ^= (key & 0xFF);

        val = ROTR(val, ROTBits);

        val = (val + i) & 0xFF;

        val = (val * multiplier) & 0xFF; // MOD 256 REVERSIBLE

        output.push_back(val);
    }

    return output;
}




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

    auto LFSR = generate_random_lfsr();

    const unsigned int LFSR_SEED = LFSR.seed;
    const unsigned int LFSR_TAP = LFSR.tap;
    const unsigned int ROTATION_BITS = (rd() % 7) + 1;
    const unsigned int MODULUS = primes[ rd() % (sizeof(primes)/sizeof(unsigned int)) ];
    const unsigned int MULTIPLIER = ( rd() % (MODULUS - 2)) + 2;
    const unsigned int MULTIPLIERINV = mod_inverse(MULTIPLIER, MODULUS);

    std::vector<unsigned int> generatedKeys;
    DWORD masterKey;
    std::vector<uint8_t> obfuscated_data = obfuscate_with_key(input_string, generatedKeys, masterKey, LFSR, ROTATION_BITS, MULTIPLIER);

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

    std::cout << R"(// --- FUNCION DE DESOFUSCACION (COPIAR Y PEGAR) ---
    #include <vector>
    #include <string>

    // Funciones auxiliares necesarias
    unsigned int lfsr_next(unsigned int &state, uint32_t tap) {
        unsigned int msb = state & tap;
        state <<= 1;
        if (msb != 0) {
            state ^= 0x04C11DB7;
        }
        return state;
    }

    unsigned char rol(unsigned char value, unsigned int count) {
        count %= 8;
        return (value << count) | (value >> (8 - count));
    }

    // Función principal de desofuscación
    std::string deobfuscate_with_key(
        const std::vector<int>& obfuscated_data,
        const std::vector<unsigned int>& keys_for_integrity_check,
        DWORD master_key)
    {
        // Recrear el estado inicial del LFSR usando la clave maestra y la semilla
        unsigned int lfsr_state = static_cast<unsigned int>(master_key) ^ LFSR_SEED;

        // Regenerar la secuencia de claves para verificar la integridad
        std::vector<unsigned int> regenerated_keys;
        if (obfuscated_data.size() != keys_for_integrity_check.size()) {
            return "SIZE_MISMATCH_ERROR";
        }
        for (size_t i = 0; i < obfuscated_data.size(); ++i) {
            regenerated_keys.push_back(lfsr_next(lfsr_state, LFSR_TAP));
        }

        // Verificación de integridad CRÍTICA
        if (regenerated_keys != keys_for_integrity_check) {
            return "INTEGRITY_ERROR"; // La clave maestra es incorrecta o los datos están corruptos
        }

        // Proceder con la desofuscación
        std::string result;
        for (size_t i = 0; i < obfuscated_data.size(); ++i) {
            unsigned char val = static_cast<unsigned char>(obfuscated_data[i]);
            
            // Revertir los pasos en orden inverso
            val = (val * INV_MULTIPLIER) % MODULUS;
            val -= static_cast<unsigned char>(i);
            val = rol(val, ROTATION_BITS);
            val ^= static_cast<unsigned char>(regenerated_keys[i]);
            
            result += static_cast<char>(val);
        }
        return result;
    }
    )";

    std::cout << "\n--- DEMOSTRACION LOCAL ---\n";
    std::string decrypted_string = deobfuscate_with_key(obfuscated_data, generatedKeys, masterKey, LFSR, ROTATION_BITS, MULTIPLIER);
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
#include "headers/parseFunctions.hpp"

#include <sstream>
#include <string>
#include <vector>
#include <cctype>
#include <stdexcept>
#include <cstdint>

std::vector<uint8_t> parseHexString(const std::string& hexString) {
    std::vector<uint8_t> output;
    std::string clean;
    clean.reserve(hexString.size());

    // 1) Limpiar espacios y convertir delimitadores a comas
    for (char c : hexString) {
        if (std::isspace((unsigned char)c))
            continue;

        // Convertir cualquier delimitador a coma
        if (c == ',' || c == '|' || c == ';')
            clean.push_back(',');
        else
            clean.push_back(c);
    }

    // 2) Separar en tokens por coma
    std::stringstream ss(clean);
    std::string token;

    while (std::getline(ss, token, ',')) {
        if (token.empty())
            continue;

        // Quitar prefijo 0x
        if (token.size() > 2 && token[0] == '0' && (token[1] == 'x' || token[1] == 'X'))
            token = token.substr(2);

        if (token.empty())
            continue;

        // 3) Convertir HEX a número
        uint32_t value = std::stoul(token, nullptr, 16);

        if (value > 255)
            throw std::runtime_error("Valor hex mayor a 0xFF.");

        output.push_back(static_cast<uint8_t>(value));
    }

    return output;
}

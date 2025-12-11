#pragma once

#include "lfsr.hpp"
#include <vector>

#ifdef _WIN32
#include <windows.h>

#else
#include <chrono>

DWORD GetTickCount() {
    using namespace std::chrono;
    return static_cast<DWORD>(duration_cast<milliseconds>(steady_clock::now().time_since_epoch()).count());
}

#endif

std::vector<uint8_t> obfuscate(const std::string &input, std::vector<unsigned int> &keys, DWORD &masterKey, const LFSRParameters &LFSR, unsigned int ROTBits, unsigned int multiplier);
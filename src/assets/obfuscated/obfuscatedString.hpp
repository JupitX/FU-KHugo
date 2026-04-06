#pragma once

#include "..\..\global\scripts\headers\lfsr.hpp"

#include <string>
#include <vector>
#include <cstdint>
#include <windows.h>

extern const LFSRParameters LFSR;
extern const unsigned int ROTBits;
extern const unsigned int modulus;
extern const unsigned int multiplier;
extern const std::vector<uint8_t> data;
extern const DWORD masterKey;
extern const std::vector<uint32_t> keys;

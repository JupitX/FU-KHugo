#pragma once

#include "lfsr.hpp"

#include <string>
#include <vector>
#include <windows.h>

std::string deobfuscate(const std::vector<uint8_t> &input, const std::vector<unsigned int> &keys, DWORD masterKey, const LFSRParameters &LFSR, unsigned int ROTBits, unsigned int multiplier);

#include "..\..\assets\obfuscated\obfuscatedString.hpp"
#include "..\..\global\scripts\headers\deobfuscator.hpp"

#include <iostream>
#include <curl/curl.h>

int main() {
    const std::vector<uint8_t> OBFUSCATED = data;
    const std::vector<uint32_t> KEYS = keys;
    const DWORD MASTERKEY = masterKey;
    const LFSRParameters shift = LFSR;
    const unsigned int ROTATION_BITS = ROTBits;
    const unsigned int MULTIPLIER = multiplier;

    std::string licenseServer = deobfuscate(OBFUSCATED, KEYS, MASTERKEY, shift, ROTATION_BITS, MULTIPLIER);
    std::string url = "https://" + licenseServer + ":443";

    std::cout << url;

    CURL* curl = curl_easy_init();

    curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_perform(curl);
    curl_easy_cleanup(curl);

    return 0;

}
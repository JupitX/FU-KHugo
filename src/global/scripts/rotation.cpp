#include "headers\rotation.hpp"

unsigned char ROTR(unsigned char value, unsigned int count) {
    count %= 8;

    unsigned char rightShift = value >> count;
    unsigned char leftShift = value << (8 - count);

    unsigned char result = rightShift | leftShift;

    return result;
};

unsigned char ROTL(unsigned char value, unsigned int count) {
    count %= 8;

    unsigned char leftShift = value << count;
    unsigned char rightShift = value >> (8 - count);

    unsigned char result = leftShift | rightShift;

    return result;
}
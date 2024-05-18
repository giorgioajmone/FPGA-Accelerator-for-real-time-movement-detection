#ifndef SOBEL_H_INCLUDED
#define SOBEL_H_INCLUDED
#include <stdint.h>

void takeSobelBlocking(uint32_t framebuffer);
void takeSobelNonBlocking(uint32_t framebuffer);
void waitSobel();

#endif

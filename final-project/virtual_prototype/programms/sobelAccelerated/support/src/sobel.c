#include "sobel.h"

void takeSobelBlocking(uint32_t framebuffer) {
  uint32_t result;
  asm volatile ("l.nios_rrr r0,%[in1],%[in2],0xB"::[in1]"r"(5),[in2]"r"(framebuffer));
  asm volatile ("l.nios_rrr r0,%[in1],%[in2],0xB"::[in1]"r"(6),[in2]"r"(2));
  do {
    asm volatile ("l.nios_rrc %[out1],%[in1],r0,0xB":[out1]"=r"(result):[in1]"r"(7));
  } while (result == 0);
}

void takeSobelNonBlocking(uint32_t framebuffer) {
  asm volatile ("l.nios_rrr r0,%[in1],%[in2],0xB"::[in1]"r"(5),[in2]"r"(framebuffer));
  asm volatile ("l.nios_rrr r0,%[in1],%[in2],0xB"::[in1]"r"(6),[in2]"r"(2));
}

void waitSobel() {
  uint32_t result;
  do {
    asm volatile ("l.nios_rrc %[out1],%[in1],r0,0xB":[out1]"=r"(result):[in1]"r"(7));
  } while (result == 0);
}


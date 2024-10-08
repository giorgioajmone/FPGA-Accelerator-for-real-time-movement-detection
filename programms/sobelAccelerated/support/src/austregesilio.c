#include "austregesilio.h"

void takeSobelBlocking(uint32_t framebuffer) {
  uint32_t result;
  asm volatile ("l.nios_rrr r0,%[in1],%[in2],0xB"::[in1]"r"(3 << 9),[in2]"r"(framebuffer));
  asm volatile ("l.nios_rrr r0,%[in1],r0,0xB"::[in1]"r"(11 << 9));
  do {
    asm volatile ("l.nios_rrc %[out1],%[in1],r0,0xB":[out1]"=r"(result):[in1]"r"(10 << 9));
  } while (result == 0);
}

void takeSobelNonBlocking(uint32_t framebuffer) {
  asm volatile ("l.nios_rrr r0,%[in1],%[in2],0xB"::[in1]"r"(3 << 9),[in2]"r"(framebuffer));
  asm volatile ("l.nios_rrr r0,%[in1],r0,0xB"::[in1]"r"(11 << 9));
}

void waitSobel() {
  uint32_t result;
  do {
    asm volatile ("l.nios_rrc %[out1],%[in1],r0,0xB":[out1]"=r"(result):[in1]"r"(10 << 9));
  } while (result == 0);
}


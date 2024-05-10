#include <stdio.h>
#include <ov7670.h>
#include <swap.h>
#include <vga.h>

#define BURST_SIZE 31

int main () {
  volatile uint32_t ret;
  volatile uint16_t rgb565[640*480];
  volatile uint8_t grayscale[640*480];
  volatile uint32_t result, cycles,stall,idle;
  volatile unsigned int *vga = (unsigned int *) 0X50000020;
  camParameters camParams;
  vga_clear();
  
  printf("Initialising camera (this takes up to 3 seconds)!\n" );
  camParams = initOv7670(VGA);
  printf("Done!\n" );
  printf("NrOfPixels : %d\n", camParams.nrOfPixelsPerLine );
  result = (camParams.nrOfPixelsPerLine <= 320) ? camParams.nrOfPixelsPerLine | 0x80000000 : camParams.nrOfPixelsPerLine;
  vga[0] = swap_u32(result);
  printf("NrOfLines  : %d\n", camParams.nrOfLinesPerImage );
  result =  (camParams.nrOfLinesPerImage <= 240) ? camParams.nrOfLinesPerImage | 0x80000000 : camParams.nrOfLinesPerImage;
  vga[1] = swap_u32(result);
  printf("PCLK (kHz) : %d\n", camParams.pixelClockInkHz );
  printf("FPS        : %d\n", camParams.framesPerSecond );
  uint32_t grayPixels;
  vga[2] = swap_u32(2);
  vga[3] = swap_u32((uint32_t) &grayscale[0]);

  asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0x9 << 9), [in2] "r"(BURST_SIZE));

  while(1) 
  {
    takeSingleImageBlocking((uint32_t) &rgb565[0]);

    // PROFILING
    asm volatile ("l.nios_rrr r0,r0,%[in2],0xC"::[in2]"r"(7));

    // DMA - FIRST BUFFER
    asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0x3 << 9), [in2] "r"((uint32_t) rgb565));
    asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0x5 << 9), [in2] "r"(0));
    asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0x7 << 9), [in2] "r"(256));

    do{
      asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0xA << 9), [in2] "r"(0x1));
    } while(ret & 0x1);

    asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0xB << 9), [in2] "r"(0x1));

    do{
      asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0xA << 9), [in2] "r"(0x1));
    } while(ret & 0x1);

    for(volatile int i = 0; i < 600; i++) {
      uint32_t * rgb = &((uint32_t *)rgb565)[256 * (i + 1)];

      uint32_t it_hold = (i&0x1) * 256;
      

      if(i != 599) {
        // DMA - i BUFFER IN
        asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0x3 << 9), [in2] "r"((uint32_t) rgb));
        asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0x5 << 9), [in2] "r"((i&0x1) ? 0 : 256));
        asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0x7 << 9), [in2] "r"(256));
        asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0xB << 9), [in2] "r"(0x1));
      }

      for (int j = 0; j < 256; j += 2) {
        int z = (i&0x1) * 256;
        uint32_t pixel12, pixel34;
        // PIXELS - PROCESSING
        asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(pixel12) : [in1] "r"(z + j), [in2] "r"(0));
        asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(pixel34) : [in1] "r"(z + j + 1), [in2] "r"(0));
        asm volatile ("l.nios_rrr %[out1],%[in1],%[in2],0x9":[out1]"=r"(grayPixels):[in1]"r"(swap_u32(pixel34)),[in2]"r"(swap_u32(pixel12)));
        asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0x200 | (z + (j>>1))), [in2] "r"(grayPixels));
      }

      do{
         asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0xA << 9), [in2] "r"(0x1));
      } while(ret & 0x1);
  
      // DMA - i-1 BUFFER OUT

      asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0x3 << 9), [in2] "r"((uint32_t) &((uint32_t *)&grayscale[0])[i*128]));
      asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0x5 << 9), [in2] "r"((i&0x1) * 256));
      asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0x7 << 9), [in2] "r"(128));
      asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0xB << 9), [in2] "r"(0x2));

      do{
         asm volatile("l.nios_rrr %[out1],%[in1],%[in2], 20" : [out1] "=r"(ret) : [in1] "r"(0xA << 9), [in2] "r"(0x1));
      } while(ret & 0x1);
    }

    // PROFILING
    asm volatile ("l.nios_rrr %[out1],r0,%[in2],0xC":[out1]"=r"(cycles):[in2]"r"(1<<8|7<<4));
    asm volatile ("l.nios_rrr %[out1],%[in1],%[in2],0xC":[out1]"=r"(stall):[in1]"r"(1),[in2]"r"(1<<9));
    asm volatile ("l.nios_rrr %[out1],%[in1],%[in2],0xC":[out1]"=r"(idle):[in1]"r"(2),[in2]"r"(1<<10));
    printf("nrOfCycles: %d %d %d\n", cycles, stall, idle);
  }
}
#include <stdio.h>
#include <ov7670.h>
#include <swap.h>
#include <vga.h>

#define BURST_SIZE 31

int main1 () {
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

  asm volatile("l.nios_rrr %[out],%[in1],%[in2],0xD" : [out] "=r"(ret) : [in1] "r"(0x9 << 9), [in2] "r"(BURST_SIZE));

  while(1) 
  {
    takeSingleImageBlocking((uint32_t) &rgb565[0]);

    // PROFILING
    asm volatile ("l.nios_rrr r0, r0, %[in2], 0xB" :: [in2] "r" ((uint32_t)3840));
    asm volatile("l.nios_rrr r0,r0,%[in2],0xB"::[in2]"r"(7));

    // DMA - FIRST BUFFER
    asm volatile("l.nios_rrr r0,%[in1],%[in2],0xD" :: [in1] "r"(0x3 << 9), [in2] "r"((uint32_t) rgb565));
    asm volatile("l.nios_rrr r0,%[in1],%[in2],0xD" :: [in1] "r"(0x5 << 9), [in2] "r"(0));
    asm volatile("l.nios_rrr r0,%[in1],%[in2],0xD" :: [in1] "r"(0x7 << 9), [in2] "r"(256));

    do{
      asm volatile("l.nios_rrr %[out],%[in1],r0,0xD" : [out] "=r"(ret) : [in1] "r"(0xA << 9));
    } while(ret & 0x1);

    asm volatile("l.nios_rrr r0,%[in1],%[in2],0xD" : [out] "=r"(ret) : [in1] "r"(0xB << 9), [in2] "r"(0x1));

    do{
      asm volatile("l.nios_rrr %[out],%[in1],r0,0xD" : [out] "=r"(ret) : [in1] "r"(0xA << 9));
    } while(ret & 0x1);

    for(volatile uint32_t i = 0; i < 600; i++) {
      uint32_t rgbAddress = (uint32_t) &rgb565[(i + 1) << 8];
      uint32_t it_hold = (i&0x1) << 8;
      

      if(i != 599) {
        // DMA - i BUFFER IN
        asm volatile("l.nios_rrr r0,%[in1],%[in2],0xD" :: [in1] "r"(0x3 << 9), [in2] "r"((uint32_t) rgbAddress));
        asm volatile("l.nios_rrr r0,%[in1],%[in2],0xD" :: [in1] "r"(0x5 << 9), [in2] "r"((i&0x1) ? 0 : 256));
        asm volatile("l.nios_rrr r0,%[in1],%[in2],0xD" :: [in1] "r"(0x7 << 9), [in2] "r"(256));
        asm volatile("l.nios_rrr r0,%[in1],%[in2],0xD" :: [in1] "r"(0xB << 9), [in2] "r"(0x1));
      }

      for (uint32_t pixels = 0; pixels < 256; pixels += 2) {
        uint32_t pixelA, pixelB;
        // PIXELS - PROCESSING
        asm volatile("l.nios_rrr %[out],%[in1],%[in2],0xD" : [out] "=r"(pixelA) : [in1] "r"(it_hold + pixels), [in2] "r"(0));
        asm volatile("l.nios_rrr %[out],%[in1],%[in2],0xD" : [out] "=r"(pixelB) : [in1] "r"(it_hold + pixels + 1), [in2] "r"(0));
        asm volatile("l.nios_rrr %[out],%[in1],%[in2],0xC":[out]"=r"(grayPixels):[in1]"r"(swap_u32(pixelB)),[in2]"r"(swap_u32(pixelA)));
        asm volatile("l.nios_rrr r0,%[in1],%[in2],0xD" :: [in1] "r"(0x200 | (it_hold + (pixels>>1))), [in2] "r"(grayPixels));
      }

      do{
         asm volatile("l.nios_rrr %[out],%[in1],r0,0xD" : [out] "=r"(ret) : [in1] "r"(0xA << 9));
      } while(ret & 0x1);
  
      // DMA - i-1 BUFFER OUT

      asm volatile("l.nios_rrr r0,%[in1],%[in2],0xD" :: [in1] "r"(0x3 << 9), [in2] "r"((uint32_t) &((uint32_t *)&grayscale[0])[i<<7]));
      asm volatile("l.nios_rrr r0,%[in1],%[in2],0xD" :: [in1] "r"(0x5 << 9), [in2] "r"(it_hold));
      asm volatile("l.nios_rrr r0,%[in1],%[in2],0xD" :: [in1] "r"(0x7 << 9), [in2] "r"(128));
      asm volatile("l.nios_rrr r0,%[in1],%[in2],0xD" :: [in1] "r"(0xB << 9), [in2] "r"(0x2));

      do{
         asm volatile("l.nios_rrr %[out],%[in1],r0,0xD" : [out] "=r"(ret) : [in1] "r"(0xA << 9));
      } while(ret & 0x1);
    }

    // PROFILING
    asm volatile ("l.nios_rrr %[out],r0,%[in2],0xB":[out]"=r"(cycles):[in2]"r"(1<<8|7<<4));
    asm volatile ("l.nios_rrr %[out],%[in1],%[in2],0xB":[out]"=r"(stall):[in1]"r"(1),[in2]"r"(1<<9));
    asm volatile ("l.nios_rrr %[out],%[in1],%[in2],0xB":[out]"=r"(idle):[in1]"r"(2),[in2]"r"(1<<10));
    printf("Execution: %d - Stall: %d - Idle: %d\n", cycles, stall, idle);
  }
}
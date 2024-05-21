#include <stdio.h>
#include <ov7670.h>
#include <swap.h>
#include <vga.h>
#include <austregesilio.h>

#define BUFFER_SIZE 640*480/32

int main () {

  volatile uint32_t bufferA[BUFFER_SIZE];
  volatile uint32_t bufferB[BUFFER_SIZE];
  volatile uint32_t bufferC[BUFFER_SIZE];


  volatile uint32_t* sobelPresent = &bufferA[0]; 
  volatile uint32_t* sobelPast = &bufferB[0]; 
  volatile uint32_t* sobelFuture = &bufferC[0];

  volatile uint8_t dataToVga[640*480];
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
  vga[2] = swap_u32(2);
  vga[3] = swap_u32((uint32_t) &dataToVga[0]);

  asm volatile ("l.nios_rrr r0,%[in1],%[in2],0xB"::[in1]"r"(9 << 9), [in2]"r"(128));

  //takeSobelBlocking((uint32_t) &sobelPast[0]);
  //takeSobelBlocking((uint32_t) &sobelPresent[0]);

  volatile uint32_t comparisonResult;

  while(1) {
    takeSobelBlocking((uint32_t) &bufferA[0]);
    for(int pixel = 0; pixel < ((camParams.nrOfLinesPerImage*camParams.nrOfPixelsPerLine)/32); pixel++) {
      for(int j = 0; j < 32; j++){
        volatile uint32_t tmp = swap_u32(bufferA[pixel]);
        if(tmp & (1<<(31-j)))
            dataToVga[pixel*32+j] = 0xFF;
        else
            dataToVga[pixel*32+j] = 0x00;
      }
    }

    /*
    takeSobelNonBlocking((uint32_t) &sobelFuture[0]);
    for(int pixel = 0; pixel < ((camParams.nrOfLinesPerImage*camParams.nrOfPixelsPerLine) >> 5); pixel++) {
      volatile uint32_t pixelPresent = swap_u32(sobelPresent[pixel]);
      volatile uint32_t pixelPast = swap_u32(sobelPast[pixel]);
      for(int j = 0; j < 16; j++){
        asm volatile ("l.nios_rrr %[out],%[in1],%[in2],0xC":[out]"=r"(comparisonResult):[in1]"r"(pixelPresent),[in2]"r"(pixelPast));
        dataToVga[pixel << 5 + j] = comparisonResult;
        pixelPresent >>= 2;
        pixelPast >>= 2;
      }
    }

    /* for(int pixel = 0; pixel < ((camParams.nrOfLinesPerImage*camParams.nrOfPixelsPerLine) >> 5); pixel++) {
      uint32_t pixelPresent = sobelPresent[pixel];
      uint32_t pixelPast = sobelPast[pixel];
      for(int j = 0; j < 32; j++){
        dataToVga[pixel << 5 + j] = ((mask >> j) & 0x1) ? 0x6000 : ((sobelPast[pixel] >> j) & 0x1) * 0xFFFF;
      }
    } 

    waitSobel();

    volatile uint32_t *tmp;
    tmp = sobelFuture;
    sobelFuture = sobelPast;
    sobelPast = sobelPresent;
    sobelPresent = tmp;
    */

    //asm volatile ("l.nios_rrr %[out1],r0,%[in2],0xD":[out1]"=r"(cycles):[in2]"r"(1<<8|7<<4));
    //asm volatile ("l.nios_rrr %[out1],%[in1],%[in2],0xD":[out1]"=r"(stall):[in1]"r"(1),[in2]"r"(1<<9));
    //asm volatile ("l.nios_rrr %[out1],%[in1],%[in2],0xD":[out1]"=r"(idle):[in1]"r"(2),[in2]"r"(1<<10));
    //printf("nrOfCycles: %d %d %d\n", cycles, stall, idle);
  }
}

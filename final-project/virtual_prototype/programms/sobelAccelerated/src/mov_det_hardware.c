#include <stdio.h>
#include <ov7670.h>
#include <swap.h>
#include <vga.h>
#include <austregesilio.h>

#define BUFFER_SIZE 640*480/32

//#define _profileITERATION
//#define _profileMOVEMENT_DETECTION

int main () {

  uint32_t bufferA[BUFFER_SIZE];
  uint32_t bufferB[BUFFER_SIZE];
  uint32_t bufferC[BUFFER_SIZE];

  uint32_t* sobelPresent = &bufferA[0]; 
  uint32_t* sobelPast = &bufferB[0]; 
  uint32_t* sobelFuture = &bufferC[0];

  volatile uint16_t dataToVga[640*480];
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
  vga[2] = swap_u32(1);
  vga[3] = swap_u32((uint32_t) &dataToVga[0]);

  asm volatile ("l.nios_rrr r0,%[in1],%[in2],0xB"::[in1]"r"(9 << 9), [in2]"r"(200));

  takeSobelBlocking((uint32_t) &sobelPast[0]);
  takeSobelBlocking((uint32_t) &sobelPresent[0]);

  #ifdef _profileITERATION
      printf("================================ PROFILING ITERATION ================================\n");
  #endif
  #ifdef _profileMOVEMENT_DETECTION
      printf("============================ PROFILING MOVEMENTDETECTION ============================\n");
  #endif

  int frameSize = ((camParams.nrOfLinesPerImage*camParams.nrOfPixelsPerLine) >> 5);
 
  while(1) {

    #ifdef _profileITERATION
      asm volatile ("l.nios_rrr r0,r0,%[in2],0xC"::[in2]"r"(7));
    #endif

    takeSobelNonBlocking((uint32_t) &sobelFuture[0]);

    #ifdef _profileMOVEMENT_DETECTION
      asm volatile ("l.nios_rrr r0,r0,%[in2],0xC"::[in2]"r"(7));
    #endif

    for(int pixel = 0, pVGA = 0; pixel < frameSize; pixel++) {
      uint32_t pixelPresent = sobelPresent[pixel];
      uint32_t pixelPast = sobelPast[pixel];
      for(int j = 0; j < 32; j++){
        if(pixelPresent & (1<<(31-j))){
            if(pixelPast & (1<<(31-j))) dataToVga[pVGA++] = 0xFFFF;
            else dataToVga[pVGA++] = 0x08F0;
        }
        else dataToVga[pVGA++] = 0x0000;
      }
    }

    #ifdef _profileMOVEMENT_DETECTION
      asm volatile ("l.nios_rrr %[out1],r0,%[in2],0xC":[out1]"=r"(cycles):[in2]"r"(1<<8|7<<4));
      asm volatile ("l.nios_rrr %[out1],%[in1],%[in2],0xC":[out1]"=r"(stall):[in1]"r"(1),[in2]"r"(1<<9));
      asm volatile ("l.nios_rrr %[out1],%[in1],%[in2],0xC":[out1]"=r"(idle):[in1]"r"(2),[in2]"r"(1<<10));
      printf("cycles =  %d | stall = %d | idle = %d\n", cycles, stall, idle);
    #endif

    waitSobel();

    uint32_t *tmp;
    tmp = sobelFuture;
    sobelFuture = sobelPast;
    sobelPast = sobelPresent;
    sobelPresent = tmp;

    #ifdef _profileITERATION
      asm volatile ("l.nios_rrr %[out1],r0,%[in2],0xC":[out1]"=r"(cycles):[in2]"r"(1<<8|7<<4));
      asm volatile ("l.nios_rrr %[out1],%[in1],%[in2],0xC":[out1]"=r"(stall):[in1]"r"(1),[in2]"r"(1<<9));
      asm volatile ("l.nios_rrr %[out1],%[in1],%[in2],0xC":[out1]"=r"(idle):[in1]"r"(2),[in2]"r"(1<<10));
      printf("cycles =  %d | stall = %d | idle = %d\n", cycles, stall, idle);
    #endif

  }
}

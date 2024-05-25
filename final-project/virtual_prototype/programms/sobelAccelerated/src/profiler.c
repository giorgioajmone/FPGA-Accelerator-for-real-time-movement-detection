#include <stdio.h>
#include <ov7670.h>
#include <swap.h>
#include <vga.h>

#define _profileITERATION
//#define _profileIMAGE
//#define _profileGRAYSCALE
//#define _profileSOBEL
//#define _profileMOVEMENT_DETECTION

void edgeDetection( volatile uint8_t *grayscale, volatile uint8_t *sobelResult, int32_t width, int32_t height, int32_t threshold ) {
  
  const int32_t gx_array[3][3] = {{-1,0,1}, {-2,0,2}, {-1,0,1}};
  const int32_t gy_array[3][3] = { {1, 2, 1}, {0, 0, 0}, {-1,-2,-1}};
  int32_t valueX,valueY, result;
  
  for (int line = 1; line < height - 1; line++) {
    for (int pixel = 1; pixel < width - 1; pixel++) {
      valueX = valueY = 0;
      for (int dx = -1; dx < 2; dx++) {
        for (int dy = -1; dy < 2; dy++) {
          uint32_t index = ((line+dy)*width)+dx+pixel;
          int32_t gray = grayscale[index];
          valueX += gray*gx_array[dy+1][dx+1];
          valueY += gray*gy_array[dy+1][dx+1];
        }
      }
      result = (valueX < 0) ? -valueX : valueX;
      result += (valueY < 0) ? -valueY : valueY;
      sobelResult[line*width+pixel] = (result > threshold) ? 0xFF : 0;
    }
  }
}

int main () {

  volatile uint16_t rgb565[640*480];
  volatile uint16_t dataToVga[640*480];

  volatile uint8_t grayscale[640*480];

  volatile uint8_t sobelA[640*480];
  volatile uint8_t sobelB[640*480];

  volatile uint32_t result, cycles, stall, idle;
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
  vga[2] = swap_u32(1);
  vga[3] = swap_u32((uint32_t) &dataToVga[0]);

  uint8_t buffer = 0;

  #ifdef _profileITERATION
      printf("================================ PROFILING ITERATION ================================\n");
  #endif
  #ifdef _profileIMAGE
      printf("================================== PROFILING IMAGE ==================================\n");
  #endif
  #ifdef _profileGRAYSCALE
      printf("================================ PROFILING GRAYSCALE ================================\n");
  #endif
  #ifdef _profileSOBEL
      printf("================================== PROFILING SOBEL ==================================\n");
  #endif
  #ifdef _profileMOVEMENT_DETECTION
      printf("============================ PROFILING MOVEMENTDETECTION ============================\n");
  #endif

  while(1) {

    #ifdef _profileITERATION
      asm volatile ("l.nios_rrr r0,r0,%[in2],0xB"::[in2]"r"(7));
    #endif


    buffer = ~buffer;

    #ifdef _profileIMAGE
      asm volatile ("l.nios_rrr r0,r0,%[in2],0xB"::[in2]"r"(7));
    #endif
    
    takeSingleImageBlocking((uint32_t) &rgb565[0]);

    #ifdef _profileIMAGE
      asm volatile ("l.nios_rrr %[out1],r0,%[in2],0xB":[out1]"=r"(cycles):[in2]"r"(1<<8|7<<4));
      asm volatile ("l.nios_rrr %[out1],%[in1],%[in2],0xB":[out1]"=r"(stall):[in1]"r"(1),[in2]"r"(1<<9));
      asm volatile ("l.nios_rrr %[out1],%[in1],%[in2],0xB":[out1]"=r"(idle):[in1]"r"(2),[in2]"r"(1<<10));
      printf("cycles =  %d | stall = %d | idle = %d\n", cycles, stall, idle);
    #endif

    #ifdef _profileGRAYSCALE
      asm volatile ("l.nios_rrr r0,r0,%[in2],0xB"::[in2]"r"(7));
    #endif

    for (int line = 0; line < camParams.nrOfLinesPerImage; line++) {
      for (int pixel = 0; pixel < camParams.nrOfPixelsPerLine; pixel++) {
        uint16_t rgb = swap_u16(rgb565[line*camParams.nrOfPixelsPerLine+pixel]);
        uint32_t red1 = ((rgb >> 11) & 0x1F) << 3;
        uint32_t green1 = ((rgb >> 5) & 0x3F) << 2;
        uint32_t blue1 = (rgb & 0x1F) << 3;
        uint32_t gray = ((red1*54+green1*183+blue1*19) >> 8)&0xFF;
        grayscale[line*camParams.nrOfPixelsPerLine+pixel] = gray;
      }
    }

    #ifdef _profileGRAYSCALE
      asm volatile ("l.nios_rrr %[out1],r0,%[in2],0xB":[out1]"=r"(cycles):[in2]"r"(1<<8|7<<4));
      asm volatile ("l.nios_rrr %[out1],%[in1],%[in2],0xB":[out1]"=r"(stall):[in1]"r"(1),[in2]"r"(1<<9));
      asm volatile ("l.nios_rrr %[out1],%[in1],%[in2],0xB":[out1]"=r"(idle):[in1]"r"(2),[in2]"r"(1<<10));
      printf("cycles =  %d | stall = %d | idle = %d\n", cycles, stall, idle);
    #endif

    #ifdef _profileSOBEL
      asm volatile ("l.nios_rrr r0,r0,%[in2],0xB"::[in2]"r"(7));
    #endif

    edgeDetection(grayscale, (buffer == 0 ? sobelA : sobelB), camParams.nrOfPixelsPerLine, camParams.nrOfLinesPerImage, 128);

    #ifdef _profileSOBEL
      asm volatile ("l.nios_rrr %[out1],r0,%[in2],0xB":[out1]"=r"(cycles):[in2]"r"(1<<8|7<<4));
      asm volatile ("l.nios_rrr %[out1],%[in1],%[in2],0xB":[out1]"=r"(stall):[in1]"r"(1),[in2]"r"(1<<9));
      asm volatile ("l.nios_rrr %[out1],%[in1],%[in2],0xB":[out1]"=r"(idle):[in1]"r"(2),[in2]"r"(1<<10));
      printf("cycles =  %d | stall = %d | idle = %d\n", cycles, stall, idle);
    #endif

    #ifdef _profileMOVEMENT_DETECTION
      asm volatile ("l.nios_rrr r0,r0,%[in2],0xB"::[in2]"r"(7));
    #endif

    for (int pixel = 0; pixel < camParams.nrOfLinesPerImage*camParams.nrOfPixelsPerLine; pixel++) {
      if(sobelA[pixel] == sobelB[pixel]){
        dataToVga[pixel] = (((uint16_t)sobelA[pixel]) << 16) | sobelA[pixel]; 
      }
      else{
        dataToVga[pixel] = 0x08F0;
      }
    }

    #ifdef _profileMOVEMENT_DETECTION
      asm volatile ("l.nios_rrr %[out1],r0,%[in2],0xB":[out1]"=r"(cycles):[in2]"r"(1<<8|7<<4));
      asm volatile ("l.nios_rrr %[out1],%[in1],%[in2],0xB":[out1]"=r"(stall):[in1]"r"(1),[in2]"r"(1<<9));
      asm volatile ("l.nios_rrr %[out1],%[in1],%[in2],0xB":[out1]"=r"(idle):[in1]"r"(2),[in2]"r"(1<<10));
      printf("cycles =  %d | stall = %d | idle = %d\n", cycles, stall, idle);
    #endif

    #ifdef _profileITERATION
      asm volatile ("l.nios_rrr %[out1],r0,%[in2],0xB":[out1]"=r"(cycles):[in2]"r"(1<<8|7<<4));
      asm volatile ("l.nios_rrr %[out1],%[in1],%[in2],0xB":[out1]"=r"(stall):[in1]"r"(1),[in2]"r"(1<<9));
      asm volatile ("l.nios_rrr %[out1],%[in1],%[in2],0xB":[out1]"=r"(idle):[in1]"r"(2),[in2]"r"(1<<10));
      printf("cycles =  %d | stall = %d | idle = %d\n", cycles, stall, idle);
    #endif
  }
}


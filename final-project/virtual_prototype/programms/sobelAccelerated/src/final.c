#include <stdio.h>
#include <ov7670.h>
#include <swap.h>
#include <vga.h>
#include <austregesilio.h>

#define BUFFER_SIZE 640*480/32

int BitsSetTable256[256];

void initializeBitTable() { 
  BitsSetTable256[0] = 0; 
  for (int i = 0; i < 256; i++) { 
    BitsSetTable256[i] = (i & 1) + 
    BitsSetTable256[i / 2]; 
  } 
} 

int countSetBits(int n) { 
  return (BitsSetTable256[n & 0xff] + BitsSetTable256[(n >> 8) & 0xff] + 
            BitsSetTable256[(n >> 16) & 0xff] + BitsSetTable256[n >> 24]); 
} 

void getSignature(uint32_t *signature){
  asm volatile ("l.nios_rrr %[out1],%[in1],r0,0xC":[out1]"=r"(signature[0]):[in1]"r"(0));
  asm volatile ("l.nios_rrr %[out1],%[in1],r0,0xC":[out1]"=r"(signature[1]):[in1]"r"(1));
  asm volatile ("l.nios_rrr %[out1],%[in1],r0,0xC":[out1]"=r"(signature[2]):[in1]"r"(2));
  asm volatile ("l.nios_rrr %[out1],%[in1],r0,0xC":[out1]"=r"(signature[3]):[in1]"r"(3));
}

int main () {

  uint32_t bufferA[BUFFER_SIZE];
  uint32_t bufferB[BUFFER_SIZE];
  uint32_t bufferC[BUFFER_SIZE];
  uint32_t bufferD[4];
  uint32_t bufferE[4];

  uint32_t* sobelPresent = &bufferA[0]; 
  uint32_t* sobelPast = &bufferB[0]; 
  uint32_t* sobelFuture = &bufferC[0];

  uint32_t *signaturePast;
  uint32_t *signaturePresent;

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

  initializeBitTable();
  asm volatile ("l.nios_rrr r0,%[in1],%[in2],0xB"::[in1]"r"(9 << 9), [in2]"r"(200));

  takeSobelBlocking((uint32_t) &sobelPast[0]);
  getSignature(signaturePast);

  takeSobelBlocking((uint32_t) &sobelPresent[0]);
  getSignature(signaturePresent);

  int frameSize = ((camParams.nrOfLinesPerImage*camParams.nrOfPixelsPerLine) >> 5);
 
  while(1) {

    // PROFILING
    asm volatile("l.nios_rrr r0,r0,%[in2],0xB"::[in2]"r"(7));

    takeSobelNonBlocking((uint32_t) &sobelFuture[0]);
    for(int pixel = 0, pVGA = 0; pixel < frameSize; pixel++) {
      uint32_t pixelPresent = sobelPresent[pixel];
      uint32_t pixelPast = sobelPast[pixel];
      for(int j = 0; j < 32; j++){
        if(pixelPresent & (1<<(31-j)))
            if(pixelPast & (1<<(31-j)))
                dataToVga[pVGA++] = 0xFFFF;
            else
                dataToVga[pVGA++] = 0x08F0;
        else
            dataToVga[pVGA++] = 0x0000;
      }
    }

    uint32_t hammingDistance = 0;

    for(int i = 0; i < 4; i++)
        hammingDistance += countSetBits(signaturePast[i] ^ signaturePresent[i]);

    if(hammingDistance > 5) printf("TI SEI MOSSO BASTARDO\n");

    waitSobel();

    signaturePast = signaturePresent;
    getSignature(signaturePresent);

    uint32_t *tmp;
    tmp = sobelFuture;
    sobelFuture = sobelPast;
    sobelPast = sobelPresent;
    sobelPresent = tmp;

    asm volatile ("l.nios_rrr %[out1],r0,%[in2],0xD":[out1]"=r"(cycles):[in2]"r"(1<<8|7<<4));
    asm volatile ("l.nios_rrr %[out1],%[in1],%[in2],0xD":[out1]"=r"(stall):[in1]"r"(1),[in2]"r"(1<<9));
    asm volatile ("l.nios_rrr %[out1],%[in1],%[in2],0xD":[out1]"=r"(idle):[in1]"r"(2),[in2]"r"(1<<10));

    printf("Stats: %d %d %d\n", cycles, stall, idle);
  }
}

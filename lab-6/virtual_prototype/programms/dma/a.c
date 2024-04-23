
// Giorgio Ajmone 368146, Alessandro Cardinale 368411

#include <stdio.h>
#include <ov7670.h>
#include <swap.h>
#include <vga.h>

volatile uint32_t testArray[512];

int main2() {
  volatile uint32_t pointer = (uint32_t) &testArray[0];
  volatile uint32_t flag;
  volatile uint32_t value = 0;

  //initialize array

  for(volatile uint32_t i = 0; i < 512; i++) testArray[i] = i;

  //initialize memoryCi

  for(volatile uint32_t i = 0; i < 512; i++){
    asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" ((i | 0x00000200)), [valueB] "r" (0));
  }
  
//_____________________________ START TRANSFER TO MEMORY ________________________________________________________________

  // START TRANSFER 256 IN BURST OF 64 
  
  //set bus
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000600), [valueB] "r" (pointer));
  //set memory
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000A00), [valueB] "r" (0x00000000));
  //set block
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000E00), [valueB] "r" (0x00000100));
  //set burst
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00001200), [valueB] "r" (0x0000003F));

  //read bus
  asm volatile ("l.nios_rrr %[out], %[valueA], r0, 0xD" : [out] "=r" (flag) : [valueA] "r" (0x00000400));
  printf("BUS: %d\n", flag);

  //read memory
  asm volatile ("l.nios_rrr %[out], %[valueA], r0, 0xD" : [out] "=r" (flag) : [valueA] "r" (0x00000800));
  printf("MEMORY: %d\n", flag);

  //read block
  asm volatile ("l.nios_rrr %[out], %[valueA], r0, 0xD" : [out] "=r" (flag) : [valueA] "r" (0x00000C00));
  printf("BLOCK: %d\n", flag);

  //read burst
  asm volatile ("l.nios_rrr %[out], %[valueA], r0, 0xD" : [out] "=r" (flag) : [valueA] "r" (0x00001000));
  printf("BURST: %d\n", flag);

  //start transaction
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00001600), [valueB] "r" (0x0000001)); 

  printf("Start DMA\n");

  //wait until done
  flag = 1;
  while(flag == 1){
    asm volatile ("l.nios_rrr %[out], %[valueA], r0, 0xD" : [out] "=r" (flag) : [valueA] "r" (0x00001400));
  }

  // START TRANSFER 197 IN BURST OF 31 

  pointer = (uint32_t) &testArray[256];
  //set bus
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000600), [valueB] "r" (pointer));
  //set memory
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000A00), [valueB] "r" (0x00000000));
  //set block
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000E00), [valueB] "r" (0x000000C5));
  //set burst
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00001200), [valueB] "r" (0x0000001E));
  //start transaction
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00001600), [valueB] "r" (0x0000001)); 

  printf("Start DMA\n");

  //wait until done
  flag = 1;
  while(flag == 1){
    asm volatile ("l.nios_rrr %[out], %[valueA], r0, 0xD" : [out] "=r" (flag) : [valueA] "r" (0x00001400));
  }

  // START TRANSFER 59 IN BURST OF 64 

  pointer = (uint32_t) &testArray[453];
  //set bus
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000600), [valueB] "r" (pointer));
  //set memory
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000A00), [valueB] "r" (0x00000000));
  //set block
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000E00), [valueB] "r" (0x0000003B));
  //set burst
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00001200), [valueB] "r" (0x0000003F));
  //start transaction
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00001600), [valueB] "r" (0x0000001)); 

  printf("Start DMA\n");

  //wait until done
  flag = 1;
  while(flag == 1){
    asm volatile ("l.nios_rrr %[out], %[valueA], r0, 0xD" : [out] "=r" (flag) : [valueA] "r" (0x00001400));
  }


  //read memory and compare

  for(volatile uint32_t i = 0; i < 512; i++){
    asm volatile ("l.nios_rrr %[out], %[valueA], %[valueB], 0xD" : [out] "=r" (value) : [valueA] "r" (i), [valueB] "r" (0x00000000));
    printf("Value expected: %d and value received: %d\n", testArray[i], value);
    if(testArray[i] != value) {
      printf("FAILED FROM BUS TO MEMORY\n");
    }
  }

  printf("DONE COMPARING BUS TO MEMORY\n");

  //initialize memory
  
  for(volatile uint32_t i = 0; i < 512; i++){
    asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" ((i | 0x00000200)), [valueB] "r" (i+512));
  }

//_____________________________ START TRANSFER TO BUS ________________________________________________________________

  // START TRANSFER 222 IN BURST OF 96
  
  pointer = (uint32_t) &testArray[0];
  //set bus
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000600), [valueB] "r" (pointer));
  //set memory
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000A00), [valueB] "r" (0x00000000));
  //set block
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000E00), [valueB] "r" (0x000000DE));
  //set burst
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00001200), [valueB] "r" (0x0000005F));

  //read bus
  asm volatile ("l.nios_rrr %[out], %[valueA], r0, 0xD" : [out] "=r" (flag) : [valueA] "r" (0x00000400));
  printf("BUS: %d\n", flag);

  //read memory
  asm volatile ("l.nios_rrr %[out], %[valueA], r0, 0xD" : [out] "=r" (flag) : [valueA] "r" (0x00000800));
  printf("MEMORY: %d\n", flag);

  //read block
  asm volatile ("l.nios_rrr %[out], %[valueA], r0, 0xD" : [out] "=r" (flag) : [valueA] "r" (0x00000C00));
  printf("BLOCK: %d\n", flag);

  //read burst
  asm volatile ("l.nios_rrr %[out], %[valueA], r0, 0xD" : [out] "=r" (flag) : [valueA] "r" (0x00001000));
  printf("BURST: %d\n", flag);

  //start transaction
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00001600), [valueB] "r" (0x0000002)); 

  printf("Start DMA\n");

  //wait until done
  flag = 1;
  while(flag == 1){
    asm volatile ("l.nios_rrr %[out], %[valueA], r0, 0xD" : [out] "=r" (flag) : [valueA] "r" (0x00001400));
  }

  // START TRANSFER 174 IN BURST OF 87 

  pointer = (uint32_t) &testArray[222];
  //set bus
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000600), [valueB] "r" (pointer));
  //set memory
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000A00), [valueB] "r" (0x00000000));
  //set block
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000E00), [valueB] "r" (0x000000AE));
  //set burst
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00001200), [valueB] "r" (0x00000056));
  //start transaction
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00001600), [valueB] "r" (0x0000002)); 

  printf("Start DMA\n");

  //wait until done
  flag = 1;
  while(flag == 1){
    asm volatile ("l.nios_rrr %[out], %[valueA], r0, 0xD" : [out] "=r" (flag) : [valueA] "r" (0x00001400));
  }

  // START TRANSFER 116 IN BURST OF 200

  pointer = (uint32_t) &testArray[396];
  //set bus
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000600), [valueB] "r" (pointer));
  //set memory
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000A00), [valueB] "r" (0x00000000));
  //set block
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000E00), [valueB] "r" (0x00000074));
  //set burst
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00001200), [valueB] "r" (0x000000C7));
  //start transaction
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00001600), [valueB] "r" (0x0000002)); 

  printf("Start DMA\n");

  //wait until done
  flag = 1;
  while(flag == 1){
    asm volatile ("l.nios_rrr %[out], %[valueA], r0, 0xD" : [out] "=r" (flag) : [valueA] "r" (0x00001400));
  }

  //read and compare
  for(volatile uint32_t i = 0; i < 512; i++){
    asm volatile ("l.nios_rrr %[out], %[valueA], %[valueB], 0xD" : [out] "=r" (value) : [valueA] "r" (i), [valueB] "r" (0x00000000));
    printf("Value expected: %d and value received: %d\n", value, testArray[i]);
    if(testArray[i] != value) {
      printf("FAILED FROM MEMORY TO BUS\n");
    }
  }

  printf("DONE COMPARING MEMORY TO BUS\n");
}
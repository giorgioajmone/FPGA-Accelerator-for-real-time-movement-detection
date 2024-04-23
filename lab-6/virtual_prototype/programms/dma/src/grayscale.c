
// Giorgio Ajmone 368146, Alessandro Cardinale 368411

#include <stdio.h>
#include <ov7670.h>
#include <swap.h>
#include <vga.h>

volatile uint32_t testArray[512];

int main() {
  volatile uint32_t pointer1 = (uint32_t) &testArray[0];
  volatile uint32_t * pointer = (uint32_t *) &testArray[0];
  volatile uint32_t flag;
  volatile uint32_t value = 0;

  //initialize array

  for(volatile uint32_t i = 0; i < 512; i++) testArray[i] = i;

  //initialize memoryCi

  for(volatile uint32_t i = 0; i < 512; i++){
    asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" ((i | 0x00000200)), [valueB] "r" (0));
  }
  
  //set bus
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000600), [valueB] "r" (pointer1));
  //set memory
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000A00), [valueB] "r" (0x00000000));
  //set block
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000E00), [valueB] "r" (0x00000200));
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

  printf("Done comparing\n");

  //initialize memory
  
  for(volatile uint32_t i = 0; i < 512; i++){
    asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" ((i | 0x00000200)), [valueB] "r" (i+512));
  }

  //set bus
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000600), [valueB] "r" (pointer));
  //set memory
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000A00), [valueB] "r" (0x00000000));
  //set block
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000E00), [valueB] "r" (0x00000040));
  //set burst
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00001200), [valueB] "r" (0x00000007));

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


  //read and compare
  for(volatile uint32_t i = 0; i < 5; i++){
    asm volatile ("l.nios_rrr %[out], %[valueA], %[valueB], 0xD" : [out] "=r" (value) : [valueA] "r" (i), [valueB] "r" (0x00000000));
    printf("Value expected: %d and value received: %d\n", value, testArray[i]);
    if(testArray[i] != value) {
      printf("FAILED FROM MEMORY TO BUS\n");
    }
  }
}
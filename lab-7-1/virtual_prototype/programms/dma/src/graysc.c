
// Giorgio Ajmone 368146, Alessandro Cardinale 368411

#include <stdio.h>
#include <ov7670.h>
#include <swap.h>
#include <vga.h>


int main1 () {
  volatile uint32_t testArray[512];
    uint32_t value = 0;

  for(int i = 0; i < 512; i++) testArray[i] = i;
  
  //set bus
  //asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000600), [valueB] "r" (testArray));
  //set memory
  //asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000A00), [valueB] "r" (0x00000000));
  //set block
  //asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000E00), [valueB] "r" (0x00000100));
  //set burst
  //asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00001200), [valueB] "r" (0x0000003F));
  //start transaction
  //asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00001600), [valueB] "r" (0x0000001)); 

  printf("PORCA\n");

  //write to memory


  for(uint32_t i = 0; i < 512; i++){
    asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" ((i | 0x00000200)), [valueB] "r" (i));
  }

  for(uint32_t i = 0; i < 512; i++){
    printf("I: %d\n", i);
    //read and compare
    asm volatile ("l.nios_rrr %[out],%[valueA],r0,0xD" : [out] "=r" (value) : [valueA] "r" (i));
    printf("Value expected: %d and value received: %d\n", testArray[i], value);
    if(testArray[i] != value) {
      printf("FAILED FROM BUS TO MEMORY\n");
    }
  }   

  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" ((0x00000200)), [valueB] "r" (5));
  //asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" ((0x00000000)), [valueB] "r" (0));

  for(uint32_t i = 0; i < 1; i++){
    //read and compare
    asm volatile ("l.nios_rrr %[out], %[valueA], %[valueB], 0xD" : [out] "=r" (value) : [valueA] "r" (0x00000000), [valueB] "r" (0x00000000));
    printf("Value expected: %d and value received: %d\n", testArray[i], value);
    if(testArray[i] != value) {
      printf("FAILED FROM BUS TO MEMORY\n");
    }
  }

  printf("MISERIA\n");
  

  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" ((0x00000201)), [valueB] "r" (2));
  //asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" ((0x00000001)), [valueB] "r" (0));

  for(uint32_t i = 1; i < 2; i++){
    //read and compare
    asm volatile ("l.nios_rrr %[out], %[valueA], %[valueB], 0xD" : [out] "=r" (value) : [valueA] "r" (0x00000001), [valueB] "r" (0x00000000));
    printf("Value expected: %d and value received: %d\n", testArray[i], value);
    if(testArray[i] != value) {
      printf("FAILED FROM BUS TO MEMORY\n");
    }
  }

  //read from memory and compare   
}
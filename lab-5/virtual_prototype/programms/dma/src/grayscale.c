
// Giorgio Ajmone 368146, Alessandro Cardinale 368411

#include <stdio.h>
#include <ov7670.h>
#include <swap.h>
#include <vga.h>


int main () {
  volatile uint32_t testArray[512];

  for(int i = 0; i < 512; i++) testArray[i] = i;

  //transfer 256 in burst of 128
  
  //set bus
  asm volatile ("l.nios_rrr r0, %[valueB], %[valueA], 0xB" :: [valueA] "r" (0x00000600), [valueB] "r" (testArray));
  //set memory
  asm volatile ("l.nios_rrr r0, %[valueB], %[valueA], 0xB" :: [valueA] "r" (0x00000A00), [valueB] "r" (0x00000000));
  //set block
  asm volatile ("l.nios_rrr r0, %[valueB], %[valueA], 0xB" :: [valueA] "r" (0x00000E00), [valueB] "r" (0x00000100));
  //set burst
  asm volatile ("l.nios_rrr r0, %[valueB], %[valueA], 0xB" :: [valueA] "r" (0x00001200), [valueB] "r" (0x00000080));
  //start transaction
  asm volatile ("l.nios_rrr r0, %[valueB], %[valueA], 0xB" :: [valueA] "r" (0x00001600), [valueB] "r" (0x0000001)); 

  //wait until done

  uint32_t flag = 0;
  while(flag == 0){
    asm volatile ("l.nios_rrr [out], %[valueB], %[valueA], 0xB" : [out] "=r" (flag) : [valueA] "r" (0x00001400), [valueB] "r" (0x00000000));
  }

  // trasnfer 256 in burst of 32

  //set bus
  asm volatile ("l.nios_rrr r0, %[valueB], %[valueA], 0xB" :: [valueA] "r" (0x00000600), [valueB] "r" (testArray[256]));
  //set memory
  asm volatile ("l.nios_rrr r0, %[valueB], %[valueA], 0xB" :: [valueA] "r" (0x00000A00), [valueB] "r" (0x00000100));
  //set block
  asm volatile ("l.nios_rrr r0, %[valueB], %[valueA], 0xB" :: [valueA] "r" (0x00000E00), [valueB] "r" (0x00000100));
  //set burst
  asm volatile ("l.nios_rrr r0, %[valueB], %[valueA], 0xB" :: [valueA] "r" (0x00001200), [valueB] "r" (0x00000020));
  //start transaction
  asm volatile ("l.nios_rrr r0, %[valueB], %[valueA], 0xB" :: [valueA] "r" (0x00001600), [valueB] "r" (0x00000001)); 

  //wait until done

  flag = 0;
  while(flag == 0){
    asm volatile ("l.nios_rrr [out], %[valueB], %[valueA], 0xB" : [out] "=r" (flag) : [valueA] "r" (0x00001400), [valueB] "r" (0x00000000));
  }

  //read memory and compare

  uint32_t value = 0;

  for(uint32_t i = 0; i < 512; i++){
    //read and compare
    asm volatile ("l.nios_rrr [out], %[valueB], %[valueA], 0xB" : [out] "=r" (value) : [valueA] "r" (i), [valueB] "r" (0x00000000));
    printf("Value expected: %d and value received: %d\n", testArray[i], value);
    if(testArray[i] != value) {
      printf("FAILED FROM BUS TO MEMORY\n");
      exit(1);
    }
    //overwrite with value shfited by 512
    asm volatile ("l.nios_rrr r0, %[valueB], %[valueA], 0xB" : [out] "=r" (value) : [valueA] "r" ((i || 0x00000200)), [valueB] "r" (i+512));
  }

  // trasnfer 512 in burst of 256

  //set bus
  asm volatile ("l.nios_rrr r0, %[valueB], %[valueA], 0xB" :: [valueA] "r" (0x00000600), [valueB] "r" (testArray));
  //set memory
  asm volatile ("l.nios_rrr r0, %[valueB], %[valueA], 0xB" :: [valueA] "r" (0x00000A00), [valueB] "r" (0x00000000));
  //set block
  asm volatile ("l.nios_rrr r0, %[valueB], %[valueA], 0xB" :: [valueA] "r" (0x00000E00), [valueB] "r" (0x00000200));
  //set burst
  asm volatile ("l.nios_rrr r0, %[valueB], %[valueA], 0xB" :: [valueA] "r" (0x00001200), [valueB] "r" (0x000000FF));
  //start transaction
  asm volatile ("l.nios_rrr r0, %[valueB], %[valueA], 0xB" :: [valueA] "r" (0x00001600), [valueB] "r" (0x00000002));

  //wait until done

  flag = 0;
  while(flag == 0){
    asm volatile ("l.nios_rrr [out], %[valueB], %[valueA], 0xB" : [out] "=r" (flag) : [valueA] "r" (0x00001400), [valueB] "r" (0x00000000));
  }

  for(uint32_t i = 0; i < 512; i++){
    //read and compare
    asm volatile ("l.nios_rrr [out], %[valueB], %[valueA], 0xB" : [out] "=r" (value) : [valueA] "r" (i), [valueB] "r" (0x00000000));
    printf("Value expected: %d and value received: %d\n", value, testArray[i]);
    if(testArray[i] != value) {
      printf("FAILED FROM MEMORY TO BUS\n");
      exit(1);
    }
  }

  
}

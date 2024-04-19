
// Giorgio Ajmone 368146, Alessandro Cardinale 368411

#include <stdio.h>
#include <ov7670.h>
#include <swap.h>
#include <vga.h>


int main () {
  volatile uint32_t pippo = 0;
  volatile uint32_t testArray[512];
  uint32_t * pointer = (uint32_t *) &testArray[0];

  for(int i = 0; i < 512; i++) testArray[i] = 1;

  for(uint32_t i = 0; i < 512; i++){
    asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" ((i | 0x00000200)), [valueB] "r" (0));
  }

  //transfer 256 in burst of 128
  
  //set bus
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000600), [valueB] "r" (pointer));
  //set memory
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000A00), [valueB] "r" (0x00000000));
  //set block
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000E00), [valueB] "r" (0x00000200));
  //set burst
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00001200), [valueB] "r" (0x00000005));
  //start transaction
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00001600), [valueB] "r" (0x0000001)); 
  printf("ciao");
  //wait until done

  volatile uint32_t flag = 1;
  while(flag == 1){
    asm volatile ("l.nios_rrr %[out], %[valueA], %[valueB], 0xD" : [out] "=r" (flag) : [valueA] "r" (0x00001400), [valueB] "r" (0x00000000));
  }
  printf("FLAG: %d", flag);

  // trasnfer 256 in burst of 32
  /*
  //set bus
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000600), [valueB] "r" (testArray[256]));
  //set memory
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000A00), [valueB] "r" (0x00000100));
  //set block
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000E00), [valueB] "r" (0x00000100));
  //set burst
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00001200), [valueB] "r" (0x0000001F));
  //start transaction
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00001600), [valueB] "r" (0x00000001)); 

  //wait until done

  flag = 0;
  while(flag == 0){
    asm volatile ("l.nios_rrr %[out], %[valueA], %[valueB], 0xD" : [out] "=r" (flag) : [valueA] "r" (0x00001400), [valueB] "r" (0x00000000));
  }
  */
  //read memory and compare

  uint32_t value = 0, swappedValue;

  for(uint32_t i = 0; i < 5; i++){
    //read and compare
    asm volatile ("l.nios_rrr %[out], %[valueA], %[valueB], 0xD" : [out] "=r" (value) : [valueA] "r" (i), [valueB] "r" (0x00000000));
    swappedValue = swap_u32(value);
    printf("Value expected: %d and value received: %d\n", testArray[i], swappedValue);
    if(testArray[i] != swappedValue) {
      printf("FAILED FROM BUS TO MEMORY\n");
    }
    //overwrite with value shfited by 512
    asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" ((i | 0x00000200)), [valueB] "r" (i+512));
  }

  printf("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa%d", pippo);
  // trasnfer 512 in burst of 256

  //set bus
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000600), [valueB] "r" (pointer));
  //set memory
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000A00), [valueB] "r" (0x00000000));
  //set block
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000E00), [valueB] "r" (0x00000200));
  //set burst
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00001200), [valueB] "r" (0x0000003F));
  //start transaction
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00001600), [valueB] "r" (0x00000002));

  //wait until done

   printf("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa");
  // trasnfer 512 in burst of 256

  flag = 0;
  while(flag == 0){
    asm volatile ("l.nios_rrr %[out], %[valueA], %[valueB], 0xD" : [out] "=r" (flag) : [valueA] "r" (0x00001400), [valueB] "r" (0x00000000));
  }

  for(uint32_t i = 0; i < 512; i++){
    //read and compare
    asm volatile ("l.nios_rrr %[out], %[valueA], %[valueB], 0xD" : [out] "=r" (value) : [valueA] "r" (i), [valueB] "r" (0x00000000));
    printf("Value expected: %d and value received: %d\n", value, testArray[i]);
    if(testArray[i] != value) {
      printf("FAILED FROM MEMORY TO BUS\n");
    }
  }

  
}
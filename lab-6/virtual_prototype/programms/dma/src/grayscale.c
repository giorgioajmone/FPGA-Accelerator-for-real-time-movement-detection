// Giorgio Ajmone 368146, Alessandro Cardinale 368411

#include <stdio.h>
#include <ov7670.h>
#include <swap.h>
#include <vga.h>

volatile uint32_t testArray[512];

int main() {
  volatile uint32_t pointer; 
  volatile uint32_t flag, value;

  //initialize array

  for(volatile uint32_t i = 0; i < 512; i++) testArray[i] = i;

  printf("\n===== INITIALIZE MEMORY WITH VALUE 0 AND ARRAY WITH VALUES FROM 0 TO 511 =====\n");

  for(volatile uint32_t i = 0; i < 512; i++){
    asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" ((i | 0x00000200)), [valueB] "r" (0));
  }
  
  //_____________________________ START TRANSFER TO MEMORY ________________________________________________________________

  // START TRANSFER 256 IN BURST OF 64 
  
  pointer = (uint32_t) &testArray[0];
  //set bus
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000600), [valueB] "r" (pointer));
  //set memory
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000A00), [valueB] "r" (0x00000000));
  //set block
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000E00), [valueB] "r" (0x00000100));
  //set burst
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00001200), [valueB] "r" (0x0000003F));

  printf("\n===== READING CONFIGURATION OF DMA =====\n");
  //read bus
  asm volatile ("l.nios_rrr %[out], %[valueA], r0, 0xD" : [out] "=r" (flag) : [valueA] "r" (0x00000400));
  printf("Bus Address: %d\n", flag);
  //read memory
  asm volatile ("l.nios_rrr %[out], %[valueA], r0, 0xD" : [out] "=r" (flag) : [valueA] "r" (0x00000800));
  printf("Memory Address: %d\n", flag);
  //read block
  asm volatile ("l.nios_rrr %[out], %[valueA], r0, 0xD" : [out] "=r" (flag) : [valueA] "r" (0x00000C00));
  printf("Block size: %d\n", flag);
  //read burst
  asm volatile ("l.nios_rrr %[out], %[valueA], r0, 0xD" : [out] "=r" (flag) : [valueA] "r" (0x00001000));
  printf("Burst size: %d\n", flag);

  printf("\n===== TRANSFER FROM BUS TO MEMORY : BLOCK MULTIPLE OF BURST =====\n");

  //start transaction
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00001600), [valueB] "r" (0x0000001)); 

  printf("Transfering data...\n");
  flag = 1;
  while(flag == 1){
    asm volatile ("l.nios_rrr %[out], %[valueA], r0, 0xD" : [out] "=r" (flag) : [valueA] "r" (0x00001400));
  }
  printf("Transfer completed\n");

  printf("\n===== TRANSFER FROM BUS TO MEMORY : BLOCK NON-MULTIPLE OF BURST =====\n");

  // START TRANSFER 197 IN BURST OF 31 

  pointer = (uint32_t) &testArray[256];
  //set bus
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000600), [valueB] "r" (pointer));
  //set memory
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000A00), [valueB] "r" (0x00000100));
  //set block
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000E00), [valueB] "r" (0x000000C5));
  //set burst
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00001200), [valueB] "r" (0x0000001E));
  //start transaction
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00001600), [valueB] "r" (0x0000001)); 

  printf("Transfering data...\n");
  flag = 1;
  while(flag == 1){
    asm volatile ("l.nios_rrr %[out], %[valueA], r0, 0xD" : [out] "=r" (flag) : [valueA] "r" (0x00001400));
  }
  printf("Transfer completed\n");

  printf("\n===== TRANSFER FROM BUS TO MEMORY : BURST BIGGER THAN BLOCK =====\n");

  // START TRANSFER 59 IN BURST OF 64 

  pointer = (uint32_t) &testArray[453];
  //set bus
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000600), [valueB] "r" (pointer));
  //set memory
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000A00), [valueB] "r" (0x000001C5));
  //set block
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000E00), [valueB] "r" (0x0000003B));
  //set burst 
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00001200), [valueB] "r" (0x0000003F));
  //start transaction
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00001600), [valueB] "r" (0x0000001)); 

  printf("Transfering data...\n");
  flag = 1;
  while(flag == 1){
    asm volatile ("l.nios_rrr %[out], %[valueA], r0, 0xD" : [out] "=r" (flag) : [valueA] "r" (0x00001400));
  }
  printf("Transfer completed\n");

  //read memory and compare
  int correct = 1;
  for(volatile uint32_t i = 0; i < 512; i++){
    asm volatile ("l.nios_rrr %[out], %[valueA], %[valueB], 0xD" : [out] "=r" (value) : [valueA] "r" (i), [valueB] "r" (0x00000000));
    if(testArray[i] != value) {
      printf("Value expected: %d and value received: %d\n", testArray[i], value);
      correct = 0;
    }
  }

  printf("Checking value transfered\n");

  if(correct) printf("\n===================================================== TRANSFER IS CORRECT=====================================================\n");
  else printf("\n===================================================== TRANSFER IS WRONG=====================================================\n");

  printf("\n===== INITIALIZE MEMORY WITH VALUES FROM 512 to 1023 =====\n");
  
  for(volatile uint32_t i = 0; i < 512; i++){
    asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" ((i | 0x00000200)), [valueB] "r" (i+512));
  }

  //_____________________________ START TRANSFER TO BUS ________________________________________________________________

  printf("\n===== TRANSFER FROM MEMORY TO BUS : BLOCK NON-MULTIPLE OF BURST =====\n");
  
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
  //start transaction
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00001600), [valueB] "r" (0x0000002)); 

  printf("Transfering data...\n");
  flag = 1;
  while(flag == 1){
    asm volatile ("l.nios_rrr %[out], %[valueA], r0, 0xD" : [out] "=r" (flag) : [valueA] "r" (0x00001400));
  }
  printf("Transfer completed\n");

  printf("\n===== TRANSFER FROM MEMORY TO BUS : BLOCK MULTIPLE OF BURST =====\n");

  // START TRANSFER 174 IN BURST OF 87 

  pointer = (uint32_t) &testArray[222];
  //set bus
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000600), [valueB] "r" (pointer));
  //set memory
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000A00), [valueB] "r" (0x000000DE));
  //set block
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000E00), [valueB] "r" (0x000000AE));
  //set burst
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00001200), [valueB] "r" (0x00000056));
  //start transaction
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00001600), [valueB] "r" (0x0000002)); 

  printf("Transfering data...\n");
  flag = 1;
  while(flag == 1){
    asm volatile ("l.nios_rrr %[out], %[valueA], r0, 0xD" : [out] "=r" (flag) : [valueA] "r" (0x00001400));
  }
  printf("Transfer completed\n");

  printf("\n===== TRANSFER FROM MEMORY TO BUS : BURST BIGGER THAN BLOCK =====\n");

  // START TRANSFER 116 IN BURST OF 200

  pointer = (uint32_t) &testArray[396];
  //set bus
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000600), [valueB] "r" (pointer));
  //set memory
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000A00), [valueB] "r" (0x0000018C));
  //set block
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00000E00), [valueB] "r" (0x00000074));
  //set burst
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00001200), [valueB] "r" (0x000000C7));
  //start transaction
  asm volatile ("l.nios_rrr r0, %[valueA], %[valueB], 0xD" :: [valueA] "r" (0x00001600), [valueB] "r" (0x0000002)); 

  printf("Transfering data...\n");
  flag = 1;
  while(flag == 1){
    asm volatile ("l.nios_rrr %[out], %[valueA], r0, 0xD" : [out] "=r" (flag) : [valueA] "r" (0x00001400));
  }
  printf("Transfer completed\n");

  //read and compare
  correct = 1;
  for(volatile uint32_t i = 0; i < 512; i++){
    asm volatile ("l.nios_rrr %[out], %[valueA], %[valueB], 0xD" : [out] "=r" (value) : [valueA] "r" (i), [valueB] "r" (0x00000000));
    if(testArray[i] != value) {
      printf("Value expected: %d and value received: %d\n", value, testArray[i]);
      correct = 0;
    }
  }

  printf("Checking value transfered\n");

  if(correct) printf("\n===================================================== TRANSFER IS CORRECT=====================================================\n");
  else printf("\n===================================================== TRANSFER IS WRONG=====================================================\n");
}
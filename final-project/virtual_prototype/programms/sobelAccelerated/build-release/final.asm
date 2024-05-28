
final.elf:     file format elf32-or1k


Disassembly of section .vectors:

00000000 <_error>:
   0:	de ad be ef 	l.sh -20753(r13),r23
   4:	15 00 00 00 	l.nop 0x0
   8:	00 00 00 11 	l.j 4c <_exception_handler>
   c:	15 00 00 00 	l.nop 0x0
  10:	00 00 00 0f 	l.j 4c <_exception_handler>
  14:	15 00 00 00 	l.nop 0x0
  18:	00 00 00 0d 	l.j 4c <_exception_handler>
  1c:	15 00 00 00 	l.nop 0x0
  20:	00 00 00 0b 	l.j 4c <_exception_handler>
  24:	15 00 00 00 	l.nop 0x0
  28:	00 00 00 09 	l.j 4c <_exception_handler>
  2c:	15 00 00 00 	l.nop 0x0

00000030 <_start>:
  30:	18 20 00 7f 	l.movhi r1,0x7f
  34:	a8 21 ff fc 	l.ori r1,r1,0xfffc
  38:	e0 60 00 05 	l.xor r3,r0,r0
  3c:	04 00 00 52 	l.jal 184 <main>
  40:	e0 80 00 05 	l.xor r4,r0,r0

00000044 <_loop_end>:
  44:	00 00 00 00 	l.j 44 <_loop_end>
  48:	15 00 00 00 	l.nop 0x0

0000004c <_exception_handler>:
  4c:	9c 21 ff 84 	l.addi r1,r1,-124
  50:	d4 01 10 00 	l.sw 0(r1),r2
  54:	d4 01 18 04 	l.sw 4(r1),r3
  58:	d4 01 20 08 	l.sw 8(r1),r4
  5c:	d4 01 28 0c 	l.sw 12(r1),r5
  60:	d4 01 30 10 	l.sw 16(r1),r6
  64:	d4 01 38 14 	l.sw 20(r1),r7
  68:	d4 01 40 18 	l.sw 24(r1),r8
  6c:	d4 01 48 1c 	l.sw 28(r1),r9
  70:	d4 01 50 20 	l.sw 32(r1),r10
  74:	d4 01 58 24 	l.sw 36(r1),r11
  78:	d4 01 60 28 	l.sw 40(r1),r12
  7c:	d4 01 68 2c 	l.sw 44(r1),r13
  80:	d4 01 70 30 	l.sw 48(r1),r14
  84:	d4 01 78 34 	l.sw 52(r1),r15
  88:	d4 01 80 38 	l.sw 56(r1),r16
  8c:	d4 01 88 3c 	l.sw 60(r1),r17
  90:	d4 01 90 40 	l.sw 64(r1),r18
  94:	d4 01 98 44 	l.sw 68(r1),r19
  98:	d4 01 a0 48 	l.sw 72(r1),r20
  9c:	d4 01 a8 4c 	l.sw 76(r1),r21
  a0:	d4 01 b0 50 	l.sw 80(r1),r22
  a4:	d4 01 b8 54 	l.sw 84(r1),r23
  a8:	d4 01 c0 58 	l.sw 88(r1),r24
  ac:	d4 01 c8 5c 	l.sw 92(r1),r25
  b0:	d4 01 d0 60 	l.sw 96(r1),r26
  b4:	d4 01 d8 64 	l.sw 100(r1),r27
  b8:	d4 01 e0 68 	l.sw 104(r1),r28
  bc:	d4 01 e8 6c 	l.sw 108(r1),r29
  c0:	d4 01 f0 70 	l.sw 112(r1),r30
  c4:	d4 01 f8 74 	l.sw 116(r1),r31
  c8:	b7 e0 00 12 	l.mfspr r31,r0,0x12
  cc:	bb ff 00 02 	l.slli r31,r31,0x2
  d0:	1b c0 00 00 	l.movhi r30,0x0
  d4:	ab de 01 6c 	l.ori r30,r30,0x16c
  d8:	e3 de f8 00 	l.add r30,r30,r31
  dc:	87 fe 00 00 	l.lwz r31,0(r30)
  e0:	48 00 f8 00 	l.jalr r31
  e4:	15 00 00 00 	l.nop 0x0
  e8:	84 41 00 00 	l.lwz r2,0(r1)
  ec:	84 61 00 04 	l.lwz r3,4(r1)
  f0:	84 81 00 08 	l.lwz r4,8(r1)
  f4:	84 a1 00 0c 	l.lwz r5,12(r1)
  f8:	84 c1 00 10 	l.lwz r6,16(r1)
  fc:	84 e1 00 14 	l.lwz r7,20(r1)
 100:	85 01 00 18 	l.lwz r8,24(r1)
 104:	85 21 00 1c 	l.lwz r9,28(r1)
 108:	85 41 00 20 	l.lwz r10,32(r1)
 10c:	85 61 00 24 	l.lwz r11,36(r1)
 110:	85 81 00 28 	l.lwz r12,40(r1)
 114:	85 a1 00 2c 	l.lwz r13,44(r1)
 118:	85 c1 00 30 	l.lwz r14,48(r1)
 11c:	85 e1 00 34 	l.lwz r15,52(r1)
 120:	86 01 00 38 	l.lwz r16,56(r1)
 124:	86 21 00 3c 	l.lwz r17,60(r1)
 128:	86 41 00 40 	l.lwz r18,64(r1)
 12c:	86 61 00 44 	l.lwz r19,68(r1)
 130:	86 81 00 48 	l.lwz r20,72(r1)
 134:	86 a1 00 4c 	l.lwz r21,76(r1)
 138:	86 c1 00 50 	l.lwz r22,80(r1)
 13c:	86 e1 00 54 	l.lwz r23,84(r1)
 140:	87 01 00 58 	l.lwz r24,88(r1)
 144:	87 21 00 5c 	l.lwz r25,92(r1)
 148:	87 41 00 60 	l.lwz r26,96(r1)
 14c:	87 61 00 64 	l.lwz r27,100(r1)
 150:	87 81 00 68 	l.lwz r28,104(r1)
 154:	87 a1 00 6c 	l.lwz r29,108(r1)
 158:	87 c1 00 70 	l.lwz r30,112(r1)
 15c:	87 e1 00 74 	l.lwz r31,116(r1)
 160:	9c 21 00 7c 	l.addi r1,r1,124
 164:	24 00 00 00 	l.rfe
 168:	15 00 00 00 	l.nop 0x0

0000016c <_vectors>:
 16c:	00 00 00 30 	l.j 22c <main+0xa8>
 170:	00 00 06 08 	l.j 1990 <_vsnprintf+0x900>
 174:	00 00 06 14 	l.j 19c4 <printf_>
 178:	00 00 06 2c 	l.j 1a28 <snprintf_+0x4>
 17c:	00 00 06 20 	l.j 19fc <sprintf_+0x8>
 180:	00 00 06 38 	l.j 1a60 <vprintf_+0xc>

Disassembly of section .text:

00000184 <main>:
     184:	9c 21 80 04 	l.addi r1,r1,-32764
     188:	19 a0 ff f5 	l.movhi r13,0xfff5
     18c:	d5 e1 4f f8 	l.sw 32760(r1),r9
     190:	a9 ad 5d bc 	l.ori r13,r13,0x5dbc
     194:	d5 e1 a7 e0 	l.sw 32736(r1),r20
     198:	d5 e1 d7 ec 	l.sw 32748(r1),r26
     19c:	d5 e1 77 d4 	l.sw 32724(r1),r14
     1a0:	d5 e1 87 d8 	l.sw 32728(r1),r16
     1a4:	d5 e1 97 dc 	l.sw 32732(r1),r18
     1a8:	d5 e1 b7 e4 	l.sw 32740(r1),r22
     1ac:	d5 e1 c7 e8 	l.sw 32744(r1),r24
     1b0:	d5 e1 e7 f0 	l.sw 32752(r1),r28
     1b4:	d5 e1 f7 f4 	l.sw 32756(r1),r30
     1b8:	04 00 07 8d 	l.jal 1fec <vga_clear>
     1bc:	e0 21 68 00 	l.add r1,r1,r13
     1c0:	18 60 00 00 	l.movhi r3,0x0
     1c4:	04 00 06 00 	l.jal 19c4 <printf_>
     1c8:	9c 63 2b f8 	l.addi r3,r3,11256
     1cc:	18 60 ff f4 	l.movhi r3,0xfff4
     1d0:	1a 20 00 0b 	l.movhi r17,0xb
     1d4:	a8 63 dd f0 	l.ori r3,r3,0xddf0
     1d8:	aa 31 22 18 	l.ori r17,r17,0x2218
     1dc:	e2 31 18 00 	l.add r17,r17,r3
     1e0:	e0 71 08 00 	l.add r3,r17,r1
     1e4:	04 00 01 4b 	l.jal 710 <initOv7670>
     1e8:	18 80 00 00 	l.movhi r4,0x0
     1ec:	18 60 00 00 	l.movhi r3,0x0
     1f0:	9c 63 2c 2b 	l.addi r3,r3,11307
     1f4:	86 81 00 08 	l.lwz r20,8(r1)
     1f8:	04 00 05 f3 	l.jal 19c4 <printf_>
     1fc:	87 41 00 0c 	l.lwz r26,12(r1)
     200:	18 60 00 00 	l.movhi r3,0x0
     204:	d4 01 a0 00 	l.sw 0(r1),r20
     208:	04 00 05 ef 	l.jal 19c4 <printf_>
     20c:	9c 63 2c 32 	l.addi r3,r3,11314
     210:	aa 20 01 40 	l.ori r17,r0,0x140
     214:	e4 54 88 00 	l.sfgtu r20,r17
     218:	10 00 00 04 	l.bf 228 <main+0xa4>
     21c:	e2 34 a0 04 	l.or r17,r20,r20
     220:	1a 20 80 00 	l.movhi r17,0x8000
     224:	e2 34 88 04 	l.or r17,r20,r17
     228:	d4 01 88 04 	l.sw 4(r1),r17
     22c:	86 61 00 04 	l.lwz r19,4(r1)
     230:	72 73 00 01 	l.nios_rrr r19,r19,r0,0x1
     234:	1a 20 50 00 	l.movhi r17,0x5000
     238:	aa 31 00 20 	l.ori r17,r17,0x20
     23c:	d4 11 98 00 	l.sw 0(r17),r19
     240:	18 60 00 00 	l.movhi r3,0x0
     244:	d4 01 d0 00 	l.sw 0(r1),r26
     248:	04 00 05 df 	l.jal 19c4 <printf_>
     24c:	9c 63 2c 43 	l.addi r3,r3,11331
     250:	aa 20 00 f0 	l.ori r17,r0,0xf0
     254:	e4 5a 88 00 	l.sfgtu r26,r17
     258:	10 00 00 04 	l.bf 268 <main+0xe4>
     25c:	e2 3a d0 04 	l.or r17,r26,r26
     260:	1a 20 80 00 	l.movhi r17,0x8000
     264:	e2 3a 88 04 	l.or r17,r26,r17
     268:	d4 01 88 04 	l.sw 4(r1),r17
     26c:	86 21 00 04 	l.lwz r17,4(r1)
     270:	72 31 00 01 	l.nios_rrr r17,r17,r0,0x1
     274:	1a 00 50 00 	l.movhi r16,0x5000
     278:	aa 70 00 24 	l.ori r19,r16,0x24
     27c:	d4 13 88 00 	l.sw 0(r19),r17
     280:	18 60 00 00 	l.movhi r3,0x0
     284:	86 21 00 10 	l.lwz r17,16(r1)
     288:	9c 63 2c 54 	l.addi r3,r3,11348
     28c:	04 00 05 ce 	l.jal 19c4 <printf_>
     290:	d4 01 88 00 	l.sw 0(r1),r17
     294:	18 60 00 00 	l.movhi r3,0x0
     298:	86 21 00 14 	l.lwz r17,20(r1)
     29c:	9c 63 2c 65 	l.addi r3,r3,11365
     2a0:	04 00 05 c9 	l.jal 19c4 <printf_>
     2a4:	d4 01 88 00 	l.sw 0(r1),r17
     2a8:	aa 20 00 01 	l.ori r17,r0,0x1
     2ac:	72 31 00 01 	l.nios_rrr r17,r17,r0,0x1
     2b0:	aa 70 00 28 	l.ori r19,r16,0x28
     2b4:	d4 13 88 00 	l.sw 0(r19),r17
     2b8:	1a c0 ff f6 	l.movhi r22,0xfff6
     2bc:	1a 20 00 0b 	l.movhi r17,0xb
     2c0:	ab 16 a0 00 	l.ori r24,r22,0xa000
     2c4:	aa 31 22 18 	l.ori r17,r17,0x2218
     2c8:	e2 31 c0 00 	l.add r17,r17,r24
     2cc:	e2 31 08 00 	l.add r17,r17,r1
     2d0:	72 31 00 01 	l.nios_rrr r17,r17,r0,0x1
     2d4:	aa 10 00 2c 	l.ori r16,r16,0x2c
     2d8:	d4 10 88 00 	l.sw 0(r16),r17
     2dc:	04 00 00 6e 	l.jal 494 <initializeBitTable>
     2e0:	15 00 00 00 	l.nop 0x0
     2e4:	aa 20 12 00 	l.ori r17,r0,0x1200
     2e8:	aa 60 00 c8 	l.ori r19,r0,0xc8
     2ec:	70 11 98 0b 	l.nios_rrr r0,r17,r19,0xb
     2f0:	1a 00 ff f5 	l.movhi r16,0xfff5
     2f4:	1a 20 00 0b 	l.movhi r17,0xb
     2f8:	aa 10 74 00 	l.ori r16,r16,0x7400
     2fc:	aa 31 22 18 	l.ori r17,r17,0x2218
     300:	e2 31 80 00 	l.add r17,r17,r16
     304:	e2 11 08 00 	l.add r16,r17,r1
     308:	04 00 00 a6 	l.jal 5a0 <takeSobelBlocking>
     30c:	e0 70 80 04 	l.or r3,r16,r16
     310:	04 00 00 90 	l.jal 550 <getSignature>
     314:	18 60 00 00 	l.movhi r3,0x0
     318:	1a 40 ff f4 	l.movhi r18,0xfff4
     31c:	1a 20 00 0b 	l.movhi r17,0xb
     320:	aa 52 de 00 	l.ori r18,r18,0xde00
     324:	aa 31 22 18 	l.ori r17,r17,0x2218
     328:	e2 31 90 00 	l.add r17,r17,r18
     32c:	e2 51 08 00 	l.add r18,r17,r1
     330:	04 00 00 9c 	l.jal 5a0 <takeSobelBlocking>
     334:	e0 72 90 04 	l.or r3,r18,r18
     338:	04 00 00 86 	l.jal 550 <getSignature>
     33c:	18 60 00 00 	l.movhi r3,0x0
     340:	e2 94 d3 06 	l.mul r20,r20,r26
     344:	aa 20 00 05 	l.ori r17,r0,0x5
     348:	e2 94 88 48 	l.srl r20,r20,r17
     34c:	1a 20 00 0b 	l.movhi r17,0xb
     350:	aa d6 0a 00 	l.ori r22,r22,0xa00
     354:	aa 31 22 18 	l.ori r17,r17,0x2218
     358:	e2 31 b0 00 	l.add r17,r17,r22
     35c:	e2 d1 08 00 	l.add r22,r17,r1
     360:	ab 40 08 f0 	l.ori r26,r0,0x8f0
     364:	04 00 00 9b 	l.jal 5d0 <takeSobelNonBlocking>
     368:	e0 76 b0 04 	l.or r3,r22,r22
     36c:	1a e0 00 00 	l.movhi r23,0x0
     370:	1a a0 00 00 	l.movhi r21,0x0
     374:	1b 60 80 00 	l.movhi r27,0x8000
     378:	af a0 ff ff 	l.xori r29,r0,-1
     37c:	ab e0 00 20 	l.ori r31,r0,0x20
     380:	e5 95 a0 00 	l.sflts r21,r20
     384:	10 00 00 1c 	l.bf 3f4 <main+0x270>
     388:	e2 32 b8 00 	l.add r17,r18,r23
     38c:	1b c0 00 00 	l.movhi r30,0x0
     390:	1b 80 00 00 	l.movhi r28,0x0
     394:	a9 c0 00 10 	l.ori r14,r0,0x10
     398:	04 00 00 54 	l.jal 4e8 <countSetBits>
     39c:	18 60 00 00 	l.movhi r3,0x0
     3a0:	9f de 00 04 	l.addi r30,r30,4
     3a4:	e4 3e 70 00 	l.sfne r30,r14
     3a8:	13 ff ff fc 	l.bf 398 <main+0x214>
     3ac:	e3 9c 58 00 	l.add r28,r28,r11
     3b0:	aa 20 00 05 	l.ori r17,r0,0x5
     3b4:	e4 bc 88 00 	l.sfleu r28,r17
     3b8:	10 00 00 04 	l.bf 3c8 <main+0x244>
     3bc:	18 60 00 00 	l.movhi r3,0x0
     3c0:	04 00 05 81 	l.jal 19c4 <printf_>
     3c4:	9c 63 2c 76 	l.addi r3,r3,11382
     3c8:	04 00 00 88 	l.jal 5e8 <waitSobel>
     3cc:	15 00 00 00 	l.nop 0x0
     3d0:	04 00 00 60 	l.jal 550 <getSignature>
     3d4:	18 60 00 00 	l.movhi r3,0x0
     3d8:	e2 32 90 04 	l.or r17,r18,r18
     3dc:	e2 56 b0 04 	l.or r18,r22,r22
     3e0:	e2 d0 80 04 	l.or r22,r16,r16
     3e4:	03 ff ff e0 	l.j 364 <main+0x1e0>
     3e8:	e2 11 88 04 	l.or r16,r17,r17
     3ec:	03 ff ff 9f 	l.j 268 <main+0xe4>
     3f0:	e2 3a d0 04 	l.or r17,r26,r26
     3f4:	85 b1 00 00 	l.lwz r13,0(r17)
     3f8:	e2 30 b8 00 	l.add r17,r16,r23
     3fc:	85 f1 00 00 	l.lwz r15,0(r17)
     400:	aa 20 00 05 	l.ori r17,r0,0x5
     404:	e1 95 88 08 	l.sll r12,r21,r17
     408:	1a 60 00 00 	l.movhi r19,0x0
     40c:	e3 3b 98 48 	l.srl r25,r27,r19
     410:	e1 79 68 03 	l.and r11,r25,r13
     414:	19 00 00 00 	l.movhi r8,0x0
     418:	e2 33 60 00 	l.add r17,r19,r12
     41c:	e4 0b 40 00 	l.sfeq r11,r8
     420:	10 00 00 15 	l.bf 474 <main+0x2f0>
     424:	e2 31 88 00 	l.add r17,r17,r17
     428:	e3 39 78 03 	l.and r25,r25,r15
     42c:	e4 19 40 00 	l.sfeq r25,r8
     430:	1b 20 00 0b 	l.movhi r25,0xb
     434:	ab 39 22 18 	l.ori r25,r25,0x2218
     438:	e3 39 88 00 	l.add r25,r25,r17
     43c:	e2 39 08 00 	l.add r17,r25,r1
     440:	10 00 00 0a 	l.bf 468 <main+0x2e4>
     444:	e2 31 c0 00 	l.add r17,r17,r24
     448:	dc 11 e8 00 	l.sh 0(r17),r29
     44c:	9e 73 00 01 	l.addi r19,r19,1
     450:	e4 33 f8 00 	l.sfne r19,r31
     454:	13 ff ff ef 	l.bf 410 <main+0x28c>
     458:	e3 3b 98 48 	l.srl r25,r27,r19
     45c:	9e b5 00 01 	l.addi r21,r21,1
     460:	03 ff ff c8 	l.j 380 <main+0x1fc>
     464:	9e f7 00 04 	l.addi r23,r23,4
     468:	dc 11 d0 00 	l.sh 0(r17),r26
     46c:	03 ff ff f9 	l.j 450 <main+0x2cc>
     470:	9e 73 00 01 	l.addi r19,r19,1
     474:	1b 20 00 0b 	l.movhi r25,0xb
     478:	ab 39 22 18 	l.ori r25,r25,0x2218
     47c:	e3 39 88 00 	l.add r25,r25,r17
     480:	e2 39 08 00 	l.add r17,r25,r1
     484:	e2 31 c0 00 	l.add r17,r17,r24
     488:	dc 11 00 00 	l.sh 0(r17),r0
     48c:	03 ff ff f1 	l.j 450 <main+0x2cc>
     490:	9e 73 00 01 	l.addi r19,r19,1

00000494 <initializeBitTable>:
     494:	1a 20 00 00 	l.movhi r17,0x0
     498:	9e f1 4f c0 	l.addi r23,r17,20416
     49c:	d5 31 07 c0 	l.sw 20416(r17),r0
     4a0:	e2 b7 b8 04 	l.or r21,r23,r23
     4a4:	1a 20 00 00 	l.movhi r17,0x0
     4a8:	ab 20 01 00 	l.ori r25,r0,0x100
     4ac:	aa 60 00 01 	l.ori r19,r0,0x1
     4b0:	e2 71 98 88 	l.sra r19,r17,r19
     4b4:	ab 60 00 02 	l.ori r27,r0,0x2
     4b8:	e2 73 d8 08 	l.sll r19,r19,r27
     4bc:	e2 77 98 00 	l.add r19,r23,r19
     4c0:	a7 71 00 01 	l.andi r27,r17,0x1
     4c4:	86 73 00 00 	l.lwz r19,0(r19)
     4c8:	9e 31 00 01 	l.addi r17,r17,1
     4cc:	e2 73 d8 00 	l.add r19,r19,r27
     4d0:	d4 15 98 00 	l.sw 0(r21),r19
     4d4:	e4 31 c8 00 	l.sfne r17,r25
     4d8:	13 ff ff f5 	l.bf 4ac <initializeBitTable+0x18>
     4dc:	9e b5 00 04 	l.addi r21,r21,4
     4e0:	44 00 48 00 	l.jr r9
     4e4:	15 00 00 00 	l.nop 0x0

000004e8 <countSetBits>:
     4e8:	aa e0 00 02 	l.ori r23,r0,0x2
     4ec:	a6 a3 00 ff 	l.andi r21,r3,0xff
     4f0:	1a 20 00 00 	l.movhi r17,0x0
     4f4:	aa 60 00 06 	l.ori r19,r0,0x6
     4f8:	9e 31 4f c0 	l.addi r17,r17,20416
     4fc:	e2 63 98 48 	l.srl r19,r3,r19
     500:	e2 b5 b8 08 	l.sll r21,r21,r23
     504:	e2 b1 a8 00 	l.add r21,r17,r21
     508:	a6 73 03 fc 	l.andi r19,r19,0x3fc
     50c:	86 b5 00 00 	l.lwz r21,0(r21)
     510:	e2 71 98 00 	l.add r19,r17,r19
     514:	86 73 00 00 	l.lwz r19,0(r19)
     518:	e2 73 a8 00 	l.add r19,r19,r21
     51c:	aa a0 00 0e 	l.ori r21,r0,0xe
     520:	e2 a3 a8 48 	l.srl r21,r3,r21
     524:	a6 b5 03 fc 	l.andi r21,r21,0x3fc
     528:	e2 b1 a8 00 	l.add r21,r17,r21
     52c:	86 b5 00 00 	l.lwz r21,0(r21)
     530:	e2 73 a8 00 	l.add r19,r19,r21
     534:	aa a0 00 18 	l.ori r21,r0,0x18
     538:	e0 63 a8 88 	l.sra r3,r3,r21
     53c:	e0 63 b8 08 	l.sll r3,r3,r23
     540:	e2 31 18 00 	l.add r17,r17,r3
     544:	85 71 00 00 	l.lwz r11,0(r17)
     548:	44 00 48 00 	l.jr r9
     54c:	e1 73 58 00 	l.add r11,r19,r11

00000550 <getSignature>:
     550:	1a 20 00 00 	l.movhi r17,0x0
     554:	72 31 00 0c 	l.nios_rrr r17,r17,r0,0xc
     558:	d4 03 88 00 	l.sw 0(r3),r17
     55c:	aa 20 00 01 	l.ori r17,r0,0x1
     560:	72 31 00 0c 	l.nios_rrr r17,r17,r0,0xc
     564:	d4 03 88 04 	l.sw 4(r3),r17
     568:	aa 20 00 02 	l.ori r17,r0,0x2
     56c:	72 31 00 0c 	l.nios_rrr r17,r17,r0,0xc
     570:	d4 03 88 08 	l.sw 8(r3),r17
     574:	aa 20 00 03 	l.ori r17,r0,0x3
     578:	72 31 00 0c 	l.nios_rrr r17,r17,r0,0xc
     57c:	44 00 48 00 	l.jr r9
     580:	d4 03 88 0c 	l.sw 12(r3),r17

00000584 <assert_die>:
     584:	18 60 00 00 	l.movhi r3,0x0
     588:	9c 21 ff fc 	l.addi r1,r1,-4
     58c:	d4 01 48 00 	l.sw 0(r1),r9
     590:	04 00 00 dc 	l.jal 900 <puts>
     594:	9c 63 2c 8d 	l.addi r3,r3,11405
     598:	00 00 00 00 	l.j 598 <assert_die+0x14>
     59c:	15 00 00 00 	l.nop 0x0

000005a0 <takeSobelBlocking>:
     5a0:	aa 20 06 00 	l.ori r17,r0,0x600
     5a4:	70 11 18 0b 	l.nios_rrr r0,r17,r3,0xb
     5a8:	aa 20 16 00 	l.ori r17,r0,0x1600
     5ac:	70 11 00 0b 	l.nios_rrr r0,r17,r0,0xb
     5b0:	aa 60 14 00 	l.ori r19,r0,0x1400
     5b4:	72 33 02 0b 	l.nios_rrc r17,r19,r0,0xb
     5b8:	1a a0 00 00 	l.movhi r21,0x0
     5bc:	e4 11 a8 00 	l.sfeq r17,r21
     5c0:	13 ff ff fd 	l.bf 5b4 <takeSobelBlocking+0x14>
     5c4:	15 00 00 00 	l.nop 0x0
     5c8:	44 00 48 00 	l.jr r9
     5cc:	15 00 00 00 	l.nop 0x0

000005d0 <takeSobelNonBlocking>:
     5d0:	aa 20 06 00 	l.ori r17,r0,0x600
     5d4:	70 11 18 0b 	l.nios_rrr r0,r17,r3,0xb
     5d8:	aa 20 16 00 	l.ori r17,r0,0x1600
     5dc:	70 11 00 0b 	l.nios_rrr r0,r17,r0,0xb
     5e0:	44 00 48 00 	l.jr r9
     5e4:	15 00 00 00 	l.nop 0x0

000005e8 <waitSobel>:
     5e8:	aa 60 14 00 	l.ori r19,r0,0x1400
     5ec:	72 33 02 0b 	l.nios_rrc r17,r19,r0,0xb
     5f0:	1a a0 00 00 	l.movhi r21,0x0
     5f4:	e4 11 a8 00 	l.sfeq r17,r21
     5f8:	13 ff ff fd 	l.bf 5ec <waitSobel+0x4>
     5fc:	15 00 00 00 	l.nop 0x0
     600:	44 00 48 00 	l.jr r9
     604:	15 00 00 00 	l.nop 0x0

00000608 <i_cache_error_handler>:
     608:	18 60 00 00 	l.movhi r3,0x0
     60c:	00 00 00 bd 	l.j 900 <puts>
     610:	9c 63 2c 93 	l.addi r3,r3,11411

00000614 <d_cache_error_handler>:
     614:	18 60 00 00 	l.movhi r3,0x0
     618:	00 00 00 ba 	l.j 900 <puts>
     61c:	9c 63 2c 9d 	l.addi r3,r3,11421

00000620 <illegal_instruction_handler>:
     620:	18 60 00 00 	l.movhi r3,0x0
     624:	00 00 00 b7 	l.j 900 <puts>
     628:	9c 63 2c a7 	l.addi r3,r3,11431

0000062c <external_interrupt_handler>:
     62c:	18 60 00 00 	l.movhi r3,0x0
     630:	00 00 00 b4 	l.j 900 <puts>
     634:	9c 63 2c ac 	l.addi r3,r3,11436

00000638 <system_call_handler>:
     638:	18 60 00 00 	l.movhi r3,0x0
     63c:	00 00 00 b1 	l.j 900 <puts>
     640:	9c 63 2c b1 	l.addi r3,r3,11441

00000644 <readOv7670Register>:
     644:	aa 20 00 08 	l.ori r17,r0,0x8
     648:	e0 63 88 08 	l.sll r3,r3,r17
     64c:	a4 63 ff ff 	l.andi r3,r3,0xffff
     650:	1a 20 43 00 	l.movhi r17,0x4300
     654:	e0 63 88 04 	l.or r3,r3,r17
     658:	71 63 02 05 	l.nios_rrc r11,r3,r0,0x5
     65c:	1a 20 00 00 	l.movhi r17,0x0
     660:	e5 6b 88 00 	l.sfges r11,r17
     664:	10 00 00 0b 	l.bf 690 <readOv7670Register+0x4c>
     668:	15 00 00 00 	l.nop 0x0
     66c:	71 63 02 05 	l.nios_rrc r11,r3,r0,0x5
     670:	e5 6b 88 00 	l.sfges r11,r17
     674:	10 00 00 07 	l.bf 690 <readOv7670Register+0x4c>
     678:	15 00 00 00 	l.nop 0x0
     67c:	71 63 02 05 	l.nios_rrc r11,r3,r0,0x5
     680:	e5 6b 88 00 	l.sfges r11,r17
     684:	10 00 00 03 	l.bf 690 <readOv7670Register+0x4c>
     688:	15 00 00 00 	l.nop 0x0
     68c:	71 63 02 05 	l.nios_rrc r11,r3,r0,0x5
     690:	44 00 48 00 	l.jr r9
     694:	15 00 00 00 	l.nop 0x0

00000698 <writeOv7670Register>:
     698:	aa 20 00 08 	l.ori r17,r0,0x8
     69c:	e0 63 88 08 	l.sll r3,r3,r17
     6a0:	a4 84 00 ff 	l.andi r4,r4,0xff
     6a4:	a4 63 ff ff 	l.andi r3,r3,0xffff
     6a8:	e0 63 20 04 	l.or r3,r3,r4
     6ac:	1a 20 42 00 	l.movhi r17,0x4200
     6b0:	e0 63 88 04 	l.or r3,r3,r17
     6b4:	70 03 02 05 	l.nios_rrc r0,r3,r0,0x5
     6b8:	44 00 48 00 	l.jr r9
     6bc:	15 00 00 00 	l.nop 0x0

000006c0 <writeRegisterList>:
     6c0:	9c 21 ff f4 	l.addi r1,r1,-12
     6c4:	d4 01 80 00 	l.sw 0(r1),r16
     6c8:	d4 01 90 04 	l.sw 4(r1),r18
     6cc:	d4 01 48 08 	l.sw 8(r1),r9
     6d0:	e2 03 18 04 	l.or r16,r3,r3
     6d4:	aa 40 00 ff 	l.ori r18,r0,0xff
     6d8:	8c 70 00 00 	l.lbz r3,0(r16)
     6dc:	8c 90 00 01 	l.lbz r4,1(r16)
     6e0:	e2 23 20 03 	l.and r17,r3,r4
     6e4:	e4 11 90 00 	l.sfeq r17,r18
     6e8:	10 00 00 06 	l.bf 700 <writeRegisterList+0x40>
     6ec:	85 21 00 08 	l.lwz r9,8(r1)
     6f0:	07 ff ff ea 	l.jal 698 <writeOv7670Register>
     6f4:	9e 10 00 02 	l.addi r16,r16,2
     6f8:	03 ff ff f9 	l.j 6dc <writeRegisterList+0x1c>
     6fc:	8c 70 00 00 	l.lbz r3,0(r16)
     700:	86 01 00 00 	l.lwz r16,0(r1)
     704:	86 41 00 04 	l.lwz r18,4(r1)
     708:	44 00 48 00 	l.jr r9
     70c:	9c 21 00 0c 	l.addi r1,r1,12

00000710 <initOv7670>:
     710:	9c 21 ff f0 	l.addi r1,r1,-16
     714:	1a 20 42 00 	l.movhi r17,0x4200
     718:	d4 01 80 00 	l.sw 0(r1),r16
     71c:	d4 01 a0 08 	l.sw 8(r1),r20
     720:	d4 01 90 04 	l.sw 4(r1),r18
     724:	d4 01 48 0c 	l.sw 12(r1),r9
     728:	e2 03 18 04 	l.or r16,r3,r3
     72c:	e2 84 20 04 	l.or r20,r4,r4
     730:	aa 31 12 80 	l.ori r17,r17,0x1280
     734:	70 11 02 05 	l.nios_rrc r0,r17,r0,0x5
     738:	1a 20 00 01 	l.movhi r17,0x1
     73c:	aa 31 86 a0 	l.ori r17,r17,0x86a0
     740:	70 11 02 06 	l.nios_rrc r0,r17,r0,0x6
     744:	1a 40 00 00 	l.movhi r18,0x0
     748:	9e 52 2c da 	l.addi r18,r18,11482
     74c:	07 ff ff dd 	l.jal 6c0 <writeRegisterList>
     750:	e0 72 90 04 	l.or r3,r18,r18
     754:	aa 20 00 01 	l.ori r17,r0,0x1
     758:	e4 14 88 00 	l.sfeq r20,r17
     75c:	10 00 00 25 	l.bf 7f0 <initOv7670+0xe0>
     760:	aa 20 00 02 	l.ori r17,r0,0x2
     764:	e4 34 88 00 	l.sfne r20,r17
     768:	10 00 00 24 	l.bf 7f8 <initOv7670+0xe8>
     76c:	15 00 00 00 	l.nop 0x0
     770:	9c 72 01 38 	l.addi r3,r18,312
     774:	07 ff ff d3 	l.jal 6c0 <writeRegisterList>
     778:	15 00 00 00 	l.nop 0x0
     77c:	07 ff ff d1 	l.jal 6c0 <writeRegisterList>
     780:	9c 72 01 74 	l.addi r3,r18,372
     784:	1a 20 42 00 	l.movhi r17,0x4200
     788:	aa 31 11 00 	l.ori r17,r17,0x1100
     78c:	70 11 02 05 	l.nios_rrc r0,r17,r0,0x5
     790:	1a 20 00 1e 	l.movhi r17,0x1e
     794:	aa 31 84 80 	l.ori r17,r17,0x8480
     798:	70 11 02 06 	l.nios_rrc r0,r17,r0,0x6
     79c:	1a 20 00 00 	l.movhi r17,0x0
     7a0:	72 31 02 07 	l.nios_rrc r17,r17,r0,0x7
     7a4:	aa e0 00 01 	l.ori r23,r0,0x1
     7a8:	72 f7 02 07 	l.nios_rrc r23,r23,r0,0x7
     7ac:	aa a0 00 02 	l.ori r21,r0,0x2
     7b0:	72 b5 02 07 	l.nios_rrc r21,r21,r0,0x7
     7b4:	aa 60 00 03 	l.ori r19,r0,0x3
     7b8:	72 73 02 07 	l.nios_rrc r19,r19,r0,0x7
     7bc:	ab 20 00 01 	l.ori r25,r0,0x1
     7c0:	e2 31 c8 48 	l.srl r17,r17,r25
     7c4:	d4 10 88 00 	l.sw 0(r16),r17
     7c8:	d4 10 b8 04 	l.sw 4(r16),r23
     7cc:	d4 10 a8 08 	l.sw 8(r16),r21
     7d0:	d4 10 98 0c 	l.sw 12(r16),r19
     7d4:	e1 70 80 04 	l.or r11,r16,r16
     7d8:	86 41 00 04 	l.lwz r18,4(r1)
     7dc:	86 01 00 00 	l.lwz r16,0(r1)
     7e0:	86 81 00 08 	l.lwz r20,8(r1)
     7e4:	85 21 00 0c 	l.lwz r9,12(r1)
     7e8:	44 00 48 00 	l.jr r9
     7ec:	9c 21 00 10 	l.addi r1,r1,16
     7f0:	03 ff ff e1 	l.j 774 <initOv7670+0x64>
     7f4:	9c 72 01 4e 	l.addi r3,r18,334
     7f8:	03 ff ff df 	l.j 774 <initOv7670+0x64>
     7fc:	9c 72 01 64 	l.addi r3,r18,356

00000800 <takeSingleImageBlocking>:
     800:	aa 20 00 05 	l.ori r17,r0,0x5
     804:	70 11 18 07 	l.nios_rrr r0,r17,r3,0x7
     808:	aa 20 00 06 	l.ori r17,r0,0x6
     80c:	aa 60 00 02 	l.ori r19,r0,0x2
     810:	70 11 98 07 	l.nios_rrr r0,r17,r19,0x7
     814:	aa 60 00 07 	l.ori r19,r0,0x7
     818:	72 33 02 07 	l.nios_rrc r17,r19,r0,0x7
     81c:	1a a0 00 00 	l.movhi r21,0x0
     820:	e4 11 a8 00 	l.sfeq r17,r21
     824:	13 ff ff fd 	l.bf 818 <takeSingleImageBlocking+0x18>
     828:	15 00 00 00 	l.nop 0x0
     82c:	44 00 48 00 	l.jr r9
     830:	15 00 00 00 	l.nop 0x0

00000834 <takeSingleImageNonBlocking>:
     834:	aa 20 00 05 	l.ori r17,r0,0x5
     838:	70 11 18 07 	l.nios_rrr r0,r17,r3,0x7
     83c:	aa 20 00 06 	l.ori r17,r0,0x6
     840:	aa 60 00 02 	l.ori r19,r0,0x2
     844:	70 11 98 07 	l.nios_rrr r0,r17,r19,0x7
     848:	44 00 48 00 	l.jr r9
     84c:	15 00 00 00 	l.nop 0x0

00000850 <waitForNextImage>:
     850:	aa 60 00 07 	l.ori r19,r0,0x7
     854:	72 33 02 07 	l.nios_rrc r17,r19,r0,0x7
     858:	1a a0 00 00 	l.movhi r21,0x0
     85c:	e4 11 a8 00 	l.sfeq r17,r21
     860:	13 ff ff fd 	l.bf 854 <waitForNextImage+0x4>
     864:	15 00 00 00 	l.nop 0x0
     868:	44 00 48 00 	l.jr r9
     86c:	15 00 00 00 	l.nop 0x0

00000870 <enableContinues>:
     870:	aa 20 00 05 	l.ori r17,r0,0x5
     874:	70 11 18 07 	l.nios_rrr r0,r17,r3,0x7
     878:	aa 20 00 06 	l.ori r17,r0,0x6
     87c:	aa 60 00 01 	l.ori r19,r0,0x1
     880:	70 11 98 07 	l.nios_rrr r0,r17,r19,0x7
     884:	44 00 48 00 	l.jr r9
     888:	15 00 00 00 	l.nop 0x0

0000088c <disableContinues>:
     88c:	aa 20 00 06 	l.ori r17,r0,0x6
     890:	1a 60 00 00 	l.movhi r19,0x0
     894:	70 11 98 07 	l.nios_rrr r0,r17,r19,0x7
     898:	44 00 48 00 	l.jr r9
     89c:	15 00 00 00 	l.nop 0x0

000008a0 <platform_init>:
     8a0:	00 00 05 80 	l.j 1ea0 <uart_init>
     8a4:	18 60 50 00 	l.movhi r3,0x5000

000008a8 <_putchar>:
     8a8:	9c 21 ff f8 	l.addi r1,r1,-8
     8ac:	aa 20 00 18 	l.ori r17,r0,0x18
     8b0:	d4 01 80 00 	l.sw 0(r1),r16
     8b4:	e2 03 88 08 	l.sll r16,r3,r17
     8b8:	e2 10 88 88 	l.sra r16,r16,r17
     8bc:	e0 90 80 04 	l.or r4,r16,r16
     8c0:	d4 01 48 04 	l.sw 4(r1),r9
     8c4:	04 00 05 96 	l.jal 1f1c <uart_putc>
     8c8:	18 60 50 00 	l.movhi r3,0x5000
     8cc:	e0 70 80 04 	l.or r3,r16,r16
     8d0:	85 21 00 04 	l.lwz r9,4(r1)
     8d4:	86 01 00 00 	l.lwz r16,0(r1)
     8d8:	00 00 05 cd 	l.j 200c <vga_putc>
     8dc:	9c 21 00 08 	l.addi r1,r1,8

000008e0 <putchar>:
     8e0:	9c 21 ff fc 	l.addi r1,r1,-4
     8e4:	d4 01 48 00 	l.sw 0(r1),r9
     8e8:	07 ff ff f0 	l.jal 8a8 <_putchar>
     8ec:	15 00 00 00 	l.nop 0x0
     8f0:	19 60 00 00 	l.movhi r11,0x0
     8f4:	85 21 00 00 	l.lwz r9,0(r1)
     8f8:	44 00 48 00 	l.jr r9
     8fc:	9c 21 00 04 	l.addi r1,r1,4

00000900 <puts>:
     900:	9c 21 ff f8 	l.addi r1,r1,-8
     904:	d4 01 80 00 	l.sw 0(r1),r16
     908:	e0 83 18 04 	l.or r4,r3,r3
     90c:	e2 03 18 04 	l.or r16,r3,r3
     910:	d4 01 48 04 	l.sw 4(r1),r9
     914:	04 00 05 92 	l.jal 1f5c <uart_puts>
     918:	18 60 50 00 	l.movhi r3,0x5000
     91c:	a8 80 00 0a 	l.ori r4,r0,0xa
     920:	04 00 05 7f 	l.jal 1f1c <uart_putc>
     924:	18 60 50 00 	l.movhi r3,0x5000
     928:	04 00 05 bd 	l.jal 201c <vga_puts>
     92c:	e0 70 80 04 	l.or r3,r16,r16
     930:	04 00 05 b7 	l.jal 200c <vga_putc>
     934:	a8 60 00 0a 	l.ori r3,r0,0xa
     938:	19 60 00 00 	l.movhi r11,0x0
     93c:	86 01 00 00 	l.lwz r16,0(r1)
     940:	85 21 00 04 	l.lwz r9,4(r1)
     944:	44 00 48 00 	l.jr r9
     948:	9c 21 00 08 	l.addi r1,r1,8

0000094c <getchar>:
     94c:	00 00 05 9b 	l.j 1fb8 <uart_getc>
     950:	18 60 50 00 	l.movhi r3,0x5000

00000954 <_out_buffer>:
     954:	aa 20 00 18 	l.ori r17,r0,0x18
     958:	e0 63 88 08 	l.sll r3,r3,r17
     95c:	e4 65 30 00 	l.sfgeu r5,r6
     960:	10 00 00 04 	l.bf 970 <_out_buffer+0x1c>
     964:	e0 63 88 88 	l.sra r3,r3,r17
     968:	e0 84 28 00 	l.add r4,r4,r5
     96c:	d8 04 18 00 	l.sb 0(r4),r3
     970:	44 00 48 00 	l.jr r9
     974:	15 00 00 00 	l.nop 0x0

00000978 <_out_null>:
     978:	44 00 48 00 	l.jr r9
     97c:	15 00 00 00 	l.nop 0x0

00000980 <_ntoa_format>:
     980:	9c 21 ff d0 	l.addi r1,r1,-48
     984:	d4 01 d0 1c 	l.sw 28(r1),r26
     988:	1b a0 00 00 	l.movhi r29,0x0
     98c:	86 21 00 40 	l.lwz r17,64(r1)
     990:	a7 51 00 02 	l.andi r26,r17,0x2
     994:	d4 01 70 04 	l.sw 4(r1),r14
     998:	d4 01 80 08 	l.sw 8(r1),r16
     99c:	d4 01 a0 10 	l.sw 16(r1),r20
     9a0:	d4 01 b0 14 	l.sw 20(r1),r22
     9a4:	d4 01 c0 18 	l.sw 24(r1),r24
     9a8:	d4 01 e0 20 	l.sw 32(r1),r28
     9ac:	d4 01 f0 24 	l.sw 36(r1),r30
     9b0:	d4 01 90 0c 	l.sw 12(r1),r18
     9b4:	d4 01 10 28 	l.sw 40(r1),r2
     9b8:	d4 01 48 2c 	l.sw 44(r1),r9
     9bc:	e4 3a e8 00 	l.sfne r26,r29
     9c0:	e2 83 18 04 	l.or r20,r3,r3
     9c4:	e2 c4 20 04 	l.or r22,r4,r4
     9c8:	e1 c5 28 04 	l.or r14,r5,r5
     9cc:	e3 06 30 04 	l.or r24,r6,r6
     9d0:	e3 87 38 04 	l.or r28,r7,r7
     9d4:	e2 08 40 04 	l.or r16,r8,r8
     9d8:	8e e1 00 33 	l.lbz r23,51(r1)
     9dc:	86 61 00 34 	l.lwz r19,52(r1)
     9e0:	86 a1 00 38 	l.lwz r21,56(r1)
     9e4:	10 00 00 24 	l.bf a74 <_ntoa_format+0xf4>
     9e8:	87 c1 00 3c 	l.lwz r30,60(r1)
     9ec:	e4 1e e8 00 	l.sfeq r30,r29
     9f0:	10 00 00 0d 	l.bf a24 <_ntoa_format+0xa4>
     9f4:	a7 31 00 01 	l.andi r25,r17,0x1
     9f8:	e4 19 e8 00 	l.sfeq r25,r29
     9fc:	10 00 00 0b 	l.bf a28 <_ntoa_format+0xa8>
     a00:	ab 60 00 20 	l.ori r27,r0,0x20
     a04:	e4 37 e8 00 	l.sfne r23,r29
     a08:	10 00 00 06 	l.bf a20 <_ntoa_format+0xa0>
     a0c:	15 00 00 00 	l.nop 0x0
     a10:	a7 71 00 0c 	l.andi r27,r17,0xc
     a14:	e4 1b e8 00 	l.sfeq r27,r29
     a18:	10 00 00 03 	l.bf a24 <_ntoa_format+0xa4>
     a1c:	15 00 00 00 	l.nop 0x0
     a20:	9f de ff ff 	l.addi r30,r30,-1
     a24:	ab 60 00 20 	l.ori r27,r0,0x20
     a28:	00 00 00 06 	l.j a40 <_ntoa_format+0xc0>
     a2c:	ab a0 00 30 	l.ori r29,r0,0x30
     a30:	0c 00 00 07 	l.bnf a4c <_ntoa_format+0xcc>
     a34:	e3 fc 80 00 	l.add r31,r28,r16
     a38:	d8 1f e8 00 	l.sb 0(r31),r29
     a3c:	9e 10 00 01 	l.addi r16,r16,1
     a40:	e4 55 80 00 	l.sfgtu r21,r16
     a44:	13 ff ff fb 	l.bf a30 <_ntoa_format+0xb0>
     a48:	e4 30 d8 00 	l.sfne r16,r27
     a4c:	1b 60 00 00 	l.movhi r27,0x0
     a50:	e4 39 d8 00 	l.sfne r25,r27
     a54:	0c 00 00 08 	l.bnf a74 <_ntoa_format+0xf4>
     a58:	ab 20 00 20 	l.ori r25,r0,0x20
     a5c:	ab 60 00 30 	l.ori r27,r0,0x30
     a60:	e4 70 f0 00 	l.sfgeu r16,r30
     a64:	10 00 00 04 	l.bf a74 <_ntoa_format+0xf4>
     a68:	e4 30 c8 00 	l.sfne r16,r25
     a6c:	10 00 00 38 	l.bf b4c <_ntoa_format+0x1cc>
     a70:	15 00 00 00 	l.nop 0x0
     a74:	a7 31 00 10 	l.andi r25,r17,0x10
     a78:	1b 60 00 00 	l.movhi r27,0x0
     a7c:	e4 19 d8 00 	l.sfeq r25,r27
     a80:	10 00 00 27 	l.bf b1c <_ntoa_format+0x19c>
     a84:	a7 31 04 00 	l.andi r25,r17,0x400
     a88:	e4 39 d8 00 	l.sfne r25,r27
     a8c:	10 00 00 35 	l.bf b60 <_ntoa_format+0x1e0>
     a90:	e4 10 d8 00 	l.sfeq r16,r27
     a94:	10 00 00 33 	l.bf b60 <_ntoa_format+0x1e0>
     a98:	e4 10 a8 00 	l.sfeq r16,r21
     a9c:	10 00 00 04 	l.bf aac <_ntoa_format+0x12c>
     aa0:	e4 30 f0 00 	l.sfne r16,r30
     aa4:	10 00 00 30 	l.bf b64 <_ntoa_format+0x1e4>
     aa8:	aa a0 00 10 	l.ori r21,r0,0x10
     aac:	9e b0 ff ff 	l.addi r21,r16,-1
     ab0:	1b 20 00 00 	l.movhi r25,0x0
     ab4:	e4 15 c8 00 	l.sfeq r21,r25
     ab8:	10 00 00 29 	l.bf b5c <_ntoa_format+0x1dc>
     abc:	ab 20 00 10 	l.ori r25,r0,0x10
     ac0:	e4 33 c8 00 	l.sfne r19,r25
     ac4:	10 00 00 86 	l.bf cdc <_ntoa_format+0x35c>
     ac8:	ab 20 00 02 	l.ori r25,r0,0x2
     acc:	9e 10 ff fe 	l.addi r16,r16,-2
     ad0:	a6 71 00 20 	l.andi r19,r17,0x20
     ad4:	1a a0 00 00 	l.movhi r21,0x0
     ad8:	e4 33 a8 00 	l.sfne r19,r21
     adc:	10 00 00 2d 	l.bf b90 <_ntoa_format+0x210>
     ae0:	aa 60 00 20 	l.ori r19,r0,0x20
     ae4:	e4 10 98 00 	l.sfeq r16,r19
     ae8:	10 00 00 2d 	l.bf b9c <_ntoa_format+0x21c>
     aec:	e2 7c 80 00 	l.add r19,r28,r16
     af0:	aa a0 00 78 	l.ori r21,r0,0x78
     af4:	d8 13 a8 00 	l.sb 0(r19),r21
     af8:	9e 10 00 01 	l.addi r16,r16,1
     afc:	aa 60 00 20 	l.ori r19,r0,0x20
     b00:	e4 10 98 00 	l.sfeq r16,r19
     b04:	10 00 00 26 	l.bf b9c <_ntoa_format+0x21c>
     b08:	15 00 00 00 	l.nop 0x0
     b0c:	e2 7c 80 00 	l.add r19,r28,r16
     b10:	aa a0 00 30 	l.ori r21,r0,0x30
     b14:	d8 13 a8 00 	l.sb 0(r19),r21
     b18:	9e 10 00 01 	l.addi r16,r16,1
     b1c:	aa 60 00 20 	l.ori r19,r0,0x20
     b20:	e4 10 98 00 	l.sfeq r16,r19
     b24:	10 00 00 1e 	l.bf b9c <_ntoa_format+0x21c>
     b28:	1a a0 00 00 	l.movhi r21,0x0
     b2c:	e4 17 a8 00 	l.sfeq r23,r21
     b30:	10 00 00 3e 	l.bf c28 <_ntoa_format+0x2a8>
     b34:	a6 b1 00 04 	l.andi r21,r17,0x4
     b38:	e2 7c 80 00 	l.add r19,r28,r16
     b3c:	aa a0 00 2d 	l.ori r21,r0,0x2d
     b40:	d8 13 a8 00 	l.sb 0(r19),r21
     b44:	00 00 00 17 	l.j ba0 <_ntoa_format+0x220>
     b48:	9e 10 00 01 	l.addi r16,r16,1
     b4c:	e3 bc 80 00 	l.add r29,r28,r16
     b50:	d8 1d d8 00 	l.sb 0(r29),r27
     b54:	03 ff ff c3 	l.j a60 <_ntoa_format+0xe0>
     b58:	9e 10 00 01 	l.addi r16,r16,1
     b5c:	1a 00 00 00 	l.movhi r16,0x0
     b60:	aa a0 00 10 	l.ori r21,r0,0x10
     b64:	e4 33 a8 00 	l.sfne r19,r21
     b68:	0f ff ff da 	l.bnf ad0 <_ntoa_format+0x150>
     b6c:	aa a0 00 02 	l.ori r21,r0,0x2
     b70:	e4 33 a8 00 	l.sfne r19,r21
     b74:	13 ff ff e3 	l.bf b00 <_ntoa_format+0x180>
     b78:	aa 60 00 20 	l.ori r19,r0,0x20
     b7c:	e4 10 98 00 	l.sfeq r16,r19
     b80:	10 00 00 07 	l.bf b9c <_ntoa_format+0x21c>
     b84:	e2 7c 80 00 	l.add r19,r28,r16
     b88:	03 ff ff db 	l.j af4 <_ntoa_format+0x174>
     b8c:	aa a0 00 62 	l.ori r21,r0,0x62
     b90:	e4 30 98 00 	l.sfne r16,r19
     b94:	10 00 00 23 	l.bf c20 <_ntoa_format+0x2a0>
     b98:	e2 7c 80 00 	l.add r19,r28,r16
     b9c:	aa 00 00 20 	l.ori r16,r0,0x20
     ba0:	a6 31 00 03 	l.andi r17,r17,0x3
     ba4:	1a 60 00 00 	l.movhi r19,0x0
     ba8:	e4 11 98 00 	l.sfeq r17,r19
     bac:	10 00 00 3a 	l.bf c94 <_ntoa_format+0x314>
     bb0:	e2 50 80 04 	l.or r18,r16,r16
     bb4:	e2 4e 70 04 	l.or r18,r14,r14
     bb8:	e2 50 90 00 	l.add r18,r16,r18
     bbc:	1a 20 00 00 	l.movhi r17,0x0
     bc0:	e4 30 88 00 	l.sfne r16,r17
     bc4:	e1 72 90 04 	l.or r11,r18,r18
     bc8:	10 00 00 36 	l.bf ca0 <_ntoa_format+0x320>
     bcc:	e0 b2 80 02 	l.sub r5,r18,r16
     bd0:	e4 1a 88 00 	l.sfeq r26,r17
     bd4:	10 00 00 06 	l.bf bec <_ntoa_format+0x26c>
     bd8:	e2 12 70 02 	l.sub r16,r18,r14
     bdc:	aa 40 00 20 	l.ori r18,r0,0x20
     be0:	e4 5e 80 00 	l.sfgtu r30,r16
     be4:	10 00 00 37 	l.bf cc0 <_ntoa_format+0x340>
     be8:	e1 6e 80 00 	l.add r11,r14,r16
     bec:	85 c1 00 04 	l.lwz r14,4(r1)
     bf0:	86 01 00 08 	l.lwz r16,8(r1)
     bf4:	86 41 00 0c 	l.lwz r18,12(r1)
     bf8:	86 81 00 10 	l.lwz r20,16(r1)
     bfc:	86 c1 00 14 	l.lwz r22,20(r1)
     c00:	87 01 00 18 	l.lwz r24,24(r1)
     c04:	87 41 00 1c 	l.lwz r26,28(r1)
     c08:	87 81 00 20 	l.lwz r28,32(r1)
     c0c:	87 c1 00 24 	l.lwz r30,36(r1)
     c10:	84 41 00 28 	l.lwz r2,40(r1)
     c14:	85 21 00 2c 	l.lwz r9,44(r1)
     c18:	44 00 48 00 	l.jr r9
     c1c:	9c 21 00 30 	l.addi r1,r1,48
     c20:	03 ff ff b5 	l.j af4 <_ntoa_format+0x174>
     c24:	aa a0 00 58 	l.ori r21,r0,0x58
     c28:	1a e0 00 00 	l.movhi r23,0x0
     c2c:	e4 15 b8 00 	l.sfeq r21,r23
     c30:	10 00 00 04 	l.bf c40 <_ntoa_format+0x2c0>
     c34:	aa a0 00 2b 	l.ori r21,r0,0x2b
     c38:	03 ff ff c2 	l.j b40 <_ntoa_format+0x1c0>
     c3c:	e2 7c 80 00 	l.add r19,r28,r16
     c40:	a6 b1 00 08 	l.andi r21,r17,0x8
     c44:	e4 15 b8 00 	l.sfeq r21,r23
     c48:	13 ff ff d6 	l.bf ba0 <_ntoa_format+0x220>
     c4c:	e2 bc 80 00 	l.add r21,r28,r16
     c50:	03 ff ff bd 	l.j b44 <_ntoa_format+0x1c4>
     c54:	d8 15 98 00 	l.sb 0(r21),r19
     c58:	d4 01 18 00 	l.sw 0(r1),r3
     c5c:	e0 d8 c0 04 	l.or r6,r24,r24
     c60:	48 00 a0 00 	l.jalr r20
     c64:	e0 96 b0 04 	l.or r4,r22,r22
     c68:	9e 52 00 01 	l.addi r18,r18,1
     c6c:	84 61 00 00 	l.lwz r3,0(r1)
     c70:	e4 5e 90 00 	l.sfgtu r30,r18
     c74:	13 ff ff f9 	l.bf c58 <_ntoa_format+0x2d8>
     c78:	e0 a2 90 00 	l.add r5,r2,r18
     c7c:	e4 b0 f0 00 	l.sfleu r16,r30
     c80:	10 00 00 03 	l.bf c8c <_ntoa_format+0x30c>
     c84:	e2 5e 80 02 	l.sub r18,r30,r16
     c88:	1a 40 00 00 	l.movhi r18,0x0
     c8c:	03 ff ff cb 	l.j bb8 <_ntoa_format+0x238>
     c90:	e2 52 70 00 	l.add r18,r18,r14
     c94:	e0 4e 80 02 	l.sub r2,r14,r16
     c98:	03 ff ff f6 	l.j c70 <_ntoa_format+0x2f0>
     c9c:	a8 60 00 20 	l.ori r3,r0,0x20
     ca0:	9e 10 ff ff 	l.addi r16,r16,-1
     ca4:	e2 3c 80 00 	l.add r17,r28,r16
     ca8:	e0 d8 c0 04 	l.or r6,r24,r24
     cac:	e0 96 b0 04 	l.or r4,r22,r22
     cb0:	48 00 a0 00 	l.jalr r20
     cb4:	8c 71 00 00 	l.lbz r3,0(r17)
     cb8:	03 ff ff c2 	l.j bc0 <_ntoa_format+0x240>
     cbc:	1a 20 00 00 	l.movhi r17,0x0
     cc0:	e0 d8 c0 04 	l.or r6,r24,r24
     cc4:	e0 ab 58 04 	l.or r5,r11,r11
     cc8:	e0 96 b0 04 	l.or r4,r22,r22
     ccc:	48 00 a0 00 	l.jalr r20
     cd0:	e0 72 90 04 	l.or r3,r18,r18
     cd4:	03 ff ff c3 	l.j be0 <_ntoa_format+0x260>
     cd8:	9e 10 00 01 	l.addi r16,r16,1
     cdc:	e4 13 c8 00 	l.sfeq r19,r25
     ce0:	0f ff ff 8b 	l.bnf b0c <_ntoa_format+0x18c>
     ce4:	e2 15 a8 04 	l.or r16,r21,r21
     ce8:	03 ff ff a8 	l.j b88 <_ntoa_format+0x208>
     cec:	e2 7c 80 00 	l.add r19,r28,r16

00000cf0 <_ntoa_long>:
     cf0:	9c 21 ff 94 	l.addi r1,r1,-108
     cf4:	1a 20 00 00 	l.movhi r17,0x0
     cf8:	d4 01 90 48 	l.sw 72(r1),r18
     cfc:	d4 01 a0 4c 	l.sw 76(r1),r20
     d00:	d4 01 d0 58 	l.sw 88(r1),r26
     d04:	d4 01 e0 5c 	l.sw 92(r1),r28
     d08:	d4 01 10 64 	l.sw 100(r1),r2
     d0c:	d4 01 70 40 	l.sw 64(r1),r14
     d10:	d4 01 80 44 	l.sw 68(r1),r16
     d14:	d4 01 b0 50 	l.sw 80(r1),r22
     d18:	d4 01 c0 54 	l.sw 84(r1),r24
     d1c:	d4 01 f0 60 	l.sw 96(r1),r30
     d20:	d4 01 48 68 	l.sw 104(r1),r9
     d24:	d4 01 18 14 	l.sw 20(r1),r3
     d28:	d4 01 20 18 	l.sw 24(r1),r4
     d2c:	d4 01 28 1c 	l.sw 28(r1),r5
     d30:	e4 27 88 00 	l.sfne r7,r17
     d34:	e3 46 30 04 	l.or r26,r6,r6
     d38:	e0 47 38 04 	l.or r2,r7,r7
     d3c:	a7 88 00 ff 	l.andi r28,r8,0xff
     d40:	86 41 00 6c 	l.lwz r18,108(r1)
     d44:	10 00 00 04 	l.bf d54 <_ntoa_long+0x64>
     d48:	86 81 00 78 	l.lwz r20,120(r1)
     d4c:	ae 20 ff ef 	l.xori r17,r0,-17
     d50:	e2 94 88 03 	l.and r20,r20,r17
     d54:	a6 34 04 00 	l.andi r17,r20,0x400
     d58:	1a 60 00 00 	l.movhi r19,0x0
     d5c:	e4 11 98 00 	l.sfeq r17,r19
     d60:	10 00 00 07 	l.bf d7c <_ntoa_long+0x8c>
     d64:	a6 34 00 20 	l.andi r17,r20,0x20
     d68:	e4 02 98 00 	l.sfeq r2,r19
     d6c:	10 00 00 24 	l.bf dfc <_ntoa_long+0x10c>
     d70:	86 21 00 74 	l.lwz r17,116(r1)
     d74:	a6 34 00 20 	l.andi r17,r20,0x20
     d78:	1a 60 00 00 	l.movhi r19,0x0
     d7c:	e4 31 98 00 	l.sfne r17,r19
     d80:	10 00 00 03 	l.bf d8c <_ntoa_long+0x9c>
     d84:	aa 00 00 41 	l.ori r16,r0,0x41
     d88:	aa 00 00 61 	l.ori r16,r0,0x61
     d8c:	a6 10 00 ff 	l.andi r16,r16,0xff
     d90:	e3 02 10 04 	l.or r24,r2,r2
     d94:	9e c1 00 20 	l.addi r22,r1,32
     d98:	18 40 00 00 	l.movhi r2,0x0
     d9c:	a9 c0 00 09 	l.ori r14,r0,0x9
     da0:	9e 10 ff f6 	l.addi r16,r16,-10
     da4:	ab c0 00 20 	l.ori r30,r0,0x20
     da8:	e0 92 90 04 	l.or r4,r18,r18
     dac:	04 00 04 c1 	l.jal 20b0 <__umodsi3>
     db0:	e0 78 c0 04 	l.or r3,r24,r24
     db4:	e4 4b 70 00 	l.sfgtu r11,r14
     db8:	10 00 00 2d 	l.bf e6c <_ntoa_long+0x17c>
     dbc:	a6 2b 00 ff 	l.andi r17,r11,0xff
     dc0:	9e 31 00 30 	l.addi r17,r17,48
     dc4:	aa 60 00 18 	l.ori r19,r0,0x18
     dc8:	e2 31 98 08 	l.sll r17,r17,r19
     dcc:	e2 31 98 88 	l.sra r17,r17,r19
     dd0:	d8 16 88 00 	l.sb 0(r22),r17
     dd4:	e0 92 90 04 	l.or r4,r18,r18
     dd8:	04 00 04 9d 	l.jal 204c <__udivmodsi3_internal>
     ddc:	e0 78 c0 04 	l.or r3,r24,r24
     de0:	e4 98 90 00 	l.sfltu r24,r18
     de4:	10 00 00 05 	l.bf df8 <_ntoa_long+0x108>
     de8:	9c 42 00 01 	l.addi r2,r2,1
     dec:	e4 22 f0 00 	l.sfne r2,r30
     df0:	10 00 00 1d 	l.bf e64 <_ntoa_long+0x174>
     df4:	9e d6 00 01 	l.addi r22,r22,1
     df8:	86 21 00 74 	l.lwz r17,116(r1)
     dfc:	d4 01 a0 10 	l.sw 16(r1),r20
     e00:	d4 01 88 0c 	l.sw 12(r1),r17
     e04:	d4 01 90 04 	l.sw 4(r1),r18
     e08:	d8 01 e0 03 	l.sb 3(r1),r28
     e0c:	86 21 00 70 	l.lwz r17,112(r1)
     e10:	e1 02 10 04 	l.or r8,r2,r2
     e14:	d4 01 88 08 	l.sw 8(r1),r17
     e18:	9c e1 00 20 	l.addi r7,r1,32
     e1c:	e0 da d0 04 	l.or r6,r26,r26
     e20:	84 a1 00 1c 	l.lwz r5,28(r1)
     e24:	84 81 00 18 	l.lwz r4,24(r1)
     e28:	07 ff fe d6 	l.jal 980 <_ntoa_format>
     e2c:	84 61 00 14 	l.lwz r3,20(r1)
     e30:	85 21 00 68 	l.lwz r9,104(r1)
     e34:	85 c1 00 40 	l.lwz r14,64(r1)
     e38:	86 01 00 44 	l.lwz r16,68(r1)
     e3c:	86 41 00 48 	l.lwz r18,72(r1)
     e40:	86 81 00 4c 	l.lwz r20,76(r1)
     e44:	86 c1 00 50 	l.lwz r22,80(r1)
     e48:	87 01 00 54 	l.lwz r24,84(r1)
     e4c:	87 41 00 58 	l.lwz r26,88(r1)
     e50:	87 81 00 5c 	l.lwz r28,92(r1)
     e54:	87 c1 00 60 	l.lwz r30,96(r1)
     e58:	84 41 00 64 	l.lwz r2,100(r1)
     e5c:	44 00 48 00 	l.jr r9
     e60:	9c 21 00 6c 	l.addi r1,r1,108
     e64:	03 ff ff d1 	l.j da8 <_ntoa_long+0xb8>
     e68:	e3 0b 58 04 	l.or r24,r11,r11
     e6c:	03 ff ff d6 	l.j dc4 <_ntoa_long+0xd4>
     e70:	e2 31 80 00 	l.add r17,r17,r16

00000e74 <_ntoa_long_long>:
     e74:	9c 21 ff 90 	l.addi r1,r1,-112
     e78:	e2 27 40 04 	l.or r17,r7,r8
     e7c:	1a 60 00 00 	l.movhi r19,0x0
     e80:	d4 01 70 44 	l.sw 68(r1),r14
     e84:	d4 01 90 4c 	l.sw 76(r1),r18
     e88:	d4 01 a0 50 	l.sw 80(r1),r20
     e8c:	d4 01 c0 58 	l.sw 88(r1),r24
     e90:	d4 01 f0 64 	l.sw 100(r1),r30
     e94:	d4 01 80 48 	l.sw 72(r1),r16
     e98:	d4 01 b0 54 	l.sw 84(r1),r22
     e9c:	d4 01 d0 5c 	l.sw 92(r1),r26
     ea0:	d4 01 e0 60 	l.sw 96(r1),r28
     ea4:	d4 01 10 68 	l.sw 104(r1),r2
     ea8:	d4 01 48 6c 	l.sw 108(r1),r9
     eac:	d4 01 18 14 	l.sw 20(r1),r3
     eb0:	d4 01 20 18 	l.sw 24(r1),r4
     eb4:	d4 01 28 1c 	l.sw 28(r1),r5
     eb8:	d4 01 30 20 	l.sw 32(r1),r6
     ebc:	e4 31 98 00 	l.sfne r17,r19
     ec0:	e3 c7 38 04 	l.or r30,r7,r7
     ec4:	e1 c8 40 04 	l.or r14,r8,r8
     ec8:	87 01 00 74 	l.lwz r24,116(r1)
     ecc:	86 41 00 78 	l.lwz r18,120(r1)
     ed0:	10 00 00 04 	l.bf ee0 <_ntoa_long_long+0x6c>
     ed4:	86 81 00 84 	l.lwz r20,132(r1)
     ed8:	ae a0 ff ef 	l.xori r21,r0,-17
     edc:	e2 94 a8 03 	l.and r20,r20,r21
     ee0:	a6 b4 04 00 	l.andi r21,r20,0x400
     ee4:	1a 60 00 00 	l.movhi r19,0x0
     ee8:	e4 15 98 00 	l.sfeq r21,r19
     eec:	10 00 00 04 	l.bf efc <_ntoa_long_long+0x88>
     ef0:	e4 11 98 00 	l.sfeq r17,r19
     ef4:	10 00 00 2e 	l.bf fac <_ntoa_long_long+0x138>
     ef8:	18 40 00 00 	l.movhi r2,0x0
     efc:	a6 34 00 20 	l.andi r17,r20,0x20
     f00:	1a 60 00 00 	l.movhi r19,0x0
     f04:	e4 31 98 00 	l.sfne r17,r19
     f08:	10 00 00 03 	l.bf f14 <_ntoa_long_long+0xa0>
     f0c:	aa 00 00 41 	l.ori r16,r0,0x41
     f10:	aa 00 00 61 	l.ori r16,r0,0x61
     f14:	a6 10 00 ff 	l.andi r16,r16,0xff
     f18:	9e c1 00 24 	l.addi r22,r1,36
     f1c:	18 40 00 00 	l.movhi r2,0x0
     f20:	ab 80 00 09 	l.ori r28,r0,0x9
     f24:	9e 10 ff f6 	l.addi r16,r16,-10
     f28:	ab 40 00 20 	l.ori r26,r0,0x20
     f2c:	e0 b8 c0 04 	l.or r5,r24,r24
     f30:	e0 d2 90 04 	l.or r6,r18,r18
     f34:	e0 7e f0 04 	l.or r3,r30,r30
     f38:	04 00 05 d2 	l.jal 2680 <__umoddi3>
     f3c:	e0 8e 70 04 	l.or r4,r14,r14
     f40:	aa 60 00 18 	l.ori r19,r0,0x18
     f44:	a6 2c 00 ff 	l.andi r17,r12,0xff
     f48:	e1 8c 98 08 	l.sll r12,r12,r19
     f4c:	e1 8c 98 88 	l.sra r12,r12,r19
     f50:	e5 4c e0 00 	l.sfgts r12,r28
     f54:	10 00 00 35 	l.bf 1028 <_ntoa_long_long+0x1b4>
     f58:	15 00 00 00 	l.nop 0x0
     f5c:	9e 31 00 30 	l.addi r17,r17,48
     f60:	e2 31 98 08 	l.sll r17,r17,r19
     f64:	e2 31 98 88 	l.sra r17,r17,r19
     f68:	d8 16 88 00 	l.sb 0(r22),r17
     f6c:	e0 b8 c0 04 	l.or r5,r24,r24
     f70:	e0 d2 90 04 	l.or r6,r18,r18
     f74:	e0 7e f0 04 	l.or r3,r30,r30
     f78:	04 00 04 53 	l.jal 20c4 <__udivdi3>
     f7c:	e0 8e 70 04 	l.or r4,r14,r14
     f80:	e4 58 f0 00 	l.sfgtu r24,r30
     f84:	10 00 00 0a 	l.bf fac <_ntoa_long_long+0x138>
     f88:	9c 42 00 01 	l.addi r2,r2,1
     f8c:	e4 38 f0 00 	l.sfne r24,r30
     f90:	10 00 00 05 	l.bf fa4 <_ntoa_long_long+0x130>
     f94:	e4 22 d0 00 	l.sfne r2,r26
     f98:	e4 52 70 00 	l.sfgtu r18,r14
     f9c:	10 00 00 04 	l.bf fac <_ntoa_long_long+0x138>
     fa0:	e4 22 d0 00 	l.sfne r2,r26
     fa4:	10 00 00 1e 	l.bf 101c <_ntoa_long_long+0x1a8>
     fa8:	9e d6 00 01 	l.addi r22,r22,1
     fac:	86 21 00 80 	l.lwz r17,128(r1)
     fb0:	d4 01 88 0c 	l.sw 12(r1),r17
     fb4:	86 21 00 7c 	l.lwz r17,124(r1)
     fb8:	d4 01 88 08 	l.sw 8(r1),r17
     fbc:	8e 21 00 73 	l.lbz r17,115(r1)
     fc0:	d4 01 a0 10 	l.sw 16(r1),r20
     fc4:	d4 01 90 04 	l.sw 4(r1),r18
     fc8:	d8 01 88 03 	l.sb 3(r1),r17
     fcc:	e1 02 10 04 	l.or r8,r2,r2
     fd0:	9c e1 00 24 	l.addi r7,r1,36
     fd4:	84 c1 00 20 	l.lwz r6,32(r1)
     fd8:	84 a1 00 1c 	l.lwz r5,28(r1)
     fdc:	84 81 00 18 	l.lwz r4,24(r1)
     fe0:	07 ff fe 68 	l.jal 980 <_ntoa_format>
     fe4:	84 61 00 14 	l.lwz r3,20(r1)
     fe8:	85 21 00 6c 	l.lwz r9,108(r1)
     fec:	85 c1 00 44 	l.lwz r14,68(r1)
     ff0:	86 01 00 48 	l.lwz r16,72(r1)
     ff4:	86 41 00 4c 	l.lwz r18,76(r1)
     ff8:	86 81 00 50 	l.lwz r20,80(r1)
     ffc:	86 c1 00 54 	l.lwz r22,84(r1)
    1000:	87 01 00 58 	l.lwz r24,88(r1)
    1004:	87 41 00 5c 	l.lwz r26,92(r1)
    1008:	87 81 00 60 	l.lwz r28,96(r1)
    100c:	87 c1 00 64 	l.lwz r30,100(r1)
    1010:	84 41 00 68 	l.lwz r2,104(r1)
    1014:	44 00 48 00 	l.jr r9
    1018:	9c 21 00 70 	l.addi r1,r1,112
    101c:	e3 cb 58 04 	l.or r30,r11,r11
    1020:	03 ff ff c3 	l.j f2c <_ntoa_long_long+0xb8>
    1024:	e1 cc 60 04 	l.or r14,r12,r12
    1028:	e2 31 80 00 	l.add r17,r17,r16
    102c:	03 ff ff cd 	l.j f60 <_ntoa_long_long+0xec>
    1030:	aa 60 00 18 	l.ori r19,r0,0x18

00001034 <_out_char>:
    1034:	aa 20 00 18 	l.ori r17,r0,0x18
    1038:	e0 63 88 08 	l.sll r3,r3,r17
    103c:	e0 63 88 88 	l.sra r3,r3,r17
    1040:	1a 20 00 00 	l.movhi r17,0x0
    1044:	e4 03 88 00 	l.sfeq r3,r17
    1048:	10 00 00 04 	l.bf 1058 <_out_char+0x24>
    104c:	15 00 00 00 	l.nop 0x0
    1050:	03 ff fe 16 	l.j 8a8 <_putchar>
    1054:	15 00 00 00 	l.nop 0x0
    1058:	44 00 48 00 	l.jr r9
    105c:	15 00 00 00 	l.nop 0x0

00001060 <_out_fct>:
    1060:	aa 20 00 18 	l.ori r17,r0,0x18
    1064:	e0 63 88 08 	l.sll r3,r3,r17
    1068:	e0 63 88 88 	l.sra r3,r3,r17
    106c:	1a 20 00 00 	l.movhi r17,0x0
    1070:	e4 03 88 00 	l.sfeq r3,r17
    1074:	10 00 00 05 	l.bf 1088 <_out_fct+0x28>
    1078:	15 00 00 00 	l.nop 0x0
    107c:	86 24 00 00 	l.lwz r17,0(r4)
    1080:	44 00 88 00 	l.jr r17
    1084:	84 84 00 04 	l.lwz r4,4(r4)
    1088:	44 00 48 00 	l.jr r9
    108c:	15 00 00 00 	l.nop 0x0

00001090 <_vsnprintf>:
    1090:	9c 21 ff a4 	l.addi r1,r1,-92
    1094:	1a 20 00 00 	l.movhi r17,0x0
    1098:	d4 01 80 34 	l.sw 52(r1),r16
    109c:	d4 01 a0 3c 	l.sw 60(r1),r20
    10a0:	d4 01 b0 40 	l.sw 64(r1),r22
    10a4:	d4 01 10 54 	l.sw 84(r1),r2
    10a8:	d4 01 70 30 	l.sw 48(r1),r14
    10ac:	d4 01 90 38 	l.sw 56(r1),r18
    10b0:	d4 01 c0 44 	l.sw 68(r1),r24
    10b4:	d4 01 d0 48 	l.sw 72(r1),r26
    10b8:	d4 01 e0 4c 	l.sw 76(r1),r28
    10bc:	d4 01 f0 50 	l.sw 80(r1),r30
    10c0:	d4 01 48 58 	l.sw 88(r1),r9
    10c4:	e4 04 88 00 	l.sfeq r4,r17
    10c8:	e2 c4 20 04 	l.or r22,r4,r4
    10cc:	e2 85 28 04 	l.or r20,r5,r5
    10d0:	e2 06 30 04 	l.or r16,r6,r6
    10d4:	0c 00 01 e6 	l.bnf 186c <_vsnprintf+0x7dc>
    10d8:	e0 47 38 04 	l.or r2,r7,r7
    10dc:	1a 40 00 00 	l.movhi r18,0x0
    10e0:	9e 52 09 78 	l.addi r18,r18,2424
    10e4:	1b 00 00 12 	l.movhi r24,0x12
    10e8:	aa 38 08 21 	l.ori r17,r24,0x821
    10ec:	1b 80 00 00 	l.movhi r28,0x0
    10f0:	00 00 02 1a 	l.j 1958 <_vsnprintf+0x8c8>
    10f4:	d4 01 88 20 	l.sw 32(r1),r17
    10f8:	e4 03 88 00 	l.sfeq r3,r17
    10fc:	10 00 00 09 	l.bf 1120 <_vsnprintf+0x90>
    1100:	9e 10 00 01 	l.addi r16,r16,1
    1104:	e0 bc e0 04 	l.or r5,r28,r28
    1108:	9f 5c 00 01 	l.addi r26,r28,1
    110c:	e0 d4 a0 04 	l.or r6,r20,r20
    1110:	48 00 90 00 	l.jalr r18
    1114:	e0 96 b0 04 	l.or r4,r22,r22
    1118:	00 00 02 10 	l.j 1958 <_vsnprintf+0x8c8>
    111c:	e3 9a d0 04 	l.or r28,r26,r26
    1120:	1a 20 00 00 	l.movhi r17,0x0
    1124:	ab 20 00 2b 	l.ori r25,r0,0x2b
    1128:	ab 60 00 30 	l.ori r27,r0,0x30
    112c:	ab a0 00 20 	l.ori r29,r0,0x20
    1130:	ab e0 00 23 	l.ori r31,r0,0x23
    1134:	92 b0 00 00 	l.lbs r21,0(r16)
    1138:	e4 15 c8 00 	l.sfeq r21,r25
    113c:	8e 70 00 00 	l.lbz r19,0(r16)
    1140:	10 00 00 1e 	l.bf 11b8 <_vsnprintf+0x128>
    1144:	9e f0 00 01 	l.addi r23,r16,1
    1148:	e5 55 c8 00 	l.sfgts r21,r25
    114c:	10 00 00 11 	l.bf 1190 <_vsnprintf+0x100>
    1150:	a9 a0 00 2d 	l.ori r13,r0,0x2d
    1154:	e4 15 e8 00 	l.sfeq r21,r29
    1158:	10 00 00 1a 	l.bf 11c0 <_vsnprintf+0x130>
    115c:	e4 15 f8 00 	l.sfeq r21,r31
    1160:	10 00 00 1a 	l.bf 11c8 <_vsnprintf+0x138>
    1164:	aa a0 00 18 	l.ori r21,r0,0x18
    1168:	e2 73 a8 08 	l.sll r19,r19,r21
    116c:	e2 73 a8 88 	l.sra r19,r19,r21
    1170:	9e b3 ff d0 	l.addi r21,r19,-48
    1174:	a6 b5 00 ff 	l.andi r21,r21,0xff
    1178:	ab 20 00 09 	l.ori r25,r0,0x9
    117c:	e4 b5 c8 00 	l.sfleu r21,r25
    1180:	0c 00 00 30 	l.bnf 1240 <_vsnprintf+0x1b0>
    1184:	aa a0 00 2a 	l.ori r21,r0,0x2a
    1188:	00 00 00 19 	l.j 11ec <_vsnprintf+0x15c>
    118c:	1b c0 00 00 	l.movhi r30,0x0
    1190:	e4 15 68 00 	l.sfeq r21,r13
    1194:	10 00 00 07 	l.bf 11b0 <_vsnprintf+0x120>
    1198:	e4 35 d8 00 	l.sfne r21,r27
    119c:	13 ff ff f3 	l.bf 1168 <_vsnprintf+0xd8>
    11a0:	aa a0 00 18 	l.ori r21,r0,0x18
    11a4:	aa 31 00 01 	l.ori r17,r17,0x1
    11a8:	03 ff ff e3 	l.j 1134 <_vsnprintf+0xa4>
    11ac:	e2 17 b8 04 	l.or r16,r23,r23
    11b0:	03 ff ff fe 	l.j 11a8 <_vsnprintf+0x118>
    11b4:	aa 31 00 02 	l.ori r17,r17,0x2
    11b8:	03 ff ff fc 	l.j 11a8 <_vsnprintf+0x118>
    11bc:	aa 31 00 04 	l.ori r17,r17,0x4
    11c0:	03 ff ff fa 	l.j 11a8 <_vsnprintf+0x118>
    11c4:	aa 31 00 08 	l.ori r17,r17,0x8
    11c8:	03 ff ff f8 	l.j 11a8 <_vsnprintf+0x118>
    11cc:	aa 31 00 10 	l.ori r17,r17,0x10
    11d0:	aa 60 00 02 	l.ori r19,r0,0x2
    11d4:	e2 be 98 08 	l.sll r21,r30,r19
    11d8:	e2 75 f0 00 	l.add r19,r21,r30
    11dc:	e2 73 98 00 	l.add r19,r19,r19
    11e0:	9e 73 ff d0 	l.addi r19,r19,-48
    11e4:	e3 d7 98 00 	l.add r30,r23,r19
    11e8:	e2 1b d8 04 	l.or r16,r27,r27
    11ec:	92 f0 00 00 	l.lbs r23,0(r16)
    11f0:	9e b7 ff d0 	l.addi r21,r23,-48
    11f4:	a6 b5 00 ff 	l.andi r21,r21,0xff
    11f8:	e4 b5 c8 00 	l.sfleu r21,r25
    11fc:	13 ff ff f5 	l.bf 11d0 <_vsnprintf+0x140>
    1200:	9f 70 00 01 	l.addi r27,r16,1
    1204:	92 b0 00 00 	l.lbs r21,0(r16)
    1208:	aa 60 00 2e 	l.ori r19,r0,0x2e
    120c:	e4 35 98 00 	l.sfne r21,r19
    1210:	10 00 00 28 	l.bf 12b0 <_vsnprintf+0x220>
    1214:	19 c0 00 00 	l.movhi r14,0x0
    1218:	93 30 00 01 	l.lbs r25,1(r16)
    121c:	9e b9 ff d0 	l.addi r21,r25,-48
    1220:	a6 b5 00 ff 	l.andi r21,r21,0xff
    1224:	ab 60 00 09 	l.ori r27,r0,0x9
    1228:	e4 b5 d8 00 	l.sfleu r21,r27
    122c:	9e f0 00 01 	l.addi r23,r16,1
    1230:	0c 00 00 48 	l.bnf 1350 <_vsnprintf+0x2c0>
    1234:	aa 31 04 00 	l.ori r17,r17,0x400
    1238:	00 00 00 18 	l.j 1298 <_vsnprintf+0x208>
    123c:	e2 17 b8 04 	l.or r16,r23,r23
    1240:	e4 33 a8 00 	l.sfne r19,r21
    1244:	13 ff ff f0 	l.bf 1204 <_vsnprintf+0x174>
    1248:	1b c0 00 00 	l.movhi r30,0x0
    124c:	1b 20 00 00 	l.movhi r25,0x0
    1250:	86 62 00 00 	l.lwz r19,0(r2)
    1254:	e5 73 c8 00 	l.sfges r19,r25
    1258:	10 00 00 07 	l.bf 1274 <_vsnprintf+0x1e4>
    125c:	9e a2 00 04 	l.addi r21,r2,4
    1260:	aa 31 00 02 	l.ori r17,r17,0x2
    1264:	e3 c0 98 02 	l.sub r30,r0,r19
    1268:	e2 17 b8 04 	l.or r16,r23,r23
    126c:	03 ff ff e6 	l.j 1204 <_vsnprintf+0x174>
    1270:	e0 55 a8 04 	l.or r2,r21,r21
    1274:	03 ff ff fd 	l.j 1268 <_vsnprintf+0x1d8>
    1278:	e3 d3 98 04 	l.or r30,r19,r19
    127c:	aa 60 00 02 	l.ori r19,r0,0x2
    1280:	e2 ee 98 08 	l.sll r23,r14,r19
    1284:	e2 b7 70 00 	l.add r21,r23,r14
    1288:	e2 b5 a8 00 	l.add r21,r21,r21
    128c:	9e b5 ff d0 	l.addi r21,r21,-48
    1290:	e1 d9 a8 00 	l.add r14,r25,r21
    1294:	e2 1d e8 04 	l.or r16,r29,r29
    1298:	93 30 00 00 	l.lbs r25,0(r16)
    129c:	9e f9 ff d0 	l.addi r23,r25,-48
    12a0:	a6 f7 00 ff 	l.andi r23,r23,0xff
    12a4:	e4 b7 d8 00 	l.sfleu r23,r27
    12a8:	13 ff ff f5 	l.bf 127c <_vsnprintf+0x1ec>
    12ac:	9f b0 00 01 	l.addi r29,r16,1
    12b0:	92 f0 00 00 	l.lbs r23,0(r16)
    12b4:	ab 60 00 6c 	l.ori r27,r0,0x6c
    12b8:	e4 17 d8 00 	l.sfeq r23,r27
    12bc:	10 00 00 3b 	l.bf 13a8 <_vsnprintf+0x318>
    12c0:	9f 30 00 01 	l.addi r25,r16,1
    12c4:	e5 57 d8 00 	l.sfgts r23,r27
    12c8:	10 00 00 32 	l.bf 1390 <_vsnprintf+0x300>
    12cc:	aa 60 00 68 	l.ori r19,r0,0x68
    12d0:	e4 17 98 00 	l.sfeq r23,r19
    12d4:	10 00 00 3c 	l.bf 13c4 <_vsnprintf+0x334>
    12d8:	aa 60 00 6a 	l.ori r19,r0,0x6a
    12dc:	e4 17 98 00 	l.sfeq r23,r19
    12e0:	10 00 00 41 	l.bf 13e4 <_vsnprintf+0x354>
    12e4:	15 00 00 00 	l.nop 0x0
    12e8:	e3 30 80 04 	l.or r25,r16,r16
    12ec:	90 79 00 00 	l.lbs r3,0(r25)
    12f0:	ab 60 00 78 	l.ori r27,r0,0x78
    12f4:	e5 43 d8 00 	l.sfgts r3,r27
    12f8:	13 ff ff 83 	l.bf 1104 <_vsnprintf+0x74>
    12fc:	9e 19 00 01 	l.addi r16,r25,1
    1300:	aa e0 00 63 	l.ori r23,r0,0x63
    1304:	e5 43 b8 00 	l.sfgts r3,r23
    1308:	10 00 00 39 	l.bf 13ec <_vsnprintf+0x35c>
    130c:	86 61 00 20 	l.lwz r19,32(r1)
    1310:	aa 60 00 62 	l.ori r19,r0,0x62
    1314:	e4 03 98 00 	l.sfeq r3,r19
    1318:	10 00 01 57 	l.bf 1874 <_vsnprintf+0x7e4>
    131c:	e4 03 b8 00 	l.sfeq r3,r23
    1320:	10 00 00 ac 	l.bf 15d0 <_vsnprintf+0x540>
    1324:	aa 60 00 25 	l.ori r19,r0,0x25
    1328:	e4 03 98 00 	l.sfeq r3,r19
    132c:	13 ff ff 76 	l.bf 1104 <_vsnprintf+0x74>
    1330:	aa 60 00 58 	l.ori r19,r0,0x58
    1334:	e4 03 98 00 	l.sfeq r3,r19
    1338:	0f ff ff 73 	l.bnf 1104 <_vsnprintf+0x74>
    133c:	aa 31 00 20 	l.ori r17,r17,0x20
    1340:	aa e0 00 10 	l.ori r23,r0,0x10
    1344:	af 20 ff f3 	l.xori r25,r0,-13
    1348:	00 00 01 55 	l.j 189c <_vsnprintf+0x80c>
    134c:	e2 31 c8 03 	l.and r17,r17,r25
    1350:	aa 60 00 2a 	l.ori r19,r0,0x2a
    1354:	e4 39 98 00 	l.sfne r25,r19
    1358:	10 00 00 0b 	l.bf 1384 <_vsnprintf+0x2f4>
    135c:	15 00 00 00 	l.nop 0x0
    1360:	1a 60 00 00 	l.movhi r19,0x0
    1364:	86 a2 00 00 	l.lwz r21,0(r2)
    1368:	e5 75 98 00 	l.sfges r21,r19
    136c:	10 00 00 03 	l.bf 1378 <_vsnprintf+0x2e8>
    1370:	e1 d5 a8 04 	l.or r14,r21,r21
    1374:	19 c0 00 00 	l.movhi r14,0x0
    1378:	9e 10 00 02 	l.addi r16,r16,2
    137c:	03 ff ff cd 	l.j 12b0 <_vsnprintf+0x220>
    1380:	9c 42 00 04 	l.addi r2,r2,4
    1384:	e2 17 b8 04 	l.or r16,r23,r23
    1388:	03 ff ff ca 	l.j 12b0 <_vsnprintf+0x220>
    138c:	19 c0 00 00 	l.movhi r14,0x0
    1390:	aa 60 00 7a 	l.ori r19,r0,0x7a
    1394:	e4 17 98 00 	l.sfeq r23,r19
    1398:	0f ff ff d4 	l.bnf 12e8 <_vsnprintf+0x258>
    139c:	15 00 00 00 	l.nop 0x0
    13a0:	03 ff ff d3 	l.j 12ec <_vsnprintf+0x25c>
    13a4:	aa 31 01 00 	l.ori r17,r17,0x100
    13a8:	93 70 00 01 	l.lbs r27,1(r16)
    13ac:	e4 1b b8 00 	l.sfeq r27,r23
    13b0:	0f ff ff fc 	l.bnf 13a0 <_vsnprintf+0x310>
    13b4:	15 00 00 00 	l.nop 0x0
    13b8:	aa 31 03 00 	l.ori r17,r17,0x300
    13bc:	03 ff ff cc 	l.j 12ec <_vsnprintf+0x25c>
    13c0:	9f 30 00 02 	l.addi r25,r16,2
    13c4:	93 70 00 01 	l.lbs r27,1(r16)
    13c8:	e4 1b b8 00 	l.sfeq r27,r23
    13cc:	10 00 00 04 	l.bf 13dc <_vsnprintf+0x34c>
    13d0:	15 00 00 00 	l.nop 0x0
    13d4:	03 ff ff c6 	l.j 12ec <_vsnprintf+0x25c>
    13d8:	aa 31 00 80 	l.ori r17,r17,0x80
    13dc:	03 ff ff f8 	l.j 13bc <_vsnprintf+0x32c>
    13e0:	aa 31 00 c0 	l.ori r17,r17,0xc0
    13e4:	03 ff ff c2 	l.j 12ec <_vsnprintf+0x25c>
    13e8:	aa 31 02 00 	l.ori r17,r17,0x200
    13ec:	9f 23 ff 9c 	l.addi r25,r3,-100
    13f0:	a7 39 00 ff 	l.andi r25,r25,0xff
    13f4:	aa e0 00 01 	l.ori r23,r0,0x1
    13f8:	e2 f7 c8 08 	l.sll r23,r23,r25
    13fc:	e2 f7 98 03 	l.and r23,r23,r19
    1400:	1a 60 00 00 	l.movhi r19,0x0
    1404:	e4 37 98 00 	l.sfne r23,r19
    1408:	10 00 00 11 	l.bf 144c <_vsnprintf+0x3bc>
    140c:	aa 60 00 73 	l.ori r19,r0,0x73
    1410:	e4 03 98 00 	l.sfeq r3,r19
    1414:	10 00 00 a9 	l.bf 16b8 <_vsnprintf+0x628>
    1418:	aa 60 00 70 	l.ori r19,r0,0x70
    141c:	e4 03 98 00 	l.sfeq r3,r19
    1420:	0f ff ff 3a 	l.bnf 1108 <_vsnprintf+0x78>
    1424:	e0 bc e0 04 	l.or r5,r28,r28
    1428:	aa 31 00 21 	l.ori r17,r17,0x21
    142c:	d4 01 88 0c 	l.sw 12(r1),r17
    1430:	aa 20 00 08 	l.ori r17,r0,0x8
    1434:	d4 01 88 08 	l.sw 8(r1),r17
    1438:	aa 20 00 10 	l.ori r17,r0,0x10
    143c:	9f 42 00 04 	l.addi r26,r2,4
    1440:	d4 01 70 04 	l.sw 4(r1),r14
    1444:	00 00 00 4d 	l.j 1578 <_vsnprintf+0x4e8>
    1448:	d4 01 88 00 	l.sw 0(r1),r17
    144c:	aa e0 00 6f 	l.ori r23,r0,0x6f
    1450:	e4 03 b8 00 	l.sfeq r3,r23
    1454:	0c 00 01 0a 	l.bnf 187c <_vsnprintf+0x7ec>
    1458:	e5 43 b8 00 	l.sfgts r3,r23
    145c:	03 ff ff ba 	l.j 1344 <_vsnprintf+0x2b4>
    1460:	aa e0 00 08 	l.ori r23,r0,0x8
    1464:	10 00 00 05 	l.bf 1478 <_vsnprintf+0x3e8>
    1468:	aa e0 00 10 	l.ori r23,r0,0x10
    146c:	ae e0 ff ef 	l.xori r23,r0,-17
    1470:	e2 31 b8 03 	l.and r17,r17,r23
    1474:	aa e0 00 0a 	l.ori r23,r0,0xa
    1478:	aa 60 00 64 	l.ori r19,r0,0x64
    147c:	e4 03 98 00 	l.sfeq r3,r19
    1480:	10 00 01 07 	l.bf 189c <_vsnprintf+0x80c>
    1484:	af 20 ff f3 	l.xori r25,r0,-13
    1488:	00 00 01 05 	l.j 189c <_vsnprintf+0x80c>
    148c:	e2 31 c8 03 	l.and r17,r17,r25
    1490:	1a 60 00 00 	l.movhi r19,0x0
    1494:	e4 19 98 00 	l.sfeq r25,r19
    1498:	10 00 00 15 	l.bf 14ec <_vsnprintf+0x45c>
    149c:	9f 42 00 04 	l.addi r26,r2,4
    14a0:	84 e2 00 00 	l.lwz r7,0(r2)
    14a4:	aa 60 00 1f 	l.ori r19,r0,0x1f
    14a8:	e1 07 98 48 	l.srl r8,r7,r19
    14ac:	1a 60 00 00 	l.movhi r19,0x0
    14b0:	e5 67 98 00 	l.sfges r7,r19
    14b4:	10 00 00 03 	l.bf 14c0 <_vsnprintf+0x430>
    14b8:	15 00 00 00 	l.nop 0x0
    14bc:	e0 e0 38 02 	l.sub r7,r0,r7
    14c0:	d4 01 88 0c 	l.sw 12(r1),r17
    14c4:	d4 01 f0 08 	l.sw 8(r1),r30
    14c8:	d4 01 70 04 	l.sw 4(r1),r14
    14cc:	d4 01 b8 00 	l.sw 0(r1),r23
    14d0:	e0 d4 a0 04 	l.or r6,r20,r20
    14d4:	e0 bc e0 04 	l.or r5,r28,r28
    14d8:	e0 96 b0 04 	l.or r4,r22,r22
    14dc:	07 ff fe 05 	l.jal cf0 <_ntoa_long>
    14e0:	e0 72 90 04 	l.or r3,r18,r18
    14e4:	00 00 01 1c 	l.j 1954 <_vsnprintf+0x8c4>
    14e8:	e3 8b 58 04 	l.or r28,r11,r11
    14ec:	a7 31 00 40 	l.andi r25,r17,0x40
    14f0:	e4 19 98 00 	l.sfeq r25,r19
    14f4:	84 e2 00 00 	l.lwz r7,0(r2)
    14f8:	0c 00 00 08 	l.bnf 1518 <_vsnprintf+0x488>
    14fc:	aa 60 00 18 	l.ori r19,r0,0x18
    1500:	a7 31 00 80 	l.andi r25,r17,0x80
    1504:	1a 60 00 00 	l.movhi r19,0x0
    1508:	e4 19 98 00 	l.sfeq r25,r19
    150c:	13 ff ff e7 	l.bf 14a8 <_vsnprintf+0x418>
    1510:	aa 60 00 1f 	l.ori r19,r0,0x1f
    1514:	aa 60 00 10 	l.ori r19,r0,0x10
    1518:	e0 e7 98 08 	l.sll r7,r7,r19
    151c:	03 ff ff e2 	l.j 14a4 <_vsnprintf+0x414>
    1520:	e0 e7 98 88 	l.sra r7,r7,r19
    1524:	e4 19 98 00 	l.sfeq r25,r19
    1528:	10 00 00 0c 	l.bf 1558 <_vsnprintf+0x4c8>
    152c:	a7 31 01 00 	l.andi r25,r17,0x100
    1530:	84 e2 00 00 	l.lwz r7,0(r2)
    1534:	85 02 00 04 	l.lwz r8,4(r2)
    1538:	9f 42 00 08 	l.addi r26,r2,8
    153c:	d4 01 88 14 	l.sw 20(r1),r17
    1540:	d4 01 f0 10 	l.sw 16(r1),r30
    1544:	d4 01 70 0c 	l.sw 12(r1),r14
    1548:	d4 01 b8 08 	l.sw 8(r1),r23
    154c:	d4 01 00 04 	l.sw 4(r1),r0
    1550:	00 00 00 fb 	l.j 193c <_vsnprintf+0x8ac>
    1554:	d8 01 00 03 	l.sb 3(r1),r0
    1558:	1a 60 00 00 	l.movhi r19,0x0
    155c:	e4 19 98 00 	l.sfeq r25,r19
    1560:	10 00 00 09 	l.bf 1584 <_vsnprintf+0x4f4>
    1564:	9f 42 00 04 	l.addi r26,r2,4
    1568:	d4 01 88 0c 	l.sw 12(r1),r17
    156c:	d4 01 f0 08 	l.sw 8(r1),r30
    1570:	d4 01 70 04 	l.sw 4(r1),r14
    1574:	d4 01 b8 00 	l.sw 0(r1),r23
    1578:	19 00 00 00 	l.movhi r8,0x0
    157c:	03 ff ff d5 	l.j 14d0 <_vsnprintf+0x440>
    1580:	84 e2 00 00 	l.lwz r7,0(r2)
    1584:	a7 31 00 40 	l.andi r25,r17,0x40
    1588:	1a 60 00 00 	l.movhi r19,0x0
    158c:	e4 19 98 00 	l.sfeq r25,r19
    1590:	10 00 00 09 	l.bf 15b4 <_vsnprintf+0x524>
    1594:	84 e2 00 00 	l.lwz r7,0(r2)
    1598:	a4 e7 00 ff 	l.andi r7,r7,0xff
    159c:	d4 01 88 0c 	l.sw 12(r1),r17
    15a0:	d4 01 f0 08 	l.sw 8(r1),r30
    15a4:	d4 01 70 04 	l.sw 4(r1),r14
    15a8:	d4 01 b8 00 	l.sw 0(r1),r23
    15ac:	03 ff ff c9 	l.j 14d0 <_vsnprintf+0x440>
    15b0:	19 00 00 00 	l.movhi r8,0x0
    15b4:	a7 31 00 80 	l.andi r25,r17,0x80
    15b8:	1a 60 00 00 	l.movhi r19,0x0
    15bc:	e4 19 98 00 	l.sfeq r25,r19
    15c0:	13 ff ff f7 	l.bf 159c <_vsnprintf+0x50c>
    15c4:	15 00 00 00 	l.nop 0x0
    15c8:	03 ff ff f5 	l.j 159c <_vsnprintf+0x50c>
    15cc:	a4 e7 ff ff 	l.andi r7,r7,0xffff
    15d0:	a7 51 00 02 	l.andi r26,r17,0x2
    15d4:	1a 20 00 00 	l.movhi r17,0x0
    15d8:	e4 1a 88 00 	l.sfeq r26,r17
    15dc:	0c 00 00 17 	l.bnf 1638 <_vsnprintf+0x5a8>
    15e0:	a9 c0 00 01 	l.ori r14,r0,0x1
    15e4:	19 c0 00 00 	l.movhi r14,0x0
    15e8:	00 00 00 05 	l.j 15fc <_vsnprintf+0x56c>
    15ec:	ab 00 00 20 	l.ori r24,r0,0x20
    15f0:	e0 96 b0 04 	l.or r4,r22,r22
    15f4:	48 00 90 00 	l.jalr r18
    15f8:	e0 78 c0 04 	l.or r3,r24,r24
    15fc:	e0 bc 70 00 	l.add r5,r28,r14
    1600:	9d ce 00 01 	l.addi r14,r14,1
    1604:	e4 5e 70 00 	l.sfgtu r30,r14
    1608:	13 ff ff fa 	l.bf 15f0 <_vsnprintf+0x560>
    160c:	e0 d4 a0 04 	l.or r6,r20,r20
    1610:	1a 60 00 00 	l.movhi r19,0x0
    1614:	e4 3e 98 00 	l.sfne r30,r19
    1618:	10 00 00 03 	l.bf 1624 <_vsnprintf+0x594>
    161c:	9e 3e ff ff 	l.addi r17,r30,-1
    1620:	1a 20 00 00 	l.movhi r17,0x0
    1624:	e3 9c 88 00 	l.add r28,r28,r17
    1628:	9e 3e 00 01 	l.addi r17,r30,1
    162c:	10 00 00 03 	l.bf 1638 <_vsnprintf+0x5a8>
    1630:	e1 d1 88 04 	l.or r14,r17,r17
    1634:	a9 c0 00 02 	l.ori r14,r0,0x2
    1638:	9e 22 00 04 	l.addi r17,r2,4
    163c:	d4 01 88 18 	l.sw 24(r1),r17
    1640:	e0 d4 a0 04 	l.or r6,r20,r20
    1644:	e0 bc e0 04 	l.or r5,r28,r28
    1648:	e0 96 b0 04 	l.or r4,r22,r22
    164c:	48 00 90 00 	l.jalr r18
    1650:	8c 62 00 03 	l.lbz r3,3(r2)
    1654:	1a 20 00 00 	l.movhi r17,0x0
    1658:	e4 3a 88 00 	l.sfne r26,r17
    165c:	0c 00 00 14 	l.bnf 16ac <_vsnprintf+0x61c>
    1660:	9f 1c 00 01 	l.addi r24,r28,1
    1664:	e3 4e 70 04 	l.or r26,r14,r14
    1668:	e0 b8 c0 04 	l.or r5,r24,r24
    166c:	00 00 00 08 	l.j 168c <_vsnprintf+0x5fc>
    1670:	a8 40 00 20 	l.ori r2,r0,0x20
    1674:	e0 96 b0 04 	l.or r4,r22,r22
    1678:	e0 62 10 04 	l.or r3,r2,r2
    167c:	48 00 90 00 	l.jalr r18
    1680:	9f 85 00 01 	l.addi r28,r5,1
    1684:	9f 5a 00 01 	l.addi r26,r26,1
    1688:	e0 bc e0 04 	l.or r5,r28,r28
    168c:	e4 9a f0 00 	l.sfltu r26,r30
    1690:	13 ff ff f9 	l.bf 1674 <_vsnprintf+0x5e4>
    1694:	e0 d4 a0 04 	l.or r6,r20,r20
    1698:	e4 7e 70 00 	l.sfgeu r30,r14
    169c:	10 00 00 03 	l.bf 16a8 <_vsnprintf+0x618>
    16a0:	e2 fe 70 02 	l.sub r23,r30,r14
    16a4:	1a e0 00 00 	l.movhi r23,0x0
    16a8:	e3 18 b8 00 	l.add r24,r24,r23
    16ac:	e3 98 c0 04 	l.or r28,r24,r24
    16b0:	00 00 00 aa 	l.j 1958 <_vsnprintf+0x8c8>
    16b4:	84 41 00 18 	l.lwz r2,24(r1)
    16b8:	9e 62 00 04 	l.addi r19,r2,4
    16bc:	d4 01 98 1c 	l.sw 28(r1),r19
    16c0:	1a 60 00 00 	l.movhi r19,0x0
    16c4:	e4 0e 98 00 	l.sfeq r14,r19
    16c8:	ae e0 ff ff 	l.xori r23,r0,-1
    16cc:	10 00 00 03 	l.bf 16d8 <_vsnprintf+0x648>
    16d0:	87 42 00 00 	l.lwz r26,0(r2)
    16d4:	e2 ee 70 04 	l.or r23,r14,r14
    16d8:	e3 7a b8 00 	l.add r27,r26,r23
    16dc:	e2 fa d0 04 	l.or r23,r26,r26
    16e0:	93 b7 00 00 	l.lbs r29,0(r23)
    16e4:	1a 60 00 00 	l.movhi r19,0x0
    16e8:	e4 1d 98 00 	l.sfeq r29,r19
    16ec:	10 00 00 04 	l.bf 16fc <_vsnprintf+0x66c>
    16f0:	e4 3b b8 00 	l.sfne r27,r23
    16f4:	10 00 00 15 	l.bf 1748 <_vsnprintf+0x6b8>
    16f8:	15 00 00 00 	l.nop 0x0
    16fc:	a6 71 04 00 	l.andi r19,r17,0x400
    1700:	1a a0 00 00 	l.movhi r21,0x0
    1704:	d4 01 98 18 	l.sw 24(r1),r19
    1708:	e4 13 a8 00 	l.sfeq r19,r21
    170c:	10 00 00 06 	l.bf 1724 <_vsnprintf+0x694>
    1710:	e3 17 d0 02 	l.sub r24,r23,r26
    1714:	e4 b8 70 00 	l.sfleu r24,r14
    1718:	10 00 00 04 	l.bf 1728 <_vsnprintf+0x698>
    171c:	a4 51 00 02 	l.andi r2,r17,0x2
    1720:	e3 0e 70 04 	l.or r24,r14,r14
    1724:	a4 51 00 02 	l.andi r2,r17,0x2
    1728:	1a 20 00 00 	l.movhi r17,0x0
    172c:	e4 02 88 00 	l.sfeq r2,r17
    1730:	0c 00 00 28 	l.bnf 17d0 <_vsnprintf+0x740>
    1734:	e2 3c e0 04 	l.or r17,r28,r28
    1738:	e0 bc e0 04 	l.or r5,r28,r28
    173c:	e3 78 e0 02 	l.sub r27,r24,r28
    1740:	00 00 00 0e 	l.j 1778 <_vsnprintf+0x6e8>
    1744:	a8 60 00 20 	l.ori r3,r0,0x20
    1748:	03 ff ff e6 	l.j 16e0 <_vsnprintf+0x650>
    174c:	9e f7 00 01 	l.addi r23,r23,1
    1750:	9e 25 00 01 	l.addi r17,r5,1
    1754:	d4 01 d8 2c 	l.sw 44(r1),r27
    1758:	d4 01 88 28 	l.sw 40(r1),r17
    175c:	d4 01 18 24 	l.sw 36(r1),r3
    1760:	48 00 90 00 	l.jalr r18
    1764:	e0 96 b0 04 	l.or r4,r22,r22
    1768:	86 21 00 28 	l.lwz r17,40(r1)
    176c:	e0 b1 88 04 	l.or r5,r17,r17
    1770:	84 61 00 24 	l.lwz r3,36(r1)
    1774:	87 61 00 2c 	l.lwz r27,44(r1)
    1778:	e2 3b 28 00 	l.add r17,r27,r5
    177c:	e4 91 f0 00 	l.sfltu r17,r30
    1780:	13 ff ff f4 	l.bf 1750 <_vsnprintf+0x6c0>
    1784:	e0 d4 a0 04 	l.or r6,r20,r20
    1788:	e4 7e c0 00 	l.sfgeu r30,r24
    178c:	10 00 00 03 	l.bf 1798 <_vsnprintf+0x708>
    1790:	e2 3e c0 02 	l.sub r17,r30,r24
    1794:	1a 20 00 00 	l.movhi r17,0x0
    1798:	9e f8 00 01 	l.addi r23,r24,1
    179c:	e3 9c 88 00 	l.add r28,r28,r17
    17a0:	e3 11 b8 00 	l.add r24,r17,r23
    17a4:	00 00 00 0b 	l.j 17d0 <_vsnprintf+0x740>
    17a8:	e2 3c e0 04 	l.or r17,r28,r28
    17ac:	e1 db d8 04 	l.or r14,r27,r27
    17b0:	9f 71 00 01 	l.addi r27,r17,1
    17b4:	d4 01 d8 24 	l.sw 36(r1),r27
    17b8:	e0 b1 88 04 	l.or r5,r17,r17
    17bc:	e0 d4 a0 04 	l.or r6,r20,r20
    17c0:	48 00 90 00 	l.jalr r18
    17c4:	e0 96 b0 04 	l.or r4,r22,r22
    17c8:	87 61 00 24 	l.lwz r27,36(r1)
    17cc:	e2 3b d8 04 	l.or r17,r27,r27
    17d0:	e3 71 e0 02 	l.sub r27,r17,r28
    17d4:	e3 7a d8 00 	l.add r27,r26,r27
    17d8:	90 7b 00 00 	l.lbs r3,0(r27)
    17dc:	1a 60 00 00 	l.movhi r19,0x0
    17e0:	e4 03 98 00 	l.sfeq r3,r19
    17e4:	10 00 00 08 	l.bf 1804 <_vsnprintf+0x774>
    17e8:	86 a1 00 18 	l.lwz r21,24(r1)
    17ec:	e4 15 98 00 	l.sfeq r21,r19
    17f0:	13 ff ff f0 	l.bf 17b0 <_vsnprintf+0x720>
    17f4:	e4 2e 98 00 	l.sfne r14,r19
    17f8:	13 ff ff ed 	l.bf 17ac <_vsnprintf+0x71c>
    17fc:	9f 6e ff ff 	l.addi r27,r14,-1
    1800:	1a 60 00 00 	l.movhi r19,0x0
    1804:	e4 22 98 00 	l.sfne r2,r19
    1808:	0c 00 00 16 	l.bnf 1860 <_vsnprintf+0x7d0>
    180c:	15 00 00 00 	l.nop 0x0
    1810:	e0 b1 88 04 	l.or r5,r17,r17
    1814:	e0 58 88 02 	l.sub r2,r24,r17
    1818:	00 00 00 09 	l.j 183c <_vsnprintf+0x7ac>
    181c:	ab 40 00 20 	l.ori r26,r0,0x20
    1820:	d4 01 88 18 	l.sw 24(r1),r17
    1824:	e0 96 b0 04 	l.or r4,r22,r22
    1828:	e0 7a d0 04 	l.or r3,r26,r26
    182c:	48 00 90 00 	l.jalr r18
    1830:	9f 85 00 01 	l.addi r28,r5,1
    1834:	e0 bc e0 04 	l.or r5,r28,r28
    1838:	86 21 00 18 	l.lwz r17,24(r1)
    183c:	e2 a5 10 00 	l.add r21,r5,r2
    1840:	e4 5e a8 00 	l.sfgtu r30,r21
    1844:	13 ff ff f7 	l.bf 1820 <_vsnprintf+0x790>
    1848:	e0 d4 a0 04 	l.or r6,r20,r20
    184c:	e4 7e c0 00 	l.sfgeu r30,r24
    1850:	10 00 00 03 	l.bf 185c <_vsnprintf+0x7cc>
    1854:	e2 be c0 02 	l.sub r21,r30,r24
    1858:	1a a0 00 00 	l.movhi r21,0x0
    185c:	e2 31 a8 00 	l.add r17,r17,r21
    1860:	e3 91 88 04 	l.or r28,r17,r17
    1864:	00 00 00 3d 	l.j 1958 <_vsnprintf+0x8c8>
    1868:	84 41 00 1c 	l.lwz r2,28(r1)
    186c:	03 ff fe 1e 	l.j 10e4 <_vsnprintf+0x54>
    1870:	e2 43 18 04 	l.or r18,r3,r3
    1874:	03 ff fe b4 	l.j 1344 <_vsnprintf+0x2b4>
    1878:	aa e0 00 02 	l.ori r23,r0,0x2
    187c:	13 ff fe fa 	l.bf 1464 <_vsnprintf+0x3d4>
    1880:	e4 03 d8 00 	l.sfeq r3,r27
    1884:	aa 60 00 69 	l.ori r19,r0,0x69
    1888:	ae e0 ff ef 	l.xori r23,r0,-17
    188c:	e4 23 98 00 	l.sfne r3,r19
    1890:	e2 31 b8 03 	l.and r17,r17,r23
    1894:	13 ff fe f9 	l.bf 1478 <_vsnprintf+0x3e8>
    1898:	aa e0 00 0a 	l.ori r23,r0,0xa
    189c:	a7 31 04 00 	l.andi r25,r17,0x400
    18a0:	1a 60 00 00 	l.movhi r19,0x0
    18a4:	e4 19 98 00 	l.sfeq r25,r19
    18a8:	10 00 00 04 	l.bf 18b8 <_vsnprintf+0x828>
    18ac:	aa 60 00 69 	l.ori r19,r0,0x69
    18b0:	af 20 ff fe 	l.xori r25,r0,-2
    18b4:	e2 31 c8 03 	l.and r17,r17,r25
    18b8:	e4 03 98 00 	l.sfeq r3,r19
    18bc:	10 00 00 06 	l.bf 18d4 <_vsnprintf+0x844>
    18c0:	a7 31 02 00 	l.andi r25,r17,0x200
    18c4:	aa 60 00 64 	l.ori r19,r0,0x64
    18c8:	e4 23 98 00 	l.sfne r3,r19
    18cc:	13 ff ff 16 	l.bf 1524 <_vsnprintf+0x494>
    18d0:	1a 60 00 00 	l.movhi r19,0x0
    18d4:	1a 60 00 00 	l.movhi r19,0x0
    18d8:	e4 19 98 00 	l.sfeq r25,r19
    18dc:	13 ff fe ed 	l.bf 1490 <_vsnprintf+0x400>
    18e0:	a7 31 01 00 	l.andi r25,r17,0x100
    18e4:	87 22 00 00 	l.lwz r25,0(r2)
    18e8:	e5 79 98 00 	l.sfges r25,r19
    18ec:	9f 42 00 08 	l.addi r26,r2,8
    18f0:	e0 f9 c8 04 	l.or r7,r25,r25
    18f4:	10 00 00 0a 	l.bf 191c <_vsnprintf+0x88c>
    18f8:	85 02 00 04 	l.lwz r8,4(r2)
    18fc:	e4 28 98 00 	l.sfne r8,r19
    1900:	e3 60 40 02 	l.sub r27,r0,r8
    1904:	10 00 00 03 	l.bf 1910 <_vsnprintf+0x880>
    1908:	ab a0 00 01 	l.ori r29,r0,0x1
    190c:	1b a0 00 00 	l.movhi r29,0x0
    1910:	e0 e0 c8 02 	l.sub r7,r0,r25
    1914:	e0 e7 e8 02 	l.sub r7,r7,r29
    1918:	e1 1b d8 04 	l.or r8,r27,r27
    191c:	d4 01 88 14 	l.sw 20(r1),r17
    1920:	aa 20 00 1f 	l.ori r17,r0,0x1f
    1924:	e3 39 88 48 	l.srl r25,r25,r17
    1928:	d4 01 f0 10 	l.sw 16(r1),r30
    192c:	d4 01 70 0c 	l.sw 12(r1),r14
    1930:	d4 01 b8 08 	l.sw 8(r1),r23
    1934:	d4 01 00 04 	l.sw 4(r1),r0
    1938:	d8 01 c8 03 	l.sb 3(r1),r25
    193c:	e0 d4 a0 04 	l.or r6,r20,r20
    1940:	e0 bc e0 04 	l.or r5,r28,r28
    1944:	e0 96 b0 04 	l.or r4,r22,r22
    1948:	07 ff fd 4b 	l.jal e74 <_ntoa_long_long>
    194c:	e0 72 90 04 	l.or r3,r18,r18
    1950:	e3 8b 58 04 	l.or r28,r11,r11
    1954:	e0 5a d0 04 	l.or r2,r26,r26
    1958:	90 70 00 00 	l.lbs r3,0(r16)
    195c:	1a 20 00 00 	l.movhi r17,0x0
    1960:	e4 23 88 00 	l.sfne r3,r17
    1964:	13 ff fd e5 	l.bf 10f8 <_vsnprintf+0x68>
    1968:	aa 20 00 25 	l.ori r17,r0,0x25
    196c:	e4 9c a0 00 	l.sfltu r28,r20
    1970:	10 00 00 03 	l.bf 197c <_vsnprintf+0x8ec>
    1974:	e0 bc e0 04 	l.or r5,r28,r28
    1978:	9c b4 ff ff 	l.addi r5,r20,-1
    197c:	e0 d4 a0 04 	l.or r6,r20,r20
    1980:	e0 96 b0 04 	l.or r4,r22,r22
    1984:	48 00 90 00 	l.jalr r18
    1988:	18 60 00 00 	l.movhi r3,0x0
    198c:	e1 7c e0 04 	l.or r11,r28,r28
    1990:	85 c1 00 30 	l.lwz r14,48(r1)
    1994:	86 01 00 34 	l.lwz r16,52(r1)
    1998:	86 41 00 38 	l.lwz r18,56(r1)
    199c:	86 81 00 3c 	l.lwz r20,60(r1)
    19a0:	86 c1 00 40 	l.lwz r22,64(r1)
    19a4:	87 01 00 44 	l.lwz r24,68(r1)
    19a8:	87 41 00 48 	l.lwz r26,72(r1)
    19ac:	87 81 00 4c 	l.lwz r28,76(r1)
    19b0:	87 c1 00 50 	l.lwz r30,80(r1)
    19b4:	84 41 00 54 	l.lwz r2,84(r1)
    19b8:	85 21 00 58 	l.lwz r9,88(r1)
    19bc:	44 00 48 00 	l.jr r9
    19c0:	9c 21 00 5c 	l.addi r1,r1,92

000019c4 <printf_>:
    19c4:	9c 21 ff f8 	l.addi r1,r1,-8
    19c8:	e0 c3 18 04 	l.or r6,r3,r3
    19cc:	18 60 00 00 	l.movhi r3,0x0
    19d0:	9c e1 00 08 	l.addi r7,r1,8
    19d4:	9c 81 00 03 	l.addi r4,r1,3
    19d8:	ac a0 ff ff 	l.xori r5,r0,-1
    19dc:	d4 01 48 04 	l.sw 4(r1),r9
    19e0:	07 ff fd ac 	l.jal 1090 <_vsnprintf>
    19e4:	9c 63 10 34 	l.addi r3,r3,4148
    19e8:	85 21 00 04 	l.lwz r9,4(r1)
    19ec:	44 00 48 00 	l.jr r9
    19f0:	9c 21 00 08 	l.addi r1,r1,8

000019f4 <sprintf_>:
    19f4:	9c 21 ff fc 	l.addi r1,r1,-4
    19f8:	e0 c4 20 04 	l.or r6,r4,r4
    19fc:	e0 83 18 04 	l.or r4,r3,r3
    1a00:	18 60 00 00 	l.movhi r3,0x0
    1a04:	9c e1 00 04 	l.addi r7,r1,4
    1a08:	ac a0 ff ff 	l.xori r5,r0,-1
    1a0c:	d4 01 48 00 	l.sw 0(r1),r9
    1a10:	07 ff fd a0 	l.jal 1090 <_vsnprintf>
    1a14:	9c 63 09 54 	l.addi r3,r3,2388
    1a18:	85 21 00 00 	l.lwz r9,0(r1)
    1a1c:	44 00 48 00 	l.jr r9
    1a20:	9c 21 00 04 	l.addi r1,r1,4

00001a24 <snprintf_>:
    1a24:	9c 21 ff fc 	l.addi r1,r1,-4
    1a28:	e0 c5 28 04 	l.or r6,r5,r5
    1a2c:	e0 a4 20 04 	l.or r5,r4,r4
    1a30:	e0 83 18 04 	l.or r4,r3,r3
    1a34:	18 60 00 00 	l.movhi r3,0x0
    1a38:	9c e1 00 04 	l.addi r7,r1,4
    1a3c:	d4 01 48 00 	l.sw 0(r1),r9
    1a40:	07 ff fd 94 	l.jal 1090 <_vsnprintf>
    1a44:	9c 63 09 54 	l.addi r3,r3,2388
    1a48:	85 21 00 00 	l.lwz r9,0(r1)
    1a4c:	44 00 48 00 	l.jr r9
    1a50:	9c 21 00 04 	l.addi r1,r1,4

00001a54 <vprintf_>:
    1a54:	9c 21 ff f8 	l.addi r1,r1,-8
    1a58:	e0 c3 18 04 	l.or r6,r3,r3
    1a5c:	18 60 00 00 	l.movhi r3,0x0
    1a60:	e0 e4 20 04 	l.or r7,r4,r4
    1a64:	ac a0 ff ff 	l.xori r5,r0,-1
    1a68:	9c 81 00 03 	l.addi r4,r1,3
    1a6c:	d4 01 48 04 	l.sw 4(r1),r9
    1a70:	07 ff fd 88 	l.jal 1090 <_vsnprintf>
    1a74:	9c 63 10 34 	l.addi r3,r3,4148
    1a78:	85 21 00 04 	l.lwz r9,4(r1)
    1a7c:	44 00 48 00 	l.jr r9
    1a80:	9c 21 00 08 	l.addi r1,r1,8

00001a84 <vsnprintf_>:
    1a84:	e0 e6 30 04 	l.or r7,r6,r6
    1a88:	e0 c5 28 04 	l.or r6,r5,r5
    1a8c:	e0 a4 20 04 	l.or r5,r4,r4
    1a90:	e0 83 18 04 	l.or r4,r3,r3
    1a94:	18 60 00 00 	l.movhi r3,0x0
    1a98:	03 ff fd 7e 	l.j 1090 <_vsnprintf>
    1a9c:	9c 63 09 54 	l.addi r3,r3,2388

00001aa0 <fctprintf>:
    1aa0:	9c 21 ff f4 	l.addi r1,r1,-12
    1aa4:	d4 01 18 00 	l.sw 0(r1),r3
    1aa8:	18 60 00 00 	l.movhi r3,0x0
    1aac:	d4 01 20 04 	l.sw 4(r1),r4
    1ab0:	e0 c5 28 04 	l.or r6,r5,r5
    1ab4:	9c e1 00 0c 	l.addi r7,r1,12
    1ab8:	e0 81 08 04 	l.or r4,r1,r1
    1abc:	ac a0 ff ff 	l.xori r5,r0,-1
    1ac0:	d4 01 48 08 	l.sw 8(r1),r9
    1ac4:	07 ff fd 73 	l.jal 1090 <_vsnprintf>
    1ac8:	9c 63 10 60 	l.addi r3,r3,4192
    1acc:	85 21 00 08 	l.lwz r9,8(r1)
    1ad0:	44 00 48 00 	l.jr r9
    1ad4:	9c 21 00 0c 	l.addi r1,r1,12

00001ad8 <readRtcRegister>:
    1ad8:	aa 20 00 08 	l.ori r17,r0,0x8
    1adc:	e0 63 88 08 	l.sll r3,r3,r17
    1ae0:	9c 21 ff f4 	l.addi r1,r1,-12
    1ae4:	a4 63 ff ff 	l.andi r3,r3,0xffff
    1ae8:	1a 20 d1 00 	l.movhi r17,0xd100
    1aec:	d4 01 00 08 	l.sw 8(r1),r0
    1af0:	e0 63 88 04 	l.or r3,r3,r17
    1af4:	d4 01 18 00 	l.sw 0(r1),r3
    1af8:	aa 60 00 03 	l.ori r19,r0,0x3
    1afc:	86 21 00 00 	l.lwz r17,0(r1)
    1b00:	72 31 02 05 	l.nios_rrc r17,r17,r0,0x5
    1b04:	d4 01 88 04 	l.sw 4(r1),r17
    1b08:	86 21 00 08 	l.lwz r17,8(r1)
    1b0c:	9e 31 00 01 	l.addi r17,r17,1
    1b10:	d4 01 88 08 	l.sw 8(r1),r17
    1b14:	86 21 00 08 	l.lwz r17,8(r1)
    1b18:	e5 51 98 00 	l.sfgts r17,r19
    1b1c:	10 00 00 06 	l.bf 1b34 <readRtcRegister+0x5c>
    1b20:	1a a0 00 00 	l.movhi r21,0x0
    1b24:	86 21 00 04 	l.lwz r17,4(r1)
    1b28:	e5 91 a8 00 	l.sflts r17,r21
    1b2c:	13 ff ff f4 	l.bf 1afc <readRtcRegister+0x24>
    1b30:	15 00 00 00 	l.nop 0x0
    1b34:	85 61 00 04 	l.lwz r11,4(r1)
    1b38:	44 00 48 00 	l.jr r9
    1b3c:	9c 21 00 0c 	l.addi r1,r1,12

00001b40 <writeRtcRegister>:
    1b40:	aa 20 00 08 	l.ori r17,r0,0x8
    1b44:	e0 63 88 08 	l.sll r3,r3,r17
    1b48:	a4 84 00 ff 	l.andi r4,r4,0xff
    1b4c:	a4 63 ff ff 	l.andi r3,r3,0xffff
    1b50:	e0 63 20 04 	l.or r3,r3,r4
    1b54:	1a 20 d0 00 	l.movhi r17,0xd000
    1b58:	e0 63 88 04 	l.or r3,r3,r17
    1b5c:	70 03 02 05 	l.nios_rrc r0,r3,r0,0x5
    1b60:	44 00 48 00 	l.jr r9
    1b64:	15 00 00 00 	l.nop 0x0

00001b68 <printTimeComplete>:
    1b68:	9c 21 ff bc 	l.addi r1,r1,-68
    1b6c:	18 60 00 00 	l.movhi r3,0x0
    1b70:	d4 01 90 20 	l.sw 32(r1),r18
    1b74:	d4 01 a0 24 	l.sw 36(r1),r20
    1b78:	d4 01 b0 28 	l.sw 40(r1),r22
    1b7c:	d4 01 c0 2c 	l.sw 44(r1),r24
    1b80:	d4 01 d0 30 	l.sw 48(r1),r26
    1b84:	d4 01 e0 34 	l.sw 52(r1),r28
    1b88:	d4 01 70 18 	l.sw 24(r1),r14
    1b8c:	d4 01 80 1c 	l.sw 28(r1),r16
    1b90:	d4 01 f0 38 	l.sw 56(r1),r30
    1b94:	d4 01 10 3c 	l.sw 60(r1),r2
    1b98:	d4 01 48 40 	l.sw 64(r1),r9
    1b9c:	07 ff ff cf 	l.jal 1ad8 <readRtcRegister>
    1ba0:	1a 80 00 00 	l.movhi r20,0x0
    1ba4:	e2 4b 58 04 	l.or r18,r11,r11
    1ba8:	ab 80 00 04 	l.ori r28,r0,0x4
    1bac:	ab 40 00 05 	l.ori r26,r0,0x5
    1bb0:	ab 00 00 06 	l.ori r24,r0,0x6
    1bb4:	aa c0 00 02 	l.ori r22,r0,0x2
    1bb8:	9e 94 2c b9 	l.addi r20,r20,11449
    1bbc:	07 ff ff c7 	l.jal 1ad8 <readRtcRegister>
    1bc0:	18 60 00 00 	l.movhi r3,0x0
    1bc4:	e4 12 58 00 	l.sfeq r18,r11
    1bc8:	13 ff ff fd 	l.bf 1bbc <printTimeComplete+0x54>
    1bcc:	e2 0b 58 04 	l.or r16,r11,r11
    1bd0:	07 ff ff c2 	l.jal 1ad8 <readRtcRegister>
    1bd4:	e0 7c e0 04 	l.or r3,r28,r28
    1bd8:	e0 7a d0 04 	l.or r3,r26,r26
    1bdc:	07 ff ff bf 	l.jal 1ad8 <readRtcRegister>
    1be0:	e2 4b 58 04 	l.or r18,r11,r11
    1be4:	e0 78 c0 04 	l.or r3,r24,r24
    1be8:	07 ff ff bc 	l.jal 1ad8 <readRtcRegister>
    1bec:	e3 cb 58 04 	l.or r30,r11,r11
    1bf0:	e0 76 b0 04 	l.or r3,r22,r22
    1bf4:	07 ff ff b9 	l.jal 1ad8 <readRtcRegister>
    1bf8:	e1 cb 58 04 	l.or r14,r11,r11
    1bfc:	a8 60 00 01 	l.ori r3,r0,0x1
    1c00:	07 ff ff b6 	l.jal 1ad8 <readRtcRegister>
    1c04:	e0 4b 58 04 	l.or r2,r11,r11
    1c08:	d4 01 58 10 	l.sw 16(r1),r11
    1c0c:	d4 01 90 00 	l.sw 0(r1),r18
    1c10:	d4 01 80 14 	l.sw 20(r1),r16
    1c14:	d4 01 10 0c 	l.sw 12(r1),r2
    1c18:	d4 01 70 08 	l.sw 8(r1),r14
    1c1c:	d4 01 f0 04 	l.sw 4(r1),r30
    1c20:	07 ff ff 69 	l.jal 19c4 <printf_>
    1c24:	e0 74 a0 04 	l.or r3,r20,r20
    1c28:	03 ff ff e5 	l.j 1bbc <printTimeComplete+0x54>
    1c2c:	e2 50 80 04 	l.or r18,r16,r16

00001c30 <memcpy>:
    1c30:	1a 60 00 00 	l.movhi r19,0x0
    1c34:	e4 05 98 00 	l.sfeq r5,r19
    1c38:	10 00 00 3e 	l.bf 1d30 <memcpy+0x100>
    1c3c:	e1 63 18 04 	l.or r11,r3,r3
    1c40:	e4 03 20 00 	l.sfeq r3,r4
    1c44:	10 00 00 3b 	l.bf 1d30 <memcpy+0x100>
    1c48:	e4 63 20 00 	l.sfgeu r3,r4
    1c4c:	10 00 00 3f 	l.bf 1d48 <memcpy+0x118>
    1c50:	e2 23 28 00 	l.add r17,r3,r5
    1c54:	e2 23 20 04 	l.or r17,r3,r4
    1c58:	a6 31 00 03 	l.andi r17,r17,0x3
    1c5c:	e4 11 98 00 	l.sfeq r17,r19
    1c60:	10 00 00 38 	l.bf 1d40 <memcpy+0x110>
    1c64:	e2 23 20 05 	l.xor r17,r3,r4
    1c68:	a6 31 00 03 	l.andi r17,r17,0x3
    1c6c:	e4 31 98 00 	l.sfne r17,r19
    1c70:	10 00 00 08 	l.bf 1c90 <memcpy+0x60>
    1c74:	e2 25 28 04 	l.or r17,r5,r5
    1c78:	aa 20 00 03 	l.ori r17,r0,0x3
    1c7c:	e4 a5 88 00 	l.sfleu r5,r17
    1c80:	10 00 00 2e 	l.bf 1d38 <memcpy+0x108>
    1c84:	e2 64 88 03 	l.and r19,r4,r17
    1c88:	aa 20 00 04 	l.ori r17,r0,0x4
    1c8c:	e2 31 98 02 	l.sub r17,r17,r19
    1c90:	e0 a5 88 02 	l.sub r5,r5,r17
    1c94:	1a 60 00 00 	l.movhi r19,0x0
    1c98:	e2 e4 98 00 	l.add r23,r4,r19
    1c9c:	e2 ab 98 00 	l.add r21,r11,r19
    1ca0:	92 f7 00 00 	l.lbs r23,0(r23)
    1ca4:	9e 73 00 01 	l.addi r19,r19,1
    1ca8:	d8 15 b8 00 	l.sb 0(r21),r23
    1cac:	e4 31 98 00 	l.sfne r17,r19
    1cb0:	13 ff ff fb 	l.bf 1c9c <memcpy+0x6c>
    1cb4:	e2 e4 98 00 	l.add r23,r4,r19
    1cb8:	e2 6b 88 00 	l.add r19,r11,r17
    1cbc:	e0 84 88 00 	l.add r4,r4,r17
    1cc0:	aa 20 00 03 	l.ori r17,r0,0x3
    1cc4:	e4 a5 88 00 	l.sfleu r5,r17
    1cc8:	10 00 00 0e 	l.bf 1d00 <memcpy+0xd0>
    1ccc:	aa 20 00 02 	l.ori r17,r0,0x2
    1cd0:	e2 a5 88 48 	l.srl r21,r5,r17
    1cd4:	e2 b5 88 08 	l.sll r21,r21,r17
    1cd8:	1a 20 00 00 	l.movhi r17,0x0
    1cdc:	e2 e4 88 00 	l.add r23,r4,r17
    1ce0:	87 37 00 00 	l.lwz r25,0(r23)
    1ce4:	e2 f3 88 00 	l.add r23,r19,r17
    1ce8:	9e 31 00 04 	l.addi r17,r17,4
    1cec:	e4 31 a8 00 	l.sfne r17,r21
    1cf0:	13 ff ff fb 	l.bf 1cdc <memcpy+0xac>
    1cf4:	d4 17 c8 00 	l.sw 0(r23),r25
    1cf8:	e2 73 88 00 	l.add r19,r19,r17
    1cfc:	e0 84 88 00 	l.add r4,r4,r17
    1d00:	a4 a5 00 03 	l.andi r5,r5,0x3
    1d04:	1a 20 00 00 	l.movhi r17,0x0
    1d08:	e4 05 88 00 	l.sfeq r5,r17
    1d0c:	10 00 00 09 	l.bf 1d30 <memcpy+0x100>
    1d10:	e2 e4 88 00 	l.add r23,r4,r17
    1d14:	e2 b3 88 00 	l.add r21,r19,r17
    1d18:	92 f7 00 00 	l.lbs r23,0(r23)
    1d1c:	9e 31 00 01 	l.addi r17,r17,1
    1d20:	d8 15 b8 00 	l.sb 0(r21),r23
    1d24:	e4 25 88 00 	l.sfne r5,r17
    1d28:	13 ff ff fb 	l.bf 1d14 <memcpy+0xe4>
    1d2c:	e2 e4 88 00 	l.add r23,r4,r17
    1d30:	44 00 48 00 	l.jr r9
    1d34:	15 00 00 00 	l.nop 0x0
    1d38:	03 ff ff d6 	l.j 1c90 <memcpy+0x60>
    1d3c:	e2 25 28 04 	l.or r17,r5,r5
    1d40:	03 ff ff e0 	l.j 1cc0 <memcpy+0x90>
    1d44:	e2 63 18 04 	l.or r19,r3,r3
    1d48:	e0 84 28 00 	l.add r4,r4,r5
    1d4c:	e2 64 88 04 	l.or r19,r4,r17
    1d50:	a6 73 00 03 	l.andi r19,r19,0x3
    1d54:	1a a0 00 00 	l.movhi r21,0x0
    1d58:	e4 13 a8 00 	l.sfeq r19,r21
    1d5c:	10 00 00 1a 	l.bf 1dc4 <memcpy+0x194>
    1d60:	aa 60 00 03 	l.ori r19,r0,0x3
    1d64:	e2 64 88 05 	l.xor r19,r4,r17
    1d68:	a6 73 00 03 	l.andi r19,r19,0x3
    1d6c:	e4 33 a8 00 	l.sfne r19,r21
    1d70:	10 00 00 07 	l.bf 1d8c <memcpy+0x15c>
    1d74:	e2 65 28 04 	l.or r19,r5,r5
    1d78:	aa 60 00 04 	l.ori r19,r0,0x4
    1d7c:	e4 a5 98 00 	l.sfleu r5,r19
    1d80:	10 00 00 03 	l.bf 1d8c <memcpy+0x15c>
    1d84:	e2 65 28 04 	l.or r19,r5,r5
    1d88:	a6 64 00 03 	l.andi r19,r4,0x3
    1d8c:	e0 a5 98 02 	l.sub r5,r5,r19
    1d90:	ae f3 ff ff 	l.xori r23,r19,-1
    1d94:	ae a0 ff ff 	l.xori r21,r0,-1
    1d98:	e3 64 a8 00 	l.add r27,r4,r21
    1d9c:	e3 31 a8 00 	l.add r25,r17,r21
    1da0:	93 7b 00 00 	l.lbs r27,0(r27)
    1da4:	9e b5 ff ff 	l.addi r21,r21,-1
    1da8:	d8 19 d8 00 	l.sb 0(r25),r27
    1dac:	e4 35 b8 00 	l.sfne r21,r23
    1db0:	13 ff ff fb 	l.bf 1d9c <memcpy+0x16c>
    1db4:	e3 64 a8 00 	l.add r27,r4,r21
    1db8:	e2 31 98 02 	l.sub r17,r17,r19
    1dbc:	e0 84 98 02 	l.sub r4,r4,r19
    1dc0:	aa 60 00 03 	l.ori r19,r0,0x3
    1dc4:	e4 a5 98 00 	l.sfleu r5,r19
    1dc8:	10 00 00 13 	l.bf 1e14 <memcpy+0x1e4>
    1dcc:	aa 60 00 02 	l.ori r19,r0,0x2
    1dd0:	e2 65 98 48 	l.srl r19,r5,r19
    1dd4:	e2 f3 98 04 	l.or r23,r19,r19
    1dd8:	ae a0 ff fc 	l.xori r21,r0,-4
    1ddc:	e3 24 a8 00 	l.add r25,r4,r21
    1de0:	87 79 00 00 	l.lwz r27,0(r25)
    1de4:	e3 31 a8 00 	l.add r25,r17,r21
    1de8:	d4 19 d8 00 	l.sw 0(r25),r27
    1dec:	9e f7 ff ff 	l.addi r23,r23,-1
    1df0:	1b 20 00 00 	l.movhi r25,0x0
    1df4:	e4 37 c8 00 	l.sfne r23,r25
    1df8:	13 ff ff f9 	l.bf 1ddc <memcpy+0x1ac>
    1dfc:	9e b5 ff fc 	l.addi r21,r21,-4
    1e00:	e2 60 98 02 	l.sub r19,r0,r19
    1e04:	aa a0 00 02 	l.ori r21,r0,0x2
    1e08:	e2 73 a8 08 	l.sll r19,r19,r21
    1e0c:	e2 31 98 00 	l.add r17,r17,r19
    1e10:	e0 84 98 00 	l.add r4,r4,r19
    1e14:	a4 a5 00 03 	l.andi r5,r5,0x3
    1e18:	1a 60 00 00 	l.movhi r19,0x0
    1e1c:	e4 05 98 00 	l.sfeq r5,r19
    1e20:	13 ff ff c4 	l.bf 1d30 <memcpy+0x100>
    1e24:	15 00 00 00 	l.nop 0x0
    1e28:	ac a5 ff ff 	l.xori r5,r5,-1
    1e2c:	ae 60 ff ff 	l.xori r19,r0,-1
    1e30:	e2 e4 98 00 	l.add r23,r4,r19
    1e34:	e2 b1 98 00 	l.add r21,r17,r19
    1e38:	92 f7 00 00 	l.lbs r23,0(r23)
    1e3c:	9e 73 ff ff 	l.addi r19,r19,-1
    1e40:	d8 15 b8 00 	l.sb 0(r21),r23
    1e44:	e4 33 28 00 	l.sfne r19,r5
    1e48:	13 ff ff fb 	l.bf 1e34 <memcpy+0x204>
    1e4c:	e2 e4 98 00 	l.add r23,r4,r19
    1e50:	03 ff ff b8 	l.j 1d30 <memcpy+0x100>
    1e54:	15 00 00 00 	l.nop 0x0

00001e58 <memmove>:
    1e58:	03 ff ff 76 	l.j 1c30 <memcpy>
    1e5c:	15 00 00 00 	l.nop 0x0

00001e60 <bcopy>:
    1e60:	e2 24 20 04 	l.or r17,r4,r4
    1e64:	e0 83 18 04 	l.or r4,r3,r3
    1e68:	03 ff ff 72 	l.j 1c30 <memcpy>
    1e6c:	e0 71 88 04 	l.or r3,r17,r17

00001e70 <memset>:
    1e70:	e1 63 18 04 	l.or r11,r3,r3
    1e74:	e0 a3 28 00 	l.add r5,r3,r5
    1e78:	e2 23 18 04 	l.or r17,r3,r3
    1e7c:	a4 84 00 ff 	l.andi r4,r4,0xff
    1e80:	e4 31 28 00 	l.sfne r17,r5
    1e84:	10 00 00 04 	l.bf 1e94 <memset+0x24>
    1e88:	15 00 00 00 	l.nop 0x0
    1e8c:	44 00 48 00 	l.jr r9
    1e90:	15 00 00 00 	l.nop 0x0
    1e94:	d8 11 20 00 	l.sb 0(r17),r4
    1e98:	03 ff ff fa 	l.j 1e80 <memset+0x10>
    1e9c:	9e 31 00 01 	l.addi r17,r17,1

00001ea0 <uart_init>:
    1ea0:	ae 20 ff 83 	l.xori r17,r0,-125
    1ea4:	d8 03 88 05 	l.sb 5(r3),r17
    1ea8:	aa 20 00 17 	l.ori r17,r0,0x17
    1eac:	d8 03 88 00 	l.sb 0(r3),r17
    1eb0:	d8 03 00 01 	l.sb 1(r3),r0
    1eb4:	aa 20 00 03 	l.ori r17,r0,0x3
    1eb8:	d8 03 88 03 	l.sb 3(r3),r17
    1ebc:	44 00 48 00 	l.jr r9
    1ec0:	15 00 00 00 	l.nop 0x0

00001ec4 <uart_wait_rx>:
    1ec4:	8e 23 00 05 	l.lbz r17,5(r3)
    1ec8:	a6 31 00 01 	l.andi r17,r17,0x1
    1ecc:	1a 60 00 00 	l.movhi r19,0x0
    1ed0:	e4 11 98 00 	l.sfeq r17,r19
    1ed4:	10 00 00 04 	l.bf 1ee4 <uart_wait_rx+0x20>
    1ed8:	15 00 00 00 	l.nop 0x0
    1edc:	44 00 48 00 	l.jr r9
    1ee0:	15 00 00 00 	l.nop 0x0
    1ee4:	15 00 00 00 	l.nop 0x0
    1ee8:	03 ff ff f7 	l.j 1ec4 <uart_wait_rx>
    1eec:	15 00 00 00 	l.nop 0x0

00001ef0 <uart_wait_tx>:
    1ef0:	8e 23 00 05 	l.lbz r17,5(r3)
    1ef4:	a6 31 00 40 	l.andi r17,r17,0x40
    1ef8:	1a 60 00 00 	l.movhi r19,0x0
    1efc:	e4 11 98 00 	l.sfeq r17,r19
    1f00:	10 00 00 04 	l.bf 1f10 <uart_wait_tx+0x20>
    1f04:	15 00 00 00 	l.nop 0x0
    1f08:	44 00 48 00 	l.jr r9
    1f0c:	15 00 00 00 	l.nop 0x0
    1f10:	15 00 00 00 	l.nop 0x0
    1f14:	03 ff ff f7 	l.j 1ef0 <uart_wait_tx>
    1f18:	15 00 00 00 	l.nop 0x0

00001f1c <uart_putc>:
    1f1c:	9c 21 ff f4 	l.addi r1,r1,-12
    1f20:	d4 01 80 00 	l.sw 0(r1),r16
    1f24:	d4 01 90 04 	l.sw 4(r1),r18
    1f28:	d4 01 48 08 	l.sw 8(r1),r9
    1f2c:	e2 43 18 04 	l.or r18,r3,r3
    1f30:	07 ff ff f0 	l.jal 1ef0 <uart_wait_tx>
    1f34:	e2 04 20 04 	l.or r16,r4,r4
    1f38:	aa 20 00 18 	l.ori r17,r0,0x18
    1f3c:	e0 90 88 08 	l.sll r4,r16,r17
    1f40:	e0 84 88 88 	l.sra r4,r4,r17
    1f44:	d8 12 20 00 	l.sb 0(r18),r4
    1f48:	86 01 00 00 	l.lwz r16,0(r1)
    1f4c:	86 41 00 04 	l.lwz r18,4(r1)
    1f50:	85 21 00 08 	l.lwz r9,8(r1)
    1f54:	44 00 48 00 	l.jr r9
    1f58:	9c 21 00 0c 	l.addi r1,r1,12

00001f5c <uart_puts>:
    1f5c:	9c 21 ff f0 	l.addi r1,r1,-16
    1f60:	d4 01 80 00 	l.sw 0(r1),r16
    1f64:	d4 01 90 04 	l.sw 4(r1),r18
    1f68:	d4 01 a0 08 	l.sw 8(r1),r20
    1f6c:	d4 01 48 0c 	l.sw 12(r1),r9
    1f70:	e2 43 18 04 	l.or r18,r3,r3
    1f74:	e2 04 20 04 	l.or r16,r4,r4
    1f78:	92 90 00 00 	l.lbs r20,0(r16)
    1f7c:	1a 20 00 00 	l.movhi r17,0x0
    1f80:	e4 34 88 00 	l.sfne r20,r17
    1f84:	10 00 00 07 	l.bf 1fa0 <uart_puts+0x44>
    1f88:	85 21 00 0c 	l.lwz r9,12(r1)
    1f8c:	86 01 00 00 	l.lwz r16,0(r1)
    1f90:	86 41 00 04 	l.lwz r18,4(r1)
    1f94:	86 81 00 08 	l.lwz r20,8(r1)
    1f98:	44 00 48 00 	l.jr r9
    1f9c:	9c 21 00 10 	l.addi r1,r1,16
    1fa0:	07 ff ff d4 	l.jal 1ef0 <uart_wait_tx>
    1fa4:	e0 72 90 04 	l.or r3,r18,r18
    1fa8:	9e 10 00 01 	l.addi r16,r16,1
    1fac:	d8 12 a0 00 	l.sb 0(r18),r20
    1fb0:	03 ff ff f3 	l.j 1f7c <uart_puts+0x20>
    1fb4:	92 90 00 00 	l.lbs r20,0(r16)

00001fb8 <uart_getc>:
    1fb8:	9c 21 ff f8 	l.addi r1,r1,-8
    1fbc:	d4 01 80 00 	l.sw 0(r1),r16
    1fc0:	d4 01 48 04 	l.sw 4(r1),r9
    1fc4:	07 ff ff c0 	l.jal 1ec4 <uart_wait_rx>
    1fc8:	e2 03 18 04 	l.or r16,r3,r3
    1fcc:	8d 70 00 00 	l.lbz r11,0(r16)
    1fd0:	aa 20 00 18 	l.ori r17,r0,0x18
    1fd4:	e1 6b 88 08 	l.sll r11,r11,r17
    1fd8:	e1 6b 88 88 	l.sra r11,r11,r17
    1fdc:	86 01 00 00 	l.lwz r16,0(r1)
    1fe0:	85 21 00 04 	l.lwz r9,4(r1)
    1fe4:	44 00 48 00 	l.jr r9
    1fe8:	9c 21 00 08 	l.addi r1,r1,8

00001fec <vga_clear>:
    1fec:	aa 20 00 03 	l.ori r17,r0,0x3
    1ff0:	70 11 01 00 	l.nios_crr r0,r17,r0,0x0
    1ff4:	44 00 48 00 	l.jr r9
    1ff8:	15 00 00 00 	l.nop 0x0

00001ffc <vga_textcorr>:
    1ffc:	aa 20 00 06 	l.ori r17,r0,0x6
    2000:	70 11 19 00 	l.nios_crr r0,r17,r3,0x0
    2004:	44 00 48 00 	l.jr r9
    2008:	15 00 00 00 	l.nop 0x0

0000200c <vga_putc>:
    200c:	aa 20 00 02 	l.ori r17,r0,0x2
    2010:	70 11 19 00 	l.nios_crr r0,r17,r3,0x0
    2014:	44 00 48 00 	l.jr r9
    2018:	15 00 00 00 	l.nop 0x0

0000201c <vga_puts>:
    201c:	aa 60 00 02 	l.ori r19,r0,0x2
    2020:	92 23 00 00 	l.lbs r17,0(r3)
    2024:	1a a0 00 00 	l.movhi r21,0x0
    2028:	e4 31 a8 00 	l.sfne r17,r21
    202c:	10 00 00 04 	l.bf 203c <vga_puts+0x20>
    2030:	15 00 00 00 	l.nop 0x0
    2034:	44 00 48 00 	l.jr r9
    2038:	15 00 00 00 	l.nop 0x0
    203c:	9c 63 00 01 	l.addi r3,r3,1
    2040:	70 13 89 00 	l.nios_crr r0,r19,r17,0x0
    2044:	03 ff ff f8 	l.j 2024 <vga_puts+0x8>
    2048:	92 23 00 00 	l.lbs r17,0(r3)

0000204c <__udivmodsi3_internal>:
    204c:	e4 04 00 00 	l.sfeq r4,r0
    2050:	a9 60 00 00 	l.ori r11,r0,0x0
    2054:	10 00 00 15 	l.bf 20a8 <__udivmodsi3_internal+0x5c>
    2058:	a9 83 00 00 	l.ori r12,r3,0x0
    205c:	a8 c0 00 01 	l.ori r6,r0,0x1
    2060:	e5 84 00 00 	l.sflts r4,r0
    2064:	10 00 00 05 	l.bf 2078 <__udivmodsi3_internal+0x2c>
    2068:	e4 84 60 00 	l.sfltu r4,r12
    206c:	e0 84 20 00 	l.add r4,r4,r4
    2070:	13 ff ff fc 	l.bf 2060 <__udivmodsi3_internal+0x14>
    2074:	e0 c6 30 00 	l.add r6,r6,r6
    2078:	e0 eb 30 00 	l.add r7,r11,r6
    207c:	b8 c6 00 41 	l.srli r6,r6,0x1
    2080:	e1 0c 20 02 	l.sub r8,r12,r4
    2084:	e4 a4 60 00 	l.sfleu r4,r12
    2088:	b8 84 00 41 	l.srli r4,r4,0x1
    208c:	0c 00 00 04 	l.bnf 209c <__udivmodsi3_internal+0x50>
    2090:	15 00 00 00 	l.nop 0x0
    2094:	a9 67 00 00 	l.ori r11,r7,0x0
    2098:	a9 88 00 00 	l.ori r12,r8,0x0
    209c:	e4 26 00 00 	l.sfne r6,r0
    20a0:	13 ff ff f7 	l.bf 207c <__udivmodsi3_internal+0x30>
    20a4:	e0 eb 30 00 	l.add r7,r11,r6
    20a8:	44 00 48 00 	l.jr r9
    20ac:	15 00 00 00 	l.nop 0x0

000020b0 <__umodsi3>:
    20b0:	a9 a9 00 00 	l.ori r13,r9,0x0
    20b4:	07 ff ff e6 	l.jal 204c <__udivmodsi3_internal>
    20b8:	15 00 00 00 	l.nop 0x0
    20bc:	44 00 68 00 	l.jr r13
    20c0:	a9 6c 00 00 	l.ori r11,r12,0x0

000020c4 <__udivdi3>:
    20c4:	1a a0 00 00 	l.movhi r21,0x0
    20c8:	e4 25 a8 00 	l.sfne r5,r21
    20cc:	e2 64 20 04 	l.or r19,r4,r4
    20d0:	10 00 00 4c 	l.bf 2200 <__udivdi3+0x13c>
    20d4:	e2 23 18 04 	l.or r17,r3,r3
    20d8:	e4 a6 18 00 	l.sfleu r6,r3
    20dc:	10 00 00 6c 	l.bf 228c <__udivdi3+0x1c8>
    20e0:	aa a0 ff ff 	l.ori r21,r0,0xffff
    20e4:	e4 46 a8 00 	l.sfgtu r6,r21
    20e8:	0c 00 00 b1 	l.bnf 23ac <__udivdi3+0x2e8>
    20ec:	aa a0 00 ff 	l.ori r21,r0,0xff
    20f0:	1a a0 00 ff 	l.movhi r21,0xff
    20f4:	aa b5 ff ff 	l.ori r21,r21,0xffff
    20f8:	e4 46 a8 00 	l.sfgtu r6,r21
    20fc:	10 00 00 03 	l.bf 2108 <__udivdi3+0x44>
    2100:	aa e0 00 18 	l.ori r23,r0,0x18
    2104:	aa e0 00 10 	l.ori r23,r0,0x10
    2108:	1a a0 00 00 	l.movhi r21,0x0
    210c:	e3 26 b8 48 	l.srl r25,r6,r23
    2110:	9e b5 2e 68 	l.addi r21,r21,11880
    2114:	e2 b5 c8 00 	l.add r21,r21,r25
    2118:	8e b5 00 00 	l.lbz r21,0(r21)
    211c:	e2 b5 b8 00 	l.add r21,r21,r23
    2120:	aa e0 00 20 	l.ori r23,r0,0x20
    2124:	e4 17 a8 00 	l.sfeq r23,r21
    2128:	10 00 00 07 	l.bf 2144 <__udivdi3+0x80>
    212c:	e3 37 a8 02 	l.sub r25,r23,r21
    2130:	e0 63 c8 08 	l.sll r3,r3,r25
    2134:	e2 a4 a8 48 	l.srl r21,r4,r21
    2138:	e0 c6 c8 08 	l.sll r6,r6,r25
    213c:	e2 35 18 04 	l.or r17,r21,r3
    2140:	e2 64 c8 08 	l.sll r19,r4,r25
    2144:	ab 60 00 10 	l.ori r27,r0,0x10
    2148:	e2 e6 d8 48 	l.srl r23,r6,r27
    214c:	e1 91 bb 0a 	l.divu r12,r17,r23
    2150:	e2 ac bb 06 	l.mul r21,r12,r23
    2154:	e2 31 a8 02 	l.sub r17,r17,r21
    2158:	e2 bb d8 04 	l.or r21,r27,r27
    215c:	e2 31 d8 08 	l.sll r17,r17,r27
    2160:	a7 26 ff ff 	l.andi r25,r6,0xffff
    2164:	e2 b3 a8 48 	l.srl r21,r19,r21
    2168:	e3 79 63 06 	l.mul r27,r25,r12
    216c:	e2 31 a8 04 	l.or r17,r17,r21
    2170:	e4 bb 88 00 	l.sfleu r27,r17
    2174:	10 00 00 0a 	l.bf 219c <__udivdi3+0xd8>
    2178:	15 00 00 00 	l.nop 0x0
    217c:	e2 31 30 00 	l.add r17,r17,r6
    2180:	e4 46 88 00 	l.sfgtu r6,r17
    2184:	10 00 00 05 	l.bf 2198 <__udivdi3+0xd4>
    2188:	9e ac ff ff 	l.addi r21,r12,-1
    218c:	e4 bb 88 00 	l.sfleu r27,r17
    2190:	0c 00 01 3a 	l.bnf 2678 <__udivdi3+0x5b4>
    2194:	9d 8c ff fe 	l.addi r12,r12,-2
    2198:	e1 95 a8 04 	l.or r12,r21,r21
    219c:	e2 31 d8 02 	l.sub r17,r17,r27
    21a0:	e2 b1 bb 0a 	l.divu r21,r17,r23
    21a4:	e2 f5 bb 06 	l.mul r23,r21,r23
    21a8:	e2 31 b8 02 	l.sub r17,r17,r23
    21ac:	aa e0 00 10 	l.ori r23,r0,0x10
    21b0:	e2 31 b8 08 	l.sll r17,r17,r23
    21b4:	a6 73 ff ff 	l.andi r19,r19,0xffff
    21b8:	e3 39 ab 06 	l.mul r25,r25,r21
    21bc:	e2 31 98 04 	l.or r17,r17,r19
    21c0:	e4 b9 88 00 	l.sfleu r25,r17
    21c4:	10 00 00 09 	l.bf 21e8 <__udivdi3+0x124>
    21c8:	e2 26 88 00 	l.add r17,r6,r17
    21cc:	e4 46 88 00 	l.sfgtu r6,r17
    21d0:	10 00 00 05 	l.bf 21e4 <__udivdi3+0x120>
    21d4:	9e 75 ff ff 	l.addi r19,r21,-1
    21d8:	e4 b9 88 00 	l.sfleu r25,r17
    21dc:	0c 00 00 03 	l.bnf 21e8 <__udivdi3+0x124>
    21e0:	9e b5 ff fe 	l.addi r21,r21,-2
    21e4:	e2 b3 98 04 	l.or r21,r19,r19
    21e8:	aa 20 00 10 	l.ori r17,r0,0x10
    21ec:	e1 8c 88 08 	l.sll r12,r12,r17
    21f0:	e1 8c a8 04 	l.or r12,r12,r21
    21f4:	19 60 00 00 	l.movhi r11,0x0
    21f8:	44 00 48 00 	l.jr r9
    21fc:	15 00 00 00 	l.nop 0x0
    2200:	e4 45 18 00 	l.sfgtu r5,r3
    2204:	0c 00 00 06 	l.bnf 221c <__udivdi3+0x158>
    2208:	aa 20 ff ff 	l.ori r17,r0,0xffff
    220c:	19 80 00 00 	l.movhi r12,0x0
    2210:	19 60 00 00 	l.movhi r11,0x0
    2214:	44 00 48 00 	l.jr r9
    2218:	15 00 00 00 	l.nop 0x0
    221c:	e4 45 88 00 	l.sfgtu r5,r17
    2220:	0c 00 00 74 	l.bnf 23f0 <__udivdi3+0x32c>
    2224:	aa 20 00 ff 	l.ori r17,r0,0xff
    2228:	1a 20 00 ff 	l.movhi r17,0xff
    222c:	aa 31 ff ff 	l.ori r17,r17,0xffff
    2230:	e4 45 88 00 	l.sfgtu r5,r17
    2234:	10 00 00 03 	l.bf 2240 <__udivdi3+0x17c>
    2238:	aa a0 00 18 	l.ori r21,r0,0x18
    223c:	aa a0 00 10 	l.ori r21,r0,0x10
    2240:	1a 20 00 00 	l.movhi r17,0x0
    2244:	e2 65 a8 48 	l.srl r19,r5,r21
    2248:	9e 31 2e 68 	l.addi r17,r17,11880
    224c:	e2 31 98 00 	l.add r17,r17,r19
    2250:	8e 71 00 00 	l.lbz r19,0(r17)
    2254:	e2 73 a8 00 	l.add r19,r19,r21
    2258:	aa 20 00 20 	l.ori r17,r0,0x20
    225c:	e4 31 98 00 	l.sfne r17,r19
    2260:	10 00 00 6b 	l.bf 240c <__udivdi3+0x348>
    2264:	e2 f1 98 02 	l.sub r23,r17,r19
    2268:	e4 85 18 00 	l.sfltu r5,r3
    226c:	10 00 00 05 	l.bf 2280 <__udivdi3+0x1bc>
    2270:	a9 80 00 01 	l.ori r12,r0,0x1
    2274:	e4 a6 20 00 	l.sfleu r6,r4
    2278:	0c 00 00 fb 	l.bnf 2664 <__udivdi3+0x5a0>
    227c:	15 00 00 00 	l.nop 0x0
    2280:	19 60 00 00 	l.movhi r11,0x0
    2284:	44 00 48 00 	l.jr r9
    2288:	15 00 00 00 	l.nop 0x0
    228c:	1a 20 00 00 	l.movhi r17,0x0
    2290:	e4 26 88 00 	l.sfne r6,r17
    2294:	10 00 00 4d 	l.bf 23c8 <__udivdi3+0x304>
    2298:	aa 20 ff ff 	l.ori r17,r0,0xffff
    229c:	aa 20 00 01 	l.ori r17,r0,0x1
    22a0:	e0 d1 33 0a 	l.divu r6,r17,r6
    22a4:	aa 20 00 ff 	l.ori r17,r0,0xff
    22a8:	e4 46 88 00 	l.sfgtu r6,r17
    22ac:	10 00 00 03 	l.bf 22b8 <__udivdi3+0x1f4>
    22b0:	aa e0 00 01 	l.ori r23,r0,0x1
    22b4:	1a e0 00 00 	l.movhi r23,0x0
    22b8:	aa 20 00 03 	l.ori r17,r0,0x3
    22bc:	e2 f7 88 08 	l.sll r23,r23,r17
    22c0:	1a 20 00 00 	l.movhi r17,0x0
    22c4:	e2 a6 b8 48 	l.srl r21,r6,r23
    22c8:	9e 31 2e 68 	l.addi r17,r17,11880
    22cc:	e2 31 a8 00 	l.add r17,r17,r21
    22d0:	8e b1 00 00 	l.lbz r21,0(r17)
    22d4:	e2 b5 b8 00 	l.add r21,r21,r23
    22d8:	aa 20 00 20 	l.ori r17,r0,0x20
    22dc:	e4 31 a8 00 	l.sfne r17,r21
    22e0:	10 00 00 a4 	l.bf 2570 <__udivdi3+0x4ac>
    22e4:	e3 71 a8 02 	l.sub r27,r17,r21
    22e8:	aa 20 00 10 	l.ori r17,r0,0x10
    22ec:	e0 63 30 02 	l.sub r3,r3,r6
    22f0:	e2 e6 88 48 	l.srl r23,r6,r17
    22f4:	a7 26 ff ff 	l.andi r25,r6,0xffff
    22f8:	a9 60 00 01 	l.ori r11,r0,0x1
    22fc:	e1 83 bb 0a 	l.divu r12,r3,r23
    2300:	e2 2c bb 06 	l.mul r17,r12,r23
    2304:	e0 63 88 02 	l.sub r3,r3,r17
    2308:	aa 20 00 10 	l.ori r17,r0,0x10
    230c:	e0 63 88 08 	l.sll r3,r3,r17
    2310:	e2 33 88 48 	l.srl r17,r19,r17
    2314:	e2 ac cb 06 	l.mul r21,r12,r25
    2318:	e0 63 88 04 	l.or r3,r3,r17
    231c:	e4 b5 18 00 	l.sfleu r21,r3
    2320:	10 00 00 0a 	l.bf 2348 <__udivdi3+0x284>
    2324:	15 00 00 00 	l.nop 0x0
    2328:	e0 63 30 00 	l.add r3,r3,r6
    232c:	e4 46 18 00 	l.sfgtu r6,r3
    2330:	10 00 00 05 	l.bf 2344 <__udivdi3+0x280>
    2334:	9e 2c ff ff 	l.addi r17,r12,-1
    2338:	e4 b5 18 00 	l.sfleu r21,r3
    233c:	0c 00 00 cd 	l.bnf 2670 <__udivdi3+0x5ac>
    2340:	9d 8c ff fe 	l.addi r12,r12,-2
    2344:	e1 91 88 04 	l.or r12,r17,r17
    2348:	e0 63 a8 02 	l.sub r3,r3,r21
    234c:	e2 a3 bb 0a 	l.divu r21,r3,r23
    2350:	e2 35 bb 06 	l.mul r17,r21,r23
    2354:	e0 63 88 02 	l.sub r3,r3,r17
    2358:	e2 35 a8 04 	l.or r17,r21,r21
    235c:	aa a0 00 10 	l.ori r21,r0,0x10
    2360:	e0 63 a8 08 	l.sll r3,r3,r21
    2364:	a6 73 ff ff 	l.andi r19,r19,0xffff
    2368:	e3 31 cb 06 	l.mul r25,r17,r25
    236c:	e0 63 98 04 	l.or r3,r3,r19
    2370:	e4 b9 18 00 	l.sfleu r25,r3
    2374:	10 00 00 09 	l.bf 2398 <__udivdi3+0x2d4>
    2378:	e0 66 18 00 	l.add r3,r6,r3
    237c:	e4 46 18 00 	l.sfgtu r6,r3
    2380:	10 00 00 05 	l.bf 2394 <__udivdi3+0x2d0>
    2384:	9e 71 ff ff 	l.addi r19,r17,-1
    2388:	e4 b9 18 00 	l.sfleu r25,r3
    238c:	0c 00 00 03 	l.bnf 2398 <__udivdi3+0x2d4>
    2390:	9e 31 ff fe 	l.addi r17,r17,-2
    2394:	e2 33 98 04 	l.or r17,r19,r19
    2398:	aa 60 00 10 	l.ori r19,r0,0x10
    239c:	e1 8c 98 08 	l.sll r12,r12,r19
    23a0:	e1 8c 88 04 	l.or r12,r12,r17
    23a4:	44 00 48 00 	l.jr r9
    23a8:	15 00 00 00 	l.nop 0x0
    23ac:	e4 46 a8 00 	l.sfgtu r6,r21
    23b0:	10 00 00 03 	l.bf 23bc <__udivdi3+0x2f8>
    23b4:	aa e0 00 01 	l.ori r23,r0,0x1
    23b8:	1a e0 00 00 	l.movhi r23,0x0
    23bc:	aa a0 00 03 	l.ori r21,r0,0x3
    23c0:	03 ff ff 52 	l.j 2108 <__udivdi3+0x44>
    23c4:	e2 f7 a8 08 	l.sll r23,r23,r21
    23c8:	e4 46 88 00 	l.sfgtu r6,r17
    23cc:	0f ff ff b7 	l.bnf 22a8 <__udivdi3+0x1e4>
    23d0:	aa 20 00 ff 	l.ori r17,r0,0xff
    23d4:	1a 20 00 ff 	l.movhi r17,0xff
    23d8:	aa 31 ff ff 	l.ori r17,r17,0xffff
    23dc:	e4 46 88 00 	l.sfgtu r6,r17
    23e0:	13 ff ff b8 	l.bf 22c0 <__udivdi3+0x1fc>
    23e4:	aa e0 00 18 	l.ori r23,r0,0x18
    23e8:	03 ff ff b6 	l.j 22c0 <__udivdi3+0x1fc>
    23ec:	aa e0 00 10 	l.ori r23,r0,0x10
    23f0:	e4 45 88 00 	l.sfgtu r5,r17
    23f4:	10 00 00 03 	l.bf 2400 <__udivdi3+0x33c>
    23f8:	aa a0 00 01 	l.ori r21,r0,0x1
    23fc:	1a a0 00 00 	l.movhi r21,0x0
    2400:	aa 20 00 03 	l.ori r17,r0,0x3
    2404:	03 ff ff 8f 	l.j 2240 <__udivdi3+0x17c>
    2408:	e2 b5 88 08 	l.sll r21,r21,r17
    240c:	e3 26 98 48 	l.srl r25,r6,r19
    2410:	e0 a5 b8 08 	l.sll r5,r5,r23
    2414:	ab e0 00 10 	l.ori r31,r0,0x10
    2418:	e3 39 28 04 	l.or r25,r25,r5
    241c:	e2 23 98 48 	l.srl r17,r3,r19
    2420:	e3 79 f8 48 	l.srl r27,r25,r31
    2424:	e1 91 db 0a 	l.divu r12,r17,r27
    2428:	e2 ac db 06 	l.mul r21,r12,r27
    242c:	e0 63 b8 08 	l.sll r3,r3,r23
    2430:	e2 64 98 48 	l.srl r19,r4,r19
    2434:	e2 31 a8 02 	l.sub r17,r17,r21
    2438:	e2 73 18 04 	l.or r19,r19,r3
    243c:	e2 31 f8 08 	l.sll r17,r17,r31
    2440:	a7 b9 ff ff 	l.andi r29,r25,0xffff
    2444:	e3 f3 f8 48 	l.srl r31,r19,r31
    2448:	e2 bd 63 06 	l.mul r21,r29,r12
    244c:	e2 31 f8 04 	l.or r17,r17,r31
    2450:	e4 b5 88 00 	l.sfleu r21,r17
    2454:	10 00 00 0b 	l.bf 2480 <__udivdi3+0x3bc>
    2458:	e0 c6 b8 08 	l.sll r6,r6,r23
    245c:	e2 31 c8 00 	l.add r17,r17,r25
    2460:	e4 59 88 00 	l.sfgtu r25,r17
    2464:	10 00 00 7e 	l.bf 265c <__udivdi3+0x598>
    2468:	9f ec ff ff 	l.addi r31,r12,-1
    246c:	e4 b5 88 00 	l.sfleu r21,r17
    2470:	10 00 00 7b 	l.bf 265c <__udivdi3+0x598>
    2474:	15 00 00 00 	l.nop 0x0
    2478:	9d 8c ff fe 	l.addi r12,r12,-2
    247c:	e2 31 c8 00 	l.add r17,r17,r25
    2480:	e2 31 a8 02 	l.sub r17,r17,r21
    2484:	e2 b1 db 0a 	l.divu r21,r17,r27
    2488:	e3 75 db 06 	l.mul r27,r21,r27
    248c:	e2 31 d8 02 	l.sub r17,r17,r27
    2490:	ab 60 00 10 	l.ori r27,r0,0x10
    2494:	e2 31 d8 08 	l.sll r17,r17,r27
    2498:	a6 73 ff ff 	l.andi r19,r19,0xffff
    249c:	e3 7d ab 06 	l.mul r27,r29,r21
    24a0:	e2 31 98 04 	l.or r17,r17,r19
    24a4:	e4 bb 88 00 	l.sfleu r27,r17
    24a8:	10 00 00 0b 	l.bf 24d4 <__udivdi3+0x410>
    24ac:	15 00 00 00 	l.nop 0x0
    24b0:	e2 31 c8 00 	l.add r17,r17,r25
    24b4:	e4 59 88 00 	l.sfgtu r25,r17
    24b8:	10 00 00 65 	l.bf 264c <__udivdi3+0x588>
    24bc:	9e 75 ff ff 	l.addi r19,r21,-1
    24c0:	e4 bb 88 00 	l.sfleu r27,r17
    24c4:	10 00 00 62 	l.bf 264c <__udivdi3+0x588>
    24c8:	15 00 00 00 	l.nop 0x0
    24cc:	9e b5 ff fe 	l.addi r21,r21,-2
    24d0:	e2 31 c8 00 	l.add r17,r17,r25
    24d4:	ab a0 00 10 	l.ori r29,r0,0x10
    24d8:	e1 8c e8 08 	l.sll r12,r12,r29
    24dc:	e1 8c a8 04 	l.or r12,r12,r21
    24e0:	e3 2c e8 48 	l.srl r25,r12,r29
    24e4:	a6 66 ff ff 	l.andi r19,r6,0xffff
    24e8:	a6 b5 ff ff 	l.andi r21,r21,0xffff
    24ec:	e0 c6 e8 48 	l.srl r6,r6,r29
    24f0:	e3 f5 9b 06 	l.mul r31,r21,r19
    24f4:	e2 79 9b 06 	l.mul r19,r25,r19
    24f8:	e2 b5 33 06 	l.mul r21,r21,r6
    24fc:	e2 b5 98 00 	l.add r21,r21,r19
    2500:	e3 bf e8 48 	l.srl r29,r31,r29
    2504:	e2 bd a8 00 	l.add r21,r29,r21
    2508:	e4 b3 a8 00 	l.sfleu r19,r21
    250c:	e2 31 d8 02 	l.sub r17,r17,r27
    2510:	10 00 00 04 	l.bf 2520 <__udivdi3+0x45c>
    2514:	e3 39 33 06 	l.mul r25,r25,r6
    2518:	1a 60 00 01 	l.movhi r19,0x1
    251c:	e3 39 98 00 	l.add r25,r25,r19
    2520:	aa 60 00 10 	l.ori r19,r0,0x10
    2524:	e2 75 98 48 	l.srl r19,r21,r19
    2528:	e2 73 c8 00 	l.add r19,r19,r25
    252c:	e4 91 98 00 	l.sfltu r17,r19
    2530:	10 00 00 0c 	l.bf 2560 <__udivdi3+0x49c>
    2534:	e4 11 98 00 	l.sfeq r17,r19
    2538:	0f ff ff 53 	l.bnf 2284 <__udivdi3+0x1c0>
    253c:	19 60 00 00 	l.movhi r11,0x0
    2540:	aa 20 00 10 	l.ori r17,r0,0x10
    2544:	e2 b5 88 08 	l.sll r21,r21,r17
    2548:	a7 ff ff ff 	l.andi r31,r31,0xffff
    254c:	e0 84 b8 08 	l.sll r4,r4,r23
    2550:	e2 b5 f8 00 	l.add r21,r21,r31
    2554:	e4 84 a8 00 	l.sfltu r4,r21
    2558:	0f ff ff 4b 	l.bnf 2284 <__udivdi3+0x1c0>
    255c:	15 00 00 00 	l.nop 0x0
    2560:	9d 8c ff ff 	l.addi r12,r12,-1
    2564:	19 60 00 00 	l.movhi r11,0x0
    2568:	44 00 48 00 	l.jr r9
    256c:	15 00 00 00 	l.nop 0x0
    2570:	ab a0 00 10 	l.ori r29,r0,0x10
    2574:	e0 c6 d8 08 	l.sll r6,r6,r27
    2578:	e2 23 a8 48 	l.srl r17,r3,r21
    257c:	e2 e6 e8 48 	l.srl r23,r6,r29
    2580:	e1 71 bb 0a 	l.divu r11,r17,r23
    2584:	e2 6b bb 06 	l.mul r19,r11,r23
    2588:	e0 63 d8 08 	l.sll r3,r3,r27
    258c:	e2 a4 a8 48 	l.srl r21,r4,r21
    2590:	e2 31 98 02 	l.sub r17,r17,r19
    2594:	e2 b5 18 04 	l.or r21,r21,r3
    2598:	e2 75 e8 48 	l.srl r19,r21,r29
    259c:	e2 31 e8 08 	l.sll r17,r17,r29
    25a0:	a7 26 ff ff 	l.andi r25,r6,0xffff
    25a4:	e2 31 98 04 	l.or r17,r17,r19
    25a8:	e3 b9 5b 06 	l.mul r29,r25,r11
    25ac:	e4 bd 88 00 	l.sfleu r29,r17
    25b0:	10 00 00 0b 	l.bf 25dc <__udivdi3+0x518>
    25b4:	e2 64 d8 08 	l.sll r19,r4,r27
    25b8:	e2 31 30 00 	l.add r17,r17,r6
    25bc:	e4 46 88 00 	l.sfgtu r6,r17
    25c0:	10 00 00 25 	l.bf 2654 <__udivdi3+0x590>
    25c4:	9f 6b ff ff 	l.addi r27,r11,-1
    25c8:	e4 bd 88 00 	l.sfleu r29,r17
    25cc:	10 00 00 22 	l.bf 2654 <__udivdi3+0x590>
    25d0:	15 00 00 00 	l.nop 0x0
    25d4:	9d 6b ff fe 	l.addi r11,r11,-2
    25d8:	e2 31 30 00 	l.add r17,r17,r6
    25dc:	e2 31 e8 02 	l.sub r17,r17,r29
    25e0:	e3 71 bb 0a 	l.divu r27,r17,r23
    25e4:	e3 bb bb 06 	l.mul r29,r27,r23
    25e8:	e2 31 e8 02 	l.sub r17,r17,r29
    25ec:	ab a0 00 10 	l.ori r29,r0,0x10
    25f0:	e0 71 e8 08 	l.sll r3,r17,r29
    25f4:	a6 b5 ff ff 	l.andi r21,r21,0xffff
    25f8:	e2 39 db 06 	l.mul r17,r25,r27
    25fc:	e0 63 a8 04 	l.or r3,r3,r21
    2600:	e4 b1 18 00 	l.sfleu r17,r3
    2604:	10 00 00 0b 	l.bf 2630 <__udivdi3+0x56c>
    2608:	15 00 00 00 	l.nop 0x0
    260c:	e0 63 30 00 	l.add r3,r3,r6
    2610:	e4 46 18 00 	l.sfgtu r6,r3
    2614:	10 00 00 0c 	l.bf 2644 <__udivdi3+0x580>
    2618:	9e bb ff ff 	l.addi r21,r27,-1
    261c:	e4 b1 18 00 	l.sfleu r17,r3
    2620:	10 00 00 09 	l.bf 2644 <__udivdi3+0x580>
    2624:	15 00 00 00 	l.nop 0x0
    2628:	9f 7b ff fe 	l.addi r27,r27,-2
    262c:	e0 63 30 00 	l.add r3,r3,r6
    2630:	aa a0 00 10 	l.ori r21,r0,0x10
    2634:	e1 6b a8 08 	l.sll r11,r11,r21
    2638:	e0 63 88 02 	l.sub r3,r3,r17
    263c:	03 ff ff 30 	l.j 22fc <__udivdi3+0x238>
    2640:	e1 6b d8 04 	l.or r11,r11,r27
    2644:	03 ff ff fb 	l.j 2630 <__udivdi3+0x56c>
    2648:	e3 75 a8 04 	l.or r27,r21,r21
    264c:	03 ff ff a2 	l.j 24d4 <__udivdi3+0x410>
    2650:	e2 b3 98 04 	l.or r21,r19,r19
    2654:	03 ff ff e2 	l.j 25dc <__udivdi3+0x518>
    2658:	e1 7b d8 04 	l.or r11,r27,r27
    265c:	03 ff ff 89 	l.j 2480 <__udivdi3+0x3bc>
    2660:	e1 9f f8 04 	l.or r12,r31,r31
    2664:	19 80 00 00 	l.movhi r12,0x0
    2668:	03 ff ff 07 	l.j 2284 <__udivdi3+0x1c0>
    266c:	19 60 00 00 	l.movhi r11,0x0
    2670:	03 ff ff 36 	l.j 2348 <__udivdi3+0x284>
    2674:	e0 63 30 00 	l.add r3,r3,r6
    2678:	03 ff fe c9 	l.j 219c <__udivdi3+0xd8>
    267c:	e2 31 30 00 	l.add r17,r17,r6

00002680 <__umoddi3>:
    2680:	1a e0 00 00 	l.movhi r23,0x0
    2684:	e4 25 b8 00 	l.sfne r5,r23
    2688:	e2 64 20 04 	l.or r19,r4,r4
    268c:	e2 a3 18 04 	l.or r21,r3,r3
    2690:	10 00 00 33 	l.bf 275c <__umoddi3+0xdc>
    2694:	e2 23 18 04 	l.or r17,r3,r3
    2698:	e4 a6 18 00 	l.sfleu r6,r3
    269c:	10 00 00 5a 	l.bf 2804 <__umoddi3+0x184>
    26a0:	aa a0 ff ff 	l.ori r21,r0,0xffff
    26a4:	e4 46 a8 00 	l.sfgtu r6,r21
    26a8:	0c 00 00 9b 	l.bnf 2914 <__umoddi3+0x294>
    26ac:	aa a0 00 ff 	l.ori r21,r0,0xff
    26b0:	1a a0 00 ff 	l.movhi r21,0xff
    26b4:	aa b5 ff ff 	l.ori r21,r21,0xffff
    26b8:	e4 46 a8 00 	l.sfgtu r6,r21
    26bc:	10 00 00 03 	l.bf 26c8 <__umoddi3+0x48>
    26c0:	aa e0 00 18 	l.ori r23,r0,0x18
    26c4:	aa e0 00 10 	l.ori r23,r0,0x10
    26c8:	1a a0 00 00 	l.movhi r21,0x0
    26cc:	e3 26 b8 48 	l.srl r25,r6,r23
    26d0:	9e b5 2e 68 	l.addi r21,r21,11880
    26d4:	e2 b5 c8 00 	l.add r21,r21,r25
    26d8:	8e b5 00 00 	l.lbz r21,0(r21)
    26dc:	e2 b5 b8 00 	l.add r21,r21,r23
    26e0:	ab 20 00 20 	l.ori r25,r0,0x20
    26e4:	e4 19 a8 00 	l.sfeq r25,r21
    26e8:	10 00 00 07 	l.bf 2704 <__umoddi3+0x84>
    26ec:	e2 f9 a8 02 	l.sub r23,r25,r21
    26f0:	e2 23 b8 08 	l.sll r17,r3,r23
    26f4:	e2 a4 a8 48 	l.srl r21,r4,r21
    26f8:	e0 c6 b8 08 	l.sll r6,r6,r23
    26fc:	e2 35 88 04 	l.or r17,r21,r17
    2700:	e2 64 b8 08 	l.sll r19,r4,r23
    2704:	ab e0 00 10 	l.ori r31,r0,0x10
    2708:	e3 26 f8 48 	l.srl r25,r6,r31
    270c:	e3 b1 cb 0a 	l.divu r29,r17,r25
    2710:	e2 bd cb 06 	l.mul r21,r29,r25
    2714:	e2 31 a8 02 	l.sub r17,r17,r21
    2718:	e2 b1 f8 08 	l.sll r21,r17,r31
    271c:	a7 66 ff ff 	l.andi r27,r6,0xffff
    2720:	e2 33 f8 48 	l.srl r17,r19,r31
    2724:	e3 bb eb 06 	l.mul r29,r27,r29
    2728:	e2 35 88 04 	l.or r17,r21,r17
    272c:	e4 bd 88 00 	l.sfleu r29,r17
    2730:	10 00 00 09 	l.bf 2754 <__umoddi3+0xd4>
    2734:	15 00 00 00 	l.nop 0x0
    2738:	e2 31 30 00 	l.add r17,r17,r6
    273c:	e4 46 88 00 	l.sfgtu r6,r17
    2740:	10 00 00 05 	l.bf 2754 <__umoddi3+0xd4>
    2744:	e4 bd 88 00 	l.sfleu r29,r17
    2748:	10 00 00 03 	l.bf 2754 <__umoddi3+0xd4>
    274c:	15 00 00 00 	l.nop 0x0
    2750:	e2 31 30 00 	l.add r17,r17,r6
    2754:	00 00 00 59 	l.j 28b8 <__umoddi3+0x238>
    2758:	e2 31 e8 02 	l.sub r17,r17,r29
    275c:	e4 a5 18 00 	l.sfleu r5,r3
    2760:	10 00 00 06 	l.bf 2778 <__umoddi3+0xf8>
    2764:	e3 64 20 04 	l.or r27,r4,r4
    2768:	e1 63 18 04 	l.or r11,r3,r3
    276c:	e1 84 20 04 	l.or r12,r4,r4
    2770:	44 00 48 00 	l.jr r9
    2774:	15 00 00 00 	l.nop 0x0
    2778:	aa 20 ff ff 	l.ori r17,r0,0xffff
    277c:	e4 45 88 00 	l.sfgtu r5,r17
    2780:	0c 00 00 76 	l.bnf 2958 <__umoddi3+0x2d8>
    2784:	aa 20 00 ff 	l.ori r17,r0,0xff
    2788:	1a 20 00 ff 	l.movhi r17,0xff
    278c:	aa 31 ff ff 	l.ori r17,r17,0xffff
    2790:	e4 45 88 00 	l.sfgtu r5,r17
    2794:	10 00 00 03 	l.bf 27a0 <__umoddi3+0x120>
    2798:	aa 60 00 18 	l.ori r19,r0,0x18
    279c:	aa 60 00 10 	l.ori r19,r0,0x10
    27a0:	1a 20 00 00 	l.movhi r17,0x0
    27a4:	e2 e5 98 48 	l.srl r23,r5,r19
    27a8:	9e 31 2e 68 	l.addi r17,r17,11880
    27ac:	e2 31 b8 00 	l.add r17,r17,r23
    27b0:	8e f1 00 00 	l.lbz r23,0(r17)
    27b4:	e2 f7 98 00 	l.add r23,r23,r19
    27b8:	aa 20 00 20 	l.ori r17,r0,0x20
    27bc:	e4 31 b8 00 	l.sfne r17,r23
    27c0:	10 00 00 9b 	l.bf 2a2c <__umoddi3+0x3ac>
    27c4:	e3 31 b8 02 	l.sub r25,r17,r23
    27c8:	e4 85 18 00 	l.sfltu r5,r3
    27cc:	10 00 00 04 	l.bf 27dc <__umoddi3+0x15c>
    27d0:	e4 46 20 00 	l.sfgtu r6,r4
    27d4:	10 00 00 09 	l.bf 27f8 <__umoddi3+0x178>
    27d8:	e1 75 a8 04 	l.or r11,r21,r21
    27dc:	e3 64 30 02 	l.sub r27,r4,r6
    27e0:	e4 84 d8 00 	l.sfltu r4,r27
    27e4:	e0 a3 28 02 	l.sub r5,r3,r5
    27e8:	0c 00 00 f9 	l.bnf 2bcc <__umoddi3+0x54c>
    27ec:	aa a0 00 01 	l.ori r21,r0,0x1
    27f0:	e2 a5 a8 02 	l.sub r21,r5,r21
    27f4:	e1 75 a8 04 	l.or r11,r21,r21
    27f8:	e1 9b d8 04 	l.or r12,r27,r27
    27fc:	44 00 48 00 	l.jr r9
    2800:	15 00 00 00 	l.nop 0x0
    2804:	1a 20 00 00 	l.movhi r17,0x0
    2808:	e4 26 88 00 	l.sfne r6,r17
    280c:	10 00 00 49 	l.bf 2930 <__umoddi3+0x2b0>
    2810:	aa 20 ff ff 	l.ori r17,r0,0xffff
    2814:	aa 20 00 01 	l.ori r17,r0,0x1
    2818:	e0 d1 33 0a 	l.divu r6,r17,r6
    281c:	aa 20 00 ff 	l.ori r17,r0,0xff
    2820:	e4 46 88 00 	l.sfgtu r6,r17
    2824:	10 00 00 03 	l.bf 2830 <__umoddi3+0x1b0>
    2828:	aa a0 00 01 	l.ori r21,r0,0x1
    282c:	1a a0 00 00 	l.movhi r21,0x0
    2830:	aa 20 00 03 	l.ori r17,r0,0x3
    2834:	e2 b5 88 08 	l.sll r21,r21,r17
    2838:	1a 20 00 00 	l.movhi r17,0x0
    283c:	e2 e6 a8 48 	l.srl r23,r6,r21
    2840:	9e 31 2e 68 	l.addi r17,r17,11880
    2844:	e2 31 b8 00 	l.add r17,r17,r23
    2848:	8e 31 00 00 	l.lbz r17,0(r17)
    284c:	e2 31 a8 00 	l.add r17,r17,r21
    2850:	aa a0 00 20 	l.ori r21,r0,0x20
    2854:	e4 35 88 00 	l.sfne r21,r17
    2858:	10 00 00 47 	l.bf 2974 <__umoddi3+0x2f4>
    285c:	e2 f5 88 02 	l.sub r23,r21,r17
    2860:	aa a0 00 10 	l.ori r21,r0,0x10
    2864:	e2 23 30 02 	l.sub r17,r3,r6
    2868:	e3 26 a8 48 	l.srl r25,r6,r21
    286c:	a7 66 ff ff 	l.andi r27,r6,0xffff
    2870:	e2 b1 cb 0a 	l.divu r21,r17,r25
    2874:	e3 b5 cb 06 	l.mul r29,r21,r25
    2878:	e2 31 e8 02 	l.sub r17,r17,r29
    287c:	ab a0 00 10 	l.ori r29,r0,0x10
    2880:	e2 31 e8 08 	l.sll r17,r17,r29
    2884:	e3 b3 e8 48 	l.srl r29,r19,r29
    2888:	e2 b5 db 06 	l.mul r21,r21,r27
    288c:	e2 31 e8 04 	l.or r17,r17,r29
    2890:	e4 b5 88 00 	l.sfleu r21,r17
    2894:	10 00 00 08 	l.bf 28b4 <__umoddi3+0x234>
    2898:	15 00 00 00 	l.nop 0x0
    289c:	e2 31 30 00 	l.add r17,r17,r6
    28a0:	e4 46 88 00 	l.sfgtu r6,r17
    28a4:	10 00 00 04 	l.bf 28b4 <__umoddi3+0x234>
    28a8:	e4 b5 88 00 	l.sfleu r21,r17
    28ac:	0c 00 00 d1 	l.bnf 2bf0 <__umoddi3+0x570>
    28b0:	15 00 00 00 	l.nop 0x0
    28b4:	e2 31 a8 02 	l.sub r17,r17,r21
    28b8:	e2 b1 cb 0a 	l.divu r21,r17,r25
    28bc:	e3 35 cb 06 	l.mul r25,r21,r25
    28c0:	e2 31 c8 02 	l.sub r17,r17,r25
    28c4:	ab 20 00 10 	l.ori r25,r0,0x10
    28c8:	e1 91 c8 08 	l.sll r12,r17,r25
    28cc:	a6 73 ff ff 	l.andi r19,r19,0xffff
    28d0:	e2 35 db 06 	l.mul r17,r21,r27
    28d4:	e1 8c 98 04 	l.or r12,r12,r19
    28d8:	e4 b1 60 00 	l.sfleu r17,r12
    28dc:	10 00 00 09 	l.bf 2900 <__umoddi3+0x280>
    28e0:	15 00 00 00 	l.nop 0x0
    28e4:	e1 8c 30 00 	l.add r12,r12,r6
    28e8:	e4 46 60 00 	l.sfgtu r6,r12
    28ec:	10 00 00 05 	l.bf 2900 <__umoddi3+0x280>
    28f0:	e4 b1 60 00 	l.sfleu r17,r12
    28f4:	10 00 00 03 	l.bf 2900 <__umoddi3+0x280>
    28f8:	15 00 00 00 	l.nop 0x0
    28fc:	e1 8c 30 00 	l.add r12,r12,r6
    2900:	e1 8c 88 02 	l.sub r12,r12,r17
    2904:	19 60 00 00 	l.movhi r11,0x0
    2908:	e1 8c b8 48 	l.srl r12,r12,r23
    290c:	44 00 48 00 	l.jr r9
    2910:	15 00 00 00 	l.nop 0x0
    2914:	e4 46 a8 00 	l.sfgtu r6,r21
    2918:	10 00 00 03 	l.bf 2924 <__umoddi3+0x2a4>
    291c:	aa e0 00 01 	l.ori r23,r0,0x1
    2920:	1a e0 00 00 	l.movhi r23,0x0
    2924:	aa a0 00 03 	l.ori r21,r0,0x3
    2928:	03 ff ff 68 	l.j 26c8 <__umoddi3+0x48>
    292c:	e2 f7 a8 08 	l.sll r23,r23,r21
    2930:	e4 46 88 00 	l.sfgtu r6,r17
    2934:	0f ff ff bb 	l.bnf 2820 <__umoddi3+0x1a0>
    2938:	aa 20 00 ff 	l.ori r17,r0,0xff
    293c:	1a 20 00 ff 	l.movhi r17,0xff
    2940:	aa 31 ff ff 	l.ori r17,r17,0xffff
    2944:	e4 46 88 00 	l.sfgtu r6,r17
    2948:	13 ff ff bc 	l.bf 2838 <__umoddi3+0x1b8>
    294c:	aa a0 00 18 	l.ori r21,r0,0x18
    2950:	03 ff ff ba 	l.j 2838 <__umoddi3+0x1b8>
    2954:	aa a0 00 10 	l.ori r21,r0,0x10
    2958:	e4 45 88 00 	l.sfgtu r5,r17
    295c:	10 00 00 03 	l.bf 2968 <__umoddi3+0x2e8>
    2960:	aa 60 00 01 	l.ori r19,r0,0x1
    2964:	1a 60 00 00 	l.movhi r19,0x0
    2968:	aa 20 00 03 	l.ori r17,r0,0x3
    296c:	03 ff ff 8d 	l.j 27a0 <__umoddi3+0x120>
    2970:	e2 73 88 08 	l.sll r19,r19,r17
    2974:	ab e0 00 10 	l.ori r31,r0,0x10
    2978:	e0 c6 b8 08 	l.sll r6,r6,r23
    297c:	e2 a3 88 48 	l.srl r21,r3,r17
    2980:	e3 26 f8 48 	l.srl r25,r6,r31
    2984:	e3 b5 cb 0a 	l.divu r29,r21,r25
    2988:	e2 7d cb 06 	l.mul r19,r29,r25
    298c:	e0 63 b8 08 	l.sll r3,r3,r23
    2990:	e2 24 88 48 	l.srl r17,r4,r17
    2994:	e2 b5 98 02 	l.sub r21,r21,r19
    2998:	e2 31 18 04 	l.or r17,r17,r3
    299c:	e2 71 f8 48 	l.srl r19,r17,r31
    29a0:	a7 66 ff ff 	l.andi r27,r6,0xffff
    29a4:	e2 b5 f8 08 	l.sll r21,r21,r31
    29a8:	e2 b5 98 04 	l.or r21,r21,r19
    29ac:	e3 bb eb 06 	l.mul r29,r27,r29
    29b0:	e4 bd a8 00 	l.sfleu r29,r21
    29b4:	10 00 00 09 	l.bf 29d8 <__umoddi3+0x358>
    29b8:	e2 64 b8 08 	l.sll r19,r4,r23
    29bc:	e2 b5 30 00 	l.add r21,r21,r6
    29c0:	e4 46 a8 00 	l.sfgtu r6,r21
    29c4:	10 00 00 05 	l.bf 29d8 <__umoddi3+0x358>
    29c8:	e4 bd a8 00 	l.sfleu r29,r21
    29cc:	10 00 00 03 	l.bf 29d8 <__umoddi3+0x358>
    29d0:	15 00 00 00 	l.nop 0x0
    29d4:	e2 b5 30 00 	l.add r21,r21,r6
    29d8:	e2 b5 e8 02 	l.sub r21,r21,r29
    29dc:	e3 b5 cb 0a 	l.divu r29,r21,r25
    29e0:	e3 fd cb 06 	l.mul r31,r29,r25
    29e4:	e2 b5 f8 02 	l.sub r21,r21,r31
    29e8:	ab e0 00 10 	l.ori r31,r0,0x10
    29ec:	e2 b5 f8 08 	l.sll r21,r21,r31
    29f0:	a6 31 ff ff 	l.andi r17,r17,0xffff
    29f4:	e3 bb eb 06 	l.mul r29,r27,r29
    29f8:	e2 35 88 04 	l.or r17,r21,r17
    29fc:	e4 bd 88 00 	l.sfleu r29,r17
    2a00:	10 00 00 09 	l.bf 2a24 <__umoddi3+0x3a4>
    2a04:	15 00 00 00 	l.nop 0x0
    2a08:	e2 31 30 00 	l.add r17,r17,r6
    2a0c:	e4 46 88 00 	l.sfgtu r6,r17
    2a10:	10 00 00 05 	l.bf 2a24 <__umoddi3+0x3a4>
    2a14:	e4 bd 88 00 	l.sfleu r29,r17
    2a18:	10 00 00 03 	l.bf 2a24 <__umoddi3+0x3a4>
    2a1c:	15 00 00 00 	l.nop 0x0
    2a20:	e2 31 30 00 	l.add r17,r17,r6
    2a24:	03 ff ff 93 	l.j 2870 <__umoddi3+0x1f0>
    2a28:	e2 31 e8 02 	l.sub r17,r17,r29
    2a2c:	e3 a6 b8 48 	l.srl r29,r6,r23
    2a30:	e0 a5 c8 08 	l.sll r5,r5,r25
    2a34:	a9 a0 00 10 	l.ori r13,r0,0x10
    2a38:	e3 bd 28 04 	l.or r29,r29,r5
    2a3c:	e2 23 b8 48 	l.srl r17,r3,r23
    2a40:	e2 7d 68 48 	l.srl r19,r29,r13
    2a44:	e2 b1 9b 0a 	l.divu r21,r17,r19
    2a48:	e3 75 9b 06 	l.mul r27,r21,r19
    2a4c:	e0 63 c8 08 	l.sll r3,r3,r25
    2a50:	e3 e4 b8 48 	l.srl r31,r4,r23
    2a54:	e2 31 d8 02 	l.sub r17,r17,r27
    2a58:	e3 ff 18 04 	l.or r31,r31,r3
    2a5c:	e3 71 68 08 	l.sll r27,r17,r13
    2a60:	a5 fd ff ff 	l.andi r15,r29,0xffff
    2a64:	e2 3f 68 48 	l.srl r17,r31,r13
    2a68:	e1 8f ab 06 	l.mul r12,r15,r21
    2a6c:	e2 3b 88 04 	l.or r17,r27,r17
    2a70:	e4 ac 88 00 	l.sfleu r12,r17
    2a74:	e0 c6 c8 08 	l.sll r6,r6,r25
    2a78:	10 00 00 0b 	l.bf 2aa4 <__umoddi3+0x424>
    2a7c:	e1 a4 c8 08 	l.sll r13,r4,r25
    2a80:	e2 31 e8 00 	l.add r17,r17,r29
    2a84:	e4 5d 88 00 	l.sfgtu r29,r17
    2a88:	10 00 00 58 	l.bf 2be8 <__umoddi3+0x568>
    2a8c:	9f 75 ff ff 	l.addi r27,r21,-1
    2a90:	e4 ac 88 00 	l.sfleu r12,r17
    2a94:	10 00 00 55 	l.bf 2be8 <__umoddi3+0x568>
    2a98:	15 00 00 00 	l.nop 0x0
    2a9c:	9e b5 ff fe 	l.addi r21,r21,-2
    2aa0:	e2 31 e8 00 	l.add r17,r17,r29
    2aa4:	e2 31 60 02 	l.sub r17,r17,r12
    2aa8:	e3 71 9b 0a 	l.divu r27,r17,r19
    2aac:	e2 7b 9b 06 	l.mul r19,r27,r19
    2ab0:	e2 31 98 02 	l.sub r17,r17,r19
    2ab4:	aa 60 00 10 	l.ori r19,r0,0x10
    2ab8:	e2 71 98 08 	l.sll r19,r17,r19
    2abc:	a7 ff ff ff 	l.andi r31,r31,0xffff
    2ac0:	e1 ef db 06 	l.mul r15,r15,r27
    2ac4:	e2 73 f8 04 	l.or r19,r19,r31
    2ac8:	e4 af 98 00 	l.sfleu r15,r19
    2acc:	10 00 00 0b 	l.bf 2af8 <__umoddi3+0x478>
    2ad0:	15 00 00 00 	l.nop 0x0
    2ad4:	e2 73 e8 00 	l.add r19,r19,r29
    2ad8:	e4 5d 98 00 	l.sfgtu r29,r19
    2adc:	10 00 00 41 	l.bf 2be0 <__umoddi3+0x560>
    2ae0:	9e 3b ff ff 	l.addi r17,r27,-1
    2ae4:	e4 af 98 00 	l.sfleu r15,r19
    2ae8:	10 00 00 3e 	l.bf 2be0 <__umoddi3+0x560>
    2aec:	15 00 00 00 	l.nop 0x0
    2af0:	9f 7b ff fe 	l.addi r27,r27,-2
    2af4:	e2 73 e8 00 	l.add r19,r19,r29
    2af8:	aa 20 00 10 	l.ori r17,r0,0x10
    2afc:	e2 b5 88 08 	l.sll r21,r21,r17
    2b00:	e2 b5 d8 04 	l.or r21,r21,r27
    2b04:	e2 b5 88 48 	l.srl r21,r21,r17
    2b08:	e1 66 88 48 	l.srl r11,r6,r17
    2b0c:	a7 7b ff ff 	l.andi r27,r27,0xffff
    2b10:	a7 e6 ff ff 	l.andi r31,r6,0xffff
    2b14:	e1 9b fb 06 	l.mul r12,r27,r31
    2b18:	e3 f5 fb 06 	l.mul r31,r21,r31
    2b1c:	e3 7b 5b 06 	l.mul r27,r27,r11
    2b20:	e3 7b f8 00 	l.add r27,r27,r31
    2b24:	e2 2c 88 48 	l.srl r17,r12,r17
    2b28:	e2 31 d8 00 	l.add r17,r17,r27
    2b2c:	e4 bf 88 00 	l.sfleu r31,r17
    2b30:	e2 73 78 02 	l.sub r19,r19,r15
    2b34:	10 00 00 04 	l.bf 2b44 <__umoddi3+0x4c4>
    2b38:	e2 b5 5b 06 	l.mul r21,r21,r11
    2b3c:	1b 60 00 01 	l.movhi r27,0x1
    2b40:	e2 b5 d8 00 	l.add r21,r21,r27
    2b44:	ab e0 00 10 	l.ori r31,r0,0x10
    2b48:	e3 71 f8 48 	l.srl r27,r17,r31
    2b4c:	e2 bb a8 00 	l.add r21,r27,r21
    2b50:	e2 31 f8 08 	l.sll r17,r17,r31
    2b54:	a5 8c ff ff 	l.andi r12,r12,0xffff
    2b58:	e4 93 a8 00 	l.sfltu r19,r21
    2b5c:	10 00 00 14 	l.bf 2bac <__umoddi3+0x52c>
    2b60:	e2 31 60 00 	l.add r17,r17,r12
    2b64:	e4 33 a8 00 	l.sfne r19,r21
    2b68:	0c 00 00 0f 	l.bnf 2ba4 <__umoddi3+0x524>
    2b6c:	e4 6d 88 00 	l.sfgeu r13,r17
    2b70:	e2 2d 88 02 	l.sub r17,r13,r17
    2b74:	e4 8d 88 00 	l.sfltu r13,r17
    2b78:	e1 73 a8 02 	l.sub r11,r19,r21
    2b7c:	10 00 00 03 	l.bf 2b88 <__umoddi3+0x508>
    2b80:	aa 60 00 01 	l.ori r19,r0,0x1
    2b84:	1a 60 00 00 	l.movhi r19,0x0
    2b88:	e1 6b 98 02 	l.sub r11,r11,r19
    2b8c:	e2 eb b8 08 	l.sll r23,r11,r23
    2b90:	e2 31 c8 48 	l.srl r17,r17,r25
    2b94:	e1 6b c8 48 	l.srl r11,r11,r25
    2b98:	e1 97 88 04 	l.or r12,r23,r17
    2b9c:	44 00 48 00 	l.jr r9
    2ba0:	15 00 00 00 	l.nop 0x0
    2ba4:	13 ff ff f3 	l.bf 2b70 <__umoddi3+0x4f0>
    2ba8:	15 00 00 00 	l.nop 0x0
    2bac:	e0 d1 30 02 	l.sub r6,r17,r6
    2bb0:	e4 91 30 00 	l.sfltu r17,r6
    2bb4:	0c 00 00 09 	l.bnf 2bd8 <__umoddi3+0x558>
    2bb8:	aa 20 00 01 	l.ori r17,r0,0x1
    2bbc:	e2 31 e8 00 	l.add r17,r17,r29
    2bc0:	e2 b5 88 02 	l.sub r21,r21,r17
    2bc4:	03 ff ff eb 	l.j 2b70 <__umoddi3+0x4f0>
    2bc8:	e2 26 30 04 	l.or r17,r6,r6
    2bcc:	1a a0 00 00 	l.movhi r21,0x0
    2bd0:	03 ff ff 09 	l.j 27f4 <__umoddi3+0x174>
    2bd4:	e2 a5 a8 02 	l.sub r21,r5,r21
    2bd8:	03 ff ff f9 	l.j 2bbc <__umoddi3+0x53c>
    2bdc:	1a 20 00 00 	l.movhi r17,0x0
    2be0:	03 ff ff c6 	l.j 2af8 <__umoddi3+0x478>
    2be4:	e3 71 88 04 	l.or r27,r17,r17
    2be8:	03 ff ff af 	l.j 2aa4 <__umoddi3+0x424>
    2bec:	e2 bb d8 04 	l.or r21,r27,r27
    2bf0:	03 ff ff 31 	l.j 28b4 <__umoddi3+0x234>
    2bf4:	e2 31 30 00 	l.add r17,r17,r6

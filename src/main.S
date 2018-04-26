.syntax unified
.global main
.type main, %function

@ for details on how this assignment template works, see
@ https://cs.anu.edu.au/courses/comp2300/assignments/01-synth/#getting-started

.macro generator freq amount
@@freq = r4 amount = r5
  mov r0, \freq
  cmp r0, 1
  beq zero\@
  
  mov r0, 0

  mov r10, #48000 @@8 @#48000 hz
  udiv r10, r10, \freq @@r9 stores n value for amount of times to increment 
  mov r7, r10
  b normal\@

  zero\@:
  mov r0, 0

  mov r10, 1
  mov r7, r10

  normal\@:
  
  mov r9, \amount
  udiv r8, r9, r10

  calltimes\@:

    mov r0, 0xaad8

    mov r1, #43600 @@4 @#43600

    udiv r1, r1, r10 @@r8 stores x value to increment by

    bl checkloop

    subs r8, 1

    mov r10, r7

    mov r6, 0

    bne calltimes\@

.endm

main:
  bl init

loop:
  mov r4, 440 
  mov r5, #12000
  generator r4, r5
  mov r4, 1 
  mov r5, #24000
  generator r4, r5
  mov r4, 440 
  mov r5, #48000
  generator r4, r5
  b loop

checkloop:
  add r6, r0, r1
  push {lr}
  bl BSP_AUDIO_OUT_Play_Sample
  pop {lr}
  mov r0, r6
  subs r10, 1
  bne checkloop
  bx lr

.size main, .-main 

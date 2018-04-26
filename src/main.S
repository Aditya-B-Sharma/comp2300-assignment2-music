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

    push {lr}

    bl checkloop

    pop {lr}

    subs r8, 1

    mov r10, r7

    mov r6, 0

    bne calltimes\@

.endm

main:
  bl init

loop:

@@ structure:
@@ bl [amount of time you want the next note to play for]
@@ bl [next note]

@@ alternatively:
@@ mov r4, frequency of note
@@ mov r5, [(48000*time)] i.e 48000 * 0.25 = 12000 therefore mov r5, #12000
@@ generator r4, r5

  bl quartersecond  @@ a quarter second OF
  bl fourforty      @@ a 440 hz note

  bl halfsecond     @@ a half second OF
  bl silence        @@ silence

  bl quartersecond
  bl fivetwentythree

  bl halfsecond
  bl silence

  bl quartersecond
  bl fourforty

  bl quartersecond
  bl silence

  bl quartersecond
  bl fourforty

  bl halfsecond
  bl silence
  
  bl quartersecond
  bl fivetwentythree

  bl halfsecond
  bl silence

  bl quartersecond
  bl fourforty

  bl quartersecond
  bl silence

  bl quartersecond
  bl fourforty
  
  bl halfsecond
  bl silence

  bl quartersecond
  bl fivetwentythree

  bl halfsecond
  bl silence

  bl quartersecond
  bl fourforty

  bl quartersecond
  bl silence

  bl quartersecond
  bl fourninetyfour

  bl halfsecond
  bl silence

  bl quartersecond
  bl fourforty

  bl halfsecond
  bl silence

  bl quartersecond
  bl threeninetytwo

  bl quartersecond
  bl silence

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



@@ timings

quartersecond:
  mov r5, #12000
  bx lr

halfsecond:
  mov r5, #24000
  bx lr  

@@ frequencies

fourforty:
  mov r4, 440 
  generator r4, r5
  bx lr

fivetwentythree:
  mov r4, 523
  generator r4, r5
  bx lr

fourninetyfour:
  mov r4, 494
  generator r4, r5
  bx lr

threeninetytwo:
  mov r4, 392
  generator r4, r5
  bx lr

silence:
  mov r4, 1 
  generator r4, r5
  bx lr

.size main, .-main 

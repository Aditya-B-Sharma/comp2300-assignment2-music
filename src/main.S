.syntax unified
.global main
.type main, %function

.macro generator freq amount   @@ define a macro that takes in two arguments, frequency and amount of time to play it for
  mov r0, \freq                @@ we put the freqeuency is r0 to compare, this is mainly for silence (if 1 is input as frequency it will play silence)
  cmp r0, 1
  beq zero\@
  
  mov r0, 0

  mov r10, #48000             @@ r9 stores n value for amount of times to increment where n = 48000 / frequency = total hertz / frequency = increments for peak to peak amplitude
  udiv r10, r10, \freq 
  mov r7, r10                 @@ we store the r10 value in r7 as r10 will decrement when the shape is created, and we need to use that value again
  b normal\@                

  zero\@:                     @@ if silence is to be played, we set r10 to 1 so we can just make a 1-point wave
  mov r0, 0

  mov r10, 1
  mov r7, r10

  normal\@:                   @@ the length of time we want to play something / amount of times we must increment = the amount of times we must play a shape (i.e triangle) to keep it going for x time
                              @@ we store this in r8
  mov r9, \amount
  udiv r8, r9, r10

  calltimes\@:                @@ this will repeat until r8 = 0 meaning we have make our required amount of shapes

    mov r0, 0xaad8            @@ lower bound of the amplitude

    mov r1, #43600            @@ the total amplitude
    

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
  bl fiveeightseven      @@ a 440 hz note

  bl quartersecond     @@ a half second OF
  bl fourforty        @@ silence

  bl quartersecond
  bl fiveeightseven

  bl halfsecond
  bl eighteighty

  bl halfsecond
  bl seveneightyfour

  bl quartersecond
  bl sevenforty

  bl quartersecond
  bl sixfiftynine

  bl fullsecond
  bl fivefivefour

  bl inkling
  bl silence


  bl quartersecond  
  bl fivefivefour      

  bl quartersecond     
  bl fourforty        

  bl quartersecond
  bl fivefivefour

  bl halfsecond
  bl sevenforty

  bl halfsecond
  bl sixfiftynine

  bl quartersecond
  bl fivefivefour

  bl quartersecond
  bl fiveeightseven

  bl fullsecond
  bl sevenforty

  bl inkling
  bl silence



  bl quartersecond  
  bl fiveeightseven      

  bl quartersecond     
  bl fourforty        

  bl quartersecond
  bl fiveeightseven

  bl halfsecond
  bl eighteighty

  bl halfsecond
  bl seveneightyfour

  bl quartersecond
  bl sevenforty

  bl quartersecond
  bl sixfiftynine

  bl fullsecond
  bl fivefivefour

  bl inkling
  bl silence


  bl quartersecond  
  bl fivefivefour      

  bl quartersecond     
  bl fourforty        

  bl quartersecond
  bl fivefivefour

  bl halfsecond
  bl sevenforty

  bl halfsecond
  bl sixfiftynine

  bl quartersecond
  bl fivefivefour

  bl quartersecond
  bl fiveeightseven

  bl fullsecond
  bl fiveeightseven

  bl inkling
  bl silence



  bl fullsecond
  bl sevenforty      

  bl fullsecond     
  bl eighteighty        

  bl quartersecond
  bl seveneightyfour

  bl quartersecond
  bl eighteighty

  bl quartersecond
  bl seveneightyfour

  bl quartersecond
  bl sevenforty

  bl fullsecond
  bl sixfiftynine

  bl inkling
  bl silence


  
  bl fullsecond
  bl sixfiftynine      

  bl fullsecond     
  bl seveneightyfour        

  bl quartersecond
  bl sevenforty

  bl quartersecond
  bl seveneightyfour

  bl quartersecond
  bl sevenforty

  bl quartersecond
  bl sixfiftynine

  bl fullsecond
  bl fiveeightseven

  bl inkling
  bl silence




  bl fullsecond
  bl sevenforty      

  bl fullsecond     
  bl eighteighty        

  bl quartersecond
  bl seveneightyfour

  bl quartersecond
  bl sevenforty

  bl quartersecond
  bl seveneightyfour

  bl quartersecond
  bl eighteighty

  bl fullsecond
  bl nineeightyseven

  bl inkling
  bl silence



  bl halfsecond
  bl eighteighty      

  bl quartersecond     
  bl seveneightyfour      

  bl quartersecond
  bl sevenforty

  bl fullsecond
  bl seveneightyfour

  bl quartersecond
  bl sevenforty

  bl quartersecond
  bl seveneightyfour

  bl quartersecond
  bl sevenforty

  bl quartersecond
  bl sixfiftynine

  bl fullsecond
  bl fiveeightseven

  bl inkling
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

inkling:
  mov r5, #1000
  bx lr 

quartersecond:
  mov r5, #12000
  bx lr

halfsecond:
  mov r5, #24000
  bx lr  

fullsecond:
  mov r5, #48000
  bx lr
 

@@ frequencies

fourforty:
  mov r4, 440 
  generator r4, r5
  bx lr

fiveeightseven:
  mov r4, 587 
  generator r4, r5
  bx lr

eighteighty:
  mov r4, 880 
  generator r4, r5
  bx lr

seveneightyfour:
  mov r4, 784 
  generator r4, r5
  bx lr

sevenforty:
  mov r4, 740 
  generator r4, r5
  bx lr

sixfiftynine:
  mov r4, 659 
  generator r4, r5
  bx lr

fivefivefour:
  mov r4, 554 
  generator r4, r5
  bx lr

nineeightyseven:
  mov r4, 987
  generator r4, r5
  bx lr


  /*
587
440
587
880
784
740
659
554



554
440
554
740
659
554
587
740

587
440
587
880
784
740
659
554

554
440
554
740
659
554
587

740
880
784
880
784
740
659

659
784
740
784
740
659
587

740
880
784
740
784
880
987

880
784
740
784
740
784
740
659
587

*/

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

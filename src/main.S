.syntax unified
.global main
.type main, %function

.macro generator freq amount   @@ define a macro that takes in two arguments, frequency and amount of time to play it for
  mov r0, \freq                @@ we put the freqeuency is r0 to compare, this is mainly for silence (if 1 is input as frequency it will play silence)
  cmp r0, 1
  beq zero\@
  
  mov r0, 0

  mov r10, #48000             @@ r10 stores n value for amount of times to increment where n = 48000 / frequency = total hertz / frequency = amount of increments for peak to peak amplitude
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
    
    udiv r1, r1, r10          @@ as r10 stored the amount of increments needed to make a shape, 
                              @@ total amplitude / r10 = value per increment

    push {lr}                 @@ push and pop lr as we will be using bl in checkloop to play the sample
    bl checkloop
    pop {lr}

    subs r8, 1                @@ decrement the amount of times a shape has been played until the required amount of time has been reached

    mov r10, r7               @@ as checkloop resets r10 to 0, we must set it back to our required n amount of increments

    mov r6, 0                 @@ checkloop also changes r6 and since checkloop requires it to be 0 we must reset
 
    bne calltimes\@           @@ go through this label again if we havent reached our play amount (time)

.endm

main:
  bl init                     @@ initialise audio 


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

  bl quartersecond                                 @@ ~The club isnt the best place to find a lover so the bar is where I go
  bl threeninetytwo 

  bl quartersecond
  bl silence


  b loop                                           @@ repeat


checkloop:                                         @@ our main label which makes the sawtooth shape, r0 is set to our required sample
  add r6, r0, r1                                   @@ r6 holds lower bound of amplitude + increment amount
  push {lr}                                        @@ push and pop lr just in case it gets used in BSP
  bl BSP_AUDIO_OUT_Play_Sample
  pop {lr}
  mov r0, r6                                       @@ now we set r0 to r6 since the amplitude - increment was previously played
  subs r10, 1                                      @@ decrement from our n increment counter
  bne checkloop                                    @@ if we havent reached our upper peak of amplitude, keep rising
  bx lr                                            @@ branch back otherwise


@@ timings
@@ alternate structure to reduce repeatability

quartersecond:
  mov r5, #12000
  bx lr

halfsecond:
  mov r5, #24000
  bx lr  

@@ frequencies
@@ alternate structure to reduce repeatability, so we can simple play the frequency we want

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

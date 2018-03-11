  .syntax unified
  .global main
  .type main, %function

@ for details on how this assignment template works, see
@ https://cs.anu.edu.au/courses/comp2300/assignments/01-synth/#getting-started

main:
  @ replace this infinite loop with your Part 1 code
  @ https://cs.anu.edu.au/courses/comp2300/assignments/01-synth/#part-1
  nop
  b main
  .size main, .-main

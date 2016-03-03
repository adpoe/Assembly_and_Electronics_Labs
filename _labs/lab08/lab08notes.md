Notes for CS 447 Lab 08:

- ALU - Adder — use the one from logisim
- B invert and carry in - combo is the same
- PART A:: Does not show any overflow detection components
    *  Implement this in part A, and replicate 8x in Part B
   * OR replicate those units 8x, and add one overflow detection unit in part B
- a - b < 0, then we we know that a < b
- Overflow output derived from but NOT equal to MSB

Rules:
1. If sign of two inputs A and B is SAME, but sign of the RESULT is DIFF, then there is an overflow 
2. If Cin at the MSB is different from Cout (at the MSB), then there is an overflow


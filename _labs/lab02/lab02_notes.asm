#######################################################
# Anthony Poerio (adp59@pitt.edu)                     #
# CS 447 - Fall 2015                                  #
# Lab02 - System Calls, Branches, and Comparisons     # 
#######################################################

.data
   helloMsg:   .asciiz    "Hello, world!"

.text
# Print an integer:  Syscall 1
    addi $s0, $zero, 447      # $s0 = 447 (integer)
    addi $v0, $zero, 1        # Syscall 1: Print integer
    add  $a0, $zero, $s0      # Set the value to print:  (0 + 447) = 447
    syscall                   # Print the integer, 447

# Print a string:   Syscall 4        
    addi $v0, $zero, 4        # Syscall 4: Print string
    la   $a0, helloMsg        # $a0 = address of the first character of helloMsg
    syscall                   # print the string, helloMsg
    
# Read integer from input:  Syscall 5
    addi $v0, $zero, 5        # Syscall 5:  Read integer
    syscall                   # Read integer
    add  $s2, $zero, $v0      # Set $s2 to the integer user entered
    
# System time:  Syscall 30   
# Low bits in in $a0
# High bits in $a1   
    addi $v0, $zero, 30      # Syscall 30:  Return system time
    syscall                  # Get system time, store in $a0 (low order bits), 
                             # and $a1 (high order bits)

# Set RNG seed:  Syscall 40
# RNG id in $a0
# Seed value in $a1
     addi $v0, $zero, 40     # Syscall 40:  Generate Random Number
     xor  $a1, $t0, $t0      # set $a1 to zero
     addi $a1, $a0, 0        # set $a1 to low order bits from previous call to System Time
                             # $a1 is our seed value for the r$NG
     addi $a0, $zero, 0      # $a0 = 0. This is the ID number for the RNG

# Random integer:   Syscall 42
# RNG ID in $a0
# Upper bount in $a1
# Returns random number in $a0
     addi $v0, $zero, 42     # Syscall 42:  Random int range
     add  $a0, $zero, $zero  # Set RNG ID to 0
     xor  $a1, $t0, $t0      # set $a1 to zero
     addi $a1, $zero, 5      # set upper bound to 5 (exclusive)
     syscall                 # Generate a random number and put it in $a0
     add  $s1 $zero, $a0     # Copy the random number to $s1
     
# Control Flow:  Count down loop from 5 to 1, skipping three     
     addi $s0, $zero, 3      # Set $s0 to 3 (do not want to print 3)
     addi $v0, $zero 1       # Syscall 1: print integer 
     addi $a0, $zero, 5      # integer to be printed (start at 5)
     
Loop:
     # If integer to be printed is 0, were are done (so go to done)
     beq  $a0, $zero, done
     # If integer to be printed is not equal to $s0 (3), go to printInteger
     bne  $a0, $s0, printInteger 
     addi $a0, $a0, -1       # Decrease the integer to be printed by 1
     j    Loop               # Go back to loop
printInteger:
     syscall                 # Print integer  
     addi $a0, $a0, -1       # Decrease the integer to be printed by 1 
     j    Loop               # Go back to loop

done: 
    addi $v0, $zero, 10      # Syscall 10:  terminate program
    syscall                  # Exit     
      
                             
# Terminate program: Syscall 10
     addi $v0, $zero, 10     # Syscall 10:  Terminate program
     syscall                 # Terminate program            
    
    
    
    

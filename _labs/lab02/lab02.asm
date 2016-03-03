#######################################################
# Anthony Poerio (adp59@pitt.edu)                     #
# CS 447 - Fall 2015                                  #
# Lab02 - System Calls, Branches, and Comparisons     # 
#     -HIGHER/LOWER GAME-                             #
#######################################################

# Instructions:
# - Write a program that generates a random number between 0 and 9, inclusive
# - Ask user to guesss it
# - If guess is correct -> Congratulate user
# - Otherwise -> tell user that their guess was: too high -OR- too low
#                then, tell user to guess again
# - User can guess -AT MOST- 3x


.data 
   prompt:   .asciiz   "Enter a number between 0 and 9: "
   tooHigh:  .asciiz   "Your guess is too high."
   tooLow:   .asciiz   "Your guess is too low."
   youLose:  .asciiz   "You lose.  The number was "
   period:   .asciiz   "."
   newLine:  .asciiz   "\n"
   youWin:   .asciiz   "Congratulations!  You win!"

.text

#############################################
# Step 1:  Generate a Random number [0, 9)  #
#############################################

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
     syscall	
     
# Random integer:   Syscall 42
# RNG ID in $a0
# Upper bount in $a1
# Returns random number in $a0
     addi $v0, $zero, 42     # Syscall 42:  Random int range
     add  $a0, $zero, $zero  # Set RNG ID to 0
     xor  $a1, $t0, $t0      # set $a1 to zero
     addi $a1, $zero, 10     # set upper bound to 9 (value is 10, exclusive)
     syscall                 # Generate a random number and put it in $a0
     add  $s1 $zero, $a0     # Copy the random number to $s1
     
#######################################
# Result: Random number is now in $s1 #
#######################################
#                                       
#   
#############################################
# Step 2:  Setup up control flow, and loop  #
#############################################
     # Control Flow:  Count down loop from 3 to 0     
     # initalize counter, set it to $t0
     addi $t0, $zero, 3      # Loop iterations left (start at 3)

Loop:
     # If iteration number is 0, were are done (so go to done)
     beq  $t0, $zero, LoseGame
     # If integer to be printed is not equal to $s0 (3), go to Guess
     bne  $a0, $s0, Guess 
     j    Loop               # Go back to loop
     
Guess:
     # Print a string:   Syscall 4        
     addi $v0, $zero, 4      # Syscall 4: Print string
     la   $a0, prompt        # $a0 = prompt message string
     syscall                 # print the string

     # Read integer from input:  Syscall 5
     addi $v0, $zero, 5      # Syscall 5:  Read integer
     syscall                 # Read integer
     add  $s2, $zero, $v0    # Set $s2 to the integer user entered
     
     # Compare input and branch accordingly
     beq  $s2, $s1, guessedRight  # if user's guesss == random number -> guessedRight
     bgt, $s2, $s1, guessedHigh   # if user's guess > random number -> guessedHigh
     blt  $s2, $s1, guessedLow    # if user's guess < random number -> guessedLow

     # Decrement counter if no valid branches
     addi $t0, $t0, -1       # Decrease the integer to be printed by 1 
     j    Loop               # Go back to loop

guessedRight:
    # Print a string:   Syscall 4        
    addi $v0, $zero, 4       # Syscall 4: Print string
    la   $a0, youWin         # $a0 = youLose String
    syscall                  # print the string
    # Terminate program: Syscall 10
    addi $v0, $zero, 10      # Syscall 10:  Terminate program
    syscall                  # Terminate program            

guessedHigh:
     # Print a string:   Syscall 4        
     addi $v0, $zero, 4      # Syscall 4: Print string
     la   $a0, tooHigh       # $a0 = tooHigh message string
     syscall                 # print the string
     # Print a string:   Syscall 4        
     addi $v0, $zero, 4      # Syscall 4: Print string
     la   $a0, newLine       # $a0 = tnewLine
     syscall                 # print the string  
     # Decrement counter and Go back to loop
     addi $t0, $t0, -1       # Decrease the integer to be printed by 1 
     j    Loop               # Go back to loop

guessedLow:
     # Print a string:   Syscall 4        
     addi $v0, $zero, 4      # Syscall 4: Print string
     la   $a0, tooLow        # $a0 = tooLow message string
     syscall                 # print the string
     # Print a string:   Syscall 4        
     addi $v0, $zero, 4      # Syscall 4: Print string
     la   $a0, newLine       # $a0 = tnewLine
     syscall                 # print the string  
     # Decrement counter and Go back to loop
     addi $t0, $t0, -1       # Decrease the integer to be printed by 1 
     j    Loop               # Go back to loop


LoseGame: 
    # Print a string:   Syscall 4        
    addi $v0, $zero, 4       # Syscall 4: Print string
    la   $a0, youLose        # $a0 = youLose String
    syscall                  # print the string
    # Print an integer:  Syscall 1
    addi $v0, $zero, 1        # Syscall 1: Print integer
    add  $a0, $zero, $s1      # set $a0 = to random number, store in $s1
    syscall                   # Print the random integer
    # Print a string:   Syscall 4        
    addi $v0, $zero, 4       # Syscall 4: Print string
    la   $a0, period         # $a0 = period
    syscall                  # print the string
    # End program
    addi $v0, $zero, 10      # Syscall 10:  terminate program
    syscall                  # Exit     
 


# Safety exit
# Terminate program: Syscall 10
     addi $v0, $zero, 10     # Syscall 10:  Terminate program
     syscall                 # Terminate program            
    
    

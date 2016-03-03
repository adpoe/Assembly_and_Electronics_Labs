#######################################################
# Anthony Poerio (adp59@pitt.edu)                     #
# CS 447 - Fall 2015                                  #
# Lab03 - Arithmetic and Logical Instructions         # 
#     -Part 1: Bit Manipulation-                      #
#######################################################

.data  
       prompt: .asciiz "Please enter your integer: "
       output: .asciiz "Here is your output: "

.text
	la   $a0, prompt       # Load prompt into argument register
	addi $v0, $zero, 4     # Load 4 into $v0, to print the prompt in $a0
	syscall                # Print a String
	
	                       # Read an integer from the user
        addi $v0, $zero, 5     # Add number 5 into $v0 - Read Integer
        syscall                # Get a user's input
	
	add  $t0, $zero, $v0   # Move Result from user input into $t0
	srl  $t1, $t0, 15      # Shift the number in $t0 right 15 bits
	                       # Store result in $t1
	and  $t1, 7            # bitwise and with $t1 and number 7
	                       # will exctract only bits which are 1
	                       # in the 3 LEAST significant bits
	                      
	la   $a0, output       # Load prompt into argument register
	addi $v0, $zero, 4     # Load 4 into $v0, to print the prompt in $a0
	syscall                # Print a String	            
	
	addi $v0, $zero, 1     # Move 1 in $v0, to print an integer
	add  $a0, $zero, $t1   # Move value of $t1 into argument $a0
	syscall                # Print number in $a0, the result of our computation                                   

	addi $v0, $zero, 10    # Move 10 into $v0, exit syscall
	syscall                # Exit program

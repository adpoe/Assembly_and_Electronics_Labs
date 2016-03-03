#######################################################
# Anthony Poerio (adp59@pitt.edu)                     #
# CS 447 - Fall 2015                                  #
# Lab05 - Table Lookups and Recursion	              # 
#     -Part 2: Factorial Recursive Function-          #
#######################################################

.data
	prompt:          .asciiz    "Enter a nonnegative integer: "
	equals:          .asciiz    "! = "
	newLine:	 .asciiz    "\n"
	space:           .asciiz    " "
	invalid:         .asciiz    "Invalid integer; try again."
	
.text

################
#### MAIN  #####
################
Main:
	# Print prompt
	la   $a0, prompt              # Load prompt into argument register
	addi $v0, $zero, 4            # Load 4 into $v0, to print the prompt in $a0
	syscall                       # Print a String
	la   $a0, newLine             # Load newline into argument register
	addi $v0, $zero, 4            # Load 4 into $v0, to print the prompt in $a0
	syscall                       # Print a String
	# Read integer
	addi $v0, $zero, 5            # Load 5 into $v0, to read a string into $a0
	syscall                       # Print a String
	
	addi $t0, $v0, 0              # Move user entered integer into $t0

checkValidity:
	bgt  $t0, -1, validFactorial  # if number entered is > -1, go to validFactorial
	# Else, print that the entry was invalid and go back to Main
	# Print invalid
	la   $a0, invalid             # Load invalid into argument register
	addi $v0, $zero, 4            # Load 4 into $v0, to print the prompt in $a0
	syscall                       # Print a String
	la   $a0, newLine             # Load newline into argument register
	addi $v0, $zero, 4            # Load 4 into $v0, to print the prompt in $a0
	syscall     
	j Main

validFactorial:	
	addi $a0, $t0, 0              # $a0 = result of user input
	jal _Fac
	addi $t9, $v0, 0              # Store factorial return value in $t9
	# Print $t0 = user entered number
	addi $a0, $t0, 0              # $a0 = user entered number
	addi $v0, $zero, 1            # load 1 into $v0 for print integer syscall
	syscall
	# Print equals
	la   $a0, equals              # Load equals into argument register
	addi $v0, $zero, 4            # Load 4 into $v0, to print the prompt in $a0
	syscall                       # Print a String
	# Print $t9 = user entered number
	addi $a0, $t9, 0              # $a0 = user entered number
	addi $v0, $zero, 1                # load 1 into $v0 for print integer syscall
	syscall
	# Terminate program
	addi $v0, $zero, 10           # prepare for syscall 10 - exit
	syscall 	              # exit
###            ###
###  /endMain  ###
###	       ###



# Function: _Fac
# Purpose:  Tail recursive function to calculate a factorial, given a valid positive integer as input
# Parameters:
#	$a0 = valid positive integer
# Return:
#	$v0 = value of one factorial iteration
_Fac:
	# Prologue
	addi $sp $sp, -32     
	sw   $ra, 0($sp)
	sw   $a0, 4($sp)
	sw   $a1, 8($sp)
	sw   $s0, 12($sp) 
	sw   $s1, 16($sp)
	sw   $s2, 20($sp)
	sw   $s3, 24($sp)
	sw   $s4, 28($sp)
	# End stack creation
	
	# Base case
	addi $v0, $zero, 1
	beq, $a0, 0, exitFac

	# Set values
	addi $s0, $a0, 0
	addi $a0, $a0 -1
	jal _Fac
	
	# Perform recursive computation
	mul $v0, $s0, $v0							

exitFac:
	# Epilogue
	lw   $s4, 28($sp)
	lw   $s3, 24($sp)
	lw   $s2, 20($sp)
	lw   $s1, 16($sp)
	lw   $s0, 12($sp)
	lw   $a1, 8($sp)
	lw   $a0, 4($sp)
	lw   $ra, 0($sp)
	addi $sp $sp, 32     
	# End stack destruction
	jr $ra


#######################################################
# Anthony Poerio (adp59@pitt.edu)                     #
# CS 447 - Fall 2015                                  #
# Lab05 - Table Lookups and Recursion	              # 
#     -Part 1: Table Lookups-                         #
#######################################################

# Registers used in Main:
# ----------------------------------------------------------------------------------------
#    $t0 = comparison counter for main loop, also the value most recently checked index   \
#    $t1 = how far to move from start of names array to accesss a given item              \
#    $t2 = byte address age we are looking for, if found                                  \
#    $t3 = used to hold output value from _LookUpAge                                      \
#    $s0 = used to help clear the newline from user input	                          \
# -----------------------------------------------------------------------------------------


.data
	# Given input array
	names:  	.asciiz    "steve", "john", "chelsea", "julia", "ryan"
	ages:    	.byte      20, 25, 22, 21, 23
	# Buffers for input and output
	inputStr:	.space	   64
	outputBuffer:	.space	   64
	# Strings to print during user interaction
	prompt:		.asciiz    "Please enter a name: "
	ageIs:		.asciiz    "Age is: "
	notFound:       .asciiz    "Not found!"
	newLine:	.asciiz    "\n"
	spaceChar:	.asciiz    " "


.text
################
#### MAIN  #####
################
 
 Main:
	# print prompt
	la    $a0, prompt     	      # load prompt into $a0
	addi  $v0, $zero, 4   	      # prepare for syscall 4 - print a string
	syscall 	              # print string	
	
	# get user input
	addi $v0, $zero, 8            # Read input string
	la   $a0, inputStr            # Load address of input string into $a0
	addi $a1, $zero, 64           # 64 characters is the max number to read
	syscall		              # User's input will now be stored in $a0 (refererecnce) and inputStr (label)
	
	# prepare to remove the newline which we got in user input
	addi  $s0, $zero, 0            # $s0 = start index of the string
removeNewline:
        lb    $a3, inputStr($s0)       # $a3 = character at current index
        addi  $s0, $s0, 1              # Increment index by 1
        bnez  $a3, removeNewline       # If $a3 != 0, continue looping
        subiu $s0, $s0, 2              # $s0 - 2 = position of the newLine character
        sb    $0, inputStr($s0)        # Replace newLine with a null character (0)	

			
	# setup comparison loop
	addi $t0, $zero, 0           # $t0 = a counter, initialized to 0
	la   $a0, inputStr	     # Confirm:  User's input name is in $a0 
	la   $a1, names		     # Confirm:  The string to test is in $a1
	addi $t1, $zero, 0	     # $t1 = how far to move to access next string in $a1
	
	
makeComparison:
	# Perform the comparison loop
	bgt  $t0, 4, printNoMatch    # if we are on the 5th iteration (> 4), print the result
	
	# Setup variables
	la   $a0, inputStr	     # Confirm:  User's input name is in $a0 
	la   $a1, names		     # Confirm:  The string to test is in $a1
	add  $a1, $a1, $t1	     # $a1 = start index of NEXT available string to check
	
	# FUNCTION CALL - GOAL: 
	# -----------------------------------------------------
	# Check if user input ($a0) = current NEXT available, unchecked item in array ($a1), 
	# We will only be checking up until a null terminator is reached, so it's necessary to
	# Run through this a few times to check EVERY item in the array
	# ------------------------------------------------------
	# Store $t values before making a call to string length
	addi $sp, $sp, -16
	sw   $a0, 0($sp)
	sw   $a1, 4($sp)
	sw   $t0, 8($sp)
	sw   $t1, 12($sp)
	# End storage
	jal _StrEqual                # Function call to compare equality of $a0 and $a1
	# Restore $t values
	lw  $t1, 12($sp)
	lw  $t0, 8($sp)
	lw  $a1, 4($sp)
	lw  $a0, 0($sp)
	addi $sp, $sp, 20
	# End restore
	# $v0 = 1 if the compared strings are equal, 0 if they are NOT equal.
	beq $v0, 1, printResult     # If strings are equal, print the result
			            # else continue iterating
	
	# FUNCTION CALL - GOAL: 
	# -----------------------------------------------------
	# Need to get string length of CURRENT item in array, 
	# in order to move through it, Item by item.
	# ------------------------------------------------------
	# Store $t values before making a call to string length
	addi $sp, $sp, -16
	sw   $a0, 0($sp)
	sw   $a1, 4($sp)
	sw   $t0, 8($sp)
	sw   $t1, 12($sp)
	# End storage
	jal  _strLength              # call _strLength, gets length most recently compared string in name, $a1
	# Restore $t values
	lw  $t1, 12($sp)
	lw  $t0, 8($sp)
	lw  $a1, 4($sp)
	lw  $a0, 0($sp)
	addi $sp, $sp, 16
	# End restore
	# $v1 = Length of current item, up to null terminator
	add $t1, $t1, $v1            # $t1 now equals distance from start of names at which the NEXT 
			             # unchecked String can be found
	addi $t1, $t1, 1 	     # Add one more character, because mips won't count the null
	
	addi $t0, $t0, 1             # Increment $t0 by - holds the value of current index we are checking
	j makeComparison             # continue on makeComparison loop, using $t1 to index into the array now
	
printResult:			     # If match was found, Lookup corresponding age in AGES 
	la   $a0, ages               # $a0 = ages byte array
	addi $a1, $t0, 0             # $t0 = number of iterations the main loop performed

	
	
	# FUNCTION CALL - GOAL: 
	# -----------------------------------------------------
	# Get the age value at the index corresponding to the name
	# we have a match for. 
	# ------------------------------------------------------
	# Store $t values before making a call to string length
	addi $sp, $sp, -20
	sw   $a0, 0($sp)
	sw   $a1, 4($sp)
	sw   $t0, 8($sp)
	sw   $t1, 12($sp)
	sw   $t2, 16($sp)
	# End storage
	jal _LookUpAge                # Function call to LookUpAge in the corresponding byte array
	# Restore $t values
	lw  $t2, 16($sp)
	lw  $t1, 12($sp)
	lw  $t0, 8($sp)
	lw  $a1, 4($sp)
	lw  $a0, 0($sp)
	addi $sp, $sp, 20
	# End restore
	addi $t3, $v0, 0             # $t3 = the return value from _LookupAge
		
	# print AgeIs
	la    $a0, ageIs    	     # load ageIs into $a0
	addi  $v0, $zero, 4   	     # prepare for syscall 4 - print a string
	syscall 	             # print string	
		
	addi $a0, $t3, 0             # $a0 = the byte we've indexed at $t3, the age we are looking for
	addi $v0, $zero,1            # prepare for syscall 1 - print an integer
	syscall 		     # print an integer
		
	# Terminate program
	addi $v0, $zero, 10          # prepare for syscall 10 - exit
	syscall 	
	
printNoMatch: 			     # If match _NOT_ found, print a string telling user "No Match!"
	# print newLine
	la    $a0, newLine     	     # load newLine into $a0
	addi  $v0, $zero, 4   	     # prepare for syscall 4 - print a string
	syscall 	             # print string	
	
	# print notFound
	la    $a0, notFound    	     # load notFound into $a0
	addi  $v0, $zero, 4   	     # prepare for syscall 4 - print a string
	syscall 	             # print string	
	
	# Terminate program
	addi $v0, $zero, 10          # prepare for syscall 10 - exit
	syscall 	             # exit
###            ###
###  /endMain  ###
###	       ###


###########################
######## FUNCTIONS ########
###########################

# Function:  _strEqual
# Purpose:   Check if two strings are equal
# Parameters:  
# 	$a0 = a string to test equality on
#	$a1 = a second string to test against
# Return:
#	$v0 = 1 if the strings are equal
#	 "  = 0 if the strings are NOT equal 
_StrEqual:
	# Create stack
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
	
testLoop:	
	# Load current byte of $a0 and $a1, starting at 0
	lb   $s0, 0($a0)
	lb   $s1, 0($a1)
	# If $s0 reaches a null terminator, confirm the equality
	beq  $s0, 0, confirmEquality
	# If current characters are NOT equal, or a null (zero is reached) the strings CANNOT be equal. 
	bne  $s0, $s1, stringsNotEqual 
	# If current strings ARE equal, increment values in $a0 and $a1, continue testing
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	j testLoop
		
confirmEquality:
	beq $s0, $s1, stringsEqual      # if BOTH $s0 and $s1 are null at same time, then the Strings are equal
	j stringsNotEqual	 	# if not we move right into stringsNotEqual

stringsEqual: 
	addi $v0, $zero, 1              # If strings are equal, then $v0 = 1
	j exitEquals

stringsNotEqual:	
	addi $v0, $zero, 0              # If strings are NOT equal, $v0 = 0
	j exitEquals

exitEquals:
	# Destroy stack
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



# Function: _lookUpAge
# Purpose:  Lookup the age of the corresponding string, in a dictionary data type
# Parameters:
#	$a0 = address of a byte array
#	$a1 = index to return
# Return:
#	$v0 = the value AT the index specified, in the given byte array
_LookUpAge:
	# Create stack
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
	
	add  $s0, $zero, $a0        # $s0 = ages
	add  $s1, $s0, $a1          # $s1 = the byte address in $a0 + number of iterations 
				    # we performed in the main loop
	lb   $s1, 0($s1)	    # $s1 = only the number we are looking for	

	# Store return value
	addi $v0, $s1, 0	    # $v0 = the number we found, stored in the return value
exitLookup:
	# Destroy stack
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



# Function:      Get String Length (_strLength)
# Type:          Leaf Function, always a Callee
# argument:      $a1 = address of a null terminated String
# return value:  $v1 = length of specified string 		
_strLength:
		addi $sp, $sp, -12    # Allocate stack frame for our function
		sw   $ra, 0($sp)      # store $ra in position 0 of stack frame
		sw   $s0, 4($sp)      # store $t0 in position 4 of stack frame
		sw   $s1, 8($sp)      # store $t1 in position 8 of stack frame
		
		addi $v1, $zero, 0    # Initialize counter for return to 0
		addi $s0, $a1, 0      # Set $s0 to String passed into function
  lenLoop:	lbu  $s1, 0($s0)      # Loads ONLY the first BYTE (char) into $t1 register
		beq  $s1, 0, exitLen  # Exit with counter value of 0, if $s1 == 0
		                      # Means byte is null	
		addi $v1, $v1, 1      # Else increment $v0 (return address AND our counter) by 1
		addi $s0, $s0, 1      # And increment value in $s0 by 1, so we can access its n + 1 byte
		                      # In the next loop
		j lenLoop	

   exitLen:    
   		# Restore stack from method	
    		lw   $s1, 8($sp)      # load $t1 from position 8 of stack frame
 	        lw   $s0, 4($sp)      # load $t0 from position 4 of stack frame
 	        lw   $ra, 0($sp)      # load $ra from position 0 of stack frame
 	        addi $sp, $sp, 12     # De-allocate stack frame for our function
		
  	        jr $ra
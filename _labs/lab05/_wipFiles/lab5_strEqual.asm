.data
		test: 	    .asciiz      "hola"
		testWrong:  .asciiz      "wrong"
		testRight:  .asciiz      "hola"
		buffer:     .space       64
		outBuffer:   .space       64
		newLine:    .asciiz      "\n"

		
.text
	####################################
	##### CONFIRM _StrLength WORKS #####
	####################################
	la $a1, test	          # load value of test into $a0, confirm that _strLength is functional
	jal _strLength
	
	# print number from _strLength
	addi $a0, $v1, 0          # set $a0 to return value from _strLength
	addi $v0, $zero, 1	  # print the return value
	syscall
	
	# print newLine
	la    $a0, newLine     	     # load prompt into $a0
	addi  $v0, $zero, 4   	     # prepare for syscall 4 - print a string
	syscall 	             # print string	
	
	
	####################################
	##### CONFIRM _StrEquals WORKS #####
	####################################
	#
	# FIRST TEST VALID VALUE
	#
	# Setup values for _StrEqual
	la $a0, test
	la $a1, testRight
	jal _StrEqual
	

	# print return value from from _StrEqual
	addi $a0, $v0, 0        # set $a0 to return value from _strEquals
	addi  $v0, $zero, 1	  # print the return value
	syscall
	
	# print newLine
	la    $a0, newLine     	     # load prompt into $a0
	addi  $v0, $zero, 4   	     # prepare for syscall 4 - print a string
	syscall 	             # print string	
	#
	# THEN, TEST INVALID VALUE
	#
	# Setup values for _StrEqual
	la $a0, test
	la $a1, testWrong
	jal _StrEqual
	
	# print return value  from _StrEqual
	addi $a0, $v0, 0        # set $a0 to return value from _strEquals
	addi  $v0, $zero, 1	  # print the return value
	syscall
	
	# print newLine
	la    $a0, newLine     	     # load prompt into $a0
	addi  $v0, $zero, 4   	     # prepare for syscall 4 - print a string
	syscall 
	#################################
	#### NOW, TEST ON USER INPUT ####
	#################################
	# get user input
	addi $v0, $zero, 8           # Read input string
	la   $a0, buffer             # Load address of input string into $a0
	addi $a1, $zero, 64          # 64 characters is the max number to read
	syscall		             # User's input will now be stored in $a0 (refererecnce) and inputStr (label)
	
	li $s0,0                      # Set index to 0
remove:
        lb $a3,buffer($s0)      # Load character at index
        addi $s0,$s0,1        # Increment index
        bnez $a3,remove    # Loop until the end of string is reached
        beq $a1,$s0,skip      # Do not remove \n when it isn't present
        subiu $s0,$s0,2     # Backtrack index to '\n'
        sb $0, buffer($s0)        # Add the terminating character in its place
skip:	
	
	# Setup values for _StrEqual
	la $a0, buffer
	la $a1, test
	jal _StrEqual
	# print return value from _StrEqual
	addi  $a0, $v0, 0        # set $a0 to return value from _strEquals
	addi  $v0, $zero, 1	 # print the return value
	syscall
		                 # print string	
	##
	###############################################################
	# Confirm that our input buffer is actually storing something #
	###############################################################
	# print newLine
	la    $a0, newLine     	     # load prompt into $a0
	addi  $v0, $zero, 4   	     # prepare for syscall 4 - print a string
	syscall 
	
	la   $a0, buffer
	
	la $a1, buffer	             # load value of test into $a0, confirm that _strLength is functional
	jal _strLength
	
	
	# print number from _strLength
	addi $a0, $v1, 0          # set $a0 to return value from _strLength
	addi $v0, $zero, 1	  # print the return value
	syscall
	
	# print newLine
	la    $a0, newLine     	     # load prompt into $a0
	addi  $v0, $zero, 4   	     # prepare for syscall 4 - print a string
	syscall 	             # print string	
	
	
	# Terminate program
	addi $v0, $zero, 10        # prepare for syscall 10 - exit
	syscall 

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
	
	
			
# Function:      Get String Length (_strLength)
# Type:          Leaf Function, always a Callee
# argument:      $a1 = address of a null terminated String
# return value:  $v1 = length of specified string 
_strLength:
		addi $sp, $sp, -12    # Allocate stack frame for our function
		sw   $ra, 0($sp)      # store $ra in position 0 of stack frame
		sw   $s0, 4($sp)      # store $t0 in position 4 of stack frame
		sw   $s1, 8($sp)      # store $t1 in position 8 of stack frame
		
		#la   $t1, testString
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


# Function:      Read String (_readString)
# What it does:  Reads a null-terminated string into memory from user input.
# Type:          Non-Leaf Function
# argument:      $a0 = address of an input string
# argument:      $a1 = address of output buffer
# return value:  None	
_readString:
		addi $sp, $sp, -12    # Allocate stack frame for our function
		sw   $ra, 0($sp)      # store $ra in position 0 of stack frame
		sw   $t0, 4($sp)      # store $t0 in position 4 of stack frame
		sw   $t1, 8($sp)      # store $t1 in position 8 of stack frame	
		
readStrBody:	jal  _strLength       # $v0 = _strLength($a0)  get length of $a0  in $v0		
		la   $t0, outBuffer         # $t0 points to the buffer
		addi $t0, $v0, -1     # $t0 = length of $a0 (now stored in $v0) - 1      
		add  $t0, $t0, $a0    # Add value of $a0 to $t0
		sb   $zero, 0($t0)    # Set byte 0 of $t0 to 0

		
    exitRd:     lw   $t1  8($sp)      # restore value $t1
    		lw   $t0  4($sp)      # restore value $t0
    		lw   $ra, 0($sp)      # restore value $ra
    		
    		jr   $ra 

  	        
	
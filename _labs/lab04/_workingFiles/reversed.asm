.data
	inputStr:    	 .space   64
	buffer:          .space   64
	finalOut:        .space   64
	enterStr:        .asciiz  "Enter a string: "
	stringHas:       .asciiz  "This string has"
	numChars:        .asciiz  "characters."
	specStart:       .asciiz  "Specify start index: "
	specEnd:         .asciiz  "Specify the end index: "
	substringIs:     .asciiz  "Your substring is: "
	newLine:         .asciiz  "\n"
	space:           .asciiz  " " 
	
.text
getData: 
	# Print prompt
	la   $a0, enterStr     # Load enterStr into argument register
	addi $v0, $zero, 4     # Load 4 into $v0, to print the prompt in $a0
	syscall                # Print a String
	la   $a0, newLine      # Load newline into argument register
	addi $v0, $zero, 4     # Load 4 into $v0, to print the prompt in $a0
	syscall                # Print a String
	# Read in input string
	addi $v0, $zero, 8     # Read input string
	la   $a0, inputStr     # Load address of input string into $a0
	addi $a1, $zero, 64    # 64 characters is the max number to read
	syscall
	
	# print message to specify START
	la   $a0, specStart    # Load specStart into argument register
	addi $v0, $zero, 4     # Load 4 into $v0, to print the prompt in $a0
	syscall                # Print a String
	la   $a0, newLine      # Load newline into argument register
	addi $v0, $zero, 4     # Load 4 into $v0, to print the prompt in $a0
	syscall                # Print a String
	# Read the start number the user inputs
	addi $v0, $zero, 5     # Add number 5 into $v0 - Read Integer
        syscall                # Get a user's input
        add  $a2, $zero, $v0    # Move user input into $a2
	

	# print message to specify END
	la   $a0, specEnd      # Load specEnd into argument register
	addi $v0, $zero, 4     # Load 4 into $v0, to print the prompt in $a0
	syscall                # Print a String
	la   $a0, newLine      # Load newline into argument register
	addi $v0, $zero, 4     # Load 4 into $v0, to print the prompt in $a0
	syscall                # Print a String
	# Read the start number the user inputs
	addi $v0, $zero, 5     # Add number 5 into $v0 - Read Integer
        syscall                # Get a user's input
        add  $a3, $zero, $v0   # Move user input into $a3 	
	
# END getData

manipulateData: 
	# CALL _readString:  Function call, setup arguments
	# argument:      $a0 = address of an input string
	# argument:      $a1 = address of output buffer
	# return value:  None	
	la $a0, inputStr       # Load value of input string into $a0
	la $a1, buffer         # Load address of buffer into $a1
	jal _readString        # Remove newline character from string in $a0
			       # And MOVE it into the buffer, in $a1
			       

	# CALL _strLength:  Function call, setup arguments
	# argument:      $a0 = address of a null terminated String
	# return value:  $v0 = length of specified string 		
	la $a0, inputStr         # Confirm:  Address of null terminated string is in $a0
	jal _strLength         # RETURNS: length of string in $a0
	                       # in the register, $v0 
	addi $s3, $v0, 0                       
	
#############################################################################
	# Call function to print string detailing length
	la   $a0, stringHas    # Load stringHas into argument register
	addi $v0, $zero, 4     # Load 4 into $v0, to print the prompt in $a0
	syscall                # Print a String
	la   $a0, space        # Load newline into argument register
	addi $v0, $zero, 4     # Load 4 into $v0, to print the prompt in $a0
	syscall 
	addi $a0, $s3, 0       # load return value from function
	addi $v0, $zero, 1     # print number in $a0
	syscall         
	la   $a0, space        # Load newline into argument register
	addi $v0, $zero, 4     # Load 4 into $v0, to print the prompt in $a0
	syscall 
	la   $a0, numChars     # Load newline into argument register
	addi $v0, $zero, 4     # Load 4 into $v0, to print the prompt in $a0
	syscall  
	la   $a0, newLine      # Load newline into argument register
	addi $v0, $zero, 4     # Load 4 into $v0, to print the prompt in $a0
	syscall 				
##############################################################################	
	
	# CALL _subString:  Function call, setup arguments	
	# argument:      $a0 = address of an input string
	# argument:      $a1 = address of output buffer
	# argument:      $a2 = start index for the input string (inclusive)
	# argument:      $a3 = end index for the input string (exclusive)
	# return value:  $v0 = address of the output buffer (same as $a1)
	la  $a0, inputStr        # Confirm:   Address of BUFFER -original string with newline removed
			       # is the input string 
	la  $a1, finalOut      # Confrim:   Output buffer is $a1 
	add $a2, $a2, $zero    # Confirm:  $a2 is user input for start index
	add $a3, $a3, $zero    # Confirm:  $a3 is user input for end index	
	jal _subString	       # $v0 has the address of our output string
	
	
	                       
  	
outputData: 
	# print message to specify END
	la   $a0, substringIs  # Load specEnd into argument register
	addi $v0, $zero, 4     # Load 4 into $v0, to print the prompt in $a0
	syscall                # Print a String
	la   $a0, newLine      # Load newline into argument register
	addi $v0, $zero, 4     # Load 4 into $v0, to print the prompt in $a0
	syscall                # Print a String  
	la   $a0, finalOut     # Load specEnd into argument register
	addi $v0, $zero, 4     # Load 4 into $v0, to print the prompt in $a0
	syscall                # Print a String
		  	
	# gracefully exit 
   	addi $v0, $zero, 10    # terminate program 
	syscall	
	
######################################
########   PROGRAM FUNCTIONS  ########
######################################
    		    		

# Function:      Get String Length (_strLength)
# Type:          Leaf Function, always a Callee
# argument:      $a0 = address of a null terminated String
# return value:  $v0 = length of specified string 		
_strLength:
		addi $sp, $sp, -12    # Allocate stack frame for our function
		sw   $ra, 0($sp)      # store $ra in position 0 of stack frame
		sw   $t0, 4($sp)      # store $t0 in position 4 of stack frame
		sw   $t1, 8($sp)      # store $t1 in position 8 of stack frame
		
		#la   $t1, testString
		addi $v0, $zero, 0    # Initialize counter for return to 0
		addi $t0, $a0, 0      # Set $t0 to String passed into function
  lenLoop:	lbu  $t1, 0($t0)      # Loads ONLY the first BYTE (char) into $t1 register
		beq  $t1, 0, exitLen  # Exit with counter value of 0, if $t1 == 0
		                      # Means byte is null	
		addi $v0, $v0, 1      # Else increment $v0 (return address AND our counter) by 1
		addi $t0, $t0, 1      # And increment value in $t0 by 1, so we can access its n + 1 byte
		                      # In the next loop
		j lenLoop
		

   exitLen:    
   		# Restore stack from method	
    		lw   $t1, 8($sp)      # load $t1 from position 8 of stack frame
 	        lw   $t0, 4($sp)      # load $t0 from position 4 of stack frame
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
		la   $t0, buffer      # $t0 points to the buffer
		addi $t0, $v0, -1     # $t0 = length of $a0 (now stored in $v0) - 1      
		add  $t0, $t0, $a0    # Add value of $a0 to $t0
		sb   $zero, 0($t0)    # Set byte 0 of $t0 to 0

		
    exitRd:     lw   $t1  8($sp)      # restore value $t1
    		lw   $t0  4($sp)      # restore value $t0
    		lw   $ra, 0($sp)      # restore value $ra
    		
    		jr   $ra 


# Function:      Return a Sub String (_subString)
# Type:          Non-Leaf Function (calls other functions)
# argument:      $a0 = address of an input string
# argument:      $a1 = address of output buffer
# argument:      $a2 = start index for the input string (inclusive)
# argument:      $a3 = end index for the input string (exclusive)
# return value:  $v0 = address of the output buffer (same as $a1)	            
_subString:   
		addi $sp, $sp, -20    # Allocate stack frame for our function
		sw   $ra, 0($sp)      # store $ra in position 0 of stack frame
		sw   $t0, 4($sp)      # store $t0 in position 4 of stack frame
		sw   $t1, 8($sp)      # store $t1 in position 8 of stack frame
		sw   $t2, 12($sp)     # store $t2 in position 12 of stack frame
		sw   $t3, 16($sp)     # store $t3 in position 16 of stack frame
		
		# Need to check: user provide end index $a3 NOT > strLength)$a0)
		#                if it is, set it to LENGTH of string tiself
		# Check:  Neither index provided is less than 0 - then just0
		# Check:  End index > start index.... 
		# If any failure -> output put buffer - "\0"
		# need to la $t0 buffer? 
		
  operation:	 add   $t0, $zero, $a1      # Set $t0 to the value of $a1 (output buffer address)
           	 add   $t1, $a0, $a2        # Set START address to:  STRING address + user supplied start index
           	 add   $t2, $a0, $a3        # Set END address to:   STRING address + user supplied end index
           	 add   $t3, $zero, $zero    # $t3 will hold each individual byte we pull out of $t0
           	            	 
           	 
    subLoop:     beq   $t1, $t2, exitSub
    		 lbu   $t3, 0($t1)          # Store first byte of start address into $t3
    		 sb    $t3, 0($t0)          # Store the first byte of the START address INTO the 0th byte of BUFFER
    		 addi  $t1, $t1, 1          # Increment the address of $t0, so we can access the NEXT byte
    		                            # the next time our loop iterates	         
    		                                              
    		 addi  $t0, $t0, 1         # Increment the value of $t0 by 1, so we can store 
    		                           # the (0 + n) byte of $t1 INTO -> the (0+n) byte of $t0
	                           		                                  
    		 j subLoop            

		
    exitSub:    add  $v0, $zero, $a1      # store the START address of the OUTPUT BUFFER into $v0
 
    		lw   $t3, 16($sp)         # restore value of $t3
    		lw   $t2  12($sp)         # restore value fo $t2
    		lw   $t1  8($sp)          # restore value $t1
    		lw   $t0  4($sp)          # restore value $t0
    		lw   $ra, 0($sp)          # restore value $ra             
    		    	
    		jr   $ra 
    		 

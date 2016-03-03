.data	
		buffer:          .space   64
		inputString:     .asciiz  "Hello\n"
		

	enterStr:        .asciiz  "Enter a string: "
	stringHas:       .asciiz  "This string has"
	numChars:        .asciiz  "characters."
	specStart:       .asciiz  "Specify start index: "
	specEnd:         .asciiz  "Specify the end index: "
	substringIs:     .asciiz  "Your substring is: "
	newLine:         .asciiz  "\n"
	space:           .asciiz  " " 
	
		

.text 
		la $a0, inputString
		jal _strLength
		
		
		addi $v0, $zero, 10
		syscall

# Function:      Get String Length (_strLength)
# Type:          Leaf Function, always a Callee
# argument:      $a0 = address of a null terminated String
# return value:  $v0 = length of specified string 		
_strLength:
		addi $sp, $sp, -32   # Allocate stack frame for our function
		sw   $ra, 0($sp)      # store $ra in position 0 of stack frame
		sw   $t0, 4($sp)      # store $t0 in position 4 of stack frame
		sw   $t1, 8($sp)      # store $t1 in position 8 of stack frame
		
		#la   $t1, testString
		addi $v0, $zero, 0    # Initialize counter for return to 0
		addi $t0, $a0, 0      # Set $t0 to String passed into function
  lenLoop:	lbu  $t1, 0($t0)      # Loads ONLY the first BYTE (char) into $t1 register
		beq  $t1, 0, exitLen     # Exit with counter value of 0, if $t1 == 0
		                      # Means byte is null	
		addi $v0, $v0, 1      # Else increment $v0 (return address AND our counter) by 1
		addi $t0, $t0, 1      # And increment value in $t0 by 1, so we can access its n + 1 byte
		                      # In the next loop
		j lenLoop
		
   exitLen:     lw   $t1, 8($sp)      # load $t1 from position 8 of stack frame
 	        lw   $t0, 4($sp)      # load $t0 from position 4 of stack frame
 	        lw   $ra, 0($sp)      # load $ra from position 0 of stack frame
 	        addi $sp, $sp, 12     # De-allocate stack frame for our function
		
  	        jr $ra
  	        
  	        
  	        

  	          	        
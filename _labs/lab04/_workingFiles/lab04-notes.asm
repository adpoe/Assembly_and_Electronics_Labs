#######################################################
# Anthony Poerio (adp59@pitt.edu)                     #
# CS 447 - Fall 2015                                  #
# Lab04 - Function Calls                              # 
#######################################################
.data 
	buffer:          .space   64
	testString:      .asciiz  "Hello\n\0"
	prompt:          .asciiz  "Enter a string: "
	stringHas:       .asciiz  "This string has "
	numChars:        .asciiz  " characters."
	specStart:       .asciiz  "Specify start index: "
	specEnd:         .asciiz  "Specify the end index: "
	retSubstring:    .asciiz  "Your substring is: "


## Function call maintained by "jal functionName"
## - jumps to function AND stores RETURN ADDRESS (PC + 4) into $ra register
## - then, at END of function call, do "jr $ra", and it goes back to where it was before the function was called
##
## Overwriting registers when need more than provided
## - called 'spilling' registers from memory
## - I.E. - return address also stored in $ra... if call ANOTHER function, the $ra is being overwritten
## - How to deal?  'spill register from memory'
## - Callee (being called) ; Caller (calling other function)
## - When spilling, CALLER, must store its values in a stack 
## 
## Requirements (non-leaf function [calls others]) FUNCTION MAKING CALL
## - CALLER needs to save $ta register on stack
## - Save the TEMPORARY registers (from $t0 - $t7) onto a stack (BEFORE MAKING CALL(
## - AND, if calling a function that uses MORE THAN 4args, save the $a0-$a3 registers onto stack
##
## Requirements for function BEING CALLED (callee)
## - Save $s0 - $s9 registers onto stack
## - Save $v0 - $v1 onto stack
## - Then, BEFORE going back to **caller**, RESTORE (lw) everything it previously saved
##
## LAB - Three (3) functions to write
## ----------------------------------
## First:  Return length of a string
## - la $t1, inputString
## - lbu $t0, $t1(0)  #  Loads ONLY the first BYTE into the $t0 register. (can do $t1(1) for second by, etc.)
## - KNOW:  End of string when null (0) reached
## - Have a LOOP with a coutner running, and BEQ if $t0 = $zero
## - Count HOW MANY TIMES we iterate until the BEQ counter is hit
## - For index validation
## - Tells us how many iterations... find length of 
##
## Second:  Correct Mips appendage of \n to END of every String
## - Take a string as user input
## - Remove \n at END of String, and return string with a null at end.
## - So, just change string so it does not have a newline at end
## - To CORRECT string for you --- 
## 
## Third:  Substring function
## - Take two indices from USER and extract strings from user, and output them
## - 1st:  Ensure indices are valid (not negative, not zero [ end of string])
## Address of output buffer -- output buffer store substring.... it's enmpt at begining... a2 start, a3 end
## check if a2 and a3 valid..... use funciton 1 to see if 0.... check a3 not bigger than length of string, a2 not neg or 0
## start address of string is stored in $ao...... extract index from position 2 - 5....... a0 is start..... chracter array.... 
## offset is, so load byte at $a0 + 2.... that's the address to load the byte from.... then PUT that address into lbu instruction....
## say, $t3 = $a0 + 2 (ai is start index), and user wants two
## lbu, $t2, 0($t3)
## thing inside bracket can NEVER be a register, it's the offset - so need to STORE... the input somewehre else
## Then, for every subsequent interation $t3 + 1 (add $t3, $t3, 1)
## sbu to PUT into output buffer.... lb or lw = lb + offfset * unit (here * # bytes,)
## sbu $t2, $t3(0) -- puts value in 2 times number of bytes
## so, start output in 
## - If valid, lbu from start index from end index, run a loop -- sw in output buffer
## 3 checks - end index NOT greater than start ; end index greater than length of string,
## if so -- set to length of string; if either index less than or end less than start index, then String is empty
## 
##  NOTE -- STACK GROWS DOWNWARDS:
##  When ALLOCATING memory sp  (pushing on to stack)  addi $sp, $sp, -4
##     o Then SW
##  When DE-ALLOCATING memory sp  (popping off  stack)  addi $sp, $sp, +4
##     o Then LW
##  WRITE FUNCTION CODE FIRST....
##  offset is always in bytes... 4 bytes for each register....you want to store
##  numVars on stack * 4 = memory to allocate onto stack.... 
##  SP MOVEMENTS ARE ALWAYS RELATIVE......each function pushes its OWN STACK FRAME onto the stack..... 
##  At fucntion EXIT -- pop wholeeee stack frame out.... sp + allocation from beginning of... of function...
## # # CALLER does SP -4
##
##
##  BODY OF PROGRAM - get a string from user, pass it to cuntions... blah
## 




		# do I do when this function gets CALLED>....allocate... and store variables I'm going to use
		# as I work in this function.... 
		## addi    $sp, $sp, (-32)      # Increment value of the stack frame
		## sw      
		## Store values....

## Beginning of NON-LEAF FUCNTION.... allocate memory, create "activation frame", add it to stack, save old values
## END of non-leaf function - restore old values from saved memory, de-allocate memory (decrease stack point), 
# which destroys stack 







.text 
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
  
## Second:  Correct Mips appendage of \n to END of every String
## - Take a string as user input
## - Remove \n at END of String, and return string with a null at end.
## - So, just change string so it does not have a newline at end
## - To CORRECT string for you --- 


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
		
		# Need to use syscall 8.... 
		# Where to store the buffer? 
		
checkString:	jal  _strLength       # $v0 = _strLength($a0)  get length of $a0  in $v0
		addi $t0, $v0, -1     # $t0 = length of $a0 (now stored in $v0) - 1      
		add  $t0, $t0, $a0    # Add value of $a0 to $t0
		lbu  $t0, 0
		sw   $t0, buffer      # ?? 
		
    exitSub:    lw   $t1  8($sp)      # restore value $t1
    		lw   $t0  4($sp)      # restore value $t0
    		lw   $ra, 0($sp)      # restore value $ra
    		
    		jr   $ra 

    
# Function:      Return a Sub String (_subString)
# Type:          Non-Leaf Function
# argument:      $a0 = address of an input string
# argument:      $a1 = address of output buffer
# argument:      $a2 = start index for the input string (inclusive)
# argument:      $a3 = end index for the input string (exclusive)
# return value:  $v0 = address of the output buffer (same as $a1)	            
_subString   
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
		
  operation:	# Call _strLength to length of input string
                # Use _readString to get string from specific starting point to specific ending point
                # Print substring
		
    exitSub:    lw   $t3, 16($sp)     # restore value of $t3
    		lw   $t2  12($sp)     # restore value fo $t2
    		lw   $t1  8($sp)      # restore value $t1
    		lw   $t0  4($sp)      # restore value $t0
    		lw   $ra, 0($sp)      # restore value $ra
    		
    		jr   $ra 
    		
		        
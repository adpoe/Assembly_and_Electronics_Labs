#######################################################
# Anthony Poerio (adp59@pitt.edu)                     #
# CS 447 - Fall 2015                                  #
# Lab03 - Arithmetic and Logical Instructions         # 
#     -Part 2: Exponenent Calculator                  #
#######################################################

#   Registers used
#        $t0 = Accumulator
#        $t1 = Multiplicand (x)  (register for multplicand of EACH iteration)
#        $t2 = Exponent / Counter (y) - (how many times to multiply the number by itself)
#        $t3 = Multiplier  (register to keep the multiplier, which remains same throughout)
#        $t4 = Shifted multiplier (adding this every time)
#                                 (if bit 0, add nothing. If bit 1, add shifted number)
#        $t5 = Bit extraction CONSTANT (Always the number 1, used to extract LSB) 
#        $t6 = Extracted LSB  
#        $t7 = Counter - How many more times to loop
#        $t8 = Sentinel value is (y-2)         
#    32-bit Multiplication loop
#        $s1 = counter, from 0 - 31
#        $s2 = intermediate value accumulator
#

.data 
	prompt:   .asciiz "x^y calculator"
	getX:     .asciiz "Please enter x: "
	getY:     .asciiz "Please enter y: "
	uptick:   .asciiz "^"
	space:    .asciiz " "
	equals:   .asciiz "="
	newline:  .asciiz "\n"
	negative: .asciiz "Integer must be nonnegative."

.text   
	# Print prompt
	la   $a0, prompt       # Load prompt into argument register
	addi $v0, $zero, 4     # Load 4 into $v0, to print the prompt in $a0
	syscall                # Print a String
	la   $a0, newline      # Load newline into argument register
	addi $v0, $zero, 4     # Load 4 into $v0, to print the prompt in $a0
	syscall                # Print a String
get_X:	
	# Get X-Value
	la   $a0, getX         # Load prompt into argument register
	addi $v0, $zero, 4     # Load 4 into $v0, to print the prompt in $a0
	syscall                # Print a String
	                       # Read an integer from the user
        addi $v0, $zero, 5     # Add number 5 into $v0 - Read Integer
        syscall                # Get a user's input
        add $t1, $zero, $v0    # Move user input into $t1
        blt $t1, $zero, x_less_than_zero  # check if  x < 0
get_Y:        
        # Get Y-Value
        la   $a0, getY         # Load prompt into argument register
	addi $v0, $zero, 4     # Load 4 into $v0, to print the prompt in $a0
	syscall                # Print a String
	                       # Read an integer from the user
        addi $v0, $zero, 5     # Add number 5 into $v0 - Read Integer
        syscall                # Get a user's input
        add $t2, $zero, $v0    # Move user input into $t2
        	blt $t2, $zero, y_less_than_zero # check if y < 0
        
        # Set remaining variables
        addi $t0, $zero, 0       # Set accumulator to zero
                                 # This will accumulate the results of all addition and multiplication
                                 # When we're done, it will be the final value
        # add  $t1, $zero, 0       # Assert: user input = X
        # add  $t2, $zero, 0       # Assert: user input = Y
        add  $t3, $zero, $t1     # Set $t3 == $t1, this is a constant multiplier
  				 # Constant because we are doing EXPONENTIATION
  				 # A number times itself, a set amount of times
  	addi $t4, $zero, 0       # Assert $t4 = Number to add. 
  	                         # We'll shift MULTIPLIER ($t3) LEFT as many bits as the COUNTER
  	                         # If and ONLY IF LSB at current evaluation == 0
  	addi $t5, $zero, 1       # Set $t5 = 1.  This is the BIT EXTRACTION CONSTANT
  				 # After shifting $t3 as many bits RIGHT as the COUNTER ($t7), and storing in $t4
  				 # we'll extract the LSB FROM from the counter and using AND with $t4 and $t5.
  				 # Through this method, we'll compare the LSB of the shifted $t4 with the bit 1 in $t5
  				 # and store the result in $t6. $t6 will then tell us whether the LSB is 1 or 0. 
  				 # And from this, we'll know whether to add a number, or just do nothing. (Add 0)
  	addi $t6, $zero, 0       # Assert $t6 = Extracted LSB (0 or 1) for current iteration
  				 # We default setting this to zero, but we'll be changing this as our process iterates.
  	addi $t7, $zero, 0       # Assert - This is the counter, setting it zero, and we will count UP to the
  				 # Y value stored in $t2. 
  				 # Plan to keep the process running until for as long as $t7 < $t2
  	addi $t8, $t2, -2        # Sentinel value is y-2			 			 
	
	
	### Count UP! to value in $t7, starting at 0 for $t2
	### because then we can SLL by counter number and add. Should make this simpler.
	addi $s2  $zero, 0     # intermediate accumulator
	
	# Account for edge cases, before doing the loop 
edge_cases: 
	beq $t1, $zero, mutliple_of_zero
	beq $t2, $zero, to_the_zero

start:
	bgt  $t7, $t8, complete # if [counter ($t7)] == [num times to exponentiate ($t2)]
	#bgt  $t7, $t2, complete # if [counter ($t7)] == [num times to exponentiate ($t2)]
	                        # Then the calculation is complete
	                        # Else, we continue on to bit extraction for the current bit, below   
	                        
	### NEED - a Counter from 1 to 32 (loop 32times)
	# Do this 32x - from here: 
	addi $s1, $zero, 0     # Initialize counter for 32 bit multiplication iterations to 0
	
iterate:                                                                      
	### Bit extraction - Loop 32x each iteration
	# addi  $s1, $s1, 1     # Increment counter for 32 bit multiplication iterations
	srlv  $t4, $t3, $s1     # Shift right by number of iterations in $s1
				# Store this SHIFTED NUMBER in $t6 			
	and   $t6, $t5, $t4     # AND the shifted number ($t4) with 1 ($t5)	
	
	### check if $t6 == 0 (then do nothing)
	beq   $t6, $zero, increment
	### else $t6 == 1 (then shift $t3 LEFT by Counter, s1
	### Store it in $t4 and add it into the accumulator)
	sllv  $t4, $t1, $s1     # Shift $t1 BITWISE LEFT by value in $s1, store in $t4
	######## <<< add   $t0, $t0, $t4     # Add shifted value in $t4 to Accumulator >>>
	add   $s2, $s2, $t4     # Add shifted value in $t4 to Accumulator
	addi  $t4, $zero, 0     # Clear out $t4 for next iteration
	
increment:
	 addi  $s1, $s1, 1       # Increment counter for 32 bit multiplication iterations
		
	
checkCounter: 
	blt   $s1, 31, iterate    # iterate again if counter is less than 31`
	beq   $s1, 31, accumulate # continue iterations if less than 31 iterations have happened
	# bgt   $s1, 32, start    # go back to start if greater than 31
accumulate: 
	addi  $t3, $s2, 0       # Set results of LAST accumulation into multiplicand
	addi  $s2, $zero, 0     # Set intermediate accumulator to 0, for next iteration
	addi  $t7, $t7, 1	# Increment counter
	j start
		
	# Print result
complete:
	addi $t0, $t3, 0       # Move results of last iteration to $t0
	addi $v0, $zero, 1     # Move 1 in $v0, to print an integer
	add  $a0, $zero, $t1   # Move value of (X) $t0 into argument $a0
	syscall                # Print number in $a0, the result of our computation    
	la   $a0, uptick       # Load uptick into argument register
	addi $v0, $zero, 4     # Load 4 into $v0, to print the prompt in $a0
	syscall                # Print a String
	addi $v0, $zero, 1     # Move 1 in $v0, to print an integer
	add  $a0, $zero, $t2   # Move value of (Y) $t2 into argument $a0
	syscall                # Print number in $a0, the result of our computation 
	la   $a0, space        # Load space into argument register
	addi $v0, $zero, 4     # Load 4 into $v0, to print the prompt in $a0
	syscall                # Print a String	
	la   $a0, equals       # Load equals into argument register
	addi $v0, $zero, 4     # Load 4 into $v0, to print the prompt in $a0
	syscall                # Print a String	
	la   $a0, space        # Load space into argument register
	addi $v0, $zero, 4     # Load 4 into $v0, to print the prompt in $a0
	syscall                # Print a String	
	addi $v0, $zero, 1     # Move 1 in $v0, to print an integer
	add  $a0, $zero, $t0   # Move value of (Accumulator) $t0 into argument $a0
	syscall                # Print number in $a0, the result of our computation 
	
	# System Exit
	addi $v0, $zero, 10
	syscall

						
mutliple_of_zero:
	# If x = 0
	addi $t3, $zero, 0      # set result to zero  
	j complete

to_the_zero:
	# if y = 0
	addi $t3, $zero, 1      # set result to one  
	j complete			
	
x_less_than_zero:		
	# if x < 0
	la   $a0, negative     # Load negative into argument register
	addi $v0, $zero, 4     # Load 4 into $v0, to print the prompt in $a0
	syscall                # Print a String
	la   $a0, newline      # Load space into argument register
	addi $v0, $zero, 4     # Load 4 into $v0, to print the prompt in $a0
	syscall                # Print a String	
	j get_X	

y_less_than_zero:		
	# if  y < 0
	la   $a0, negative     # Load negative into argument register
	addi $v0, $zero, 4     # Load 4 into $v0, to print the prompt in $a0
	syscall                # Print a String
	la   $a0, newline      # Load space into argument register
	addi $v0, $zero, 4     # Load 4 into $v0, to print the prompt in $a0
	syscall                # Print a String	
	j get_Y			

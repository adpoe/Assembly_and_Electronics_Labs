#Author - Anthony Poerio - adp59@pitt.edu
# Univeristy of Pittsburgh: CS 447 - Spring 2015 
# Lab 01 - Assembly Program

.text
# Loop which performs the following math - $t9 = 179 + (-293) + 561
# There is a 500ms 'sleep' system call between each arithmetic operation
# The program runs in an _infinite_loop_ after its initiation 
# Must use the MARS Assembly Environment to run 
top_of_loop:    addi $t9, $zero, 0   # store value: 0 in $t9	
		addi $v0, $zero, 32  # request the sleep syscall
                addi $a0, $zero, 500 # delay amount is 500 ms
                syscall              # perform the syscall
                
                addi $t9, $t9, 179   # add 179 to value in $t9
                addi $v0, $zero, 32  # request the sleep syscall
                addi $a0, $zero, 500 # delay amount is 500 ms
                syscall              # perform the syscall
                
                addi $t9, $t9, -293  # subtract 293 from valu in $t9
                addi $v0, $zero, 32  # request the sleep syscall
                addi $a0, $zero, 500 # delay amount is 500 ms
                syscall              # perform the syscall
                
                addi $t9, $t9, 561   # add 561 to value in $t9
                addi $v0, $zero, 32  # request the sleep syscall
                addi $a0, $zero, 500 # delay amount is 500 ms
                syscall              # perform the syscall
                
                j    top_of_loop     # return to top of loop
                
                

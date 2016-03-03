# page 2 = main.... code
# still need to write two functions, which are called by pseudo code
# SrtEqual - gets 2 strings => return 1 if strings are equal. Return 0 if strings are NOT equal.
# Load byte( from ($a0 address)  = $t0
# Load byte( frrom ($a1 address) = $t0
# check if $t0 = $t1
# if equal, look at next char
# if NOT equal, just return zero
# beq $t0, $t1 --> if equal, move to next (moveNext)
# if NOT equal $v0 = 0;  jr $ra (or j end, which goes to $ra)
# moveNext:   either equal OR if non-zero char, increment addresses and moveNext
# 	Check if $t0 = 0 or not.
# 	if $t0 = 0, j end
# 	else inrement address of $a0 and $a1
# end
#      return
# lookUp  -> takes array address, and an index
# calculate EFFECTIVE memory address --> add index onto base address and LW at that position
# 1. compute address
# 2. LW from that address
# 
# Finding name - if result of strEqual is 1....
#        index = 0
#        while index < 5
#        match(strEqual(strNames(index))... but want third string and sizes of strings can be different
#        Can use strLength frunction from lab 4..... 
#        increment index BY the length of the string
#        index = 0
#        index = index + strLength(index)
#        jal strlength($t0)
#        $t0 = $t0 + $v0 
# OR - count zero terminators.... at first terminators index 1
#       or 

##
#   Part B - factorial:   follow conventions
#      pseudo-code.... given
#       - but pseudo code doesn't give conventions
#	- preserve argument AND preserve return addresss 
#	- equal factorial arg-1
#	- continue until we reach the terminating condition
#	- fact =  
# 	-   frame setup
#	-   decrement stack point
#	-   store:  arguments, and return address
#	-   decrement sp by 8
#	-   push argument onto stack
#	-   push return address onto stack
#	-   THEN:: decrement arg by 1, and call jal fac
#           pop off stack
#	-   mul $v0, $v0, $a0
#	-   make sure to call * on everything
#	-   check for terminating condition (if $a0 == 1)
#	-   terminate:  decrement $a0 by 1
#	-   THNK:   When to POP off STACK?  When to PUSH onto stack?  When to do frame cleanup, jr $ra
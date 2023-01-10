
### Please note that 0 is for numbers that are primes and 1 is non-primes. That way I don't have to set all the data of primes to 1 :)

### Data Declaration Section ###

.data

primes:		.space  1000            # reserves a block of 1000 bytes in application memory
err_msg:	.asciiz "Invalid input! Expected integer n, where 1 < n < 1001.\n"
seperator:		.asciiz ", "

### Executable Code Section ###

.text

main:
    # get input
    li      $v0,5                   # set system call code to "read integer"
    syscall                         # read integer from standard input stream to $v0

    move	$s0,$v0
	
    # validate input
    li 	    $t0,1001                # $t0 = 1001
    slt	    $t1,$v0,$t0		        # $t1 = input < 1001
    beq     $t1,$zero,invalid_input # if !(input < 1001), jump to invalid_input
    nop
    li	    $t0,1                   # $t0 = 1
    slt     $t1,$t0,$v0		        # $t1 = 1 < input
    beq     $t1,$zero,invalid_input # if !(1 < input), jump to invalid_input
    nop
    
    # initialise primes array
    la	    $t0,primes			# $s1 = address of the first element in the array
    li 	    $t2,2			# The starting value ie pointer 0 = 2 since there's no point including lesser numbers!
    li	    $s1,1			# A saved value to use for marking the primes in the primes "list"
    
findRoot:				# A function for finding the nearest root to a number rounded up
	add	$t3,$t3,1
	mul	$t9,$t3,$t3
	slt	$t9,$s0,$t9
	beqz	$t9,findRoot		# Loops if $t3 squared is to small else continues to loop
	nop
    
    ### Continue implementation of Sieve of Eratosthenes ###
loop:
	# $t0 is the pointer
	# $t2 is the counter
	move	$a0,$t2			# Set argument to counter
	lb	$t8, ($t0)		# Load Byte at pointer $t0 to var $t8
	beq	$t8,0,setFalse 		# Check if value ($t8) in prims == 0
	nop
	addi	$t0,$t0,1		# Increment
	addi	$t2,$t2,1		# ...
	sub	$t7,$t2,$t3		# If counter ($t2) >= the root of the entered number then terminate
	slt	$t7,$t7,$zero 		# ...
	beqz	$t7,printNice		# Prints the values if all needed values are set to prime/not-prime
	nop
	j loop
	

setFalse:
	la	$t4,primes		# $t4 is pointer to primes
	add	$a1,$t2,-2		# $a1 setting up $a1 to be base value (doesn't use the square optimization)
	add	$a1,$a1,$a0		# ...
	add	$t4,$t4,$a1		# Moving pointer some steps forward (shouldn't set the first value, since that's the prime)
	add	$a1,$a0,$a0		# $a1 is our starting values to mark
	move	$t5,$a1			# $t5 is our counter
	slt 	$t7,$t5,$s0		# Checking if setFalse needs to continue
	beqz	$t7,endSetFalse
	nop
	fLoop:			# Loop to set non-primes to 1
		sb 	$s1,($t4)	# Setting value at pointer to non-prime ie 1
		add	$t4,$t4,$a0	# Moving forward in primes
		add	$t5,$t5,$a0 	# Moving forward in counter
		slt 	$t7,$s0,$t5  	# Checking if all non-primes are set
		beqz	$t7,fLoop	# Else looping the fLoop (falseLoop)
		nop
	endSetFalse:		# Ending the setFalse when all non-primes are marked
	addi	$t0,$t0,1		# Incrementing main pointer
	addi	$t2,$t2,1		# Incrementing main counter
	j loop				# Looping to do the same things to all primes
		

    ### Print nicely to output stream ###
printNice:
	la	$t0, primes		# Setting up a new pointer to primes
	li	$t1, 2			# Keeping track of value of first position in primes
	forEachPrime:			# Checking if value is prime ie not marked in primes ie has value 0
		lb	$t3, ($t0)		# Loading byte at pointer
		beqz	$t3,print		# Prints if the value is a prime
		nop
		add	$t0,$t0,1		# Else increments pointer and counter
		add	$t1,$t1,1		# ...
		ble	$t1, $s0, forEachPrime	# Looping if not all values are checked
		nop    
		j exit_program			# Exits if all values are checked ie printed
    	print:				# Prints the current value of counter if it is a prime number
    		move	$a0,$t1			# Print value
    		li	$v0, 1			# ...
		syscall				# ...
		
		li	$v0, 4			# Adds a seperator between primes
		la	$a0, seperator		# ...
		syscall				# ...
		
		add	$t0,$t0,1		# Increments pointer and counter
		add	$t1,$t1,1		# ...
		ble	$t1, $s0, forEachPrime	# Loops if end reached
		nop
    
    
    # exit program
    j       exit_program
    nop

invalid_input:
    # print error message
    li      $v0, 4                  # set system call code "print string"
    la      $a0, err_msg            # load address of string err_msg into the system call argument registry
    syscall                         # print the message to standard output stream

exit_program:
    # exit program
    li $v0, 10                      # set system call code to "terminate program"
    syscall                         # exit program

# int multiply(int a, int b) {
#     int i, sum = 0;
#     for (i = 0; i < a; i++)
#         sum += b;
#     return sum;
# }

# int faculty(int n) {
#     int i, fac = 1;
#     for (i = n; i > 1; i--)
#         fac = multiply(fac, i);
#     return fac;
# }

main:
	li $v0, 5			# set system call 5 to "read integer"
    	syscall			# read integer from stio to $v0
    	move $a1, $v0

	#li $v0, 5		
	#syscall			
	#move $a0, $v0 
	#jal multiply
    
	jal faculity
    
	move $a0, $v0			# move func return to argument
	li $v0, 1				# set system call to 1 to "print integer"
	syscall				# print integer
    
	li $v0, 10			# set system call 10 to "terminate program"
	syscall				# terminate program
    
    
multiply: # $a0 * $a1 = $v0. Code example doesn't seem to care for negatives so neither do I :DD
	# $t0 is sum
	li $t0, 0
	ble $a0, 0, multReturn
	nop
	beqz $a1, multReturn
	nop
	multLoop:
		add $t0, $t0, $a1
		sub $a0, $a0, 1
		bnez $a0, multLoop # call loop if $a1 not eq to zero
		nop	
	
	multReturn:
		move $v0, $t0
		jr $ra
	
faculity: # $a1 ! = $v0
	move $s0, $ra
	ble $a1, 1, setOne
	nop
	move $t2, $a1
	
	facLoop:
		sub $t2, $t2, 1
		move $a0, $t2
		jal multiply
		beqz $v0, facReturn # return if multiple = 0
		nop
		move $a1, $v0
		j facLoop
	
	setOne:
		add $a1, $zero, 1
	
	facReturn:
		move $v0, $a1
		jr $s0










	

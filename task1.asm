.data

str:
	.asciiz "the answer = "

.text

main:
	jal my_func
	addi $t0, $v0, 0 # Store return val in $t0

	# Print str to console
	li $v0, 4
	la $a0, str
	syscall

	# Print $t0 to console
	li $v0, 1
	addi $a0, $t0, 0
	syscall
	
	# Terminate prog
	li $v0, 10
	syscall

# Must be below main
my_func:
    # Read user input
    li $v0, 5   # 5 is system call code for read_int
    syscall     # $v0 now has int from console input

    jr $ra      # Return control back to the caller
# messages.asm

.data

str:
	.asciiz "the answer = "

file_name:
	.asciiz "task1.asm"

.text

main:
	# Open file
    li $v0, 13
    la $a0, file_name
    li $a1, 1
    li $a2, 0
    syscall

	# Store file descriptor in $t1
	addi $t1, $a0, 0

	jal my_func

	# Store return val in $t0
	addi $t0, $v0, 0

	# Print str to console
	li $v0, 4
	la $a0, str
	syscall

	# Print $t0 to console
	li $v0, 1
	addi $a0, $t0, 0
	syscall

	# Close file
	li $v0, 16
	addi $a0, $t1, 0
	syscall
	
	# Terminate prog
	li $v0, 10
	syscall
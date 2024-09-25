.data 

arrayA:
	.word 11, 0, 31, 22, 9, 17, 6, 9

count:
	.word 999 # 999 is a dummy val

countStrArr:
	.asciiz "One"
	.asciiz "Two"
	.asciiz "Three"
	.asciiz "Four"
	.asciiz "Five"
	.asciiz "Six"
	.asciiz "Seven"
	.asciiz "Eight"

substr0:
	.asciiz " multiples of "
substr1:
	.asciiz " ("
substr2:
	.asciiz ", "
substr3:
	.asciiz " and "
substr4:
	.asciiz ")."

noMultiplesSubstr0:
	.asciiz "Zero multiples of "
noMultiplesSubstr1:
	.asciiz "."

.text

main:
	# code to setup the variable mappings
	la $t0, arrayA				# $t0 --> arrayA
	la $t8, count				# $t8 --> count
	add $t8, $0, $0				# Set count to 0 (count not 0 at the start by qn restrictions)

	# code for reading in the user value X
    li $v0, 5					# read_int
	syscall						# $v0 now has int from console input
	addi $t1, $v0, 0			# $t1 --> X (return val, assumed to be pow of 2)

	# code for counting multiples of X in arrayA (using a loop)
	addi $t3, $0, -1			# $t3 --> -ve val to replace non-multiples of X (since arrayA cannot contain -ve vals on init)
	addi $t4, $t0, 28			# $t4 --> arrayA + (arrayA length - 1) * 4 (Final address for traversal by ptr)
	add $t5, $t0, $0			# $t5 --> copy of arrayA for Loop0
	addi $s0, $t1, -1			# $s0 --> bitmask to get remainder of division by pow of 2

LoopStart0:
	beq $t5, $t4, LoopEnd0

	lw $t6, 0($t5)				# $t6 --> current element of arrayA copy

	and $t6, $t6, $s0			# Bitmasking to get remainder of division by pow of 2

	beq $t6, $0, IncrementCount	# No need to set -ve val if $t6 is multiple of X

	sw $t3, 0($t5)				# Replace element that is not a multiple of X with $t3

	j LoopUpdate0				# For Else of IncrementCount to work

IncrementCount:
	addi $t8, $t8, 1

LoopUpdate0:
	addi $t5, $t5, 4			# For traversal by ptr

	j LoopStart0

LoopEnd0:
	# code for printing result
	li $v0, 4					# For print_string service

	beq $t8, $0, NoMultiples	# Accts for 0

	la $t2, countStrArr			# $t2 --> countStrArr

	addi $t7, $t8, 0			# $t7 --> offset for countStrArr (init as $t7 = $t8)

	addi $t7, $t7, -1			# Since 1st element in countStrArr is "One"

	sll $t7, $t7, 2				# Multiply $t7 by 4 to get offset for countStrArr

	add $t2, $t2, $t7			# Offset countStrArr for correct countStr to be printed

	## Printing of 1 or more multiples
	addi $a0, $t2, 0
	syscall						# "One" - "Eight"

	la $a0, substr0
	syscall						# " multiples of "

	li $v0, 1					# For print_int service
	addi $a0, $t1, 0
	syscall						# "<val of X>"

	li $v0, 4					# For print_string service
	la $a0, substr1
	syscall						# " ("

	### Printing of 1 or more substr2 and substr3
	add $t5, $t0, $0			# $t5 --> copy of arrayA for Loop0 (reinit)
	addi $t9, $0, 0				# $t9 --> print count

LoopStart1:
	beq $t5, $t4, LoopEnd1

	lw $t6, 0($t5)				# $t6 --> current element of arrayA copy

	beq $t6, $t3, LoopUpdate1	# Do not print if -ve val

	li $v0, 1					# For print_int service
	addi $a0, $t6, 0
	syscall						# "<val at $t5>"

	li $v0, 4					# For print_string service

	addi $t9, $t9, 1			# For updating print count (must be here instead of under LoopUpdate1)

	beq $t9, $t8, LoopUpdate1	# Check print count against count here to remove extra comma at the end

	la $a0, substr2
	syscall						# ", "

LoopUpdate1:
	addi $t5, $t5, 4			# For traversal by ptr

	j LoopStart1

LoopEnd1:
	la $a0, substr4
	syscall						# ")."

	j TerminateProg				# For Else of NoMultiples to work

NoMultiples:
	la $a0, noMultiplesSubstr0
	syscall						# "Zero multiples of "

	li $v0, 1					# For print_int service
	addi $a0, $t1, 0
	syscall						# "<val of X>"

	li $v0, 4					# For print_string service
	la $a0, noMultiplesSubstr1
	syscall						# "."

TerminateProg:
	li $v0, 10
	syscall
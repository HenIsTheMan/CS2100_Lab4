.data 

arrayA:
	.word 1, 0, 2, 0, 3, 5, 7, 9

count:
	.word 999 # 999 is a dummy val

countStr0:
	.asciiz "One"
countStr1:
	.asciiz "Two"
countStr2:
	.asciiz "Three"
countStr3:
	.asciiz "Four"
countStr4:
	.asciiz "Five"
countStr5:
	.asciiz "Six"
countStr6:
	.asciiz "Seven"
countStr7:
	.asciiz "Eight"

countStrArr:
	.word,
	countStr0,
	countStr1,
	countStr2,
	countStr3,
	countStr4,
	countStr5,
	countStr6,
	countStr7

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

zeroMultiplesSubstr0:
	.asciiz "Zero multiples of "
zeroMultiplesSubstr1:
	.asciiz "."

.text

# $t0 --> arrayA
# $t1 --> X (assumed to be pow of 2)
# $t2 --> countStrArr
# $t3 --> loop var 0
# $t4 --> arrayA + (arrayA length - 1) * 4 (For traversal by ptr)
# $t5 --> copy of arrayA for Loop0
# $t6 --> current element of copy of arrayA in Loop0
# $t7 --> loop var 1
# $t8 --> count
# $t9 --> bitmask to get remainder of division by pow of 2

main:
	# code to setup the variable mappings
	la $t0, arrayA		# $t0 --> arrayA
	la $t8, count		# $t8 --> count

	# code for reading in the user value X
    li $v0, 5			# 5 is system call code for read_int
	syscall				# $v0 now has int from console input
	addi $t1, $v0, 0	# Store return val in $t1

	# code for counting multiples of X in arrayA (using a loop)
	add $t8, $0, $0		# Set count to 0 (count not 0 at the start by qn restrictions)
	addi $t4, $t0, 28	# Since arrayA length is fixed at 8
	add $t5, $t0, $0	# $t5 --> copy of arrayA for Loop0
	addi $t9, $t1, -1	# $t9 --> bitmask to get remainder of division by pow of 2

LoopStart0:
	beq $t3, $t4, LoopEnd0

	lw $t6, 0($t5)

	## Bitmasking to get remainder of division by pow of 2
	and $t6, $t6, $t9

	addi $t3, $t3, 4 # For traversal by ptr

LoopEnd0:
	# code for printing result
	li $v0, 4 # For print_string service

	beq $t8, $0, ZeroMultiples # Acct for 0

	la $t2, countStrArr # $t2 --> countStrArr

	## Loop to get correct address and correct countStr
	addi $t7, $0, 1 # Start with 1 since 0 was accted for

LoopStart1:
	beq $t7, $t8, LoopEnd1

	addi $t2, $t2, 4

	addi $t7, $t7, 1

	j LoopStart1

LoopEnd1:
	## Logic for printing non-0 multiples
	addi $a0, $t2, 0
	syscall

	la $a0, substr0
	syscall

	li $v0, 1 # For print_int service
	addi $a0, $t1, 0
	syscall

	li $v0, 4 # For print_string service
	la $a0, substr1
	syscall

	### TODO: use substr2 and substr3 here, must switch between services too

	la $a0, substr4
	syscall

	j TerminateProg

ZeroMultiples:
	la $a0, zeroMultiplesSubstr0
	syscall

	li $v0, 1 # For print_int service
	addi $a0, $t1, 0
	syscall

	li $v0, 4 # For print_string service
	la $a0, zeroMultiplesSubstr1
	syscall

TerminateProg:
	li $v0, 10
	syscall
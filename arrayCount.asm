.data 

arrayA:
	.word 1, 0, 2, 0, 3, 5, 7, 9

count:
	.word 999 # 999 is a dummy val

.text

main:
	# code to setup the variable mappings
	la $t0, arrayA
	la $t8, count


	add $zero, $zero, $zero  #dummy instructions, can be removed
	add $zero, $zero, $zero  #dummy instructions, can be removed
	add $zero, $zero, $zero  #dummy instructions, can be removed

	# code for reading in the user value X

	# code for counting multiples of X in arrayA

	# code for printing result

	# code for terminating program
	li  $v0, 10
	syscall
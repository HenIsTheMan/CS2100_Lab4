# task1.asm

.data

.text

# Callee
my_func:
    # Read user input
    li $v0, 5   # 5 is system call code for read_int
    syscall     # $v0 now has int from console input

    jr $ra      # Return control back to the caller
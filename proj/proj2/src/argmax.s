.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue
    li t0, 1
    bge a1, t0, prepare
    li a0, 36
    j exit

prepare:
    addi sp, sp, -12
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    li t0, 0 # counter = 0
    lw s0, 0(a0) # max = num[0]
    li s1, 0 # max_index = 0

loop_start:
    bge t0, a1, loop_end
    slli t1, t0, 2
    add t2, a0, t1 # t2 -> address of current number
    lw t3, 0(t2) # t3 -> current number
    bgt t3, s0, loop_continue # current number > max
    addi t0, t0, 1
    j loop_start

loop_continue:
    addi s0, t3, 0
    addi s1, t0, 0
    addi t0, t0, 1
    j loop_start

loop_end:
    # Epilogue
    addi a0, s1, 0
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    addi sp, sp, 12
    jr ra

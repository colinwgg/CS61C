.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
# void relu(int *a0, int a1) {
#   for (int i = 0, i < a1, i++) {
#       #if (a0[i] < 0) {
#           a0[i] = 0;
#           }
#       }
# }
relu:
    # Prologue
    li t0, 1
    bge a1, t0, prepare
    li a0, 36
    j exit

prepare:
    addi sp, sp, -8
    sw ra, 0(sp)
    sw s0, 4(sp)
    li t0, 0 # i = 0

loop_start:
    bge t0, a1, loop_end
    slli s0, t0, 2
    add t1, s0, a0
    lw t2, 0(t1)
    blt t2, x0, loop_continue
    addi t0, t0, 1
    j loop_start

loop_continue:
    sw x0, 0(t1)
    addi t0, t0, 1
    j loop_start

loop_end:
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    addi sp, sp, 8
    jr ra

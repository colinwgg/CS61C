.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:
    # Error checks
    li t0, 1
    blt a1, t0, error
    blt a2, t0, error
    blt a4, t0, error
    blt a5, t0, error
    bne a2, a4, error
    li t0, 0 # t0 -> outer_counter
    # Prologue
    addi sp, sp, -12
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)

outer_loop_start:
    bge t0, a1, outer_loop_end
    li t1, 0 # t1 -> inner_counter

inner_loop_start:
    bge t1, a5, inner_loop_end
    addi sp, sp, -36
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)
    sw a5, 20(sp)
    sw a6, 24(sp)
    sw t0, 28(sp)
    sw t1, 32(sp)

    mul t5, t0, a2
    slli t5, t5, 2
    add a0, a0, t5 # start of array A
    slli t5, t1, 2
    add a1, a3, t5 # start of array B
    addi a3, x0, 1
    addi a4, a5, 0
    
    jal dot
    addi s0, a0, 0

    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw a4, 16(sp)
    lw a5, 20(sp)
    lw a6, 24(sp)
    lw t0, 28(sp)
    lw t1, 32(sp)
    addi sp, sp, 36

    # count the target entry in d
    mul t2, t0, a5
    add t2, t2, t1
    slli t3, t2, 2
    add s1, a6, t3
    sw s0, 0(s1)

    addi t1, t1, 1
    j inner_loop_start
inner_loop_end:
    addi t0, t0, 1
    j outer_loop_start

outer_loop_end:
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    addi sp, sp, 12
    jr ra

error:
    li a0, 38
    j exit
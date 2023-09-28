.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:
    # Prologue
    addi sp, sp, -16
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)

    # fopen
    addi sp, sp, -12
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    li a1, 0
    jal fopen # test j fopen later
    li t0, -1
    beq a0, t0, fopen_error
    mv s0, a0 # s0 -> file descriptor
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    addi sp, sp, 12

    # read r
    addi sp, sp, -12
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    mv a0, s0
    li a2, 4
    jal fread
    li t0, 4
    bne a0, t0, fread_error
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    addi sp, sp, 12

    # read c
    addi sp, sp, -12
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    mv a0, s0
    mv a1, a2
    li a2, 4
    jal fread
    li t0, 4
    bne a0, t0, fread_error
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    addi sp, sp, 12

    # Allocate space on the heap to store the matrix
    lw t0, 0(a1)
    lw t1, 0(a2)
    mul s1, t0, t1 # s1 -> length of matrix
    addi sp, sp, -12
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    slli a0, s1, 2
    jal malloc
    li t0, 0
    beq a0, t0, malloc_error
    mv s2, a0 # s2 -> pointer to the matrix
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    addi sp, sp, 12

    # read matrix
    addi sp, sp, -12
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    mv a0, s0
    mv a1, s2
    slli a2, s1, 2
    jal fread
    slli t0, s1, 2
    bne a0, t0, fread_error
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    addi sp, sp, 12

    # close file
    addi sp, sp, -4
    sw a0, 0(sp)
    mv a0, s0
    jal fclose
    li t0, -1
    beq a0, t0, fclose_error
    lw a0, 0(sp)
    addi sp, sp, 4

    mv a0, s2

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    addi sp, sp, 16

    jr ra

fopen_error:
    li a0, 27
    j exit

malloc_error:
    li a0, 26
    j exit

fread_error:
    li a0, 29
    j exit

fclose_error:
    li a0, 28
    j exit
.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:
    # Prologue
    addi sp, sp, -16
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)

    # open file
    addi sp, sp, -16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    li a1, 1
    jal fopen
    li t0, -1
    beq a0, t0, fopen_error
    mv s0, a0 # s0 -> file descriptor
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    addi sp, sp, 16

    # malloc for r and c
    addi sp, sp, -16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    li a0, 8
    jal malloc
    mv s1, a0 # s1 -> pointer to r and c in memory
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    addi sp, sp, 16

    # write r and c into *s1
    sw a2, 0(s1)
    sw a3, 4(s1)

    # write r and c into file
    addi sp, sp, -16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    mv a0, s0
    mv a1, s1
    li a2, 2
    li a3, 4
    jal fwrite
    li t0, 2
    bne a0, t0, fwrite_error
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    addi sp, sp, 16

    # write matrix into file
    addi sp, sp, -16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    mv a0, s0
    lw t0, 0(s1) # t0 -> r
    lw t1, 4(s1) # t1 -> c
    mul s2, t0, t1 # number of elements
    mv a2, s2
    li a3, 4
    jal fwrite
    bne a0, s2, fwrite_error
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    addi sp, sp, 16

    # close file
    addi sp, sp, -4
    sw a0, 0(sp)
    mv a0, s0
    jal fclose
    li t0, -1
    beq a0, t0, fclose_error
    lw a0, 0(sp)
    addi sp, sp, 4

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

fclose_error:
    li a0, 28
    j exit

fwrite_error:
    li a0, 30
    j exit
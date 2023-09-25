.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    # Prologue
    li t0, 1
    blt a2, t0, end36
    blt a3, t0, end37
    blt a4, t0, end37
    addi sp, sp, -16
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    li t0, 0 # t0 -> counter = 0
    li s0, 0 # s0 -> return_value = 0
    j loop_start

loop_start:
    bge t0, a2, loop_end
    slli t1, t0, 2 # t1 = 4*index 
    mul t2, t1, a3 # t2 = 4*index*stride1
    mul t3, t1, a4 # t3 = 4*index*stride2
    add t4, a0, t2 # t4 -> address A
    add t5, a1, t3 # t5 -> address B
    lw s1, 0(t4)
    lw s2, 0(t5)
    mul t6, s1, s2
    add s0 ,s0, t6
    addi t0, t0, 1
    j loop_start

loop_end:
    # Epilogue
    addi a0, s0, 0
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    addi sp, sp, 16
    jr ra

end36:
    li a0, 36
    j exit
end37:
    li a0, 37
    j exit
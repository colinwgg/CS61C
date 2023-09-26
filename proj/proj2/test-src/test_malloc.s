.import ../src/utils.s
.import ../src/../coverage-src/initialize_zero.s

.data

.globl main_test
.text
# main_test function for testing
main_test:

    # load 2147483647 into a0
    li a0 2147483647

    # call initialize_zero function
    jal ra initialize_zero
    # we expect initialize_zero to exit early with code 26

    # exit normally
    li a0 0
    jal exit

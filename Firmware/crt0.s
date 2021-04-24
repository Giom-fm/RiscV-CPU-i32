.text
.align	2
.globl	_start
.type	_start, @function
.org    0
    
_start:
        # Create stack address  0xFFFF
	addi    a1,zero,0xFF
        slli    a1,a1,8
        ori     a1,a1,0xFF
        # Set the stack address
	addi	sp, a1, -4
        # Call the main function
        jal     ra, main
_end:
        j       _end

#RAM
########################
    .section .data
msg:
    .asciz "  Hello world! \n"


# ROM:
########################
    .section .text
    .globl _start

_start:
    li x2, 0x00000050   # pointer to store addr

infite_loop:
    la x1, msg          # Pointer to msg addr
    addi x2, x2, 0x00000010 # store addr + offset

string_printing_loop:
    lw x3, 0(x1)
    sw x3, 0(x2)
    
    beq x3, zero, infite_loop

    addi x1, x1, 1
    addi x2, x2, 1

    j string_printing_loop
    

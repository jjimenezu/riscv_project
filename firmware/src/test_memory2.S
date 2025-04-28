   .section .text
    .globl _start

_start:
    # values 
    li x1, 0x12345678
    add x2, x0, x0
    # store
loop:
    sw x1, 0x0(x2)
    addi x2, x2, 4
    j loop
    
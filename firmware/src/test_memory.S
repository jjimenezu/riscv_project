    .section .text
    .globl _start

_start:
    # values 
    li x1, 0x12345678
    li x2, 0x10
    # store
    sw x1, 0x10(x2)
    sh x1, 0x14(x2)
    sb x1, 0x18(x2)

    nop
    nop
    nop
    nop

    # load
    lw x5, 0x10(x2)
    lh x6, 0x14(x2)
    lb x7, 0x18(x2)

    nop
    nop
    nop
    nop
    j .

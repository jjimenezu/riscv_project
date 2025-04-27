    .section .text
    .globl _start

_start:

    #
    addi x1, x0, 0x7FF
    addi x2, x0, -256   #0xF00

    #
    add  x3, x1, x2
    and  x4, x1, x2
    or   x5, x3, x4

    #
    add  x1, x0, x0
    addi x2, x0, 32
    lui  x3, 0xFFFFF
    addi x3, x3, 0x7FF
loop:
    addi x1, x1, 0x001
    slli x3, x3, 1
    blt  x1, x2, loop

    #
    add  x1, x0, x0
    add  x2, x0, x0
    add  x3, x0, x0
    add  x4, x0, x0
    add  x5, x0, x0


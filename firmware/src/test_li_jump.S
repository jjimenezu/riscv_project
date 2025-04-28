    .section .text
    .globl _start

_start:
    # full retgisters
    li x1, 0x1
    li x2, 0x2
    li x3, 0x3
    li x4, 0x7FF
    li x5, 0x800
    li x6, 0xFFFFFFFF
    li x7, 0xF0000000
    li x8, 0x0FFFFFFF
    li x9, 0x0F000000
    li x10, 0xA
    li x11, 0xB
    li x12, 0xFF235660
    li x13, 0x13
    li x14, 0x14
    li x15, 0x15
    li x16, 0x16
    li x17, 0x35234
    li x18, 0x1000000005
    li x19, 0x19
    li x20, 0x20
    li x21, 0x34
    li x22, 0x22
    li x23, 0x23
    li x24, 0x24
    li x25, 0x25
    li x26, 0x26
    li x27, 0x27
    li x28, 0x28
    li x29, 0x29
    li x30, 0x30
    auipc x25, 0x000FFF55

    jal x31, jal_target
jal_target2:
    add  x3, x1, x2
    and  x4, x1, x2
    or   x5, x3, x4
    add  x3, x1, x2
    and  x4, x1, x2
    or   x5, x3, x4

    #
    add  x1, x0, x0
    addi x2, x0, 32
    lui  x3, 0xFFFFF
    addi x3, x3, 0x7FF
    #
    li x1, 0xF4
    jalr x30, 0x8(x1)


jal_target:
    jal x29, jal_target2


    j .

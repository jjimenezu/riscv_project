    .section .text
    .globl _start

_start:
    nop


    # BEQ test
    li x1, 0
    li x2, 32
loop_beq:
    addi x1, x1, 1
    beq  x1, x2, end_loop_beq
    j loop_beq
end_loop_beq:



    # BNE test
    li x1, 32
    li x2, 32
    li x3, 32
    li x4, 32
loop_bne:
    bne  x1 ,x2, end_loop_bne
    bne  x1 ,x3, end_loop_bne
    bne  x1 ,x3, end_loop_bne
    bne  x2 ,x1, end_loop_bne
    bne  x2 ,x3, end_loop_bne
    bne  x2 ,x4, end_loop_bne
    bne  x2 ,x3, end_loop_bne
    bne  x4 ,x3, end_loop_bne
    bne  x2 ,x2, end_loop_bne
    addi x1, x0, 31
    j loop_bne
end_loop_bne:



    # BLT test
    li x1, 64
    li x2, 32
    li x3, 1
    li x4, 0
loop_blt:
    sub x1, x1, x3
    blt x1, x2, end_loop_blt
    j loop_blt
end_loop_blt:

    li x1, 1
    li x2, 2
    li x3, 3
    li x4, 4
    j .
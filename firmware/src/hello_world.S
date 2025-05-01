# .section .data
# mensaje:    .asciz "Hello World!"     # String a copiar en memoria
# longitud:   .word 12                # Longitud sin el null ('\0')

.section .text
.globl _start

_start:

    # Address
    li x1, 0x00000010

    # Pointer
    add x2, x1, x0

    # Store Char ' '
    li x3, 0x20
    sb x3, 0(x2)
    addi x2, x2, 1

    # Store Char ' '
    li x3, 0x20
    sb x3, 0(x2)
    addi x2, x2, 1

    # Store Char 'H'
    li x3, 0x48
    sb x3, 0(x2)
    addi x2, x2, 1

    # Store Char 'e'
    li x3, 0x65
    sb x3, 0(x2)
    addi x2, x2, 1

    # Store Char 'l'
    li x3, 0x6C
    sb x3, 0(x2)
    addi x2, x2, 1

    # Store Char 'l'
    li x3, 0x6C
    sb x3, 0(x2)
    addi x2, x2, 1

    # Store Char 'o'
    li x3, 0x6F
    sb x3, 0(x2)
    addi x2, x2, 1

    # Store Char ' '
    li x3, 0x20
    sb x3, 0(x2)
    addi x2, x2, 1

    # Store Char 'w'
    li x3, 0x77
    sb x3, 0(x2)
    addi x2, x2, 1

    # Store Char 'o'
    li x3, 0x6F
    sb x3, 0(x2)
    addi x2, x2, 1

    # Store Char 'r'
    li x3, 0x72
    sb x3, 0(x2)
    addi x2, x2, 1

    # Store Char 'l'
    li x3, 0x6C
    sb x3, 0(x2)
    addi x2, x2, 1

    # Store Char 'd'
    li x3, 0x64
    sb x3, 0(x2)
    addi x2, x2, 1

    # Store Char '!'
    li x3, 0x21
    sb x3, 0(x2)
    addi x2, x2, 1

    # Store Char ' '
    li x3, 0x20
    sb x3, 0(x2)
    addi x2, x2, 1

    # Store Char ' '
    li x3, 0x20
    sb x3, 0(x2)
    addi x2, x2, 1


end:
    j .
    

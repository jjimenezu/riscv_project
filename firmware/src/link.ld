ENTRY(_start)

MEMORY
{
  ROM (rx) : ORIGIN = 0x00000000, LENGTH = 1024
  RAM (rw) : ORIGIN = 0x00010000, LENGTH = 1024
}

SECTIONS
{
  /* Instructions */
  .text : {
    *(.text*)
    *(.rodata*)
  } > ROM

  /* Data */
  .data : {
    *(.data*)
  } > RAM

}

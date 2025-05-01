############ Input Parameters ############
# Memory size in Bytes
ROM_SIZE ?= 1024
RAM_SIZE ?= 1024

# firmware source code name. Without ".c" or ".S" extension
SRC ?= hello_world
##########################################

#
RTL = $(wildcard rtl/*.v)
RTL_OUT = sim/results/core.o
#
CORE_TB = sim/core_tb.v
CORE_TB_WF = sim/core_tb.gtkw
ROM_IN = sim/rom.mem
RAM_IN = sim/ram.mem
RAM_OUT = sim/results/ram
REGS_OUT = sim/results/regs_file
#
FIRMWARE = firmware/$(SRC)
FIRMWARE_SRC = firmware/src/$(SRC)

compile_rtl:
	@iverilog -o $(RTL_OUT) $(RTL)

simulate:
	@iverilog -o $(RTL_OUT) $(CORE_TB) $(RTL)
	@vvp $(RTL_OUT)
	@xxd -r -p $(RAM_OUT).mem $(RAM_OUT).bin

show_wf:
	@gtkwave $(CORE_TB_WF)

show_ram:
	@xxd -g 1 $(RAM_OUT).bin

show_regs:
	cat $(REGS_OUT).mem

compile_asm:
	@riscv64-unknown-elf-as -march=rv32i -o $(FIRMWARE).o $(FIRMWARE_SRC).S
	@riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -nostdlib -Ttext=0x0 -T firmware/src/link.ld -o $(FIRMWARE).elf $(FIRMWARE).o
	@riscv64-unknown-elf-objcopy -O binary -j .text $(FIRMWARE).elf $(FIRMWARE)_text.bin
	@riscv64-unknown-elf-objcopy -O binary -j .data $(FIRMWARE).elf $(FIRMWARE)_data.bin
	
	@riscv64-unknown-elf-objdump -D -m riscv:rv32 -M numeric $(FIRMWARE).elf > $(FIRMWARE)_disassembly.txt

	@xxd -p -c 1 $(FIRMWARE)_text.bin > $(ROM_IN)
	@xxd -p -c 1 $(FIRMWARE)_data.bin > $(RAM_IN)
	
	@lines=$$(wc -l < $(ROM_IN)); \
	missing=$$(($(ROM_SIZE) - $$lines)); \
	for i in $$(seq 1 $$missing); do echo 00; done >> $(ROM_IN)

	@lines=$$(wc -l < $(RAM_IN)); \
	missing=$$(($(RAM_SIZE) - $$lines)); \
	for j in $$(seq 1 $$missing); do echo 00; done >> $(RAM_IN)
	
clean:
	@rm -rf sim/results/* firmware/*.* sim/out*mem sim/*.mem



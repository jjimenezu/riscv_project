############ Input Parameters ############

# ROM/intruction_memory size in Bytes
ROM_SIZE ?= 1024

# firmware source code name. Without extension ".c" or ".S"
SRC ?= test0

##########################################

#
RTL = $(wildcard rtl/*.v)
RTL_OUT = sim/out/core.out
#
CORE_TB = sim/core_tb.v
CORE_TB_WF = sim/waveforms/core_tb.gtkw
ROM = sim/rom.mem
#
FIRMWARE = firmware/$(SRC)
FIRMWARE_SRC = firmware/src/$(SRC)

compile_rtl:
	@iverilog -o $(RTL_OUT) $(RTL)

simulate:
	@iverilog -o $(RTL_OUT) $(CORE_TB) $(RTL)
	@vvp $(RTL_OUT)

show:
	@gtkwave $(CORE_TB_WF)

compile_asm:
	@riscv64-unknown-elf-as -march=rv32i -o $(FIRMWARE).o $(FIRMWARE_SRC).S
	@riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -nostdlib -Ttext=0x0 -o $(FIRMWARE).elf $(FIRMWARE).o
	@riscv64-unknown-elf-objcopy -O binary $(FIRMWARE).elf $(FIRMWARE).bin
	@riscv64-unknown-elf-objdump -D -m riscv:rv32 -M numeric $(FIRMWARE).elf > $(FIRMWARE)_disassembly.txt

	@xxd -p -c 1 $(FIRMWARE).bin > $(FIRMWARE).mem
	
	@#{ for i in $$(seq 1 4); do echo "00"; done; cat $(FIRMWARE).mem; } > $(FIRMWARE).mem.tmp && mv $(FIRMWARE).mem.tmp $(FIRMWARE).mem
	
	@lines=$$(wc -l < $(FIRMWARE).mem); \
	missing=$$(($(ROM_SIZE) - $$lines)); \
	for i in $$(seq 1 $$missing); do echo 00; done >> $(FIRMWARE).mem
	
	@cp $(FIRMWARE).mem $(ROM)

clean:
	@rm -rf sim/out/* sim/waveforms/vcd/* firmware/*.*



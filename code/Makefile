test0:
	# compile to objetc
	riscv64-unknown-elf-as -march=rv32i -o test0.o test0.S

	# obtain elf
	riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -nostdlib -Ttext=0x0 -o test0.elf test0.o

	# obtain bin
	riscv64-unknown-elf-objcopy -O binary test0.elf test0.bin

	# obtain readable dissasembly code
	riscv64-unknown-elf-objdump -D -m riscv:rv32 -M numeric test0.elf > test0_disassembly.txt

	# obtain .mem to simulate in verilog
	xxd -p -c 1 test0.bin > test0.mem


clean:
	rm -rf *.o *.elf *.bin *.hex *.mem

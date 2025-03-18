RTL_FILES = $(wildcard rtl/*.v)
CORE_TB = sim/core_tb.v
#
# OUT_DIR = sim/out
# WAVEFORMS_DIR = sim/waveforms


core:
	iverilog -o sim/out/core.out $(CORE_TB) $(RTL_FILES)
	vvp sim/out/core.out

core_wf:
	gtkwave sim/waveforms/core_tb.gtkw

clean:
	rm -rf sim/out/* sim/waveforms/vcd/*

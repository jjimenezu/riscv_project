// `include "../rtl/core.v"
// `include "../rtl/control_unit.v"
// `include "../rtl/alu.v"
// `include "../rtl/regs_file.v"
// `include "../rtl/memory.v"

`define  ROM_SIZE  1024
`define  RAM_SIZE  1024

module core_tb();

parameter integer ADDR_BITS = 10;
parameter N = 32;  // Regs width
parameter M = 32;   // # Regs

//DUT interfae
reg clk,rst;

reg [7:0] in_rom [0:2**ADDR_BITS-1];
reg [7:0] out_data_mem [0:2**ADDR_BITS-1];
reg [N-1:0] out_registers [0:M-1];


reg [31:0] i;
integer regs_file;
integer ram_file;

initial while(1) #10 clk = !clk;



core core(
    .clk(clk),
    .rst(rst)
);

initial begin

    clk = 0;
    rst = 0;
    #50;
    rst = 1;
    #22;
    rst = 0;

    // Load instruction memory
    $readmemh("sim/rom.mem", in_rom);
    for(i = 0; i<`ROM_SIZE; i = i+1) begin
        core.rom.mem[i] =  in_rom[i];
    end

    // Execution
    #50000;

    // Save Regs File state
    regs_file = $fopen("sim/out_regs_file.mem", "w");
    for (i = 0; i < 32; i = i+1) begin
        $fwrite(regs_file, "x%d = %h\n", i[4:0], core.regs_file.registers[i]);
    end
    $fclose(regs_file);

    // Save RAM state
    ram_file = $fopen("sim/out_ram.mem", "w");
    $fwrite(ram_file, "\t\t\t+0\t+1\t+2\t+3",);
    for (i = 0; i < `RAM_SIZE; i = i+4) begin
        $fwrite(ram_file, "\n%h\t", {i[31:2],2'b00});
        $fwrite(ram_file, "%h\t",  core.ram.mem[i+2'b00]);
        $fwrite(ram_file, "%h\t",  core.ram.mem[i+2'b01]);
        $fwrite(ram_file, "%h\t",  core.ram.mem[i+2'b10]);
        $fwrite(ram_file, "%h",  core.ram.mem[i+2'b11]);
    end
    $fclose(ram_file);

    $finish();

end

// Generate waveform
initial begin
    $dumpfile("sim/waveforms/vcd/core_tb.vcd");
    $dumpvars(0, core_tb);
end



endmodule



/*
                // Register File
                core.regs_file.registers[0],
                core.regs_file.registers[1],
                core.regs_file.registers[2],
                core.regs_file.registers[3],
                core.regs_file.registers[4],
                core.regs_file.registers[5],
                core.regs_file.registers[6],
                core.regs_file.registers[7],
                core.regs_file.registers[8],
                core.regs_file.registers[9],
                core.regs_file.registers[10],
                core.regs_file.registers[11],
                core.regs_file.registers[12],
                core.regs_file.registers[13],
                core.regs_file.registers[14],
                core.regs_file.registers[15],
                core.regs_file.registers[16],
                core.regs_file.registers[17],
                core.regs_file.registers[18],
                core.regs_file.registers[19],
                core.regs_file.registers[20],
                core.regs_file.registers[21],
                core.regs_file.registers[22],
                core.regs_file.registers[23],
                core.regs_file.registers[24],
                core.regs_file.registers[25],
                core.regs_file.registers[26],
                core.regs_file.registers[27],
                core.regs_file.registers[28],
                core.regs_file.registers[29],
                core.regs_file.registers[30],
                core.regs_file.registers[31],
                
                // Instruction Memory
                core.instr_mem.mem[0],
                core.instr_mem.mem[1],
                core.instr_mem.mem[2],
                core.instr_mem.mem[3],
                core.instr_mem.mem[4],
                core.instr_mem.mem[5],
                core.instr_mem.mem[6],
                core.instr_mem.mem[7],
                core.instr_mem.mem[8],
                core.instr_mem.mem[9],
                core.instr_mem.mem[10],
                core.instr_mem.mem[11],
                core.instr_mem.mem[12],
                core.instr_mem.mem[13],
                core.instr_mem.mem[14],
                core.instr_mem.mem[15],
                core.instr_mem.mem[16],
                core.instr_mem.mem[17],
                core.instr_mem.mem[18],
                core.instr_mem.mem[19],
                core.instr_mem.mem[20],
                core.instr_mem.mem[21],
                core.instr_mem.mem[22],
                core.instr_mem.mem[23],
                core.instr_mem.mem[24],
                core.instr_mem.mem[25],
                core.instr_mem.mem[26],
                core.instr_mem.mem[27],
                core.instr_mem.mem[28],
                core.instr_mem.mem[29],
                core.instr_mem.mem[30],
                core.instr_mem.mem[31],

                // Instruction Memory
                core.data_mem.mem[0],
                core.data_mem.mem[1],
                core.data_mem.mem[2],
                core.data_mem.mem[3],
                core.data_mem.mem[4],
                core.data_mem.mem[5],
                core.data_mem.mem[6],
                core.data_mem.mem[7],
                core.data_mem.mem[8],
                core.data_mem.mem[9],
                core.data_mem.mem[10],
                core.data_mem.mem[11],
                core.data_mem.mem[12],
                core.data_mem.mem[13],
                core.data_mem.mem[14],
                core.data_mem.mem[16],
                core.data_mem.mem[17],
                core.data_mem.mem[18],
                core.data_mem.mem[19],
                core.data_mem.mem[20],
                core.data_mem.mem[21],
                core.data_mem.mem[22],
                core.data_mem.mem[23],
                core.data_mem.mem[24],
                core.data_mem.mem[25],
                core.data_mem.mem[26],
                core.data_mem.mem[27],
                core.data_mem.mem[28],
                core.data_mem.mem[29],
                core.data_mem.mem[30],
                core.data_mem.mem[31]
                );
                */


// generate
//     genvar i;
//     for (i = 0; i < 32; i = i + 1) begin
//         initial  $dumpvars(0, core.regs_file.registers[i]);
//     end
// endgenerate
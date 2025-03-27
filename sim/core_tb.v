// `include "../rtl/core.v"
// `include "../rtl/control_unit.v"
// `include "../rtl/alu.v"
// `include "../rtl/regs_file.v"
// `include "../rtl/memory.v"


module core_tb();

//DUT interfae
reg clk,rst;

reg [31:0] mem [31:0];


reg [31:0] i;

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
    #10;
    rst = 0;

    // Load instruction memory
    $readmemh("sim/firmware.hex", mem);
    for(i = 0; i<10; i = i+1) begin
        core.instr_mem.mem[i*4 + 0] =  mem[i][7:0];
        core.instr_mem.mem[i*4 + 1] =  mem[i][15:8];
        core.instr_mem.mem[i*4 + 2] =  mem[i][23:16];
        core.instr_mem.mem[i*4 + 3] =  mem[i][31:24];
    end

    #1000;

    $finish();

end

// Generate waveform
initial begin
    $dumpfile("sim/waveforms/vcd/core_tb.vcd");
    // $dumpfile("waveforms/vcd/core_tb.vcd");
    $dumpvars(0, core_tb,
                
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
end

// generate
//     genvar i;
//     for (i = 0; i < 32; i = i + 1) begin
//         initial  $dumpvars(0, core.regs_file.registers[i]);
//     end
// endgenerate

endmodule


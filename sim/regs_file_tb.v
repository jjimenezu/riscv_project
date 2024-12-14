// `include "../rtl/regs_file.v"

`timescale 1ns / 1ps

module regs_file_tb#(
    parameter T = 7  // # Test patterns
);

// DUT interface
reg         rst, w_enb;
reg  [4:0]  rs1, rs2, rd;
reg  [31:0] w_data;
wire [31:0] r_data1, r_data2;

// Clock
reg clk = 0;
initial while (1) #5 clk = !clk;

// DUT instance
regs_file regs_file_dut (
    .clk(clk),
    .rst(rst),
    .w_enb(w_enb),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .w_data(w_data),
    .r_data1(r_data1),
    .r_data2(r_data2)
);

// Arrays for testing
reg [4:0]  array_rs1    [0:T-1];
reg [4:0]  array_rs2    [0:T-1];
reg [4:0]  array_rd     [0:T-1];
reg [31:0] array_w_enb  [0:T-1];
reg [31:0] array_w_data [0:T-1];

reg [3:0] i;    // test array iterator
initial begin

    // Generate waveform
    $dumpfile("sim/waveforms/regs_file_tb.vcd");
    $dumpvars(0, regs_file_tb, 
                regs_file_dut.registers[0],
                regs_file_dut.registers[1],
                regs_file_dut.registers[2],
                regs_file_dut.registers[3],
                regs_file_dut.registers[4],
                regs_file_dut.registers[5],
                regs_file_dut.registers[6],
                regs_file_dut.registers[7],
                regs_file_dut.registers[8],
                regs_file_dut.registers[9],
                regs_file_dut.registers[10],
                regs_file_dut.registers[11],
                regs_file_dut.registers[12],
                regs_file_dut.registers[13],
                regs_file_dut.registers[14],
                regs_file_dut.registers[16],
                regs_file_dut.registers[17],
                regs_file_dut.registers[18],
                regs_file_dut.registers[19],
                regs_file_dut.registers[20],
                regs_file_dut.registers[21],
                regs_file_dut.registers[22],
                regs_file_dut.registers[23],
                regs_file_dut.registers[24],
                regs_file_dut.registers[25],
                regs_file_dut.registers[26],
                regs_file_dut.registers[27],
                regs_file_dut.registers[28],
                regs_file_dut.registers[29],
                regs_file_dut.registers[30],
                regs_file_dut.registers[31]
                );

    // Test patterns
    array_rs1[0] = 5'd00; array_rs2[0] = 5'd00; array_rd[0] = 5'd08; array_w_enb[0] = 1'b1; array_w_data[0] = 32'hE14C_00A5;
    array_rs1[1] = 5'd08; array_rs2[1] = 5'd16; array_rd[1] = 5'd16; array_w_enb[1] = 1'b1; array_w_data[1] = 32'h014C_45A5;
    array_rs1[2] = 5'd12; array_rs2[2] = 5'd27; array_rd[2] = 5'd08; array_w_enb[2] = 1'b1; array_w_data[2] = 32'hE34C_35C7;
    array_rs1[3] = 5'd00; array_rs2[3] = 5'd00; array_rd[3] = 5'd00; array_w_enb[3] = 1'b1; array_w_data[3] = 32'hAAAA_AAAA;
    array_rs1[4] = 5'd16; array_rs2[4] = 5'd08; array_rd[4] = 5'd00; array_w_enb[4] = 1'b0; array_w_data[4] = 32'hAAAA_AAAA;
    array_rs1[5] = 5'd01; array_rs2[5] = 5'd31; array_rd[5] = 5'd03; array_w_enb[5] = 1'b0; array_w_data[5] = 32'hAAAA_AAAA;
    array_rs1[6] = 5'd27; array_rs2[6] = 5'd12; array_rd[6] = 5'd04; array_w_enb[6] = 1'b0; array_w_data[6] = 32'hAAAA_AAAA;


    ////**** Stimulus driving ****////
    // power up reset
    rst    = 0;
    rs1    = 0;
    rs2    = 0;
    rd     = 0;
    w_enb  = 0;
    w_data = 0;
    #10
    rst = 1;
    #10
    rst = 0;
    #10
    // array loop
    for (i = 0; i <= 6; i = i + 1) begin
        rs1    = array_rs1[i];
        rs2    = array_rs2[i];
        rd     = array_rd[i];
        w_enb  = array_w_enb[i];
        w_data = array_w_data[i]; 
        #10;
    end
    // reset
    rst = 1;
    #10
    rst = 0;
    #10
    // array loop again
    for (i = 0; i <= 6; i = i + 1) begin
        rs1    = array_rs1[i];
        rs2    = array_rs2[i];
        rd     = array_rd[i];
        w_enb  = array_w_enb[i];
        w_data = array_w_data[i]; 
        #10;
    end

    #10;
    $finish;

end

endmodule
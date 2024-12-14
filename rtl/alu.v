// ALU implementation for RV32I ISA
// Copyright ejjimenezu
// Dec,2024


// ALU opcodes
`define ADD  4'b0_000
`define SUB  4'b1_000
`define SLL  4'b0_001
`define SLT  4'b0_010
`define SLTU 4'b0_011
`define XOR  4'b0_100
`define SRL  4'b0_101
`define SRA  4'b1_101
`define OR   4'b0_110
`define AND  4'b0_111

`define ZERO 32'h0000_0000


module alu (
    `ifdef USE_POWER_PINS
        inout vccd1,
        inout vssd1,
    `endif
    input  wire [3:0]  alu_op,
    input  wire [31:0] in1, in2,
    output reg  [31:0] out,
    output reg         zero, overflow
    );


always @(*) begin

    overflow = 1'b0;
    zero     = (out==`ZERO) ? 1'b1 : 1'b0;

    case(alu_op)

        `ADD : {overflow,out} = in1 + in2;

        `SUB : {overflow,out} = in1 - in2;

        `SLL : out = in1 << in2[4:0];

        `SLT : out = ($signed(in1) < $signed(in2))     ? 32'h0000_0001 : `ZERO;

        `SLTU: out = ($unsigned(in1) < $unsigned(in2)) ? 32'h0000_0001 : `ZERO;

        `XOR : out =  in1 ^ in2;

        `SRL : out = in1 >> in2[4:0];

        `SRA : out = $signed(in1) >>> in2[4:0];

        `OR  : out =  in1 | in2;

        `AND : out =  in1 & in2;

        default: out = `ZERO;

    endcase

end

endmodule

// `include "../rtl/alu.v"

`define ADD  3'b000     // SUB if (funct7==1)
`define SRL  3'b101     // SRA if (funct7==1)

module alu_tb;

// DUT interface
reg [31:0] in1, in2;
reg [2:0]  funct3;
reg        funct7;
wire[31:0] out;
wire       zero;


// DUT instance
alu alu_dut (
    .in1(in1),
    .in2(in2),
    .funct3(funct3),
    .funct7(funct7),
    .out(out),
    .zero(zero)
);

// Arrays for testing
reg [31:0] array_in1 [0:10];
reg [31:0] array_in2 [0:10];

reg [3:0] i;    // func3 iterator
reg [7:0] j;    // Test pattern iterator

initial begin

    // Generate waveform
    $dumpfile("sim/waveforms/alu_tb.vcd");
    $dumpvars(0, alu_tb);

    // Test patterns
    array_in1[0] = 32'h0000_0AC3; array_in2[0] = 32'h0000_011F;
    array_in1[1] = 32'hC000_0027; array_in2[1] = 32'h0000_00F6;
    array_in1[2] = 32'h0000_00AD; array_in2[2] = 32'hE000_00A5;
    array_in1[3] = 32'hC000_0037; array_in2[3] = 32'hF000_00FF;
    array_in1[4] = 32'h0000_011F; array_in2[4] = 32'h0000_0AC3;
    array_in1[5] = 32'hA100_0015; array_in2[5] = 32'h0000_0002;
    array_in1[6] = 32'hA100_0015; array_in2[6] = 32'h0000_000A;

    ////**** Stimulus driving ****////
    funct7 = 1'b0;

    // funct3 loop
    for (i = 0; i < 8; i = i + 1) begin
        funct3 = i;
        // test pattern loop
        for (j = 0; j <= 6; j = j + 1) begin
            if( funct3==`ADD || funct3==`SRL) begin
                in1 = array_in1[j];
                in2 = array_in2[j];
                #10;
                funct7 = 1'b1;
                #10;
                funct7 = 1'b0;
            end else begin
                in1 = array_in1[j];
                in2 = array_in2[j];
                #10;
            end
        end

    end

end

endmodule









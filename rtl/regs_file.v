// Registers File implementation
// Copyright ejjimenezu
// Dec,2024

module regs_file#(
    parameter N = 32,  // Regs width
    parameter M = 32   // # Regs
)(
    input wire clk, rst, w_enb,
    input wire [4:0]  rs1, rs2, rd,
    input wire [31:0] w_data,
    output reg [31:0] r_data1, r_data2
);


// Regs file
reg [N-1:0] registers [0:M-1];
integer i;

// Writing
always @(posedge clk /*or posedge rst*/) begin
    if (rst) begin
        for (i = 1; i < M; i = i + 1) begin
            registers[i] <= 32'h0000_0000;  
        end
    end else if (w_enb && rd != 5'b00000) begin
        registers[rd] <= w_data;  
    end
end

// Reading
always @(*) begin
    // registers[0] = 32'h0000_0000;
    r_data1 = (rs1 == 5'd0) ? 32'h00000000 : registers[rs1];
    r_data2 = (rs2 == 5'd0) ? 32'h00000000 : registers[rs2];
end

endmodule
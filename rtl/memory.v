module memory #(
	parameter integer ADDR_BITS = 10
) (
`ifdef USE_POWER_PINS	
	inout vccd1,	// User area 1 1.8V supply
	inout vssd1,	// User area 1 digital ground
`endif	
	input wire clk, 
	input wire rst,
	input wire [3:0] w_enb,
	input wire       r_enb,
	input wire [31:0] addr, w_data,
	output reg [31:0] r_data
);

// Memory array
reg [7:0] mem [0:2**ADDR_BITS-1];

// Writing
always @(posedge clk) begin
	if (w_enb[0]) mem[addr + 2'b00] <= w_data[7 : 0];
	if (w_enb[1]) mem[addr + 2'b01] <= w_data[15: 8];
	if (w_enb[2]) mem[addr + 2'b10] <= w_data[23:16];
	if (w_enb[3]) mem[addr + 2'b11] <= w_data[31:24];
	
end

// Reading
always @(*) begin
	r_data = r_enb ? {mem[addr+2'b11] , mem[addr+2'b10] , mem[addr+2'b01] , mem[addr]} :
					 32'h0000_0000; 
end

endmodule
module memory #(
	parameter integer ADDR_BITS = 10
) (
`ifdef USE_POWER_PINS	
	inout vccd1,	// User area 1 1.8V supply
	inout vssd1,	// User area 1 digital ground
`endif	
	input wire clk, rst, w_enb, r_enb,
	input wire [31:0] addr, w_data,
	output reg [31:0] r_data
);

// Memory array
reg [7:0] mem [0:2**ADDR_BITS-1];
integer i;

// Address procesing
// wire
// always @(*) begin
// end

// Writing
always @(posedge clk /*or posedge rst*/) begin
    if (rst) begin
        for (i = 0; i < 2**ADDR_BITS; i = i + 1) begin
            mem[i] <= 8'h00;  
        end
    end else if (w_enb) begin
        mem[addr[ADDR_BITS-1:4] + 2'b00] <= w_data[7 : 0];
		mem[addr[ADDR_BITS-1:4] + 2'b01] <= w_data[15: 8];
		mem[addr[ADDR_BITS-1:4] + 2'b10] <= w_data[23:16];
		mem[addr[ADDR_BITS-1:4] + 2'b11] <= w_data[31:24];
    end
end

// Reading
always @(*) begin
	if (r_enb) begin
        // r_data[7 : 0] = mem[addr[ADDR_BITS-1:4] + 2'b00];
		// r_data[15: 8] = mem[addr[ADDR_BITS-1:4] + 2'b01];
		// r_data[23:16] = mem[addr[ADDR_BITS-1:4] + 2'b10];
		// r_data[31:24] = mem[addr[ADDR_BITS-1:4] + 2'b11];
		r_data[7 : 0] = mem[addr + 0];
		r_data[15: 8] = mem[addr + 1];
		r_data[23:16] = mem[addr + 2];
		r_data[31:24] = mem[addr + 3];
	end else begin
		r_data = 32'h0000_0000;
	end
end

endmodule
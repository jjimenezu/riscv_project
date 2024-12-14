//  OPCODES
`define R_OP     7'b01100_11     // reg-reg operations
`define I_OP     7'b00100_11     // reg-imm operations
`define L_OP     7'b00000_11     // load     
`define S_OP     7'b01000_11     // store
`define B_OP     7'b11000_11     // branch
`define J_OP     7'b11011_11     // jump
`define JR_OP    7'b11001_11     // jump to register
`define LUI_OP   7'b01101_11     // LUI: load upper immtermediate
`define AUIPC_OP 7'b00101_11     // AUIPC: add upper immediate to pc


module core #(
	parameter integer ADDR_BITS = 10
)(
    input wire clk, rst
);

// Internal conections
wire [31:0] instruction;
wire [31:0] imm_ext;
reg  [11:0] imm;
wire [31:0] reg_r1;
wire [31:0] reg_r2;
wire [31:0] alu_out;
wire [31:0] mem_out;
wire [3 :0] ctr_alu_op;
wire ctr_alu_in2_mux;
wire ctr_writeback_mux;
wire ctr_reg_w_enb;
wire ctr_mem_w_enb;
wire ctr_mem_r_enb;
wire ctr_branch_mux;
wire unknown_op;
wire alu_zero;
wire alu_overflow;            

// Program Counter: pointer to current instruction memory address
reg [31:0] PC, next_PC;


// 
memory instr_mem (
    .clk(clk), 
    .rst(rst),  // explore about special rst for instructions
    .w_enb(),   // fixed to 0 in normal use, to 1 when bootloading
    .r_enb(),   // fixed to 1 ¿always?
	.addr(PC),    // from PC or bootloader
    .w_data(32'h0000_0000),  // from bootloader: fixed to 0 in normal use
	.r_data(instruction)   // to instruction bus  
);

memory data_mem (
    .clk(clk), 
    .rst(rst), 
    .w_enb(ctr_mem_w_enb),   // from Control Unit
    .r_enb(ctr_mem_r_enb),   // from Control Unit
	.addr(alu_out),    // from ALU
    .w_data(reg_r2),  // from regs_file r_data2 
	.r_data(mem_out)   // to   writeback MUX
);

regs_file regs_file(
    .clk(clk),
    .w_enb(ctr_reg_w_enb),        // from Control Unit
    .rs1(instruction[19:15]),     // from instruction bus
    .rs2(instruction[24:20]),     // from instruction bus
    .rd (instruction[11: 7]),     // from instruction bus
    .w_data(ctr_writeback_mux ?  mem_out : alu_out ),  // from writeback MUX
    .r_data1(reg_r1), // to ALU in1
    .r_data2(reg_r2)  // to ALU in2 MUX and data_mem w_data 
);

alu alu(
    .alu_op(ctr_alu_op),
    .in1(reg_r1),     // from ALU r_data1
    .in2(ctr_alu_in2_mux ? imm_ext : reg_r2 ),     // from ALU in2 MUX
    .out(alu_out),           // to data_mem address and writeback MUX
    .zero(alu_zero),         // to PC_source MUX control
    .overflow(alu_overflow)  // overflow is ignored in the ISA but I want monitor it
);

control_unit control_unit(
    .opcode(instruction[6:0]),
    .funct3(instruction[14:12]),  
    .funct7(instruction[30]),
    .alu_op(ctr_alu_op),
    .alu_src(ctr_alu_in2_mux),
    .mem2reg(ctr_writeback_mux), 
    .reg_write(ctr_reg_w_enb), 
    .mem_read(ctr_mem_r_enb),
    .mem_write(ctr_mem_w_enb),
    .branch(ctr_branch_mux),
    .unknown_op(unknown_op)
);


always @(posedge clk or posedge rst) begin
    if(rst) begin
        PC <= 0;
    end else begin
        PC <= next_PC;
    end
end


always @(*) begin

    // PC logic
    next_PC = (ctr_branch_mux & alu_zero) ? (PC+(imm_ext<<1)) : (PC+4);

    // Immediates decode
    case (instruction[6:0])
        `I_OP: imm = instruction[31:20];
        `L_OP: imm = instruction[31:20];
        `S_OP: imm = {instruction[31:25],instruction[11:7]};
        `B_OP: imm = {instruction[31],instruction[7],instruction[30:25],instruction[11:8]};
        // `AUIPC_OP:
        // `LUI_OP
        // `J_OP:
        // `JR_OP
        default: imm = {12{1'b0}};
    endcase
    
end


// Immediate value sign extend
assign imm_ext = (imm[11]) ? {{20{1'b1}},imm} : {{20{1'b0}},imm};

////**** FETCH ****////


endmodule
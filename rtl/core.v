//  OPCODES
`define R_OP     7'b01100_11     // R-type: reg-reg operations
`define I_OP     7'b00100_11     // I-type: reg-imm operations
`define L_OP     7'b00000_11     // I-type: load
`define JR_OP    7'b11001_11     // I-type: jump and link register
`define S_OP     7'b01000_11     // S-type: store
`define B_OP     7'b11000_11     // B-type: branch
`define LUI_OP   7'b01101_11     // U-type: LUI: load upper immtermediate
`define AUIPC_OP 7'b00101_11     // U-type: AUIPC: add upper immediate to PC
`define J_OP     7'b11011_11     // J-type: jump and link


module core #(
	parameter integer ADDR_BITS = 10
)(
    input wire clk, rst
);

// Internal conections
wire [31:0] instruction;
// wire [31:0] imm_ext;
reg [31:0] imm; // reg  [11:0] imm;
wire [31:0] reg_r_data1;
wire [31:0] reg_r_data2;
wire [31:0] alu_out;
wire [31:0] mem_out;
wire [3 :0] ctr_alu_op;
wire ctr_alu_in2_mux;
wire ctr_alu_in1_mux;
wire ctr_branch_select_no_zero;
wire [2:0] ctr_writeback_mux; //000: ALU    001: Mem    010: Imm     100: PC+4 
wire ctr_reg_w_enb;
wire [3:0] ctr_mem_w_enb;
wire [3:0] ctr_mem_r_enb;
wire ctr_branch_mux;
wire [1:0] ctr_jump;
wire unknown_op;
wire alu_zero;
wire alu_no_zero;
wire alu_overflow;            

// Program Counter: pointer to current instruction memory address
reg [31:0] PC; 
wire [31:0] PC_plus4;
wire [31:0] next_PC;
wire branch_alu_zero;

//
wire [6:0] opcode = instruction[6:0];

// 
memory instr_mem (
    .clk(clk), 
    .rst(rst),              // explore about special rst for instructions
    .w_enb(4'b0000),               // fixed to 0 in normal use, to 1 when bootloading
    .r_enb(4'b1111),           // fixed 1
	.addr(PC),              // from PC or bootloader
    // .w_data(32'h0000_0000),      // from bootloader: fixed to 0 in normal use
	.r_data(instruction)    // to instruction bus  
);

memory data_mem (
    .clk(clk), 
    .rst(rst), 
    .w_enb(ctr_mem_w_enb),  // from Control Unit
    .r_enb(ctr_mem_r_enb),  // from Control Unit
	.addr(alu_out),         // from ALU
    .w_data(reg_r_data2),        // from regs_file r_data2 
	.r_data(mem_out)        // to   writeback MUX
);

regs_file regs_file(
    .clk(clk),
    .rst(rst),
    .w_enb(ctr_reg_w_enb),      // from Control Unit
    .rs1(instruction[19:15]),   // from instruction bus
    .rs2(instruction[24:20]),   // from instruction bus
    .rd (instruction[11: 7]),   // from instruction bus
    .w_data(ctr_writeback_mux[2] ? PC_plus4 : ctr_writeback_mux[1] ?  imm : ctr_writeback_mux[0] ? mem_out : alu_out ),  // from writeback MUX
    .r_data1(reg_r_data1),           // to ALU in1
    .r_data2(reg_r_data2)            // to ALU in2 MUX and data_mem w_data 
);

alu alu(
    .alu_op(ctr_alu_op),
    .in1(ctr_alu_in1_mux ? PC  : reg_r_data1),               // from ALU r_data1
    .in2(ctr_alu_in2_mux ? imm : reg_r_data2 ),     // from ALU in2 MUX
    .out(alu_out),              // to data_mem address and writeback MUX
    .zero(alu_zero),            // to PC_source MUX control
    .no_zero(alu_no_zero), //  to PC_source MUX control
    .overflow(alu_overflow)     // overflow is ignored in the ISA but I want monitor it
);

control_unit control_unit(
    .opcode(opcode),
    .funct3(instruction[14:12]),  
    .funct7(instruction[30]),
    .alu_op(ctr_alu_op),
    .alu_src2(ctr_alu_in2_mux),
    .alu_src1(ctr_alu_in1_mux),
    .branch_select_no_zero(ctr_branch_select_no_zero),
    .writeback_mux(ctr_writeback_mux), 
    .reg_write(ctr_reg_w_enb), 
    .mem_read(ctr_mem_r_enb),
    .mem_write(ctr_mem_w_enb),
    .branch(ctr_branch_mux),
    .jump(ctr_jump),
    .unknown_op(unknown_op)
);


// PC sequential logic //
always @(posedge clk /*or posedge rst*/) begin
    if(rst) begin
        PC <= 0;
    end else begin
        PC <= next_PC;
    end
end


// Immediates decode //
always @(*) begin
    case (opcode)
        `I_OP: imm = {{20{instruction[31]}},instruction[31:20]};
        `L_OP: imm = {{20{instruction[31]}},instruction[31:20]};
        `S_OP: imm = {{20{instruction[31]}},instruction[31:25],instruction[11:7]};
        `B_OP: imm = {{19{instruction[31]}},instruction[31],instruction[7],instruction[30:25],instruction[11:8], 1'b0};
        `AUIPC_OP: imm = {instruction[31:12],{12{1'b0}}};
        `LUI_OP:   imm = {instruction[31:12],{12{1'b0}}};
        `J_OP:     imm = {{11{instruction[31]}},instruction[31],instruction[19:12],instruction[20],instruction[30:21], 1'b0};
        `JR_OP:    imm = {{20{instruction[31]}},instruction[31:20]};
        default: imm = {32{1'b0}};
    endcase 
end


//


// Next PC logic    
assign branch_alu_zero = ctr_branch_select_no_zero ? alu_no_zero : alu_zero;                                        
assign next_PC = ctr_jump[1] ? alu_out : ((ctr_branch_mux&branch_alu_zero)|ctr_jump[0]) ? PC+imm : PC_plus4 ;
assign PC_plus4 = PC+4;


// Immediate value sign extend
// assign imm_ext = (imm[11]) ? {{20{1'b1}},imm} : {{20{1'b0}},imm};




endmodule


// diferenciar imm de load, store e inmediates

// Para branch:
//      Manejar op de alu segun el funt3 de la instruccion (Alu control en diarama de paterson enesy)
//      Manejar mux (And en diarama patersonvenesy)
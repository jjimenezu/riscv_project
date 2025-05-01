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
    input wire clk, 
    input wire rst
);

////____ Program Counter Register ____////
reg [ADDR_BITS-1:0] PC;

////____ Internal Connections Wires ____////
wire [31:0] instruction;
wire [31:0] imm;
wire [31:0] regs_r_data1;
wire [31:0] regs_r_data2;
wire [31:0] alu_out;
wire [31:0] mem_out;
wire [31:0] mem_out_maskered;
wire [31:0] PC_plus_4;
wire [31:0] PC_plus_imm;
// Mux Outputs
wire [31:0] regs_w_data;
wire [31:0] alu_in1;
wire [31:0] alu_in2;
wire        branch_zero;
wire [31:0] PC_skip;
wire [31:0] next_PC;
// Datapath Control Unit Signals
wire [3:0] ctrl_alu_op;
wire       ctrl_alu_in1;
wire       ctrl_alu_in2;
wire [1:0] ctrl_regs_w_data;
wire       ctrl_regs_w_enb;
wire       ctrl_regs_r_enb;
wire [2:0] ctrl_imm_op;
wire [3:0] ctrl_mem_r_enb;
wire [3:0] ctrl_mem_w_enb;
wire       ctrl_branch;
wire       ctrl_branch_zero;
wire       ctrl_jump;
// Debug Signals
wire        alu_overflow;
wire        alu_invalid_op;
wire        invalid_op;
// TO DO: add debug signals for misaligned addresses

////____ Internal Modules Connection ____////

memory rom (
    //inputs
    .clk(clk), 
    .rst(rst),             
    .w_enb(4'h0),            
    .r_enb(1'b1),            
	.addr(PC),              
    .w_data(32'h0000_0000),    
	.r_data(instruction)
);

memory ram (
    //inputs
    .clk(clk), 
    .rst(rst), 
    .w_enb(ctrl_mem_w_enb),  
    .r_enb(ctrl_mem_r_enb[0]), 
	.addr(alu_out[ADDR_BITS-1:0]),        
    .w_data(regs_r_data2), 
    //outputs
	.r_data(mem_out)
);
// TO DO: memory bootloader system 

regs_file regs_file(
    //inputs
    .clk(clk),
    .rst(rst),
    .w_enb(ctrl_regs_w_enb),     
    .r_enb(ctrl_regs_r_enb),      
    .rs1(instruction[19:15]),  
    .rs2(instruction[24:20]), 
    .rd (instruction[11: 7]),  
    .w_data(regs_w_data),  //from mux
    //outputs
    .r_data1(regs_r_data1),
    .r_data2(regs_r_data2)
);

alu alu(
    //inputs
    .alu_op(ctrl_alu_op),
    .in1(alu_in1),             // from mux
    .in2(alu_in2),             // from mux
    //outputs
    .out(alu_out),             
    .zero(alu_zero),       
    .invalid_op(alu_invalid_op),     
    .overflow(alu_overflow)     // overflow is ignored in the ISA
);

control_unit control_unit(
    //inputs
    .opcode(instruction[6:0]),
    .funct3(instruction[14:12]),  
    .funct7(instruction[30]),    // only important bit
    //outputs
    .alu_op(ctrl_alu_op),
    .alu_in1(ctrl_alu_in1),
    .alu_in2(ctrl_alu_in2),
    .regs_w_data(ctrl_regs_w_data),
    .regs_w_enb(ctrl_regs_w_enb), 
    .regs_r_enb(ctrl_regs_r_enb),
    .imm_op(ctrl_imm_op),
    .mem_w_enb(ctrl_mem_w_enb),
    .mem_r_enb(ctrl_mem_r_enb),
    .branch(ctrl_branch),
    .branch_zero(ctrl_branch_zero),
    .jump(ctrl_jump),
    .invalid_op(invalid_op)
);

imm_gen imm_gen(
    // inputs
    .instr(instruction[31:7]),
    .imm_op(ctrl_imm_op),
    // output
    .imm(imm)
);


////____ PC Logic (Sequential) ____////
always @(posedge clk) begin
    if(rst) begin
        PC <= 0;
    end else begin
        PC <= next_PC[ADDR_BITS-1:0];
    end
end

////____ Internal Connections Assignment (Combinational) ____////
assign PC_plus_4 = PC + 32'h0000_0004;

assign PC_plus_imm = PC + imm;

// Muxes Output Logic
assign regs_w_data = (ctrl_regs_w_data==2'b00) ? alu_out :
                     (ctrl_regs_w_data==2'b01) ? mem_out_maskered:
                     (ctrl_regs_w_data==2'b10) ? PC_plus_4:
                                                 imm; 

assign alu_in1 = ctrl_alu_in1 ?         PC :
                                regs_r_data1;


assign alu_in2 = ctrl_alu_in2 ?         imm :
                                regs_r_data2;

assign PC_skip =  ctrl_jump ? alu_out :
                              PC_plus_imm;

assign branch_zero = ctrl_branch_zero ? ~alu_zero :
                                        alu_zero;

assign next_PC = ((branch_zero&&ctrl_branch)||ctrl_jump) ? PC_skip :
                                                           PC_plus_4;

// Memory read logic
assign mem_out_maskered = mem_out & {{8{ctrl_mem_r_enb[3]}} , {8{ctrl_mem_r_enb[2]}} , {8{ctrl_mem_r_enb[1]}}, {8{ctrl_mem_r_enb[0]}}};

endmodule

// TODO: ajustar tamaño de buses de manera independiente para cantidad de bits en las direcciones de ram y rom
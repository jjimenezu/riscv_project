
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

// ALU opcodes {funct7_important_bit , funct3}
`define ADD  4'b0_000
`define SLT  4'b0_010
`define SLTU 4'b0_011
`define XOR  4'b0_100

// 

module control_unit(
    input wire  [6:0]   opcode,
    input wire  [2:0]   funct3,
    input wire          funct7,
    //
    output reg  [3:0]   alu_op,
    output reg          alu_in2,
    output reg          alu_in1,
    output reg  [1:0]   regs_w_data, 
    output reg          regs_w_enb,
    output reg          regs_r_enb, 
    output reg  [2:0]   imm_op,
    output reg  [3:0]   mem_w_enb,
    output reg  [3:0]   mem_r_enb,
    output reg          branch,
    output reg          branch_zero,
    output reg          jump,
    output reg          invalid_op
    );


always @(*) begin

// Default values
alu_op       = `ADD;
alu_in2     = 1'b0;
alu_in1     = 1'b0;
regs_w_data  = 2'b00;
regs_w_enb   = 1'b0; 
imm_op       = 3'h0;
mem_r_enb    = 4'h0;
mem_w_enb    = 4'h0;
branch       = 1'b0;
jump         = 1'b0;
branch_zero  = 1'b0;
regs_r_enb   = 1'b0;
invalid_op   = 1'b0;

// In any instruction case
    case (opcode)

        `R_OP: begin
            regs_r_enb   = 1'b1;
            alu_op      =  {funct7,funct3};
            regs_w_enb  =  1'b1;
        end

        `I_OP: begin
            regs_r_enb   = 1'b1;
            imm_op    = 3'h1; // I-type
            alu_in2   =   1'b1;
            alu_op     =  (funct3[1:0]==2'b01)  ?  {funct7,funct3} // Considerate Shifts special case
                                                :  {1'b0,funct3} ; 
            regs_w_enb  =  1'b1;
        end 

        `L_OP: begin
            regs_r_enb   = 1'b1;
            imm_op    = 3'h1; // I-type
            alu_in2   =  1'b1;
            mem_r_enb    =   funct3[1] ? 4'b1111 : // word case
                             funct3[0] ? 4'b0011 : // half case 
                                         4'b0001 ; // byte case
            regs_w_data  = 2'b01;  // data from mem
            regs_w_enb  =  1'b1;
        end

        `S_OP: begin
            regs_r_enb   = 1'b1;
            imm_op    = 3'h2; // S-type
            alu_in2   =  1'b1;
            mem_w_enb   =   funct3[1] ? 4'b1111 : // word case
                            funct3[0] ? 4'b0011 : // half case 
                                        4'b0001 ; // byte case
        end

        `B_OP: begin
            regs_r_enb   = 1'b1;
            imm_op    = 3'h3; // B-type
            alu_op      =   funct3[1] ? `SLTU :
                            funct3[2] ? `SLT  :
                                        `XOR  ;
            branch_zero =   (funct3==3'b001) ? 1'b1 :
                            (funct3==3'b100) ? 1'b1 :
                            (funct3==3'b110) ? 1'b1 : 
                                               1'b0 ;
            branch      =   1'b1;
        end
            
        `J_OP: begin
            alu_in1   =   1'b1;   // data fromm PC
            alu_in2   =   1'b1;   // data from immediate
            regs_w_enb  =   1'b1;
            regs_w_data =   2'b10;  // data from PC+4
            imm_op    = 3'h5; // J-type
            jump        =   1'b1;
        end

        `JR_OP: begin
            regs_r_enb   = 1'b1;
            imm_op    = 3'h1; // I-type
            alu_in2   =   1'b1;   // data from immediate
            regs_w_enb  =   1'b1;
            regs_w_data =   2'b10;  // data from PC+4
            jump        =   1'b1;
        end

        `LUI_OP: begin
            regs_w_enb  =   1'b1;
            regs_w_data =   2'b11;  // data from immediate
            imm_op    = 3'h4; // U-type
        end

        `AUIPC_OP: begin
            alu_in1   =   1'b1;   // data fromm PC
            alu_in2   =   1'b1;   // data from immediate
            regs_w_enb =   1'b1;
            imm_op    = 3'h4; // U-type
        end

        default: begin
            invalid_op = 1'b1;
        end

    endcase

end

endmodule







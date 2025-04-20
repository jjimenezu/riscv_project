
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
    input wire [6:0] opcode,
    input wire [2:0] funct3,
    input wire       funct7,
    output reg [3:0] alu_op,
    output reg alu_src2,
    output reg alu_src1,
    output reg branch_select_no_zero,
    output reg [2:0] writeback_mux, 
    output reg reg_write, 
    output reg [3:0] mem_read,
    output reg [3:0] mem_write,
    output reg branch,
    output reg [1:0] jump,
    output reg unknown_op
    );



always @(*) begin

    unknown_op   =   1'b0;
    branch_select_no_zero =   1'b0;
    alu_src1     =   1'b0;
    jump = 2'b00;

    case (opcode)

        `R_OP: begin
            alu_op = {funct7,funct3};
            alu_src2     =   1'b0;
            writeback_mux     =   3'b000;
            reg_write   =   1'b1;
            mem_read    =   4'h0;
            mem_write   =   4'h0;
            branch      =   1'b0;
        end

        `I_OP: begin
            alu_op      =   (funct3[1:0]==2'b01) ? {funct7,funct3} : {1'b0,funct3} ; // Considerate Shifts special case
            alu_src2     =   1'b1;
            writeback_mux     =   3'b000;
            reg_write   =   1'b1;
            mem_read    =   4'h0;
            mem_write   =   4'h0;
            branch      =   1'b0;
        end

        `L_OP: begin
            alu_op      =   4'h0; // add to calc efective address
            alu_src2     =   1'b1;
            writeback_mux     =   3'b001;
            reg_write   =   1'b1;
            mem_read    =   funct3[1] ? 4'b1111 : // word case
                            funct3[0] ? 4'b0011 : // half case 
                                        4'b0001 ; // byte case
            mem_write   =   4'h0;
            branch      =   1'b0;
        end

        `S_OP: begin
            alu_op      =   4'h0; // add to calc efective address
            alu_src2     =   1'b1;
            writeback_mux     =   3'b000; // X
            reg_write   =   1'b0;
            mem_read    =   4'h0;
            mem_write   =   funct3[1] ? 4'b1111 : // word case
                            funct3[0] ? 4'b0011 : // half case 
                                        4'b0001 ; // byte case
            branch      =   1'b0;
        end

        `B_OP: begin
            alu_op      =   funct3[1] ? `SLTU :
                            funct3[2] ? `SLT  : `XOR;
            alu_src2     =   1'b0;  
            writeback_mux     =   3'b000; // X
            reg_write   =   1'b0;
            mem_read    =   4'h0;
            mem_write   =   4'h0;
            branch      =   1'b1;
            branch_select_no_zero =  (funct3==3'b001) ? 1'b1 :
                            (funct3==3'b100) ? 1'b1 :
                            (funct3==3'b110) ? 1'b1 : 1'b0;
            // if ((funct3==3'b001)||(funct3==3'b100)||(funct3==3'b110))
            //     branch_select_no_zero = 1'b1;
            // else
            //     branch_select_no_zero = 1'b0;
        end
            
        `J_OP: begin
            alu_op      =   4'h0;  //X
            alu_src2    =   1'b0; //X
            writeback_mux     =   3'b100;
            reg_write   =   1'b1;
            mem_read    =   4'h0;
            mem_write   =   4'h0;
            branch      =   1'b0;

            jump        =   2'b01;
        end

        `JR_OP: begin
            alu_op      =   4'h0;  //add
            alu_src2    =   1'b1; //imm
            writeback_mux     =   3'b100;
            reg_write   =   1'b1;
            mem_read    =   4'h0;
            mem_write   =   4'h0;
            branch      =   1'b0;

            jump        =   2'b01;
        end

        `LUI_OP: begin
            alu_op      =   4'h0; //X
            alu_src2    =   1'b1; //X
            writeback_mux     =   3'b010;
            reg_write   =   1'b1;
            mem_read    =   4'h0;
            mem_write   =   4'h0;
            branch      =   1'b0;

            alu_src1    =   1'b0; //X
        end

        `AUIPC_OP: begin
            alu_op      =   4'h0;
            alu_src2    =   1'b1;
            writeback_mux     =   3'b000;
            reg_write   =   1'b1;
            mem_read    =   4'h0;
            mem_write   =   4'h0;
            branch      =   1'b0;

            alu_src1    =   1'b1;
        end

        default: begin
            alu_op      =   4'h0;
            alu_src2    =   1'b0;
            writeback_mux     =   3'b000;
            reg_write   =   1'b0;
            mem_read    =   4'h0;
            mem_write   =   4'h0;
            branch      =   1'b0;
            unknown_op  =   1'b1;
        end

    endcase

end




endmodule

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

module control_unit(
    input wire [6:0] opcode,
    input wire [2:0] funct3,
    input wire       funct7,
    output reg [3:0] alu_op,
    output reg  alu_src,
    output reg mem2reg, 
    output reg reg_write, 
    output reg mem_read,
    output reg mem_write,
    output reg branch,
    output reg unknown_op
    );



always @(*) begin

    unknown_op  =   1'b0;
    
    case (opcode)

        `R_OP: begin
            alu_op = {funct7,funct3};
            alu_src     =   1'b0;
            mem2reg     =   1'b0;
            reg_write   =   1'b1;
            mem_read    =   1'b0;
            mem_write   =   1'b0;
            branch      =   1'b0;
        end

        `I_OP: begin
            alu_op = {funct7,funct3};
            alu_src     =   1'b1;
            mem2reg     =   1'b0;
            reg_write   =   1'b1;
            mem_read    =   1'b0;
            mem_write   =   1'b0;
            branch      =   1'b0;
        end

        `L_OP: begin
            alu_op      =   4'h0; // add to calc efective address
            alu_src     =   1'b1;
            mem2reg     =   1'b1;
            reg_write   =   1'b1;
            mem_read    =   1'b1;
            mem_write   =   1'b0;
            branch      =   1'b0;
        end

        `S_OP: begin
            alu_op      =   4'h0; // add to calc efective address
            alu_src     =   1'b1;
            mem2reg     =   1'b0; // X
            reg_write   =   1'b0;
            mem_read    =   1'b0;
            mem_write   =   1'b1;
            branch      =   1'b0;
        end

        `B_OP: begin
            alu_op      =   4'h0;
            alu_src     =   1'b0;
            mem2reg     =   1'b0; // X
            reg_write   =   1'b0;
            mem_read    =   1'b0;
            mem_write   =   1'b0;
            branch      =   1'b1;
        end
            
        // `J_OP:

        // `JR_OP:

        // `LUI_OP:

        // `AUIPC_OP:

        default: begin
            alu_op      =   4'h0;
            alu_src     =   1'b0;
            mem2reg     =   1'b0;
            reg_write   =   1'b0;
            mem_read    =   1'b0;
            mem_write   =   1'b0;
            branch      =   1'b0;
            unknown_op  =   1'b1;
        end

    endcase

end




endmodule
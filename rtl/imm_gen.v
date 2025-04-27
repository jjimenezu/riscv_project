module imm_gen(
    input wire [31:7] instr,
    input wire [2:0]  imm_op,
    output reg [31:0] imm
);

// Immediates Generator //
always @(*) begin
    case (imm_op)

        // I-type
        3'h1: imm = {{20{instr[31]}},instr[31:20]};

        // S-type
        3'h2: imm = {{20{instr[31]}},instr[31:25],instr[11:7]};

        // B-type
        3'h3: imm = {{19{instr[31]}},instr[31],instr[7],instr[30:25],instr[11:8], 1'b0};

        // U-type
        3'h4: imm = {instr[31:12],{12{1'b0}}};

        // J-type
        3'h5: imm = {{11{instr[31]}},instr[31],instr[19:12],instr[20],instr[30:21], 1'b0};

        default: imm = {32{1'b0}};
    endcase 
end

endmodule
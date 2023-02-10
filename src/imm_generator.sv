`include "RISCV_defs.svh"

module imm_generator(
    input logic [`IM_INSTLEN-1:0] inst,
    output logic [`RF_XLEN-1:0] imm
);

    logic [11:0] unextended_imm;
    logic [19:0] unextended_uimm;
    logic [6:0] opcode, funct7;
    logic [2:0] funct3;

    assign opcode = inst[6:0];
    assign funct3 = inst[14:12];
    assign funct7 = inst[31:25];
    
    always_comb begin
        case (opcode)
            7'b0010011, 7'b0000011, 7'b1100111, 7'b1110011:
                unextended_imm = inst[31:20];
            7'b0100011:
                unextended_imm = {inst[31:25], inst[11:7]};
            7'b0110111, 7'b0010111:
                unextended_uimm = inst[31:12];
            7'b1100011:
                unextended_imm = {inst[31], inst[7], inst[30:25], inst[11:8]};
            7'b1101111:
                unextended_uimm = {inst[31], inst[19:12], inst[20], inst[30:21]};
        endcase
    end

    always_comb begin
        case (opcode)
            7'b0010011, 7'b1100111: begin
                if (funct3 == 3'b101 && funct7 == 7'b0100000) 
                    imm = {27'b0, unextended_imm[4:0]};
                else 
                    imm = {{20{unextended_imm[11]}}, unextended_imm};
            end
            7'b0000011, 7'b0100011: imm = {{20{unextended_imm[11]}}, unextended_imm};
            7'b0110111, 7'b0010111: imm = {unextended_uimm, 12'b0};
            7'b1100011: imm = {{19{unextended_imm[11]}}, unextended_imm, 1'b0};
            7'b1101111: imm = {{11{unextended_uimm[19]}}, unextended_uimm, 1'b0};
            7'b1110011: imm = {20'b0, unextended_imm};
        endcase
    end
    
endmodule
`include "RISCV_defs.svh"

module alu(
    input logic [`ALU_OPSLEN-1:0] alu_op,
    input logic [`RF_XLEN-1:0] A, B,
    output logic [`RF_XLEN-1:0] alu_out
);

    always_comb begin
        case (alu_op)
            `ALU_OPS_ADD:   alu_out = A + B;
            `ALU_OPS_SUB:   alu_out = A - B;
            `ALU_OPS_SLL:   alu_out = A << B[4:0];
            `ALU_OPS_SLT:   alu_out = $signed(A) < $signed(B);
            `ALU_OPS_SLTU:  alu_out = A < B;
            `ALU_OPS_XOR:   alu_out = A ^ B;
            `ALU_OPS_SRL:   alu_out = A >> B[4:0];
            `ALU_OPS_SRA:   alu_out = A >>> B[4:0];
            `ALU_OPS_AND:   alu_out = A & B;
            `ALU_OPS_OR:    alu_out = A | B;
            `ALU_OPS_A:     alu_out = A;
            `ALU_OPS_B:     alu_out = B;
            `ALU_OPS_JALR:  alu_out = (A + B) & ~(1'b1);
            default:        alu_out = 32'hx;
        endcase
    end

endmodule
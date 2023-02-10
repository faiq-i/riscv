`include "RISCV_defs.svh"

module controller(
    input clk, rst, valid,
    input logic [`IM_INSTLEN-1:0] inst_de, inst_mw,
    output logic reg_wr, sel_a, sel_b, rd_en, wr_en, fwd_a, fwd_b, stall, csr_rd, csr_wr, is_mret,
    output logic [`ALU_OPSLEN-1:0] alu_op,
    output logic [`DM_OPSLEN-1:0] rd_op, wr_op,
    output logic [`BR_OPSLEN-1:0] br_op,
    output logic [1:0] wb_sel
);

    logic [6:0] opcode, funct7;
    logic [2:0] funct3;

    logic reg_wr_de, rd_en_de, wr_en_de, csr_rd_de, csr_wr_de, is_mret_de;
    logic [1:0] wb_sel_de;
    logic [`DM_OPSLEN-1:0] rd_op_de, wr_op_de;

    assign opcode = inst_de[6:0];
    assign funct3 = inst_de[14:12];
    assign funct7 = inst_de[31:25];

    always_comb begin
        is_mret_de = 0;
        if (inst_de == 32'h30200073) begin
            is_mret_de = 1;
        end
        if (opcode == 7'b0110011) begin
            csr_rd_de = 0;
            csr_wr_de = 0;
            reg_wr_de = 1;
            sel_a = 0;
            sel_b = 0;
            rd_op_de = `DM_OPS_DEFAULT;
            rd_en_de = 0;
            wr_op_de = `DM_OPS_DEFAULT;
            wr_en_de = 0;
            wb_sel_de = `WB_SEL_ALU;
            br_op = `BR_OPS_DEFAULT;
            case (funct3)
                3'b000: begin
                    case (funct7)
                        7'b0000000: alu_op = `ALU_OPS_ADD;
                        7'b0100000: alu_op = `ALU_OPS_SUB; 
                        default:    alu_op = `ALU_OPS_DEFAULT;
                    endcase
                end
                3'b001: alu_op = `ALU_OPS_SLL;
                3'b010: alu_op = `ALU_OPS_SLT;
                3'b011: alu_op = `ALU_OPS_SLTU;
                3'b100: alu_op = `ALU_OPS_XOR;
                3'b101: begin
                    case (funct7)
                        7'b0000000: alu_op = `ALU_OPS_SRL;
                        7'b0100000: alu_op = `ALU_OPS_SRA; 
                        default:    alu_op = `ALU_OPS_DEFAULT;
                    endcase
                end
                3'b110: alu_op = `ALU_OPS_OR;
                3'b111: alu_op = `ALU_OPS_AND;
                default: alu_op = `ALU_OPS_DEFAULT;
            endcase
        end else if (opcode == 7'b0010011) begin
            csr_rd_de = 0;
            csr_wr_de = 0;
            reg_wr_de = 1;
            sel_a = 0;
            sel_b = 1;
            rd_op_de = `DM_OPS_DEFAULT;
            rd_en_de = 0;
            wr_op_de = `DM_OPS_DEFAULT;
            wr_en_de = 0;
            wb_sel_de = `WB_SEL_ALU;
            br_op = `BR_OPS_DEFAULT;
            case (funct3)
                3'b000: alu_op = `ALU_OPS_ADD;
                3'b001: alu_op = `ALU_OPS_SLL;
                3'b010: alu_op = `ALU_OPS_SLT;
                3'b011: alu_op = `ALU_OPS_SLTU;
                3'b100: alu_op = `ALU_OPS_XOR;
                3'b101: begin
                    case (funct7)
                        7'b0000000: alu_op = `ALU_OPS_SRL;
                        7'b0100000: alu_op = `ALU_OPS_SRA; 
                        default:    alu_op = `ALU_OPS_DEFAULT;
                    endcase
                end
                3'b110: alu_op = `ALU_OPS_OR;
                3'b111: alu_op = `ALU_OPS_AND;
                default: alu_op = `ALU_OPS_DEFAULT;
            endcase
        end else if (opcode == 7'b0000011) begin 
            csr_rd_de = 0;
            csr_wr_de = 0;
            alu_op = `ALU_OPS_ADD;
            reg_wr_de = 1;
            sel_a = 0;
            sel_b = 1;
            rd_en_de = 1;
            wb_sel_de = `WB_SEL_DM;
            wr_op_de = `DM_OPS_DEFAULT;
            wr_en_de = 0;
            br_op = `BR_OPS_DEFAULT;
            case (funct3)
                3'b000: rd_op_de = `DM_OPS_LB;
                3'b001: rd_op_de = `DM_OPS_LH;
                3'b010: rd_op_de = `DM_OPS_LW;
                3'b100: rd_op_de = `DM_OPS_LBU;
                3'b101: rd_op_de = `DM_OPS_LHU; 
                default: rd_op_de = `DM_OPS_DEFAULT;
            endcase
        end else if (opcode == 7'b0100011) begin
            alu_op = `ALU_OPS_ADD;
            csr_rd_de = 0;
            csr_wr_de = 0;
            reg_wr_de = 0;
            sel_a = 0;
            sel_b = 1;
            rd_op_de = `DM_OPS_DEFAULT;
            rd_en_de = 0;
            wb_sel_de = `WB_SEL_ALU;
            wr_en_de = 1;
            br_op = `BR_OPS_DEFAULT;
            case (funct3)
                3'b000: wr_op_de = `DM_OPS_SB;
                3'b001: wr_op_de = `DM_OPS_SH;
                3'b010: wr_op_de = `DM_OPS_SW;
                default: wr_op_de = `DM_OPS_DEFAULT;
            endcase
        end else if (opcode == 7'b0110111) begin
            csr_rd_de = 0;
            csr_wr_de = 0;
            alu_op = `ALU_OPS_B;
            reg_wr_de = 1;
            sel_a = 0;
            sel_b = 1;
            rd_op_de = `DM_OPS_DEFAULT;
            rd_en_de = 0;
            wb_sel_de = `WB_SEL_ALU;
            wr_en_de = 0;
            wr_op_de = `DM_OPS_DEFAULT;
            br_op = `BR_OPS_DEFAULT;
        end else if (opcode == 7'b0010111) begin
            csr_rd_de = 0;
            csr_wr_de = 0;
            alu_op = `ALU_OPS_ADD;
            reg_wr_de = 1;
            sel_a = 1;
            sel_b = 1;
            rd_op_de = `DM_OPS_DEFAULT;
            rd_en_de = 0;
            wb_sel_de = `WB_SEL_ALU;
            wr_en_de = 0;
            wr_op_de = `DM_OPS_DEFAULT;
            br_op = `BR_OPS_DEFAULT;
        end else if (opcode == 7'b1100011) begin
            csr_rd_de = 0;
            csr_wr_de = 0;
            alu_op = `ALU_OPS_ADD;
            reg_wr_de = 0;
            sel_a = 1;
            sel_b = 1;
            rd_op_de = `DM_OPS_DEFAULT;
            rd_en_de = 0;
            wb_sel_de = `WB_SEL_ALU;
            wr_en_de = 0;
            wr_op_de = `DM_OPS_DEFAULT;
            case (funct3)
                3'b000: br_op = `BR_OPS_EQ;
                3'b001: br_op = `BR_OPS_NE;
                3'b100: br_op = `BR_OPS_LT;
                3'b101: br_op = `BR_OPS_GE;
                3'b110: br_op = `BR_OPS_LTU;
                3'b111: br_op = `BR_OPS_GEU;
                default: br_op = `BR_OPS_DEFAULT;
            endcase
        end else if (opcode == 7'b1101111) begin
            csr_rd_de = 0;
            csr_wr_de = 0;
            alu_op = `ALU_OPS_ADD;
            reg_wr_de = 1;
            sel_a = 1;
            sel_b = 1;
            rd_op_de = `DM_OPS_DEFAULT;
            rd_en_de = 0;
            wr_op_de = `DM_OPS_DEFAULT;
            wr_en_de = 0;
            wb_sel_de = `WB_SEL_PC;
            br_op = `BR_OPS_UNCOND;
        end else if (opcode == 7'b1100111) begin
            csr_rd_de = 0;
            csr_wr_de = 0;
            alu_op = `ALU_OPS_ADD;
            reg_wr_de = 1;
            sel_a = 0;
            sel_b = 1;
            rd_op_de = `DM_OPS_DEFAULT;
            rd_en_de = 0;
            wr_op_de = `DM_OPS_DEFAULT;
            wr_en_de = 0;
            wb_sel_de = `WB_SEL_PC;
            br_op = `BR_OPS_UNCOND;
        end else if (opcode == 7'b1110011) begin
            csr_rd_de = 1;
            csr_wr_de = 1;
            alu_op = `ALU_OPS_ADD;
            reg_wr_de = 1;
            sel_a = 0;
            sel_b = 0;
            rd_op_de = `DM_OPS_DEFAULT;
            rd_en_de = 0;
            wr_op_de = `DM_OPS_DEFAULT;
            wr_en_de = 0;
            wb_sel_de = `WB_SEL_CSR;
            br_op = `BR_OPS_DEFAULT;
        end else begin
            csr_rd_de = 0;
            csr_wr_de = 0;
            alu_op = `ALU_OPS_DEFAULT;
            reg_wr_de = 0;
            sel_a = 0;
            sel_b = 0;
            rd_op_de = `DM_OPS_DEFAULT;
            rd_en_de = 0;
            wr_op_de = `DM_OPS_DEFAULT;
            wr_en_de = 0;
            wb_sel_de = `WB_SEL_ALU;
            br_op = `BR_OPS_DEFAULT;
        end
    end

    de_mw_control_registers DE_MW_CTRL_REG(
        .clk(clk),
        .rst(rst),
        .reg_wr_in(reg_wr_de),
        .rd_en_in(rd_en_de),
        .wr_en_in(wr_en_de),
        .wb_sel_in(wb_sel_de),
        .rd_op_in(rd_op_de),
        .wr_op_in(wr_op_de),
        .reg_wr_out(reg_wr),
        .rd_en_out(rd_en),
        .wr_en_out(wr_en),
        .wb_sel_out(wb_sel),
        .rd_op_out(rd_op),
        .wr_op_out(wr_op),
        .csr_rd_in(csr_rd_de),
        .csr_wr_in(csr_wr_de),
        .csr_rd_out(csr_rd),
        .csr_wr_out(csr_wr),
        .is_mret_in(is_mret_de),
        .is_mret_out(is_mret)
    );

    forwarding_unit FWD_UNIT(
        .reg_wr(reg_wr),
        .valid(valid),
        .inst_de(inst_de),
        .inst_mw(inst_mw),
        .fwd_a(fwd_a),
        .fwd_b(fwd_b),
        .stall(stall)
    );

endmodule
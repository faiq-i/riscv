`include "RISCV_defs.svh"

module riscv(
    input logic rst, clk, interrupt, exception,
    output logic br, tb,
    output logic [`RF_XLEN-1:0] wdata
);

    logic reg_wr, sel_a, sel_b, rd_en, wr_en, fwd_a, fwd_b, stall, valid, csr_rd, csr_wr, is_mret;
    logic [`ALU_OPSLEN-1:0] alu_op;
    logic [`DM_OPSLEN-1:0] rd_op, wr_op;
    logic [`BR_OPSLEN-1:0] br_op;
    logic [`IM_INSTLEN-1:0] inst_de, inst_mw;
    logic [1:0] wb_sel;

    datapath DATAPATH(
        .clk(clk),
        .rst(rst),
        .reg_wr(reg_wr),
        .sel_a(sel_a),
        .sel_b(sel_b),
        .rd_en(rd_en),
        .wr_en(wr_en),
        .fwd_a(fwd_a),
        .fwd_b(fwd_b),
        .stall(stall),
        .wb_sel(wb_sel),
        .alu_op(alu_op),
        .rd_op(rd_op),
        .wr_op(wr_op),
        .br_op(br_op),
        .inst_de(inst_de),
        .inst_mw(inst_mw),
        .valid(valid),
        .csr_rd(csr_rd),
        .csr_wr(csr_wr),
        .is_mret(is_mret),
        .interrupt(interrupt),
        .exception(exception),
        .br(br),
        .tb(tb),
        .wdata_mw(wdata)
    );

    controller CONTROLLER(
        .clk(clk),
        .rst(rst),
        .inst_de(inst_de),
        .inst_mw(inst_mw),
        .reg_wr(reg_wr),
        .valid(valid),
        .sel_a(sel_a),
        .sel_b(sel_b),
        .rd_en(rd_en),
        .wr_en(wr_en),
        .fwd_a(fwd_a),
        .fwd_b(fwd_b),
        .wb_sel(wb_sel),
        .alu_op(alu_op),
        .rd_op(rd_op),
        .wr_op(wr_op),
        .br_op(br_op),
        .stall(stall),
        .csr_rd(csr_rd),
        .csr_wr(csr_wr),
        .is_mret(is_mret)
    );

endmodule
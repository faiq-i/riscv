`include "RISCV_defs.svh"

module de_mw_control_registers(
    input logic clk, rst, reg_wr_in, rd_en_in, wr_en_in, csr_rd_in, csr_wr_in, is_mret_in,
    input logic [1:0] wb_sel_in,
    input logic [`DM_OPSLEN-1:0] rd_op_in, wr_op_in,
    output logic reg_wr_out, rd_en_out, wr_en_out, csr_rd_out, csr_wr_out, is_mret_out,
    output logic [1:0] wb_sel_out,
    output logic [`DM_OPSLEN-1:0] rd_op_out, wr_op_out
);

    logic [31:0] cregs_out;

    register CTRL_REG(
        .clk(clk),
        .rst(rst),
        .stall(`NO_STALL),
        .in({16'b0, is_mret_in, csr_rd_in, csr_wr_in, rd_op_in, wr_op_in, wb_sel_in, rd_en_in, wr_en_in, reg_wr_in}),
        .out(cregs_out)
    );

    assign reg_wr_out = cregs_out[0];
    assign wr_en_out = cregs_out[1];
    assign rd_en_out = cregs_out[2];
    assign wb_sel_out = cregs_out[4:3];
    assign wr_op_out = cregs_out[8:5];
    assign rd_op_out = cregs_out[12:9];
    assign csr_wr_out = cregs_out[13];
    assign csr_rd_out = cregs_out[14];
    assign is_mret_out = cregs_out[15];

endmodule
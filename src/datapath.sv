`include "RISCV_defs.svh"

module datapath(
    input logic clk, rst, reg_wr, sel_a, sel_b, rd_en, wr_en, fwd_a, fwd_b, stall, csr_rd, csr_wr, is_mret, interrupt, exception,
    input logic [`ALU_OPSLEN-1:0] alu_op,
    input logic [`DM_OPSLEN-1:0] rd_op, wr_op,
    input logic [`BR_OPSLEN-1:0] br_op,
    input logic [1:0] wb_sel,
    output logic [`IM_INSTLEN-1:0] inst_de, inst_mw,
    output logic [`RF_XLEN-1:0] wdata_mw,
    output logic valid, br, tb
);

    logic [`IM_INSTLEN-1:0] inst_f;
    logic [`IM_ADDRESSLEN-1:0] pc_f, pc_de, pc_mw, pci_o, pc_i, pci_o_wb, epc_evec, pc_br;
    logic [`RF_XLEN-1:0] alu_out, alu_out_mw, rdata1, rdata2, imm, fwd_a_out, fwd_b_out;
    logic [`RF_XLEN-1:0] alu_a, alu_b, wb_data, dm_rdata, csr_data, csr_addr, csr_rdata;
    logic br_taken, epc_taken, reg_wr_ie, wr_en_ie;

    always_comb begin
        if (interrupt) begin
            reg_wr_ie = 0; wr_en_ie = 0;
        end else if (exception) begin
            reg_wr_ie = 0; wr_en_ie = 0;
        end else begin
            reg_wr_ie = reg_wr; wr_en_ie = wr_en;
        end
    end

    instruction_memory IM(
        .rst(rst),
        .addr(pc_f),
        .inst(inst_f)
    );
    pc_increment PC_INC(
        .pci_i(pc_f),
        .pci_o(pci_o)
    );
    register PC(
        .clk(clk),
        .rst(rst),
        .stall(`NO_STALL),
        .in(pc_i),
        .out(pc_f)
    );
    mux2x1_32bit PC_MUX(
        .ctrl(br_taken),
        .a(pci_o),
        .b(alu_out),
        .out(pc_br)
    );
    mux2x1_32bit CSR_PC_MUX(
        .ctrl(epc_taken),
        .a(pc_br),
        .b(epc_evec),
        .out(pc_i)
    );

    f_de_registers F_DE_REG(
        .clk(clk),
        .rst(rst|br_taken|epc_taken),
        .stall(stall),
        .pc_in(pc_f),
        .ir_in(inst_f),
        .pc_out(pc_de),
        .ir_out(inst_de)
    );

    register_file RF(
        .clk(clk),
        .rst(rst),
        .reg_wr(reg_wr_ie),
        .raddr1(inst_de[19:15]),
        .raddr2(inst_de[24:20]),
        .waddr(inst_mw[11:7]),
        .wdata(wb_data),
        .rdata1(rdata1),
        .rdata2(rdata2)
    );
    imm_generator IMM_GEN(
        .inst(inst_de),
        .imm(imm)
    );
    mux2x1_32bit FWD_A_MUX(
        .ctrl(fwd_a),
        .a(rdata1),
        .b(alu_out_mw),
        .out(fwd_a_out)
    );
    mux2x1_32bit FWD_B_MUX(
        .ctrl(fwd_b),
        .a(rdata2),
        .b(alu_out_mw),
        .out(fwd_b_out)
    );
    mux2x1_32bit IMM_MUX(
        .ctrl(sel_b),
        .a(fwd_b_out),
        .b(imm),
        .out(alu_b)
    );
    mux2x1_32bit SEL_A_MUX(
        .ctrl(sel_a),
        .a(fwd_a_out),
        .b(pc_de),
        .out(alu_a)
    );
    alu ALU(
        .alu_op(alu_op),
        .A(alu_a),
        .B(alu_b),
        .alu_out(alu_out)
    );
    branch_condition BR_COND(
        .br_op(br_op),
        .a(rdata1),
        .b(rdata2),
        .br_taken(br_taken)
    );
    
    de_mw_registers DE_MW_REG(
        .clk(clk),
        .rst(rst|epc_taken),
        .stall(stall),
        .pc_in(pc_de),
        .ir_in(inst_de),
        .alu_in(alu_out),
        .wd_in(rdata2),
        .csr_data_in(fwd_a_out),
        .csr_addr_in(imm),
        .pc_out(pc_mw),
        .ir_out(inst_mw),
        .alu_out(alu_out_mw),
        .wd_out(wdata_mw),
        .csr_data_out(csr_data),
        .csr_addr_out(csr_addr)
    );

    data_memory DM(
        .clk(clk),
        .rst(rst),
        .rd_en(rd_en),
        .wr_en(wr_en_ie),
        .rd_op(rd_op),
        .wr_op(wr_op),
        .addr(alu_out_mw),
        .wdata(wdata_mw),
        .rdata(dm_rdata),
        .valid(valid),
        .br(br),
        .tb(tb)
    );
    csr CSR(
        .clk(clk),
        .rst(rst),
        .pc(pc_mw),
        .interrupt(interrupt),
        .exception(exception),
        .reg_rd(csr_rd),
        .reg_wr(csr_wr),
        .addr(csr_addr),
        .wdata(csr_data),
        .rdata(csr_rdata),
        .is_mret(is_mret),
        .epc_evec(epc_evec),
        .epc_taken(epc_taken)
    );
    pc_increment PC_INC_WB(
        .pci_i(pc_mw),
        .pci_o(pci_o_wb)
    );
    mux4x1_32bit WB_MUX(
        .ctrl(wb_sel),
        .a(alu_out_mw),
        .b(dm_rdata),
        .c(pci_o_wb),
        .d(csr_rdata),
        .out(wb_data)
    );    
    
endmodule
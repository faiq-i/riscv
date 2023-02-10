module de_mw_registers(
    input logic clk, rst, stall,
    input logic [31:0] pc_in, ir_in, alu_in, wd_in, csr_data_in, csr_addr_in,
    output logic [31:0] pc_out, ir_out, alu_out, wd_out, csr_data_out, csr_addr_out
);

    register PC_REG(
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .in(pc_in),
        .out(pc_out)
    );

    register IR_REG(
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .in(ir_in),
        .out(ir_out)
    );

    register ALU_REG(
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .in(alu_in),
        .out(alu_out)
    );

    register WD_REG(
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .in(wd_in),
        .out(wd_out)
    );

    register CSR_DATA_REG(
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .in(csr_data_in),
        .out(csr_data_out)
    );

    register CSR_ADDR_REG(
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .in(csr_addr_in),
        .out(csr_addr_out)
    );

endmodule
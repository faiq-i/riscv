module f_de_registers(
    input logic clk, rst, stall,
    input logic [31:0] pc_in, ir_in,
    output logic [31:0] pc_out, ir_out
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

endmodule
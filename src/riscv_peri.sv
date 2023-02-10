module riscv_peri(
    input logic clk, rst, interrupt, exception,
    output logic tx
);

    logic br, tb;
    logic [31:0] data;

    riscv RISCV(
        .clk(clk),
        .rst(rst),
        .interrupt(interrupt),
        .exception(exception),
        .br(br),
        .tb(tb),
        .wdata(data)
    );

    uart UART(
        .clk(clk),
        .reset(rst),
        .byte_ready(br),
        .t_byte(tb),
        .data(data[7:0]),
        .tx(tx)
    );

endmodule
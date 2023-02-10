`include "RISCV_defs.svh"

module tb_riscv();

    logic clk, rst, interrupt, exception, tx;

    riscv_peri DUT(.clk(clk), .rst(rst), .interrupt(interrupt), .exception(exception), .tx(tx));

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1; #10;
        rst = 0; #405;
        interrupt = 1;
        #10;
        interrupt = 0;
    end

endmodule
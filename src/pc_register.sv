`include "RISCV_defs.svh"

module pc_register(
    input logic clk, rst,
    input logic [`IM_ADDRESSLEN-1:0] pc_i,
    output logic [`IM_ADDRESSLEN-1:0] pc_o
);

    always_ff @(posedge clk) begin
        if (rst) pc_o = 0;
        else pc_o = pc_i;
    end

endmodule
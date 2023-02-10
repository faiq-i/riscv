`include "RISCV_defs.svh"

module register_file(
    input logic clk, rst, reg_wr,
    input logic [`RF_ADDRESSLEN-1:0] raddr1, raddr2, waddr,
    input logic [`RF_XLEN-1:0] wdata,
    output logic [`RF_XLEN-1:0] rdata1, rdata2
);

    logic [`RF_XLEN-1:0] registers[`RF_SIZE];

    always_ff @(rst) begin
        if (rst) $readmemh("registers.mem", registers);
    end

    always_ff @(posedge clk) begin
        if (reg_wr & ~(waddr == 0)) begin
            registers[waddr] = wdata;
            $writememh("registers.mem", registers);
        end
    end

    assign rdata1 = (|raddr1)? registers[raddr1]: '0;
    assign rdata2 = (|raddr2)? registers[raddr2]: '0;

endmodule
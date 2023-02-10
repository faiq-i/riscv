`include "RISCV_defs.svh"

module data_memory(
    input logic clk, rst, rd_en, wr_en,
    input logic [`DM_OPSLEN-1:0] rd_op, wr_op,
    input logic [`RF_XLEN-1:0] addr, wdata,
    output logic [`RF_XLEN-1:0] rdata,
    output logic valid, br, tb
);

    logic [`DM_XLEN-1:0] data[`DM_SIZE-1:0];
    logic [`RF_XLEN-1:0] read_data;

    assign br = (|(addr[31:10])) & wr_en;

    always_ff @(posedge clk) begin
        tb <= br;
        if (rst) $readmemh("data.mem", data);
        else if (wr_en & !br) begin
            case (wr_op)
                `DM_OPS_SB: data[addr] = wdata[7:0];
                `DM_OPS_SH: begin
                    data[addr] = wdata[7:0];
                    data[addr+1] = wdata[15:8];
                end
                `DM_OPS_SW: begin
                    data[addr] = wdata[7:0];
                    data[addr+1] = wdata[15:8];
                    data[addr+2] = wdata[23:16];
                    data[addr+3] = wdata[31:24];
                end
            endcase
            $writememh("data.mem", data);
        end
    end

    always_comb begin
        valid = 0;
        if (rd_en) begin
            read_data = {data[addr+3], data[addr+2], data[addr+1], data[addr+0]};
            valid = 1;
            case (rd_op)
                `DM_OPS_LB:     rdata = {{24{read_data[7]}}, read_data[7:0]};
                `DM_OPS_LBU:    rdata = {24'b0, read_data[7:0]};
                `DM_OPS_LH:     rdata = {{16{read_data[15]}}, read_data[15:0]};
                `DM_OPS_LHU:    rdata = {16'b0, read_data[15:0]};
                `DM_OPS_LW:     rdata = read_data;
                default:        rdata = '0;
            endcase
        end
    end

endmodule
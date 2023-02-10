`include "RISCV_defs.svh"

module csr(
    input logic clk, rst, reg_rd, reg_wr, is_mret, interrupt, exception,
    input logic [`RF_XLEN-1:0] addr, wdata, pc,
    output logic [`RF_XLEN-1:0] rdata,
    output logic [`RF_XLEN-1:0] epc_evec,
    output logic epc_taken
);

    logic [`RF_XLEN-1:0] mie, mip, mstatus, mcause, mtvec, mepc, csr_mux_out;

    always_comb begin
        rdata = 0;
        epc_taken = 0;
        if (((mip[7] == 1) & (mie[7]==1) & (mstatus[7] == 1)) | ((mip[11]==1) & (mie[11]==1) & (mstatus[11]==1)) | is_mret) epc_taken = 1;
        
        if (reg_rd) begin
            case (addr)
                `CSR_MIE_ADDR:      rdata = mie;
                `CSR_MIP_ADDR:      rdata = mip;
                `CSR_MSTATUS_ADDR:  rdata = mstatus;
                `CSR_MCAUSE_ADDR:   rdata = mcause;
                `CSR_MTVEC_ADDR:    rdata = mtvec;
                `CSR_MEPC_ADDR:     rdata = mepc;
            endcase
        end
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            mip = 0; mie = 0;
            mstatus = 0;
            mtvec = 0; mepc = 16;
        end else begin
            mip[7] = interrupt;
            mip[11] = exception;
            if (epc_taken) begin
                mepc = pc-4;
            end
            if (reg_wr) begin
                case (addr)
                    `CSR_MIE_ADDR:      mie = wdata;
                    `CSR_MIP_ADDR:      mip = wdata;
                    `CSR_MSTATUS_ADDR:  mstatus = wdata;
                    `CSR_MTVEC_ADDR:    mtvec = wdata;
                    `CSR_MEPC_ADDR:     mepc = wdata;
                endcase
            end
        end
    end

    csr_encoder CSR_ENC(
        .interrupt(interrupt),
        .exception(exception),
        .cause(mcause)
    );

    mux2x1_32bit CSR_MUX(
        .ctrl(mtvec[0]),
        .a({mtvec[31:2], 2'b00}),
        .b({mtvec[31:2], 2'b00} + ((mcause[30:0])<<2)),
        .out(csr_mux_out)
    );

    mux2x1_32bit MRET_MUX(
        .ctrl(is_mret),
        .a(csr_mux_out),
        .b(mepc),
        .out(epc_evec)
    );

endmodule
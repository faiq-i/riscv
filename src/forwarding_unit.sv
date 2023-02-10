`include "RISCV_defs.svh"

module forwarding_unit(
    input logic reg_wr, valid,
    input logic [`IM_INSTLEN-1:0] inst_de, inst_mw,
    output logic fwd_a, fwd_b, stall
);
    
    assign fwd_a = (inst_de[19:15] == inst_mw[11:7]) & (|inst_mw[11:7]) & reg_wr & (inst_mw[6:0] != 7'b0000011);
    assign fwd_b = (inst_de[24:20] == inst_mw[11:7]) & (|inst_mw[11:7]) & reg_wr & (inst_mw[6:0] != 7'b0000011);
    assign stall = (!valid) & (fwd_a | fwd_b) & (inst_mw[6:0] == 7'b0000011);

endmodule
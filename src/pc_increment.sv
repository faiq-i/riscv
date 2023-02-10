`include "RISCV_defs.svh"

module pc_increment(
    input logic [`IM_ADDRESSLEN-1:0] pci_i,
    output logic [`IM_ADDRESSLEN-1:0] pci_o
);

    assign pci_o = pci_i + `PC_INCREMENT;

endmodule
`include "RISCV_defs.svh"

module instruction_memory(
    input logic rst,
    input logic [`IM_ADDRESSLEN-1:0] addr,
    output logic [`IM_INSTLEN-1:0] inst
);

    logic [`IM_XLEN-1:0] instructions[`IM_SIZE];
    
    always_ff @(rst) begin
        if (rst) $readmemh("instructions.mem", instructions);
    end
    
    assign inst = {instructions[addr], instructions[addr+1], instructions[addr+2], instructions[addr+3]};

endmodule
`include "RISCV_defs.svh"

module branch_condition(
    input logic [`BR_OPSLEN-1:0] br_op,
    input logic [`RF_XLEN-1:0] a, b,
    output logic br_taken
);

    always_comb begin
        case (br_op)
            `BR_OPS_EQ:         br_taken = (a == b);
            `BR_OPS_NE:         br_taken = (a != b);
            `BR_OPS_LT:         br_taken = ($signed(a) < $signed(b));
            `BR_OPS_GE:         br_taken = ($signed(a) >= $signed(b));
            `BR_OPS_LTU:        br_taken = (a < b);
            `BR_OPS_GEU:        br_taken = (a >= b);
            `BR_OPS_UNCOND:     br_taken = 1;
            default:            br_taken = 0;
        endcase
    end
    
endmodule
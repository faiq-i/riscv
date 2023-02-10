module register(
    input logic clk, rst, stall,
    input logic [31:0] in,
    output logic [31:0] out
);

    always_ff @(posedge clk) begin
        if (rst) out = 0;
        else if (!stall) out = in;
    end

endmodule
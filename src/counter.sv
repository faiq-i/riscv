module counter(
    input logic clk, clear, baud,
    output logic c_i);

    logic [3:0] val;

    always_ff @(posedge clk) begin
        if (clear)
            val <= 0;
        else if (baud)
            val <= val + 1;
    end

    assign c_i = (val == 9);

endmodule
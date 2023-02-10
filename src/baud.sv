module baud(
    input logic clk, clear_baud,
    output logic c_baud);

    logic [2:0] val;

    always_ff @(posedge clk) begin
        if (clear_baud)
           val <= 0;
        else
            val <= val + 1;
    end

    assign c_baud = (val == 2);

endmodule
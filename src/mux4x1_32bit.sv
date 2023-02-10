module mux4x1_32bit(
    input logic [1:0] ctrl,
    input logic [31:0] a, b, c, d,
    output logic [31:0] out
);

    always_comb begin
        case (ctrl)
            2'b00: out = a;
            2'b01: out = b;
            2'b10: out = c;
            2'b11: out = d;
        endcase
    end

endmodule
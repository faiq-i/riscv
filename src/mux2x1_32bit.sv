module mux2x1_32bit(
    input logic ctrl,
    input logic [31:0] a, b,
    output logic [31:0] out
);

    assign out = (ctrl)? b : a;

endmodule
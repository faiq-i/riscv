module u_datapath(
    input logic clk, reset, load_xmt, 
    shift, clear_baud, clear_o, start,
    input logic [7:0] data,
    output logic tx, count, counter_baud);

    logic shft;

    shift_reg sr(clk, load_xmt, shift, reset, data, shft);
    baud bd(clk, clear_baud, counter_baud);
    counter co(clk, clear_o, counter_baud, count);

    assign tx = start? shft:1'b1;

endmodule

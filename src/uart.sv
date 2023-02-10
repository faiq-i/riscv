module uart(
    input logic clk, reset, byte_ready, t_byte,
    input logic [7:0] data,
    output logic tx);

    logic load_xmt, shift, clear_baud, clear_o, start, counter, counter_baud;

    u_datapath dp(clk, reset, load_xmt, shift, clear_baud, clear_o, start, data, tx, 
    counter, counter_baud);
    
    controller_uart con(clk, reset, byte_ready, counter_baud, counter, t_byte, 
    load_xmt, shift, clear_baud, clear_o, start);

endmodule

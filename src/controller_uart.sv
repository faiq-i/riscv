module controller_uart(

    input logic clk, reset, byte_ready, counter_baud, counter, t_byte,
    output logic load_xmt, shift, clear_baud, clear_o, start);
    logic [1:0] ns, cs;

    always_ff @(posedge clk) begin
        if (reset)
            cs <= 2'b00;
        else
            cs <= ns;
    end

    always_comb begin
        case(cs)
        2'b00: begin
        if (~byte_ready) begin
            clear_baud <= 1;
            clear_o <= 1;
            load_xmt <= 0;
            start <= 0;
            shift <= 0;
            ns <= 2'b00;
        end
        else begin
            clear_baud <= 1;
            clear_o <= 1;
            load_xmt <= 1;
            start <= 0;
            shift <= 0;
            ns <= 2'b01;
        end
        end
        2'b01: begin
            if (~t_byte) begin
                clear_baud <= 1;
                clear_o <= 1;
                load_xmt <= 1;
                start <= 0;
                shift <= 0;
                ns <= 2'b01;
            end
            else begin
                clear_baud <= 0;
                clear_o <= 0;
                load_xmt <= 0;
                start <= 1;
                shift <= 0;
                ns <= 2'b10;
            end
        end
        2'b10:begin
            if (counter_baud) begin
                shift <= 1;
                clear_baud <= 1;
            end
            else begin 
                shift <= 0;
                clear_baud <= 0;
            end
            if (counter) begin
                shift <= 0;
                start <= 0;
                clear_baud <= 1;
                clear_o <= 1;
                ns <= 2'b00;
            end
        end
        endcase
    end
endmodule
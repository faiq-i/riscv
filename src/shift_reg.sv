module shift_reg(
    input logic clk, load, shift, reset,
    input logic [7:0] data,
    output logic serial_o);
    
    logic [8:0] hold;

    assign serial_o = hold[0];

    always_ff @(posedge clk) begin
        if (reset) 
            hold <= 9'd0;
        else begin
            if (shift)
                hold <= hold >> 1;
            else if (load) 
                hold <= {data,1'b0};
        end
    end
endmodule
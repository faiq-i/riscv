module csr_encoder(
    input logic interrupt, exception,
    output logic [31:0] cause
);

    always_comb begin
        if (interrupt) cause = 32'h80000001;
        else if (exception) cause = 32'h00000002;
    end

endmodule
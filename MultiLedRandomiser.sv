module LED_randomiser#(
    parameter PROBABILITY=10
)(
    input           		  enable,
    input                     clk,
    output logic        [17:0]LEDR
);

    // Create a bunch of LED randomisers for each mole
    genvar i;
    generate
        
        for(i = 0; i < 18; i++) begin
            LED_randomiser #(.PROBABILITY(PROBABILITY)) randomiser ( .clk(clk),
                                        .enable(enable),
                                        .LEDR(LEDR[i]));
        end
    endgenerate

endmodule
module MultiLedRandomiser#(
    parameter PROBABILITY=10
)(
    input           		  enable,
    input                     clk,
    output logic        [17:0]ledr
);

    // Create a bunch of LED randomisers for each mole
    genvar i;
    generate
        
        for(i = 0; i < 18; i++) begin : generateRandomisers
            LED_randomiser #(.PROBABILITY(PROBABILITY)) randomiser ( .clk(clk),
                                        .enable(enable),
                                        .led(ledr[i]));
        end : generateRandomisers
    endgenerate

endmodule
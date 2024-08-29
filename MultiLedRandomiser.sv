module MultiLedRandomiser(
    input           		  enable,
    input                     clk,
    input                     level,
    output logic        [17:0]ledr
);

    // Create a bunch of LED randomisers for each mole

    // control probability associated with each level
    logic [6:0] probability;
	 logic [6:0] double_level;
    always_comb begin
        double_level = 2 * level;
        probability = 10 - double_level;
    end

    genvar i;
    generate
        
        for(i = 0; i < 18; i++) begin : generateRandomisers
            LED_randomiser #(.SEED(i)) randomiser ( .clk(clk),
                                                    .enable(enable),
                                                    .led(ledr[i]),
                                                    .probability(probability));
        end : generateRandomisers
    endgenerate

endmodule
module MultiLedRandomiser(
    input           		  enable,
    input                     clk,
    input               [1:0] level,
    output logic        [17:0]ledr
);

    // Create a bunch of LED randomisers for each mole

    // control probability associated with each level
   logic [6:0] probability;
	logic [6:0] double_level;
	
	always_comb begin
		double_level = level << 2;
		probability = 15 - double_level;
	end
	

    genvar i;
    generate
        
        for(i = 0; i < 18; i++) begin : generateRandomisers
            LED_randomiser #(.SEED(i + 1)) randomiser ( .clk(clk),
                                                        .enable(enable),
																		  .probability(probability),
                                                        .led(ledr[i]));
        end : generateRandomisers
    endgenerate

endmodule
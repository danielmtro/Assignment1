module MultiLedRandomiser(
    input           		  enable,
    input                     clk,
    input                     level,
    output logic        [17:0]ledr
);

    // Create a bunch of LED randomisers for each mole

    // control probability associated with each level
   logic [6:0] probability;
	logic [6:0] inputProbability;
	
	always_comb begin
		
		case (level)
		
			0: begin
				probability = 15;
			end
			1: begin
				probability = 11;
			end
			2: begin
				probability = 7;
			end
			3: begin
				probability = 3;
			end
		endcase
	end
	
	
	 // add a stabiliser
	 always_ff @(posedge clk) begin
		inputProbability <= probability;
	 end

    genvar i;
    generate
        
        for(i = 0; i < 18; i++) begin : generateRandomisers
            LED_randomiser #(.SEED(i + 1)) randomiser ( .clk(clk),
                                                        .enable(enable),
																		  .probability(inputProbability),
                                                        .led(ledr[i]));
        end : generateRandomisers
    endgenerate

endmodule
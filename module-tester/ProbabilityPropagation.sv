/*
Function is used to test rng mole spawning.
*/

module ProbabilityPropagation(

	input clk,
	input level,
	input enable,
	output led
);



	 logic [6:0] probability;
	 logic [6:0] doubleLevel;
	 
	 always_comb begin
		doubleLevel = level * 4;
		probability = 15 - doubleLevel;
	 end
	 
		
	 LED_randomiser #(.SEED(1)) randomiser ( .clk(clk),
														   .enable(enable),
															.probability(probability),
															.led(led));

endmodule
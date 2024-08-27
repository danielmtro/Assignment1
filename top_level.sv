module top_level_mole_generation#(
	parameter MAX_MS=2047
)(
	input 	[3:0]KEY,
	input 	CLOCK2_50,
	output	[17:0] LEDR,
	output 	[6:0]  HEX0,
	output 	[6:0]  HEX1,
	output 	[6:0]  HEX2,
	output 	[6:0]  HEX3
);


	logic button_pressed;
	logic reset, up, enable;
	logic [$clog2(MAX_MS)-1:0] timer_value;
	logic [$clog2(MAX_MS)-1:0] random_value;


	timer u0 (.clk(CLOCK2_50),
			  .reset(reset),
			  .up(up),
			  .start_value(random_value),
			  .enable(enable),
			  .timer_value(timer_value));


	debounce debouncer (.clk(CLOCK2_50),
						.button(KEY[0]),
						.button_pressed(button_pressed));


	rng rng_module (.clk(CLOCK2_50),
						 .random_value(random_value));


	reaction_time_fsm fsm (.clk(CLOCK2_50),
						   .button_pressed(button_pressed),
						   .timer_value(timer_value),
						   .reset(reset),
						   .up(up),
						   .enable(enable),
						   .led_on(LEDR[0]));


	display display_0 (.clk(CLOCK2_50),
					   .value(timer_value),
					   .display0(HEX0),
					   .display1(HEX1),
					   .display2(HEX2),
					   .display3(HEX3));


endmodule
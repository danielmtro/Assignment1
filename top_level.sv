module top_level #(
	MAX_MS = 2047,
)(
	input 	KEY0,
	input 	CLOCK2_50,
	output	LEDR0,
	output 	[6:0]  RN15,
	output 	[6:0]  RN14,
	output 	[6:0]  RN13,
	output 	[6:0]  RN12,
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
						.button(KEY0),
						.button_pressed(button_pressed));


	rng rng_module (.clk(CLOCK2_50),
					.random_value(random_value));


	reaction_time_fsm fsm (.clk(CLOCK2_50),
						   .button_pressed(button_pressed),
						   .timer_value(timer_value),
						   .reset(reset),
						   .up(up),
						   .enable(enable),
						   .led_on(LEDR0));


	display display_0 (.clk(CLOCK2_50),
					   .value(timer_value),
					   .display0(RN15),
					   .display1(RN14),
					   .display2(RN13),
					   .display3(RN12));


endmodule
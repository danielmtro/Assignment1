/*
Integration test for determining:

- levels work
- level is displayed
- timer value is dispalyed
- LED's generate moles randomly when enabled
*/

module randomised_mole_spawning_integration_test #(
	parameter MAX_MS=2047
)(
	input 	CLOCK2_50,
	input		[3:0]  KEY,
	output	[17:0] LEDR,
	output 	[6:0]  HEX0,
	output 	[6:0]  HEX1,
	output 	[6:0]  HEX2,
	output 	[6:0]  HEX3,
	output	[6:0]	 HEX4
);


    // This is a test script for seeing if moles can be spawned on the FPGA
    logic reset, up, enable;
	logic [$clog2(MAX_MS)-1:0] timer_value;
	logic [$clog2(MAX_MS)-1:0] random_value;
   	logic [1:0] level;
	logic [6:0] segment_level;
    logic led_enable;
	
	always_comb begin
		segment_level = {5'b00000, level};
	end

    logic increment;
    logic level_button_pressed;

    debounce d0 (.clk(CLOCK2_50),               // Difficulty button debouncer
                .button(KEY[0]),
                .button_pressed(increment));

	
    // connect the increment signal to a posedge detection
    posedge_detection pos (.clk(CLOCK2_50), .button(increment), .button_edge(level_button_pressed));

	// Difficulty fsm module
	difficulty_fsm diff_fsm ( .clk(CLOCK2_50),
                              .button_edge(level_button_pressed),
                              .level(level));
		
		
	// RNG module scaled by difficulty
   rng_mole rng_module (.clk(CLOCK2_50),
                         .level(level),
                         .random_value(random_value));
	
	 // Timer module
    timer u0 (.clk(CLOCK2_50),
              .reset(reset),
              .up(up),
              .start_value(random_value),
              .enable(enable),
              .timer_value(timer_value));

	
	 // Module for controlling the timer for mole generation
    mole_control_fsm mole_fsm (
        .clk(CLOCK2_50),
        .timer_value(timer_value),
        .reset(reset),
        .up(up),
        .enable(enable),
        .led_on(led_enable)
    );

	// Generate the randomised LED's
    MultiLedRandomiser led_generator(
        .clk(CLOCK2_50),
        .enable(led_enable),
        .ledr(LEDR),
        .level(level)
    );
	
	// Module for displaying the timer for debugging
	display display_0 (.clk(CLOCK2_50),
							.value(timer_value),
							.display0(HEX0),
							.display1(HEX1),
							.display2(HEX2),
							.display3(HEX3));
						
	// Module for dislaying the level
	seven_seg sseg (.bcd(segment_level),
						 .segments(HEX4));
						 


endmodule
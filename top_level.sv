module top_level #(
	parameter MAX_MS=2047
)(
	input 	CLOCK2_50,
	input	[3:0]  KEY,
    input   [17:0] SW,
	output	[17:0] LEDR,
	output 	[6:0]  HEX0,
	output 	[6:0]  HEX1,
	output 	[6:0]  HEX2,
	output 	[6:0]  HEX3,
	output	[6:0]  HEX4
);


    // This is a test script for seeing if moles can be spawned on the FPGA


    // Timer variables
    logic reset, up, enable;
	logic [$clog2(MAX_MS)-1:0] timer_value;
	logic [$clog2(MAX_MS)-1:0] random_value;

    // Difficulty level variables
    logic [1:0] increment, level, level_button_pressed;
	logic [6:0] segment_level;

    // switches for mole hitting variables
    logic [17:0] switches;

    // variable for restarting the game
    logic restart;

    // variable for determining if a mole shoud be up
    logic activate_mole;

    // variable for determining if a mole was successfully hit
    logic increase_point;

    // variable for holding the current score;
    logic [10:0] score;
	

    //
	// Debounce the modules
    //
    debounce d0 (.clk(CLOCK2_50),               // Difficulty button debouncer
                 .button(KEY[1]),
                 .button_pressed(increment));

    // debounce all the switches
    genvar i;
    generate

        for(i=0; i<18; i++) begin  : debounce_switches
            debounce d_i (.clk(CLOCK2_50),
                          .button(SW[i]),
                          .button_pressed(switches[i]));
        end : debounce_switches
    endgenerate

    // debounce the start/restart module
    debounce d2 (.clk(CLOCK2_50),
                 .button(KEY[0]),
                 .button_pressed(restart));

    // connect the increment signal to a posedge detection
    posedge_detection pos (.clk(CLOCK2_50), .button(increment), .button_edge(level_button_pressed));

	// Difficulty fsm module
	difficulty_fsm diff_fsm ( .clk(CLOCK2_50),
                              .button_edge(level_button_pressed),
                              .level(level));
		
	// RNG module scaled by difficulty
   rng_mole mole_timing (.clk(CLOCK2_50),
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
        .led_on(activate_mole)
    );

    // module for generating random leds
    MultiLedRandomiser led_randomiser (.clk(clk),
                                       .enable(activate_mole),
                                       .ledr(LEDR));
	
						
	// Module for dislaying the level
    always_comb begin
		segment_level = {5'b00000, level};
	end
	seven_seg sseg (.bcd(segment_level),
						 .segments(HEX4));

                
	/*
                TO-DO
    - Connect the LEDR, switches to Game_Logic module
    - Connect Hit and restart to the Calc_score module
    - Connect the score to a display module
    */		 
    game_logic g_logic (
        .clk(CLOCK2_50),
        .SW_pressed(switches),
        .ledr(LEDR),
        .point_1(increase_point)
    );

    score_counter score_count (
        .clk(CLOCK2_50),
        .restart(restart),
        .mole_hit(increase_point),
        .score(score)
    );

    display display_0 (
        .clk(CLOCK2_50),
        .value(score),
        .display0(HEX0),
        .display1(HEX1),
        .display2(HEX2),
        .display3(HEX3)
    );



endmodule
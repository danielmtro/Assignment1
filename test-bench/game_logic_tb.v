`timescale 1ns/1ps

module game_logic_tb;
    // Step 1: Define test bench variables and clock:
    // reg      seed;
    reg    [17:0]  SW_pressed;
    reg    [17:0]  ledr; // Inputs as register data type (so we can assign them in the initial block)
    logic     point_1; // Outputs as wire data type (as they are assigned by the DUT)

    reg clk;  // Clock signal for sequential logic

    // Step 2: Instantiate Device Under Test:
    game_logic DUT(
			.clk(clk),// Instantiate the 'Device Under Test' (DUT), an instanceof the game_logic module.
        .SW_pressed(SW_pressed), 
		  .ledr(ledr), // Connect inputs to their respective testbench variables.
        .point_1(point_1)  // Connect outputs to their respective testbench variables.
    );
    // ^^^ Connects ports of the instantiated module to variables in this module with the same port/variable name.

    // Step 3: Toggle the clock variable every 10 time units to create a clock signal **with period = 20 time units**:
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // forever is an infinite loop!
    end

	initial begin
		ledr = 18'b000000000000000000;
		SW_pressed = 18'b000000000000000000;
	end	

    // Step 4: Initial block to specify input values starting from time = 0. Tospecify inputs for time > 0, use the delay operator `#`.
    initial begin  // Run the following code starting from the beginning of thesimulation:
        $dumpfile("waveform.vcd");  // Tell the simulator to dump variables into the 'waveform.vcd' file during the simulation. Required to produce a waveform .vcd file.
        $dumpvars();                // Also required to tell simulator to dump variables into a waveform (with filename specified above).

        //test case 1: ledr is 00000000000100000 and we oscilate over 1 clock cycle to have the SW pressed be the same.
        //Observe output

		 
        #60;
        ledr = 18'b00000000000100000;
		  #60;
        SW_pressed = 18'b000000000000000000;
        #20; 
        SW_pressed  = 18'b00000000000100000;
        #5;
		  $display("Mole hit value when button switched: %b", point_1);
        #16;
        $display("Mole hit value when after 1 clk cycle: %b", point_1);
//        SW_pressed = 000000000000000000;
		  #50;
        $display("Mole hit value after waiting some time: %b", point_1);



        

        $finish(); // Important: must end simulation (or it will go on forever!)
    end


endmodule

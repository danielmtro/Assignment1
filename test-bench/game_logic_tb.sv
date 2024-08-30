`timescale 1ns/1ps

module game_logic_tb;
    // Step 1: Define test bench variables and clock:
    // reg      seed;
    reg    [17:0]  SW_pressed;
    reg    [17:0]  ledr; // display value on LEDs
    logic     point_1; // whether player should receive a point
	 logic [17:0] input_num; //the input number given by the rng generator

    reg clk;  // Clock signal for sequential logic
	logic [17:0] mole_hit_test;
    // Step 2: Instantiate Device Under Test:
    game_logic DUT(
			.clk(clk),// Instantiate the 'Device Under Test' (DUT), an instanceof the game_logic module.
        .SW_pressed(SW_pressed), 
		  .ledr_real(ledr), // Connect inputs to their respective testbench variables.
        .point_1(point_1),
			.input_num(input_num)// Connect outputs to their respective testbench variables.
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
		input_num = 0;
	end	

    // Step 4: Initial block to specify input values starting from time = 0. Tospecify inputs for time > 0, use the delay operator `#`.
    initial begin  // Run the following code starting from the beginning of thesimulation:
        $dumpfile("waveform.vcd");  // Tell the simulator to dump variables into the 'waveform.vcd' file during the simulation. Required to produce a waveform .vcd file.
        $dumpvars();                // Also required to tell simulator to dump variables into a waveform (with filename specified above).

        //test case 1: ledr is 00000000000100000 and the user pushes the correct button
		  //this triggers a point to be won. 

		 $display("STARTING SIMULATION");
        #60;
        input_num = 18'b00000000000100000; 			//an LED turns on
		  #60;
        SW_pressed = 18'b000000000000000000; 		//the user is yet to react 
        #20; 
        SW_pressed  = 18'b00000000000100000; 		//the user whacks the correct mole
		  #40;
//		  input_num = 18'b000000000000000000; 		//the active LED turns off
		  //end of test case 1
		  
		  #30 //viewing time
		  SW_pressed = 18'b000000000000000000; //switches reset to all off 
			#30
			
			//test case 2. The user presses the incorrect button. There is still only 1 led on
		
			input_num = 18'b0000000000100000; 			//an LED turns on
			#20;
			SW_pressed = 18'b00010000000000000; //the user hits the incorrect mole
			#40; 											//viewing time
			//end test case 2
			
			input_num = 18'b0000000000000000;			//reset LEDs to off
			SW_pressed = 18'b0000000000000000;	//reset switches to off
			
			#40;											//changing LED's happened too close to 
			
			//test case 3.1: there are several LEDs on and the user interacts with 1 of them 
			//correctly
			input_num = 18'b0010001000100000; 			//more leds turn on
			#20;
			SW_pressed = 18'b0000000000100000; 	//user whacks 1 mole
			#40;
//			ledr = 18'b0010001000000000;			//mole which was hit is killed. LED turns off
//			#30;											//viewing time
			//end test case 3.1
			
			//test case 3.2: the user then interacts with the second led correctly
			
			SW_pressed = 18'b0010000000100000; 	//user hits a second mole
			#40;
//			ledr  = 18'b0000001000000000; 		//mole dies, LED turns off
			#30;											//viewing time

        $display("FINISHING SIMULATION");

        $finish(); // Important: must end simulation (or it will go on forever!)
    end


endmodule

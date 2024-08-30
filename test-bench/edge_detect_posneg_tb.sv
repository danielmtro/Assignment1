`timescale 1ns/1ps

module edge_detect_tb;
    // Step 1: Define test bench variables and clock:
 
	 reg [17:0] SW_pressed;
	 reg [17:0] SW_edge_det;
    reg clk;  // Clock signal for sequential logic

    // Step 2: Instantiate Device Under Test:
    edge_detect #(.NUM_BITS(18)) DUT (
							.clk(clk),
							.SW_pressed(SW_pressed),
							.SW_edge_det(SW_edge_det)
	 );
	 
    // ^^^ Connects ports of the instantiated module to variables in this module with the same port/variable name.

    // Step 3: Toggle the clock variable every 10 time units to create a clock signal **with period = 20 time units**:
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // forever is an infinite loop!
    end

	initial begin
		SW_pressed = 18'b000000000000000000;
		SW_edge_det = 18'b000000000000000000;
	end
		

    // Step 4: Initial block to specify input values starting from time = 0. Tospecify inputs for time > 0, use the delay operator `#`.
    initial begin  // Run the following code starting from the beginning of thesimulation:
        $dumpfile("waveform.vcd");  // Tell the simulator to dump variables into the 'waveform.vcd' file during the simulation. Required to produce a waveform .vcd file.
        $dumpvars();                // Also required to tell simulator to dump variables into a waveform (with filename specified above).

			#60;
			$display("Edge detection value is: %b", SW_edge_det);
//			#50;
			SW_pressed = 18'b000000000000100000;
			#20;
			$display("edge detection value is: %b", SW_edge_det);
			#20;
			SW_pressed = 18'b000001000000100000;
			$display("edge detection value is: %b", SW_edge_det);




        

        $finish(); // Important: must end simulation (or it will go on forever!)
    end


endmodule

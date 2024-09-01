`timescale 1ns/1ps

module difficulty_fsm_tb;

    // Inputs to the DUT (Device Under Test)
    reg clk;
    reg increment; 

    // Outputs from the DUT
    reg [1:0] level;

    // Instantiate the rng module with specific parameters
    difficulty_fsm dut (
        .clk(clk),
        .button_edge(increment),
        .level(level));

    // Clock generation
    initial begin
        clk = 0;
		  increment = 0;
        level = 2'b00;
        forever #10 clk = ~clk;  // 20ns clock period (50 MHz)
    end

    // Initial conditions and stimulus
    initial begin
        // Dump the waveform to a VCD file
        $dumpfile("waveform.vcd");
        $dumpvars();

        #10;
        // Check what the level is 
        $display("The starting level should be 0. It is %d", level);

        // increase the level 
        #10;
        increment = 1;
        $display("Level has been incremented to 1. It is %d", level);

        #10;
        $display("Level should still be 1. It is %d", level);

        #10;
        increment = 0;
        #10;
        $display("Level should still be 1. It is %d", level);

        #10;
        increment = 1;
        #10;
        $display("Level should be 2. It is %d", level);
		  

        #10;
        increment = 0;
        #10;
        increment = 1;
        #10;
        $display("Level should be 3. It is %d", level);
        increment = 0;
        #10;
        increment = 1;
        #10;
        $display("Level should be 0. It is %d", level);
        increment = 0;
        #10;
        increment = 1;
        $display("Level should be 1. It is %d", level);

        // Run the simulation for a specified time
        #10 $finish();
    end

endmodule
`timescale 1ns/1ps

module rng_mole_tb;

    // Inputs to the DUT (Device Under Test)
    reg clk;
    reg [1:0]  level; 

    // Outputs from the DUT
    wire [10:0] random_value; // 11-bit output, as MAX_VALUE is 1223 

    // Instantiate the rng module with specific parameters
    rng_mole #(
        .OFFSET(300),
		  .LVL_OFFSET(100),
        .MAX_VALUE(1223),
        .SEED(340) // Choose your seed value here
    ) dut (
        .clk(clk),
        .random_value(random_value),
        .level(level)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk;  // 20ns clock period (50 MHz)
    end

    // Initial conditions and stimulus
    initial begin
        // Dump the waveform to a VCD file
        $dumpfile("waveform.vcd");
        $dumpvars();
		  
		  $display("Time\t Level Random Value");
		  $display("%0d\t %b %b", $time, level, random_value);
		  
        #100;
		  
		  
		  // Generate a bunch of random values for level 0 test case
        level = 0;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  
		  
		  // Level 1 testing
        #100;
        level = 1;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  
			
		  // Level 2 Testing
        #100;
        level = 2;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  
		  
		  // Level 3 Testing
        #100
        level = 3;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  #20;
		  $display("%0d\t %d %d", $time, level, random_value);
		  

        // Display header
   

        // Run the simulation for a specified time
        #1000 $finish();
    end

    

endmodule
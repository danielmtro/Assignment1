`timescale 1ns/1ps

module ProbabilityPropagation_tb;

    // Inputs to the DUT (Device Under Test)
    reg clk;
    reg  enable; 

    // Outputs from the DUT
    wire ledr; // 1 bit output for the LED

   logic level;
	 
	real led_on_percentage;
	integer led_on_count = 0;
   integer num_led = 18;

	integer total_cycles = 1000; // Number of cycles to test
	
    // Instantiate the rng module with specific parameters
    ProbabilityPropagation dut (
        .enable(enable),
        .clk(clk),
        .led(ledr),
        .level(level));

    // Clock generation
    initial begin
        clk = 0;
        level = 0;
        forever #10 clk = ~clk;  // 20ns clock period (50 MHz)
    end

    // Initial conditions and stimulus
    initial begin
        // Dump the waveform to a VCD file
        $dumpfile("waveform.vcd");
        $dumpvars();


        // Essentially oscillate the enable signal and observe waveforms
        // Expected behaviour:
        // When enable is low:
        //      led is low
        // When enable is high:
        //      led is high 10% of the time (and stable)

        // Test case 1: enable is low, LEDR should be low
        enable = 0;
        #20;
		  $display("led values when enable is low: %b", ledr);

        // Test case 2: enable is high, LEDR should be high 10% of the time
        enable = 1;
        #20; // Run for a longer time to observe the behavior
        // Note: Since the output is random, we can't assert a specific value here.
        // Instead, we can print the value of LEDR to observe its behavior.
        $display("led values when enable is high: %b", ledr);


        // Test case: Toggle enable and observe LEDR
        #10;
        $display("Beginning automated tests");
    
		  $display("Beginning automated tests");
        for (int i = 0; i < total_cycles; i++) begin: looping_section
            enable = ~enable;
            #20; // Wait for one clock cycle

            if (enable && ledr) begin
                led_on_count++;
            end
        end: looping_section

        // Calculate the percentage of time LEDR is on when enable is high
        led_on_percentage = (led_on_count / (total_cycles / 2.0)) * 100.0;
        $display("LEDR was on %.2f%% of the time when enable was high", led_on_percentage);
	

		  
        $display("Changing to next level");
		  $display("Changing to next level");
		  $display("Changing to next level");
		  $display("Changing to next level");
		  $display("Changing to next level");

		  level = 3;

		  
		  $display("Beginning automated tests");
        for (int i = 0; i < total_cycles; i++) begin: looping_section
            enable = ~enable;
            #20; // Wait for one clock cycle

            if (enable && ledr) begin
                led_on_count++;
            end
        end: looping_section

        // Calculate the percentage of time LEDR is on when enable is high
        led_on_percentage = (led_on_count / (total_cycles / 2.0)) * 100.0;
        $display("LEDR was on %.2f%% of the time when enable was high", led_on_percentage);


        // Run the simulation for a specified time
        #10 $finish();
    end

endmodule
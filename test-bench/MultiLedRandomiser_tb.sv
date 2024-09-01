`timescale 1ns/1ps

module MultiLedRandomiser_tb;

    // Inputs to the DUT (Device Under Test)
    reg clk;
    reg  enable; 

    // Outputs from the DUT
    wire [17:0]ledr; // 18 bit output for all the LED's

    logic [1:0]level;
   
	real led_on_percentage;
	real led_x_on = 0;

	integer led_on_count = 0;
	integer total_cycles = 10; // Number of cycles to test
	integer self_cycles = 1000;
    integer num_led = 18;

    // Instantiate the rng module with specific parameters
    MultiLedRandomiser dut (
        .enable(enable),
        .clk(clk),
        .ledr(ledr),
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
		  
		  
		  $display("Starting at level 1");
    
        for (int i = 0; i < total_cycles; i++) begin: looping_section
            enable = ~enable;
            #20; // Wait for one clock cycle

            led_on_count = 0;
            for (int j = 0; j < num_led; j++) begin: count_led_on

                if (enable && ledr[j]) begin
                    led_on_count = led_on_count + 1;
                end

            end : count_led_on

			if(enable) begin
				$display("Number of LED on %d", led_on_count);
				$display("Current value stored in LED %b", ledr);
			end
	
        end: looping_section
		  
		  
		  // Check the probability when looping through 
        for (int i = 0; i < self_cycles; i++) begin: next_looping_section
            enable = ~enable;
            #20; // Wait for one clock cycle

            if (enable && ledr[0]) begin
                led_x_on++;
            end
        end: next_looping_section

        // Calculate the percentage of time LEDR is on when enable is high
		  
		  $display("We expect a probability of 6.6 per cent here");
        led_on_percentage = (led_x_on / (self_cycles / 2.0)) * 100.0;
        $display("LEDR was on %.2f%% of the time when enable was high", led_on_percentage);
	


		  
        $display("Changing to level 3");

		  level = 3;
		  led_x_on = 0;
        for (int i = 0; i < total_cycles; i++) begin: looping_section
            enable = ~enable;
            #20; // Wait for one clock cycle

            led_on_count = 0;
            for (int j = 0; j < num_led; j++) begin: count_led_on

                if (enable && ledr[j]) begin
                    led_on_count++;
                end

            end : count_led_on
			
			if(enable) begin
				$display("Number of LED on %d", led_on_count);
				$display("Current value stored in LED %b", ledr);
			end
	
        end: looping_section
		  
		  
		  
		  // Check the probability when looping through 
        for (int i = 0; i < self_cycles; i++) begin: next_looping_section2
            enable = ~enable;
            #20; // Wait for one clock cycle

            if (enable && ledr[0]) begin
                led_x_on++;
            end
        end: next_looping_section2

        // Calculate the percentage of time LEDR is on when enable is high
        led_on_percentage = (led_x_on / (self_cycles / 2.0)) * 100.0;
		  
		  $display("We expect a probability of 33 per cent here");
        $display("LEDR was on %.2f%% of the time when enable was high", led_on_percentage);
	



        // Run the simulation for a specified time
        #10 $finish();
    end

endmodule
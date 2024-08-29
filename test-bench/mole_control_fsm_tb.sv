`timescale 1ns/1ps

module mole_control_fsm_tb;

    // Inputs to the DUT (Device Under Test)
    reg clk;
    reg [1:0] timer_value;
    reg [1:0] reset, up, enable, led_on; 


    // Instantiate the rng module with specific parameters
    difficulty_fsm dut (
        .clk(clk),
        .timer_value(timer_value),
        .reset(reset),
        .up(up),
        .enable(enable),
        .led_on(led_on));

    // Clock generation
    initial begin
        clk = 0;
		timer_value = 1;
        reset = 1;
        up = 0;
        enable = 0;
        led_on = 0;
        forever #10 clk = ~clk;  // 20ns clock period (50 MHz)
    end

    // Initial conditions and stimulus
    initial begin
        // Dump the waveform to a VCD file
        $dumpfile("waveform.vcd");
        $dumpvars();

        #10;
        // Check what the inital state output is 
        $display("The initial state is reset: %d, up: %d, enable: %d, led_on: %d", reset, up, enable, led_on);
        $display("Timer value is: %d", timer_value);

        // Check state after LED off state
        #40;
        $display("State is reset: %d, up: %d, enable: %d, led_on: %d", reset, up, enable, led_on);
        $display("Should be reset: 0, up: 0, enable: 1, led_on: 0");
        $display("Timer value is: %d", timer_value);
        timer = 0;

        // Check LED off state with timer_value = 0
        #10;
        $display("State are reset: %d, up: %d, enable: %d, led_on: %d", reset, up, enable, led_on);
        $display("Should be reset: 1, up: 0, enable: 1, led_on: 0", reset, up, enable, led_on);        
        $display("Timer value is: %d", timer_value);
        timer = 1;

        // Check Reset 1 state
        #20;
        $display("reset: %d, up: %d, enable: %d, led_on: %d", reset, up, enable, led_on);
        $display("Should be reset: 1, up: 0, enable: 0, led_on: 0", reset, up, enable, led_on);        
        $display("Timer value is: %d", timer_value);

        // Check LED on state
        #20;
        $display("reset: %d, up: %d, enable: %d, led_on: %d", reset, up, enable, led_on);
        $display("Should be reset: 0, up: 0, enable: 1, led_on: 1", reset, up, enable, led_on); 
        $display("Timer value is: %d", timer_value);
        timer = 0;
        
        #20;
        // Check Reset 1 state
        $display("reset: %d, up: %d, enable: %d, led_on: %d", reset, up, enable, led_on);
        $display("Should be reset: 1, up: 0, enable: 0, led_on: 0", reset, up, enable, led_on);        
        $display("Timer value is: %d", timer_value);

        // Run the simulation for a specified time
        #10 $finish();
    end

endmodule
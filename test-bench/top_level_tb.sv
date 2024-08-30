`timescale 1ns/1ps

module top_level_tb;

    // Inputs
    reg CLOCK2_50;
    reg [3:0] KEY;
    reg [17:0] SW;
    
    // Outputs
    wire [17:0] LEDR;
    wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4;
    
    // Instantiate the top-level module
    top_level #(
        .MAX_MS(2047)
    ) dut (
        .CLOCK2_50(CLOCK2_50),
        .KEY(KEY),
        .SW(SW),
        .LEDR(LEDR),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4)
    );
    
    // Clock generation
    initial begin
        CLOCK2_50 = 0;
        forever #10 CLOCK2_50 = ~CLOCK2_50;  // 20ns clock period (50 MHz)
    end
     
    // Initial stimulus
    initial begin
        // Dump waveform data
        $dumpfile("top_level_waveform.vcd");
        $dumpvars(0, top_level_tb);
        
        // Initialize inputs
        KEY = 4'b1111;  // All buttons unpressed (active low)
        SW = 18'b0;     // All switches off
        
        // Wait before applying stimulus
        #100;
        
        // Simulate pressing the reset button
        KEY[0] = 0;
        #20;
        KEY[0] = 1;  // Release button
        
        // Simulate difficulty level increment button press
        #200;
        KEY[1] = 0;
        #20;
        KEY[1] = 1;  // Release the increment button
        
        // Toggle some switches to simulate hitting moles
        #300;
        SW[0] = 1;
        #40;
        SW[0] = 0;
        SW[1] = 1;
        #40;
        SW[1] = 0;
        
        // Toggle different switches
        #200;
        SW[5] = 1;
        #40;
        SW[5] = 0;
        
        // Simulate incrementing the difficulty level
        #500;
        KEY[1] = 0;
        #20;
        KEY[1] = 1;
        
        // Hit moles
        #100;
        SW[3] = 1;
        #40;
        SW[3] = 0;
        SW[4] = 1;
        #40;
        SW[4] = 0;
        
        // Finish the simulation after some time
        #2000;
        $finish;
    end

    // Monitor and display output values for debugging
    initial begin
        $monitor("Time: %0t | KEY: %b | SW: %b | LEDR: %b | HEX0: %b | HEX1: %b | HEX2: %b | HEX3: %b | HEX4: %b",
                 $time, KEY, SW, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4);
    end

endmodule
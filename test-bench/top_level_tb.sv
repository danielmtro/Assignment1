`timescale 1ns/1ps

module top_level_tb;
    // Inputs to the DUT (Device Under Test)
    reg CLOCK2_50;
    reg [3:0] KEY;
    reg [17:0] SW;

    // Outputs from the DUT
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

    // Inputs to the MultiLedRandomiser
    reg clk;
    reg enable;
    reg [1:0] level;
    
    // Outputs from the MultiLedRandomiser
    wire [17:0] ledr_randomiser;

    // Instantiate the MultiLedRandomiser module
    MultiLedRandomiser randomiser (
        .enable(enable),
        .clk(clk),
        .ledr(ledr_randomiser),
        .level(level)
    );

    // Clock generation
    initial begin
        CLOCK2_50 = 0;
        clk = 0;
        enable = 0;
        level = 0;
        forever #10 CLOCK2_50 = ~CLOCK2_50;  // 20ns clock period (50 MHz)
        forever #10 clk = ~clk;  // 20ns clock period (50 MHz)
    end

    // Initial conditions and stimulus
    initial begin
        // Dump the waveform to a VCD file
        $dumpfile("top_level_waveform.vcd");
        $dumpvars();

        // Initialize inputs
        KEY = 4'b1111;  // All buttons unpressed (active low)
        SW = 18'b0;     // All switches off

        // Display changes
        $monitor("Time: %0t | CLOCK2_50: %b | clk: %b | KEY: %b | SW: %b | LEDR: %b | HEX0: %b | HEX1: %b | HEX2: %b | HEX3: %b | HEX4: %b | Randomiser LEDR: %b",
                 $time, CLOCK2_50, clk, KEY, SW, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, ledr_randomiser);

        // Wait for initial reset propagation
        #1000;

        // Simulate pressing the reset button (active low)
        KEY[0] = 0;
        #200;

        // Release reset
        KEY[0] = 1;

        // Ensure reset is released
        #10000;

        // Toggle enable and observe LEDR values
        #10000;
        enable = 1;
        level = 2; // Change level for randomiser
        #20000;
        enable = 0;

        // Display LED values when enable is low
        #20;
        $display("LEDR values when enable is low: %b", ledr_randomiser);

        // Test case: Toggle enable and observe LEDR
        #10;
        $display("Beginning automated tests");

        for (integer i = 0; i < 100; i++) begin
            enable = ~enable;
            #20; // Wait for one clock cycle

            $display("Cycle %0d: LED values = %b", i, ledr_randomiser);
        end

        // Change level and observe
        #10000;
        level = 1; // Change to another level
        #20000;
        $display("Changing level to %0d", level);

        // Continue with more tests if needed
        #50000;

        // Finish the simulation
        $finish;
    end

endmodule
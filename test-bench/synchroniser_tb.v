`timescale 1ns/1ps

module synchroniser_tb;

    // Inputs
    reg clk;
    reg x;

    // Outputs
    wire y;

    // Instantiate the synchroniser module
    synchroniser dut (
        .clk(clk),
        .x(x),
        .y(y)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk;  // 20ns clock period (50 MHz)
    end

    // Initial conditions and stimulus
    initial begin
        // Dump the waveform to a VCD file
        $dumpfile("synchroniser_waveform.vcd");
        $dumpvars(0, synchroniser_tb);
        
        // Display header
        $display("Time\tclk\tx\ty");

        // Apply tests
        x = 0;
        #15;
        $display("%0t\t%b\t%b\t%b", $time, clk, x, y);

        x = 1;
        #25;
        $display("%0t\t%b\t%b\t%b", $time, clk, x, y);

        x = 0;
        #35;
        $display("%0t\t%b\t%b\t%b", $time, clk, x, y);

        x = 1;
        #45
        $display("%0t\t%b\t%b\t%b", $time, clk, x, y);

        x = 0;
        #55;
        $display("%0t\t%b\t%b\t%b", $time, clk, x, y);

        x = 1;
        #100;
        $display("%0t\t%b\t%b\t%b", $time, clk, x, y);

        x = 0;
        #50;
        $display("%0t\t%b\t%b\t%b", $time, clk, x, y);

        // End the simulation
        $finish;
    end

endmodule
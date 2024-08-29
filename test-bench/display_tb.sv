`timescale 1ns/1ps

module display_tb;

//input         clk,
//    input  [10:0] value,
//    output [6:0]  display0,
//    output [6:0]  display1,
//    output [6:0]  display2,
//    output [6:0]  display3

		reg clk;
		logic [10:0] value;
		logic [6:0] display0;
		logic [6:0] display1;
		logic [6:0] display2;
		logic [6:0] display3;
		
		display DUT (	.clk(clk),
							.value(value),
							.display0(display0),
							.display1(display1),
							.display2(display2),
							.display3(display3)
							
						);
						
		initial begin
        clk = 0;
        forever #1 clk = ~clk; // forever is an infinite loop!
		end
		
		initial begin
			value = 0;
			display0 = 0;
			display1 = 0;
			display2 = 0;
			display3 = 0;
		end
		
		initial begin  // Run the following code starting from the beginning of thesimulation:
        $dumpfile("waveform.vcd");  // Tell the simulator to dump variables into the 'waveform.vcd' file during the simulation. Required to produce a waveform .vcd file.
        $dumpvars();
		  
		  #60;
		  value = 1;
		  #60;
		  $display("Display 0: %b", display0);
		  $display("Display 1: %b", display1);
		  $display("Display 2: %b", display2);
		  $display("Display 3: %b", display3);
		  #40;
		  
		  
		  
		  
		  
		  
		  
		  $finish();
		  
		end
		  
	
endmodule	
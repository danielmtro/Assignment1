/**
When the nth bit of a value is changed, this module returns a value
who's nth bit has a value of 1 and all other bits have a value of 0.

Limitations. 2 clock cycles must be allowed at the beginning of a 
program for the module to recognise the initial state of the given value

The nth bit sets to 1 at the first rising edge. It returns to 0
after 1 full clock period
*/

module edge_detect #(
	  parameter NUM_BITS = 18
	  )(
    input clk,
    input[NUM_BITS - 1:0] SW_pressed,

    output[NUM_BITS - 1:0] SW_edge_det
);
    logic[NUM_BITS - 1:0] button_current;
    logic [NUM_BITS - 1:0] button_prev;

    always_ff @(posedge clk) begin : edge_detect
        button_current <= SW_pressed;
        button_prev <= button_current;        
    end : edge_detect
    
    assign SW_edge_det = (button_prev ^ button_current);

endmodule
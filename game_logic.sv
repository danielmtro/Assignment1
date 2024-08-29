/**
This computes the games logic to decide whether a user has scored a point or not

Limitations: after a button is switched, it takes 2 clock cycles for it to 
process this through to a point being gained.

Limitation: if an LED change happens withing 2 clock cycles of a SW change, the player 
may receive a bonus point

The output is a logical value describing whether there was a successful hit
*/

module game_logic(
    input clk,
    input [17:0] SW_pressed,
    input logic [17:0] input_num,

	output logic [17:0] ledr_real,
    output logic point_1
    //if SW_prev XOR SW_new (SW[x]) has a mole on it    
);
    logic [17:0] SW_edge_det;
    logic [17:0] mole_hit;
	 logic [17:0] ledr_current;
	 logic [17:0] ledr_next;
	 logic [17:0] previous_input;
    // initial previous_input = 0;
	 
	 always_ff @(posedge clk) begin
		previous_input <= input_num;
	 end
	 
	 
	 always_ff @(posedge clk) begin
		if (input_num != previous_input) begin
			ledr_current <= input_num;
		end
		else begin
			ledr_current <= ledr_next;
		end
	 end
	 
	 
	 assign ledr_real = ledr_current;
	 
//	 initial point_1 = 0;

    edge_detect_posneg u0 ( .clk(clk),
                    .SW_pressed(SW_pressed),
                    .SW_edge_det(SW_edge_det));


	 //mole hit has a 1 at the bit location where there was a successful
	 //mole hit
    assign mole_hit = (SW_edge_det & ledr_current);

    always_ff @(posedge clk) begin

        if (mole_hit) begin
            point_1 <= 1;
        end
        else begin
            point_1 <= 0;
        end
    end
	 
	 //assign new value to be used by ledr
	 assign ledr_next = (ledr_current & (~mole_hit));
	 

	 
	 



endmodule
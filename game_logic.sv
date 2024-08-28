/**
This computes the games logic to decide whether a user has scored a point or not

Limitations: after a button is switched, it takes 2 clock cycles for it to 
process this through to a point being gained.

The output is a logical value describing whether there was a successful hit
*/

module game_logic(
    input clk,
    input [17:0] SW_pressed,
    input reg [17:0] ledr,

    output logic point_1,
	 output logic [17:0] mole_hit
	 
    //if SW_prev XOR SW_new (SW[x]) has a mole on it    
);
    logic [17:0] SW_edge_det;
    initial SW_edge_det = 0;
	 
//	 initial point_1 = 0;

    edge_detect u0 ( .clk(clk),
                    .SW_pressed(SW_pressed),
                    .SW_edge_det(SW_edge_det));

//    logic [17:0] mole_hit;

    assign mole_hit = (SW_edge_det & ledr);

    always_ff @(posedge clk) begin

        if (mole_hit) begin
            point_1 <= 1;
        end
        else begin
            point_1 <= 0;
        end
    end



endmodule
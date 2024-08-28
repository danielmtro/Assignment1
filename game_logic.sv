module game_logic(
    input clk,
    input [17:0] SW_pressed,
    input reg [17:0] ledr,

    output logic point_1
    //if SW_prev XOR SW_new (SW[x]) has a mole on it    
);
    logic [17:0] SW_edge_det;
    initial SW_edge_det = 0;
	 
//	 initial point_1 = 0;

    edge_detect u0 ( .clk(clk),
                    .SW_pressed(SW_pressed),
                    .SW_edge_det(SW_edge_det));

    logic [17:0] mole_hit;

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
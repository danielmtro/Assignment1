module game_logic #(
    parameter MAX_VALUE=1223,
    parameter SEED= 483/*Fill-In*/ // Choose a random number seed here!
)(
    input clk,
    input [17:0] SW_pressed,
    input reg [$clog2(MAX_VALUE)-1:0] LEDR,

    output logic mole_hit
    //if SW_prev XOR SW_new (SW[x]) has a mole on it    
);
    logic [17:0] SW_edge_det;
    initial SW_edge_det = 0;
    edge_detect u0 ( .clk(clk),
                    .SW_pressed(SW_pressed),
                    .SW_edge_det(SW_edge_det));

    always_ff @(posedge clk) begin

        if (SW_edge_det==0) begin
            mole_hit <= 0;
        end
        else begin
            mole_hit <= 1;
        end
    end



endmodule
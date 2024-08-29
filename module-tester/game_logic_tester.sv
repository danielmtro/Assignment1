module game_logic_tester	(
	input CLOCK2_50,
	input [17:0] SW,
	
	output [17:0] LEDR,
	
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3
);

	logic [17:0] SW_pressed;
	logic clk;
	assign clk = CLOCK2_50;
	
	logic [10:0] score;
	initial score = 0;
	
	logic point_1;
	
	logic [17:0] input_num;
	logic [17:0] ledr_next;
	assign input_num = 18'b010000100001000100;
	
	
	 genvar i;
    generate

        for(i=0; i<18; i++) begin  : debounce_switches
            debounce d_i (.clk(CLOCK2_50),
                          .button(SW[i]),
                          .button_pressed(SW_pressed[i])
								  );
        end : debounce_switches
    endgenerate
	 
	 //note for usage!!
//	 always_ff @(posedge clk) begin
//		ledr_current <= ledr_next;
//	 end
	 
	 
	 
	 display display_1 (	.clk(clk),
								.value(score),
								.display0(HEX0),
								.display1(HEX1),
								.display2(HEX2),
								.display3(HEX3)
								);
	 game_logic game_logic (	.clk(clk),
										.SW_pressed(SW_pressed),
										.input_num(input_num),
										.point_1(point_1),
										.ledr_real(LEDR)
									);
	 
	 always_ff @(posedge clk) begin
		if (point_1) begin
			score <= score + 1;
		end
		else begin 
			score <= score;
		end
			
	 end 
	 
endmodule
	 
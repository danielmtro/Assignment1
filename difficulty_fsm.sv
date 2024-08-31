module difficulty_fsm(
    input           		  clk,
    input           		  button_edge,
    output logic [1:0]        level
);

//    intial level = 2'b00;

    // State teypedef enum used here
	 // Note that we specify the exact encoding that we want to use for each state
    typedef enum logic [1:0] {
        LVL1 = 2'b00,
        LVL2 = 2'b01,
        LVL3 = 2'b10,
        LVL4 = 2'b11
    } state_type;
    state_type current_state = LVL1, next_state;

    // always_comb block for next state logic
    always_comb begin
        next_state = current_state;

        case(current_state)

            LVL1: begin
                next_state = (button_edge == 1'b1) ? LVL2 : LVL1;
            end
            LVL2: begin
                next_state = (button_edge == 1'b1) ? LVL3 : LVL2;
            end
            LVL3: begin
                next_state = (button_edge == 1'b1) ? LVL4 : LVL3;
            end
            LVL4: begin
                next_state = (button_edge == 1'b1) ? LVL1: LVL4;
            end
            default: next_state = LVL1;
        endcase
    end

    // always_ff for FSM state variable flip_flops
    always_ff @(posedge clk) begin
        current_state <= next_state;
    end

    // assign outputs
    assign level = current_state;

endmodule
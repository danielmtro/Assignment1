module difficulty_fsm(
    input           		  clk,
    input           		  increment,
    output logic [1:0]    level
);

    intial level = 0;

    // Edge detection block here!
    logic button_q0, button_edge;
    always_ff @(posedge clk) begin : edge_detect
        button_q0 <= increment;
    end : edge_detect

    assign button_edge = (increment > button_q0);

    // State teypedef enum used here
    typedef enum logic [1:0] {LVL1, LVL2, LVL3, LVL4} state_type;
    state_type current_state, next_state;

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
        endcase
    end

    // always_ff for FSM state variable flip_flops
    always_ff @(posedge clk) begin
        current_state <= next_state;
    end

    // assign outputs
    assign level = current_state;

endmodule
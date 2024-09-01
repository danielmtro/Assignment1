module mole_control_fsm #(
    parameter MAX_MS=2047  
)(
    input                             clk,
    input        [$clog2(MAX_MS)-1:0] timer_value,
    output logic                      reset,
    output logic                      up,
    output logic                      enable,
    output logic                      led_on
);


    // State teypedef enum used here
    typedef enum logic [1:0] {RESET_0, LED_OFF, RESET_1, LED_ON} state_type;
    (* syn_encoding = "one-hot" *) state_type current_state, next_state;
	 
    // always_comb block for next state logic
    always_comb begin
        next_state = current_state;

        case(current_state)

            RESET_0: begin
                next_state = LED_OFF;
            end
            LED_OFF: begin
                next_state = (reset == 1'b1) ? RESET_1 : LED_OFF;
            end
            RESET_1: begin
                next_state = LED_ON;
            end
            LED_ON: begin
                next_state = (reset == 1'b1) ? RESET_0: LED_ON;
            end
        endcase
    end

    // always_ff for FSM state variable flip_flops
    always_ff @(posedge clk) begin
        current_state <= next_state;
    end

    // assign outputs
    assign led_on = (current_state == LED_ON) ? 1 : 0;

    always_comb begin
        
        if(current_state == RESET_0)begin           // First reset state
            enable = 0;
            reset = 1;
            up = 0;
        end
        else if(current_state == RESET_1) begin     // Second Reset State
            enable = 0;
            up = 0;
            reset = 1;
        end
        else if(current_state == LED_OFF) begin     // LED off state
            enable = 1;
            up = 0;
            reset = (timer_value == 0); 
        end
        else begin                                  // LED on state
            enable = 1;
            up = 0;
            reset = (timer_value == 0); 
        end
    end

endmodule
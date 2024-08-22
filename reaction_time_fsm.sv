module reaction_time_fsm #(
    parameter MAX_MS=2047  
)(
    input                             clk,
    input                             button_pressed,
    input        [$clog2(MAX_MS)-1:0] timer_value,
    output logic                      reset,
    output logic                      up,
    output logic                      enable,
    output logic                      led_on
);


    // Edge detection block here!
    logic button_q0, button_edge;
    always_ff @(posedge clk) begin : edge_detect
        button_q0 <= button_pressed;
    end : edge_detect

    assign button_edge = (button_pressed > button_q0);

    // State typedef enum here! (See 3.1 code snippets)

    typedef enum logic [1:0] {S0, S1, S2, S3} state_type;
    state_type current_state, next_state; 
   
    // always_comb for next_state_logic here! (See 3.1 code snippets)
    always_comb begin
        next_state = current_state; // Default Value for next_state
        case (current_state)
            S0: begin
                next_state = (button_edge == 1'b1) ? S1 : S0;  // Use enum for state variable.
            end
            S1: begin
                next_state = (reset == 1'b1) ? S2 : S1;
            end
            S2: begin
                next_state = (button_edge == 1'b1) ? S3 : S2;
            end
            S3: begin
                next_state = (button_edge == 1'b1) ? S0 : S3;
            end
        endcase
    end
    
    // always_ff for FSM state variable flip-flops here! (See 3.1 code snippets)
    always_ff @(posedge clk) begin
        current_state <= next_state;
    end

    // Continuously assign outputs here! (See 3.1 code snippets)
    assign led_on = (current_state == S2) ? 1 : 0;
    assign up = (current_state == S1) ? 1: 0;
    
    always_comb begin
        if(current_state == S0)begin
            enable = 0;
            reset = 1;
        end
        else if(current_state == S1) begin
            enable = 1;
            reset = (timer_value == 0); 
        end
        else if(current_state == S2) begin
            enable = 1;
            reset = 0;
        end
        else begin
            enable = 0;
            reset = 0;
        end
    end

endmodule
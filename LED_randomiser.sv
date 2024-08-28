module LED_randomiser#(
    parameter PROBABILITY=10,
    parameter SEED=1
)(
    input           		  enable,
    input                     clk,
    output logic              led
);
    /*
    Module takes in a signal (on) which tells whether or not the LED should be on.

    The LED then has a specified probability of being on.
    */
    logic on_q0, LED_Changed;
    logic [10:0] random_value;
    
    // Edge detection block here!
    always_ff @(posedge clk) begin : edge_detect
        on_q0 <= enable;
    end : edge_detect
    assign LED_Change = (enable > on_q0);

    // Create the random number here
    rng #(.SEED(SEED)) random_module (
        .clk(clk), 
        .random_value(random_value)
    );

    always_ff @(posedge clk) begin

        if (enable) begin

            // Only update if the LED change has occured
            if (LED_Change) begin
                led <= (random_value%10 == 0) ? 1'b1 : 1'b0;
            end

        end
        else begin
            led <= 1'b0;
        end

    end

endmodule
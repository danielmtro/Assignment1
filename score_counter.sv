module score_counter #(
    parameter MAX_SCORE = 9999
)(
    input                               clk,
    input                               restart,
    input                               increase_score,
    output reg [$clog2(MAX_SCORE)-1:0]  score
);
    /*
    Module takes in 2 inputs
    
    @param: restart - whether the button has been pressed to zero the score
    @param: increase_score - Should the score be incremented

    output - a score (should be 4 digits in decimal or 10 bits of binary)

    edge cases: overflowing the score > 2047 will cause it to reset back to zero
    */

    // always ff block updates the score every clock cycle if we hit a mole
    always_ff @(posedge clk) begin

        if(restart || score > MAX_SCORE - 1) begin
            score <= 0;     // set the score to zero if a restart is triggered or max score is reached
        end
        else if(increase_score) begin
            score <= score + 1;  // increment the score
            end
        else begin
            score <= score;
        end 
    end


endmodule
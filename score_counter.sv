module score_counter #(
    parameter MAX_SCORE = 9999
)(
    input                           clk,
    input                           restart,
    input                           mole_hit,
    output                    [10:0]score,
);

    /*
    Module takes in 2 inputs
    
    @param: restart - whether the button has been pressed to zero the score
    @param: mole_hit - Should the score be incremented

    output - a score (should be 4 digits in decimal or 10 bits of binary)

    edge cases: overflowing the score > 2047 will cause it to reset back to zero
    */

    // always ff block updates the score every clock cycle if we hit a mole
    always_ff @(posedge clk) begin

        if(restart) begin
            score <= 0;     // set the score to zero if a restart is triggered
        end
        else if(mole_hit) begin
            score <= score + 1;  // increment the score
            end
    end


endmodule
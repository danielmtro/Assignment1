module score_counter #(
    parameter MAX_SCORE = 2047
)(
    input                               clk,
    input                               restart,
    input                               increase_score,
    output reg [10:0]  score
);

    // always_ff block updates the score every clock cycle
    always_ff @(posedge clk) begin

        if(restart) begin
            score <= 0;     // set the score to zero if a restart is triggered
        end
        else if(increase_score) begin
            score <= score + 1;  // increment the score
            end
        else begin
            score <= score;
        end 
    end


endmodule
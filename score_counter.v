module score_counter ( parameter MAX_SCORE = 9999;
    )
(
    input mole_hit,
    input clk,
    input rst,

    output reg [$clog2(MAX_SCORE)-1:0] count
);
    initial count = 0;

    always @(posedge clk) begin
        if (rst) begin
            count <= 0;
        end
        else if (mole_hit) begin
            count <= count + 1;
        end
        else begin
            count <= count;
        end
    end

endmodule
`timescale 1ns/1ps

module score_counter_tb;

    // Parameters
    parameter MAX_SCORE = 9999;

    // Inputs
    reg clk;
    reg restart;
    reg mole_hit;

    // Outputs
    wire [$clog2(MAX_SCORE)-1:0] score;

    // Instantiate the score_counter module
    score_counter #(MAX_SCORE) uut (
        .clk(clk),
        .restart(restart),
        .mole_hit(mole_hit),
        .score(score)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // forever is an infinite loop!
    end

    // Test procedure
    initial begin
        // Initialize inputs
        restart = 0;
        mole_hit = 0;

        // Wait for global reset
        #20;

        // Test restart functionality
        restart = 1;
        #20;
        restart = 0;
        if (score !== 0) $display("Test failed: Restart did not set score to 0");

        // Random mole_hit, checking score increments and wraps at MAX_SCORE
        repeat (MAX_SCORE + 10) begin
            #20;
            mole_hit = 1;
            #20;
            mole_hit = 0;

            // Check if score wraps around after reaching MAX_SCORE
            if (score == 0 && restart == 0 && $time > (MAX_SCORE * 20)) begin
                $display("Test passed: Score reset after reaching MAX_SCORE");
            end else if (score == MAX_SCORE - 1) begin
                $display("Test passed: Score reached MAX_SCORE - 1");
            end else if (score > MAX_SCORE) begin
                $display("Test failed: Score exceeded MAX_SCORE");
            end
        end

        // Test manual restart during operation
        restart = 1;
        #20;
        restart = 0;
        if (score !== 0) $display("Test failed: Restart did not set score to 0 after being pressed during counting");

        // Finish simulation
        $finish();
    end

endmodule

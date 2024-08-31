`timescale 1ns/1ps

module score_counter_tb;

    // Parameter
    parameter MAX_SCORE = 2047;

    // Inputs
    reg clk;
    reg restart;
    reg mole_hit;

    // Outputs
    wire [$clog2(MAX_SCORE)-1:0] score;

    // Instantiate the score_counter module
    score_counter #(MAX_SCORE) dut (
        .clk(clk),
        .restart(restart),
        .increase_score(mole_hit),
        .score(score)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // forever is an infinite loop!
    end

    // Test procedure
    initial begin
        $dumpfile("tb.vcd");  // Create a waveform file
        $dumpvars();

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

        // Random mole_hit, checking score increments and wraps at MAX_SCORE finishing at a score of 10
        repeat (MAX_SCORE + 10) begin // Should 
            #20;
            mole_hit = 1;
            #20;
            mole_hit = 0;   // Increases the score by flipping the mole_hit variable between 1 and 0
            $display("Score: %d", score);
            // Check if score wraps around after reaching MAX_SCORE
            if (score == 0 && restart == 0 && $time > (MAX_SCORE * 10)) begin
                $display("Test passed: Score reset after reaching MAX_SCORE");
            end
            else if (score == MAX_SCORE) begin // Check that counter can reach MAX_SCORE
                $display("Test passed: Score reached MAX_SCORE");
            end
            else if (score > MAX_SCORE) begin
                $display("Test failed: Score exceeded MAX_SCORE");
            end
        end

        // Test manual restart during operation
        restart = 1;
        #20;
        restart = 0;
        
        if (score !== 0) $display("Test failed: Restart did not set score to 0 after being pressed during counting");
        else $display("Test passed: Restart reset the score to 0");
        $display("Score: %d", score);

        // Finish simulation
        $finish();
    end

endmodule

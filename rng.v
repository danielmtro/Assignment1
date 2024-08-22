module rng #(
    parameter OFFSET=200,
    parameter MAX_VALUE=1223,
    parameter SEED= 483/*Fill-In*/ // Choose a random number seed here!
) (
    input clk,
    output [$clog2(MAX_VALUE)-1:0] random_value // 11-bits for values 200 to 1223.
);
    reg [10:1] lfsr; // The 10-bit Linear Feedback Shift Register. Note the 10 down-to 1. (No bit-0, we count from 1 in this case!)

    // Initialise the shift reg to SEED, which should be a non-zero value:
    initial lfsr = SEED;

    // Set the feedback:
    wire feedback;
    assign feedback = lfsr[10] + lfsr[7]; /* FILL-IN */

    // Put shift register logic here (use an always @(posedge clk) block):
    //    Make sure to shift left from bit 1 (LSB) towards bit 10 (MSB).

    always @(posedge clk) begin
        
        // Loop through the 10 bits 
        for(int i=10; i > 1; i = i - 1)begin
            lfsr[i] <= lfsr[i - 1];
        end
    
        lfsr[1] <= feedback;
    end
    // Assign random_value to your LSFR output + OFFSET to acheive the range 200 to 1223. Use continuous assign!

    assign random_value = lfsr + OFFSET;
endmodule

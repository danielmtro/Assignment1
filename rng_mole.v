module rng #(
    parameter OFFSET=150,
    parameter MAX_VALUE=1223,
    parameter SEED= 483/*Fill-In*/ // Choose a random number seed here!
) (
    input clk,
    input level,
    output [$clog2(MAX_VALUE)-1:0] random_value // 11-bits for values 200 to 1223.
);

    // Level incrementer to have levels staged between 1 - 4
    wire lvl_adder = level + 1;  
    wire [10:1] netOffset = OFFSET * lvl_adder;

    reg [10:1] lfsr; // The 10-bit Linear Feedback Shift Register. Note the 10 down-to 1. (No bit-0, we count from 1 in this case!)

    // Initialise the shift reg to SEED, which should be a non-zero value:
    initial lfsr = SEED;

    // Set the feedback:
    wire feedback;
    assign feedback = lfsr[10] + lfsr[7]; 

    // Put shift register logic here (use an always @(posedge clk) block):
    //    Make sure to shift left from bit 1 (LSB) towards bit 10 (MSB).

    always @(posedge clk) begin
        lfsr <= {lfsr[9:1], feedback}; // Shift left and insert feedback at LSB
    end
    // Assign random_value to your LSFR output + OFFSET to acheive the range 200 to 1223. Use continuous assign!
    
    assign random_value = lfsr + netOffset;
endmodule

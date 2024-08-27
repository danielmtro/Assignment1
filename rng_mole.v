module rng_mole #(
    parameter OFFSET=300,
    parameter LVL_OFFSET = 100,
    parameter MAX_VALUE=1223,
    parameter SEED= 483/*Fill-In*/ // Choose a random number seed here!
) (
    input clk,
    input [1:0] level,
    output reg [$clog2(MAX_VALUE)-1:0] random_value // 11-bits for values 200 to 1223.
);
    /*
    RNG mole generation logic that will control how long a mole should be up/down for.

    Works as follows:

    We generate an random number in range (OFFSET, MAX_VALUE) (call this init)
    We output the following
    if level = 0:  init
    if level = 1: init/2 + LVL_OFFSET
    if level = 2: init/4 + LVL_OFFSET
    if level = 3: init/8 + LVL_OFFSET
    */

    // Level incrementer to have levels staged between 1 - 4
    wire lvl_adder = level + 1;  
    wire [$clog2(MAX_VALUE)-1:0]init;
    reg [$clog2(MAX_VALUE)-1:0]temp_value;

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
    assign init = lfsr + OFFSET;

    // Generate the control for scaling the random number based on level
    // TO-do try changing this from a concatenation operator to a bit-shift operator
    always @(posedge clk)begin

        case(level)

            2'b00 : temp_value <= init;                 // (300, 1223)
            2'b01 : temp_value <= {1'b0, init[9:1]};    // (250, 711)
            2'b10 : temp_value <= {2'b00, init[9:2]};   // (175, 405)
            2'b11 : temp_value <= {3'b000, init[9:3]};  // (137, 252)
            default: temp_value <= init;
        endcase
	 end

    // Asssign the output
	 always @(posedge clk) begin
		random_value <= temp_value + LVL_OFFSET;
    end



endmodule

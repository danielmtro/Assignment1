module posedge_detection(
    input           		  clk,
    input           		  button,
    output                button_edge
);

//    intial level = 2'b00;

    // Rising edge detection block here!
    logic button_q0 = 0;
    always_ff @(posedge clk) begin : edge_detect
        button_q0 <= button;
    end : edge_detect
    assign button_edge = (button > button_q0);

endmodule
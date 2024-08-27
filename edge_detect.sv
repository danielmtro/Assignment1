module name #() (
    input clk,
    input[17:0] SW_pressed,

    output[17:0] SW_edge_det
);
    logic[17:0] button_q0;
    always_ff @(posedge clk) begin : edge_detect
        button_q0 <= SW_pressed;
    end : edge_detect
    
    assign SW_edge_det = (SW_pressed > button_q0);
endmodule
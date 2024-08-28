module name #() (
    input clk,
    input[17:0] SW_pressed,

    output[17:0] SW_edge_det
);
    logic[17:0] button_current;
    logic [17:0] button_prev;

    always_ff @(posedge clk) begin : edge_detect
        button_current <= SW_pressed;
        button_prev <= button_current;        
    end : edge_detect
    
    assign SW_edge_det = (button_prev ^ button_current);

    // assign SW_edge_det = (SW_pressed > button_q0);
endmodule
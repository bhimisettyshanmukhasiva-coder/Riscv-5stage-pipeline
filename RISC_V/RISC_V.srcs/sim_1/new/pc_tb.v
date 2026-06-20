`timescale 1ns/1ps

module pc_tb;

reg clk;
reg reset;
wire [31:0] pc_out;

pc uut (
    .clk(clk),
    .reset(reset),
    .pc_out(pc_out)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Reset sequence
initial begin
    reset = 1;
    #20;
    reset = 0;
    #100;
    $finish;
end

endmodule
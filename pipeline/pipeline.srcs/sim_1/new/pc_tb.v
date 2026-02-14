`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.02.2026 14:38:12
// Design Name: 
// Module Name: pc_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pc_tb;

reg clk;
reg reset;
reg [31:0] next_pc;
wire [31:0] pc_out;

// Instantiate PC
pc uut(
    .clk(clk),
    .reset(reset),
    .next_pc(next_pc),
    .pc_out(pc_out)
);

// Clock generation
always #5 clk = ~clk;

initial
begin
    clk = 0;
    reset = 1;
    next_pc = 0;

    #10 reset = 0;

    #10 next_pc = 4;
    #10 next_pc = 8;
    #10 next_pc = 12;
    #10 next_pc = 16;

    #50 $finish;
end

endmodule

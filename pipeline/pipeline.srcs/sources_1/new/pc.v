`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.02.2026 14:37:15
// Design Name: 
// Module Name: pc
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


module pc(
    input clk,
    input reset,
    input [31:0] next_pc,
    output reg [31:0] pc_out
);

always @(posedge clk or posedge reset)
begin
    if(reset)
        pc_out <= 32'b0;
    else
        pc_out <= next_pc;
end

endmodule


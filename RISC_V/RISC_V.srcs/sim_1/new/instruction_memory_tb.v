`timescale 1ns/1ps

module instruction_memory_tb;

reg [31:0] addr;
wire [31:0] instruction;

instruction_memory uut (
    .addr(addr),
    .instruction(instruction)
);

initial begin
    addr = 0;
    #10 addr = 4;
    #10 addr = 8;
    #10 addr = 12;
    #10 addr = 16;
    #20 $finish;
end

endmodule
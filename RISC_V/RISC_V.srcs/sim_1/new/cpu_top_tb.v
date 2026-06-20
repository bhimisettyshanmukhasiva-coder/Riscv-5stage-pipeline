
`timescale 1ns/1ps

module cpu_top_tb;

reg clk;
reg reset;

// Debug outputs from cpu_top
wire [31:0] pc_if;
wire [31:0] instruction_if;
wire [31:0] alu_result_wb_out;


// ==========================
// Instantiate CPU
// ==========================

cpu_top uut (
    .clk(clk),
    .reset(reset),
    .pc_if(pc_if),
    .instruction_if(instruction_if),
    .alu_result_wb_out(alu_result_wb_out)
);


// ==========================
// Clock Generation
// ==========================

initial begin
    clk = 0;
end

always #5 clk = ~clk;   // 10 ns clock period


// ==========================
// Reset Sequence
// ==========================

initial begin
    reset = 1;
    #20;
    reset = 0;
end


// ==========================
// Monitor signals (for debug)
// ==========================

initial begin
    $display("Time\tPC\t\tInstruction\tALU_Result");
    $monitor("%0t\t%h\t%h\t%h",
             $time, pc_if, instruction_if, alu_result_wb_out);
end


// ==========================
// Simulation Stop
// ==========================

initial begin
    #300;        // run simulation for 300 ns
    $display("Simulation Finished");
    $finish;
end


endmodule


module instruction_memory (
    input  [31:0] addr,
    output [31:0] instruction
);

reg [31:0] memory [0:31];
integer i;

initial begin
    // Initialize memory to 0
    for (i = 0; i < 32; i = i + 1)
        memory[i] = 32'd0;

    // ==========================
    // LOAD-USE HAZARD TEST
    // ==========================

 memory[0] = 32'h00500093;  // addi x1, x0, 5
memory[1] = 32'h00A00113;  // addi x2, x0, 10
memory[2] = 32'h002081B3;  // add  x3, x1, x2   (forwarding)
memory[3] = 32'h00310233;  // add  x4, x2, x3   (forwarding chain)

memory[4] = 32'h00002083;  // lw   x1, 0(x0)    (load)
memory[5] = 32'h00108133;  // add  x2, x1, x1   (STALL required)

memory[6] = 32'h002081B3;  // add  x3, x1, x2   (forward after stall)
memory[7] = 32'h40110233;  // sub  x4, x2, x1   (final check)
end

assign instruction = memory[addr[31:2]];

endmodule
module data_memory(
    input clk,
    input mem_write,
    input mem_read,
    input [31:0] address,
    input [31:0] write_data,
    output [31:0] read_data
);

reg [31:0] memory [0:255];
integer i;

// ? INITIALIZE MEMORY
initial begin
    for (i = 0; i < 256; i = i + 1)
        memory[i] = 32'd0;

    // Optional: set specific values
    memory[0] = 32'd10;   // so lw x1, 0(x0) ? x1 = 10
end

// Write
always @(posedge clk) begin
    if (mem_write)
        memory[address[31:2]] <= write_data;
end

// Read
assign read_data = (mem_read) ? memory[address[31:2]] : 32'b0;

endmodule
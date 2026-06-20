module if_id (
    input clk,
    input reset,
    input stall,                  // ? ADDED

    input  [31:0] pc_in,
    input  [31:0] instruction_in,

    output reg [31:0] pc_out,
    output reg [31:0] instruction_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        pc_out <= 32'd0;
        instruction_out <= 32'd0;
    end
    else if (stall) begin
        // ? HOLD VALUES (DO NOTHING)
        pc_out <= pc_out;
        instruction_out <= instruction_out;
    end
    else begin
        // NORMAL OPERATION
        pc_out <= pc_in;
        instruction_out <= instruction_in;
    end
end

endmodule
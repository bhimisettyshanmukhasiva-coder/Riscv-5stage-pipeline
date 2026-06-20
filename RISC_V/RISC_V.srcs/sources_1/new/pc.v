module pc (
    input clk,
    input reset,
    input stall,              // ? ADDED
    output reg [31:0] pc_out
);

always @(posedge clk or posedge reset) begin
    if (reset)
        pc_out <= 32'd0;      // Reset PC to 0
    else if (!stall)          // ? ONLY UPDATE WHEN NO STALL
        pc_out <= pc_out + 32'd4;
    else
        pc_out <= pc_out;     // ? HOLD VALUE (STALL)
end

endmodule
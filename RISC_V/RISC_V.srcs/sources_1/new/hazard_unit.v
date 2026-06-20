module hazard_unit(
    input [4:0] rs1_id,
    input [4:0] rs2_id,

    input [4:0] rd_ex,
    input       mem_read_ex,

    output reg stall
);

always @(*) begin
    if (mem_read_ex &&
       ((rd_ex == rs1_id) || (rd_ex == rs2_id)))
        stall = 1;
    else
        stall = 0;
end

endmodule
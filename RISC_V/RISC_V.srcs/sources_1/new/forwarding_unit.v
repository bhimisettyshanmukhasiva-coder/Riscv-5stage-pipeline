module forwarding_unit(
    input [4:0] rs1_ex,
    input [4:0] rs2_ex,

    input [4:0] rd_mem,
    input       reg_write_mem,

    input [4:0] rd_wb,
    input       reg_write_wb,

    output reg [1:0] ForwardA,
    output reg [1:0] ForwardB
);

always @(*) begin
    // default: no forwarding
    ForwardA = 2'b00;
    ForwardB = 2'b00;

    // EX hazard (EX/MEM stage)
    if (reg_write_mem && (rd_mem != 0) && (rd_mem == rs1_ex))
        ForwardA = 2'b10;

    if (reg_write_mem && (rd_mem != 0) && (rd_mem == rs2_ex))
        ForwardB = 2'b10;

    // MEM hazard (MEM/WB stage)
    if (reg_write_wb && (rd_wb != 0) && 
        !(reg_write_mem && (rd_mem != 0) && (rd_mem == rs1_ex)) &&
        (rd_wb == rs1_ex))
        ForwardA = 2'b01;

    if (reg_write_wb && (rd_wb != 0) && 
        !(reg_write_mem && (rd_mem != 0) && (rd_mem == rs2_ex)) &&
        (rd_wb == rs2_ex))
        ForwardB = 2'b01;
end

endmodule
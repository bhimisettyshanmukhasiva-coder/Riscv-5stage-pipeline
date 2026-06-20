module id_ex(
    input clk,
    input reset,
    input stall,   // ? ADDED

    input  [31:0] read_data1_in,
    input  [31:0] read_data2_in,
    input  [31:0] imm_in,
    input  [2:0]  funct3_in,
    input  [6:0]  funct7_in,
    input  [6:0]  opcode_in,
    input  [4:0]  rd_in,

    input  [4:0]  rs1_in,
    input  [4:0]  rs2_in,

    input         alu_src_in,

    // control signals
    input  reg_write_in,
    input  mem_read_in,
    input  mem_write_in,
    input  mem_to_reg_in,

    output reg [31:0] read_data1_out,
    output reg [31:0] read_data2_out,
    output reg [31:0] imm_out,
    output reg [2:0]  funct3_out,
    output reg [6:0]  funct7_out,
    output reg [6:0]  opcode_out,
    output reg [4:0]  rd_out,

    output reg [4:0]  rs1_out,
    output reg [4:0]  rs2_out,

    output reg        alu_src_out,

    // control signals
    output reg reg_write_out,
    output reg mem_read_out,
    output reg mem_write_out,
    output reg mem_to_reg_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        read_data1_out <= 0;
        read_data2_out <= 0;
        imm_out        <= 0;
        funct3_out     <= 0;
        funct7_out     <= 0;
        opcode_out     <= 0;
        rd_out         <= 0;
        rs1_out        <= 0;
        rs2_out        <= 0;
        alu_src_out    <= 0;

        reg_write_out  <= 0;
        mem_read_out   <= 0;
        mem_write_out  <= 0;
        mem_to_reg_out <= 0;
    end

  else if (stall) begin
    // ? KEEP DATA (DO NOT ZERO)
    read_data1_out <= read_data1_in;
    read_data2_out <= read_data2_in;
    imm_out        <= imm_in;
    funct3_out     <= funct3_in;
    funct7_out     <= funct7_in;
    opcode_out     <= opcode_in;
    rd_out         <= rd_in;
    rs1_out        <= rs1_in;
    rs2_out        <= rs2_in;
    alu_src_out    <= alu_src_in;

    // ? ONLY CONTROL SIGNALS = 0 (NOP)
    reg_write_out  <= 0;
    mem_read_out   <= 0;
    mem_write_out  <= 0;
    mem_to_reg_out <= 0;
end

    // NORMAL FLOW
    else begin
        read_data1_out <= read_data1_in;
        read_data2_out <= read_data2_in;
        imm_out        <= imm_in;
        funct3_out     <= funct3_in;
        funct7_out     <= funct7_in;
        opcode_out     <= opcode_in;
        rd_out         <= rd_in;
        rs1_out        <= rs1_in;
        rs2_out        <= rs2_in;
        alu_src_out    <= alu_src_in;

        reg_write_out  <= reg_write_in;
        mem_read_out   <= mem_read_in;
        mem_write_out  <= mem_write_in;
        mem_to_reg_out <= mem_to_reg_in;
    end
end

endmodule
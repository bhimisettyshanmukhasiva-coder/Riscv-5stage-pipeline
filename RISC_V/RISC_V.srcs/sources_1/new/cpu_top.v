module cpu_top(
    input clk,
    input reset,

    // Debug Outputs
    output [31:0] pc_if,
    output [31:0] instruction_if,
    output [31:0] alu_result_wb_out
);

// ==========================
// Internal Wires
// ==========================

// IF stage
wire [31:0] pc_if_w;
wire [31:0] instruction_if_w;

// IF/ID
wire [31:0] pc_id_w;
wire [31:0] instruction_id_w;

// Decode
wire [6:0]  opcode_w;
wire [4:0]  rd_w;
wire [2:0]  funct3_w;
wire [4:0]  rs1_w;
wire [4:0]  rs2_w;
wire [6:0]  funct7_w;

// Register File
wire [31:0] read_data1_w;
wire [31:0] read_data2_w;

// Immediate
wire [31:0] imm_w;
wire [31:0] imm_ex;

// Control signals
wire alu_src_ctrl, alu_src_ex;
wire reg_write_ctrl, mem_read_ctrl, mem_write_ctrl, mem_to_reg_ctrl;
wire reg_write_ex, mem_read_ex, mem_write_ex, mem_to_reg_ex;
wire reg_write_mem, mem_read_mem, mem_write_mem, mem_to_reg_mem;
wire reg_write_wb, mem_to_reg_wb;

// ID/EX
wire [31:0] read_data1_ex, read_data2_ex;
wire [2:0]  funct3_ex;
wire [6:0]  funct7_ex, opcode_ex;
wire [4:0]  rd_ex, rs1_ex, rs2_ex;

// EX
wire [31:0] alu_result_ex;
reg  [31:0] operand1, operand2;
wire [31:0] operand2_final;

// EX/MEM
wire [31:0] alu_result_mem;
wire [4:0]  rd_mem;
wire [31:0] write_data_mem;

// MEM
wire [31:0] mem_read_data;

// MEM/WB
wire [31:0] alu_result_wb;
wire [4:0]  rd_wb;

// Write back mux
wire [31:0] write_back_data;

// Forwarding
wire [1:0] ForwardA;
wire [1:0] ForwardB;
wire stall;

// ==========================
// IF Stage
// ==========================

pc pc_inst(
    .clk(clk),
    .reset(reset),
    .stall(stall), 
    .pc_out(pc_if_w)
);

instruction_memory imem_inst(
    .addr(pc_if_w),
    .instruction(instruction_if_w)
);


// ==========================
// IF/ID
// ==========================

if_id if_id_inst(
    .clk(clk),
    .reset(reset),
    .stall(stall), 
    .pc_in(pc_if_w),
    .instruction_in(instruction_if_w),
    .pc_out(pc_id_w),
    .instruction_out(instruction_id_w)
);


// ==========================
// ID Stage
// ==========================

instruction_decode id_inst(
    .instruction(instruction_id_w),
    .opcode(opcode_w),
    .rd(rd_w),
    .funct3(funct3_w),
    .rs1(rs1_w),
    .rs2(rs2_w),
    .funct7(funct7_w)
);

// Immediate Generation
reg [31:0] imm_reg;

always @(*) begin
    case(opcode_w)
        7'b0010011, 7'b0000011:
            imm_reg = {{20{instruction_id_w[31]}}, instruction_id_w[31:20]};
        7'b0100011:
            imm_reg = {{20{instruction_id_w[31]}},
                       instruction_id_w[31:25],
                       instruction_id_w[11:7]};
        default:
            imm_reg = 32'b0;
    endcase
end

assign imm_w = imm_reg;


// Control Unit
control_unit cu_inst(
    .opcode(opcode_w),
    .reg_write(reg_write_ctrl),
    .mem_read(mem_read_ctrl),
    .mem_write(mem_write_ctrl),
    .alu_src(alu_src_ctrl),
    .mem_to_reg(mem_to_reg_ctrl)
);


// Register File
register_file rf_inst(
    .clk(clk),
    .reset(reset),
    .rs1(rs1_w),
    .rs2(rs2_w),
    .rd(rd_wb),
    .write_data(write_back_data),
    .reg_write(reg_write_wb),
    .read_data1(read_data1_w),
    .read_data2(read_data2_w)
);


// ==========================
// ID/EX
// ==========================

id_ex id_ex_inst(
    .clk(clk),
    .reset(reset),
    .stall(stall),

    .read_data1_in(read_data1_w),
    .read_data2_in(read_data2_w),
    .imm_in(imm_w),

    .funct3_in(funct3_w),
    .funct7_in(funct7_w),
    .opcode_in(opcode_w),
    .rd_in(rd_w),

    .rs1_in(rs1_w),
    .rs2_in(rs2_w),

    .alu_src_in(alu_src_ctrl),

    .reg_write_in(reg_write_ctrl),
    .mem_read_in(mem_read_ctrl),
    .mem_write_in(mem_write_ctrl),
    .mem_to_reg_in(mem_to_reg_ctrl),

    .read_data1_out(read_data1_ex),
    .read_data2_out(read_data2_ex),
    .imm_out(imm_ex),

    .funct3_out(funct3_ex),
    .funct7_out(funct7_ex),
    .opcode_out(opcode_ex),
    .rd_out(rd_ex),

    .rs1_out(rs1_ex),
    .rs2_out(rs2_ex),

    .alu_src_out(alu_src_ex),

    .reg_write_out(reg_write_ex),
    .mem_read_out(mem_read_ex),
    .mem_write_out(mem_write_ex),
    .mem_to_reg_out(mem_to_reg_ex)
);


// ==========================
// Forwarding Unit
// ==========================

forwarding_unit fu_inst(
    .rs1_ex(rs1_ex),
    .rs2_ex(rs2_ex),
    .rd_mem(rd_mem),
    .reg_write_mem(reg_write_mem),
    .rd_wb(rd_wb),
    .reg_write_wb(reg_write_wb),
    .ForwardA(ForwardA),
    .ForwardB(ForwardB)
);


// ==========================
// EX Stage
// ==========================

always @(*) begin
    case (ForwardA)
        2'b00: operand1 = read_data1_ex;
        2'b10: operand1 = alu_result_mem;
        2'b01: operand1 = write_back_data;
        default: operand1 = read_data1_ex;
    endcase

    case (ForwardB)
        2'b00: operand2 = read_data2_ex;
        2'b10: operand2 = alu_result_mem;
        2'b01: operand2 = write_back_data;
        default: operand2 = read_data2_ex;
    endcase
end

assign operand2_final = (alu_src_ex) ? imm_ex : operand2;

alu alu_inst(
    .operand1(operand1),
    .operand2(operand2_final),
    .funct3(funct3_ex),
    .funct7(funct7_ex),
    .opcode(opcode_ex),
    .alu_result(alu_result_ex)
);


// ==========================
// EX/MEM
// ==========================

ex_mem ex_mem_inst(
    .clk(clk),
    .reset(reset),

    .alu_result_in(alu_result_ex),
    .rd_in(rd_ex),
    .write_data_in(read_data2_ex),

    .reg_write_in(reg_write_ex),
    .mem_read_in(mem_read_ex),
    .mem_write_in(mem_write_ex),
    .mem_to_reg_in(mem_to_reg_ex),

    .alu_result_out(alu_result_mem),
    .rd_out(rd_mem),
    .write_data_out(write_data_mem),

    .reg_write_out(reg_write_mem),
    .mem_read_out(mem_read_mem),
    .mem_write_out(mem_write_mem),
    .mem_to_reg_out(mem_to_reg_mem)
);


// ==========================
// MEM Stage
// ==========================

data_memory dmem_inst(
    .clk(clk),
    .mem_write(mem_write_mem),
    .mem_read(mem_read_mem),
    .address(alu_result_mem),
    .write_data(write_data_mem),
    .read_data(mem_read_data)
);


// ==========================
// MEM/WB
// ==========================

mem_wb mem_wb_inst(
    .clk(clk),
    .reset(reset),

    .alu_result_in(alu_result_mem),
    .rd_in(rd_mem),

    .reg_write_in(reg_write_mem),
    .mem_to_reg_in(mem_to_reg_mem),

    .alu_result_out(alu_result_wb),
    .rd_out(rd_wb),
    .reg_write_out(reg_write_wb),
    .mem_to_reg_out(mem_to_reg_wb)
);

hazard_unit hz_inst(
    .rs1_id(rs1_w),
    .rs2_id(rs2_w),
    .rd_ex(rd_ex),
    .mem_read_ex(mem_read_ex),
    .stall(stall)
);
// ==========================
// WRITE BACK
// ==========================

assign write_back_data =
    (mem_to_reg_wb) ? mem_read_data : alu_result_wb;


// ==========================
// Debug Outputs
// ==========================

assign pc_if = pc_if_w;
assign instruction_if = instruction_if_w;
assign alu_result_wb_out = alu_result_wb;

endmodule
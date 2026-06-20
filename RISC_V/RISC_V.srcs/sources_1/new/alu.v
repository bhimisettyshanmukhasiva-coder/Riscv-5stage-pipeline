module alu(
    input  [31:0] operand1,
    input  [31:0] operand2,
    input  [2:0]  funct3,
    input  [6:0]  funct7,
    input  [6:0]  opcode,

    output reg [31:0] alu_result
);

always @(*) begin
    case (opcode)

        // =========================
        // R-type (ADD, SUB)
        // =========================
        7'b0110011: begin
            case (funct3)
                3'b000: begin
                    if (funct7 == 7'b0000000)
                        alu_result = operand1 + operand2;   // ADD
                    else if (funct7 == 7'b0100000)
                        alu_result = operand1 - operand2;   // SUB
                    else
                        alu_result = 32'b0;
                end
                default: alu_result = 32'b0;
            endcase
        end

        // =========================
        // I-type (ADDI)
        // =========================
        7'b0010011: begin
            case (funct3)
                3'b000: alu_result = operand1 + operand2; // ADDI
                default: alu_result = 32'b0;
            endcase
        end

        default: alu_result = 32'b0;

    endcase
end

endmodule
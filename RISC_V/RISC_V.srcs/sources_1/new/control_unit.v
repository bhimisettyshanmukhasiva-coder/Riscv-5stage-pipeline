module control_unit(
    input  [6:0] opcode,

    output reg reg_write,
    output reg mem_read,
    output reg mem_write,
    output reg alu_src,
    output reg mem_to_reg   // ? IMPORTANT
);

always @(*) begin
    case(opcode)

        // R-type (add, sub)
        7'b0110011: begin
            reg_write  = 1;
            mem_read   = 0;
            mem_write  = 0;
            alu_src    = 0;  // use rs2
            mem_to_reg = 0;  // ALU result
        end

        // I-type (addi)
        7'b0010011: begin
            reg_write  = 1;
            mem_read   = 0;
            mem_write  = 0;
            alu_src    = 1;  // use immediate
            mem_to_reg = 0;  // ALU result
        end

        // Load (lw)
        7'b0000011: begin
            reg_write  = 1;
            mem_read   = 1;
            mem_write  = 0;
            alu_src    = 1;  // address = base + imm
            mem_to_reg = 1;  // ? MEMORY DATA
        end

        // Store (sw)
        7'b0100011: begin
            reg_write  = 0;
            mem_read   = 0;
            mem_write  = 1;
            alu_src    = 1;  // address = base + imm
            mem_to_reg = 0;  // not used
        end

        // Default (safe reset)
        default: begin
            reg_write  = 0;
            mem_read   = 0;
            mem_write  = 0;
            alu_src    = 0;
            mem_to_reg = 0;
        end

    endcase
end

endmodule
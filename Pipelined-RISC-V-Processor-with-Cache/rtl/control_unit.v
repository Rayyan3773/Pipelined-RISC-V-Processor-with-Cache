module control_unit(
    input [6:0] opcode,

    output reg mem_read,
    output reg mem_write,
    output reg reg_write,
    output reg alu_src,
    output reg [1:0] alu_op
);

always @(*) begin
    //default prevents X
    mem_read  = 0;
    mem_write = 0;
    reg_write = 0;
    alu_src   = 0;
    alu_op    = 2'b00;

    case (opcode)

        // R-type (ADD, SUB, AND, OR)
        7'b0110011: begin
            reg_write = 1;
            alu_src   = 0;
            alu_op    = 2'b10;
        end

        // I-type (ADDI)
        7'b0010011: begin
            reg_write = 1;
            alu_src   = 1;
            alu_op    = 2'b00;
        end

        // LOAD (LW)
        7'b0000011: begin
            reg_write = 1;
            mem_read  = 1;
            alu_src   = 1;
            alu_op    = 2'b00;
        end

        // STORE (SW)
        7'b0100011: begin
            mem_write = 1;
            alu_src   = 1;
            alu_op    = 2'b00;
        end

        // BRANCH (BEQ)
        7'b1100011: begin
            alu_src   = 0;
            alu_op    = 2'b01;
        end

        default: begin
            // keep everything zero (NOP safe)
        end
    endcase
end

endmodule
module alu_control(
    input [1:0] alu_op,
    input [2:0] funct3,
    input [6:0] funct7,
    output reg [3:0] alu_control
);

always @(*) begin
    //default
    alu_control = 4'b0000;

    case (alu_op)

        // 00 → ADD (for load/store/addi)
        2'b00: begin
            alu_control = 4'b0000; // ADD
        end

        // 01 → SUB (for branch compare)
        2'b01: begin
            alu_control = 4'b0001; // SUB
        end

        // 10 → R-type instructions
        2'b10: begin
            case ({funct7, funct3})

                // ADD
                {7'b0000000, 3'b000}: alu_control = 4'b0000;

                // SUB
                {7'b0100000, 3'b000}: alu_control = 4'b0001;

                // AND
                {7'b0000000, 3'b111}: alu_control = 4'b0010;

                // OR
                {7'b0000000, 3'b110}: alu_control = 4'b0011;

                // XOR (optional)
                {7'b0000000, 3'b100}: alu_control = 4'b0100;

                // SLT (optional)
                {7'b0000000, 3'b010}: alu_control = 4'b0101;

                default: alu_control = 4'b0000;
            endcase
        end

        default: begin
            alu_control = 4'b0000;
        end
    endcase
end

endmodule
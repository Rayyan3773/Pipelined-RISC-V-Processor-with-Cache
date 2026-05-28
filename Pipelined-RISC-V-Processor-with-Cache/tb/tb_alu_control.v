`timescale 1ns/1ps

module tb_alu_control;

reg [1:0] alu_op;
reg [2:0] funct3;
reg [6:0] funct7;

wire [3:0] alu_control;

alu_control uut (
    .alu_op(alu_op),
    .funct3(funct3),
    .funct7(funct7),
    .alu_control(alu_control)
);

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_alu_control);

    // -------- lw / sw (should be ADD) --------
    alu_op = 2'b00;
    funct3 = 3'b000;
    funct7 = 7'b0000000;
    #10;

    // -------- beq (should be SUB) --------
    alu_op = 2'b01;
    funct3 = 3'b000;
    funct7 = 7'b0000000;
    #10;

    // -------- R-type ADD --------
    alu_op = 2'b10;
    funct3 = 3'b000;
    funct7 = 7'b0000000;
    #10;

    // -------- R-type SUB --------
    alu_op = 2'b10;
    funct3 = 3'b000;
    funct7 = 7'b0100000;
    #10;

    // -------- AND --------
    alu_op = 2'b10;
    funct3 = 3'b111;
    funct7 = 7'b0000000;
    #10;

    // -------- OR --------
    alu_op = 2'b10;
    funct3 = 3'b110;
    funct7 = 7'b0000000;
    #10;

    #10 $finish;
end

endmodule
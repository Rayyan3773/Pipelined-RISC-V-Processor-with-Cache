`timescale 1ns/1ps

module tb_control_unit;

reg [6:0] opcode;

wire reg_write;
wire mem_read;
wire mem_write;
wire alu_src;
wire branch;
wire [1:0] alu_op;

control_unit uut (
    .opcode(opcode),
    .reg_write(reg_write),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .alu_src(alu_src),
    .branch(branch),
    .alu_op(alu_op)
);

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_control_unit);

    // R-type
    opcode = 7'b0110011; #10;

    // lw
    opcode = 7'b0000011; #10;

    // sw
    opcode = 7'b0100011; #10;

    // beq
    opcode = 7'b1100011; #10;

    #10 $finish;
end

endmodule
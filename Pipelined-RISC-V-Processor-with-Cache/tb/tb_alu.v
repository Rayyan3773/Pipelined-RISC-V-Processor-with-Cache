`timescale 1ns/1ps

module tb_alu;

reg [31:0] a, b;
reg [3:0] alu_control;
wire [31:0] result;
wire zero;

alu uut (
    .a(a),
    .b(b),
    .alu_control(alu_control),
    .result(result),
    .zero(zero)
);

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_alu);

    // ADD
    a = 10; b = 5; alu_control = 4'b0000; #10;

    // SUB (zero case)
    a = 10; b = 10; alu_control = 4'b0001; #10;

    // AND
    a = 6; b = 3; alu_control = 4'b0010; #10;

    // OR
    a = 6; b = 3; alu_control = 4'b0011; #10;

    // XOR
    a = 6; b = 3; alu_control = 4'b0100; #10;

    // SLT
    a = 3; b = 6; alu_control = 4'b0101; #10;

    #10 $finish;
end

endmodule
`timescale 1ns/1ps

module tb_instruction_memory;

reg [31:0] addr;
wire [31:0] instruction;

instruction_memory uut (
    .addr(addr),
    .instruction(instruction)
);

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_instruction_memory);

    addr = 0;
    #10 addr = 4;
    #10 addr = 8;
    #10 addr = 12;

    #20 $finish;
end

endmodule
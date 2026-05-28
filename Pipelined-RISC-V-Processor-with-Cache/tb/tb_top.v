`timescale 1ns/1ps

module tb_top;

reg clk;
reg reset;

top_module uut (
    .clk(clk),
    .reset(reset)
);

// clock
always #5 clk = ~clk;

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_top);

    clk = 0;
    reset = 1;

    #40 reset = 0;   // longer reset

    #500 $finish;    // longer simulation
end

endmodule
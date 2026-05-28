`timescale 1ns/1ps

module tb_pc;

reg clk;
reg reset;
reg [31:0] next_pc;
wire [31:0] pc_out;

pc uut (
    .clk(clk),
    .reset(reset),
    .next_pc(next_pc),
    .pc_out(pc_out)
);

// Clock generation
always #5 clk = ~clk;

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_pc);

    clk = 0;
    reset = 1;
    next_pc = 0;

    #10 reset = 0;

    repeat (5) begin
        #10 next_pc = pc_out + 4;
    end

    #50 $finish;
end

endmodule
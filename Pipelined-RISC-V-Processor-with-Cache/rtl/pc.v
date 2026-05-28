module pc (
    input clk,
    input reset,
    input stall,
    input [31:0] pc_next,
    output reg [31:0] pc
);

always @(posedge clk) begin
    if (reset)
        pc <= 32'b0;
    else if (!stall)
        pc <= pc_next;
end

endmodule
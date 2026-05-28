module branch_predictor(
    input clk,
    input reset,
    input [31:0] pc,
    output reg predict_taken,
    output reg [31:0] predicted_target,

    input update,
    input actual_taken,
    input [31:0] actual_target
);

reg prediction_bit;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        prediction_bit <= 0;
    end else if (update) begin
        prediction_bit <= actual_taken;
    end
end

always @(*) begin
    predict_taken = prediction_bit;
    predicted_target = actual_target;
end

endmodule
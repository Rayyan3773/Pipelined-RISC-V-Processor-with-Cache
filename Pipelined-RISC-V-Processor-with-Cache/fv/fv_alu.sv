module fv_alu;

    reg  [31:0] a;
    reg  [31:0] b;
    reg  [3:0]  alu_control;

    wire [31:0] result;
    wire zero;

    alu dut (
        .a(a),
        .b(b),
        .alu_control(alu_control),
        .result(result),
        .zero(zero)
    );

    // ================= ASSERTIONS =================

    // ADD
    always @(*) begin
        if (alu_control == 4'b0010)
            assert(result == a + b);
    end

    // SUB
    always @(*) begin
        if (alu_control == 4'b0110)
            assert(result == a - b);
    end

    // AND
    always @(*) begin
        if (alu_control == 4'b0000)
            assert(result == (a & b));
    end

    // OR
    always @(*) begin
        if (alu_control == 4'b0001)
            assert(result == (a | b));
    end

    // ZERO FLAG
    always @(*) begin
        if (result == 0)
            assert(zero == 1);
    end

endmodule
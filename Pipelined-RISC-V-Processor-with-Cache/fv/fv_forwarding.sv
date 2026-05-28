module fv_forwarding;

    reg         ex_mem_reg_write;
    reg         mem_wb_reg_write;

    reg  [4:0] ex_mem_rd;
    reg  [4:0] mem_wb_rd;

    reg  [4:0] id_ex_rs1;
    reg  [4:0] id_ex_rs2;

    wire [1:0] forward_a;
    wire [1:0] forward_b;

    forwarding_unit dut (
        .ex_mem_reg_write(ex_mem_reg_write),
        .mem_wb_reg_write(mem_wb_reg_write),
        .ex_mem_rd(ex_mem_rd),
        .mem_wb_rd(mem_wb_rd),
        .id_ex_rs1(id_ex_rs1),
        .id_ex_rs2(id_ex_rs2),
        .forward_a(forward_a),
        .forward_b(forward_b)
    );

    // =====================================
    // FORWARDING ASSERTIONS
    // =====================================

    // EX/MEM hazard forwarding for rs1
    always @(*) begin
        if (ex_mem_reg_write &&
            (ex_mem_rd != 0) &&
            (ex_mem_rd == id_ex_rs1))
                assert(forward_a == 2'b10);
    end

    // EX/MEM hazard forwarding for rs2
    always @(*) begin
        if (ex_mem_reg_write &&
            (ex_mem_rd != 0) &&
            (ex_mem_rd == id_ex_rs2))
                assert(forward_b == 2'b10);
    end

    // MEM/WB hazard forwarding for rs1
    always @(*) begin
        if (mem_wb_reg_write &&
            (mem_wb_rd != 0) &&
            !(ex_mem_reg_write &&
              (ex_mem_rd != 0) &&
              (ex_mem_rd == id_ex_rs1)) &&
            (mem_wb_rd == id_ex_rs1))
                assert(forward_a == 2'b01);
    end

    // MEM/WB hazard forwarding for rs2
    always @(*) begin
        if (mem_wb_reg_write &&
            (mem_wb_rd != 0) &&
            !(ex_mem_reg_write &&
              (ex_mem_rd != 0) &&
              (ex_mem_rd == id_ex_rs2)) &&
            (mem_wb_rd == id_ex_rs2))
                assert(forward_b == 2'b01);
    end

    // No forwarding when no hazards
    always @(*) begin
        if ((ex_mem_rd != id_ex_rs1) &&
            (mem_wb_rd != id_ex_rs1))
                assert(forward_a == 2'b00);
    end

endmodule
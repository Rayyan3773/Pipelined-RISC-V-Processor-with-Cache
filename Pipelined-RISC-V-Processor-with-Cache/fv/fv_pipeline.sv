module fv_pipeline;

    reg clk;
    reg reset;

    // DUT
    top_module dut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // ===============================
    // PIPELINE ASSERTIONS
    // ===============================

    // IF/ID register should clear on reset
    always @(posedge clk) begin
        if (reset)
            assert(dut.if_id_instruction == 0);
    end

    // ID/EX pipeline registers clear on reset
    always @(posedge clk) begin
        if (reset) begin
            assert(dut.id_ex_rd == 0);
            assert(dut.id_ex_reg_write == 0);
            assert(dut.id_ex_mem_read == 0);
        end
    end

    // EX/MEM pipeline registers clear on reset
    always @(posedge clk) begin
        if (reset) begin
            assert(dut.ex_mem_rd == 0);
            assert(dut.ex_mem_reg_write == 0);
        end
    end

    // MEM/WB pipeline registers clear on reset
    always @(posedge clk) begin
        if (reset) begin
            assert(dut.mem_wb_rd == 0);
            assert(dut.mem_wb_reg_write == 0);
        end
    end

    // PC should remain stable during stall
    always @(posedge clk) begin
        if (dut.stall)
            assert($stable(dut.pc_current));
    end

    // Register x0 should never be written
    always @(posedge clk) begin
        if (dut.mem_wb_reg_write)
            assert(dut.mem_wb_rd != 0);
    end

endmodule
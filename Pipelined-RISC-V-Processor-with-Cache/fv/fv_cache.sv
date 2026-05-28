module fv_cache;

    reg         clk;
    reg         reset;

    reg         mem_read;
    reg         mem_write;

    reg  [31:0] address;
    reg  [31:0] write_data;

    wire [31:0] read_data;
    wire        stall;

    wire        mem_read_out;
    wire        mem_write_out;

    wire [31:0] addr;
    wire [31:0] write_data_out;

    reg  [31:0] read_data_in;

    data_cache dut (
        .clk(clk),
        .reset(reset),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address(address),
        .write_data(write_data),
        .read_data(read_data),
        .stall(stall),
        .mem_read_out(mem_read_out),
        .mem_write_out(mem_write_out),
        .addr(addr),
        .write_data_out(write_data_out),
        .read_data_in(read_data_in)
    );

    // Clock
    initial clk = 0;
    always #5 clk = ~clk;

    // =====================================
    // CACHE ASSERTIONS
    // =====================================

    // Cache should not read and write simultaneously
    always @(*) begin
        assert(!(mem_read && mem_write));
    end

    // Address pass-through consistency
    always @(*) begin
        assert(addr == address);
    end

    // Write data consistency
    always @(*) begin
        if (mem_write)
            assert(write_data_out == write_data);
    end

    // Memory read propagation
    always @(*) begin
        if (mem_read)
            assert(mem_read_out == 1);
    end

    // Memory write propagation
    always @(*) begin
        if (mem_write)
            assert(mem_write_out == 1);
    end

    // Stall should only occur during active memory transaction
    always @(*) begin
        if (stall)
            assert(mem_read || mem_write);
    end

endmodule
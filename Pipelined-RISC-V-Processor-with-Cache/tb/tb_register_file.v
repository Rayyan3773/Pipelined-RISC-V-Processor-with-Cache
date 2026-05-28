initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_register_file);

    clk = 0;
    reg_write = 0;
    rs1 = 0;
    rs2 = 0;
    rd = 0;
    write_data = 0;

    // Write to x1
    #10 reg_write = 1;
    rd = 5'd1;
    write_data = 32'd100;

    #10 reg_write = 0;

    // Read x1
    rs1 = 5'd1;
    rs2 = 5'd0;

    #20 $finish;
end
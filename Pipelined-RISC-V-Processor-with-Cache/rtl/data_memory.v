module data_memory(
    input clk,
    input mem_read,
    input mem_write,
    input [31:0] addr,
    input [31:0] write_data,
    output reg [31:0] read_data
);

    reg [31:0] memory [0:255];

    integer i;

    //*initialize memory for no X
    initial begin
        for (i = 0; i < 256; i = i + 1)
            memory[i] = 32'b0;

        // Optional test values
        memory[0] = 32'd5;
        memory[1] = 32'd10;
        memory[2] = 32'd15;
        memory[3] = 32'd20;
    end

    always @(posedge clk) begin
        // WRITE
        if (mem_write)
            memory[addr[9:2]] <= write_data;

        // READ
        if (mem_read)
            read_data <= memory[addr[9:2]];
        else
            read_data <= 32'b0;   //*prevents X propagation
    end

endmodule
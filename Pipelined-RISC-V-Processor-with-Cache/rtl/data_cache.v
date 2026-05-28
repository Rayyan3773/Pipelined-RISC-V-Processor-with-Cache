module data_cache(
    input clk,
    input reset,

    input mem_read,
    input mem_write,
    input [31:0] address,
    input [31:0] write_data,

    output reg [31:0] read_data,
    output reg stall,

    //interface data memory
    output reg mem_read_out,
    output reg mem_write_out,
    output reg [31:0] addr,
    output reg [31:0] write_data_out,
    input [31:0] read_data_in
);

    reg [31:0] data_array [0:15];
    reg [24:0] tag_array  [0:15];
    reg valid_array [0:15];

    reg waiting;

    wire [3:0] index = address[5:2];
    wire [24:0] tag  = address[31:7];

    wire hit = valid_array[index] && (tag_array[index] == tag);

    integer i;

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 16; i = i + 1) begin
                valid_array[i] <= 0;
                data_array[i]  <= 0;
                tag_array[i]   <= 0;
            end

            read_data <= 0;
            stall <= 0;
            waiting <= 0;

            mem_read_out  <= 0;
            mem_write_out <= 0;
            addr <= 0;
            write_data_out <= 0;

        end else begin
            //defaults every cycle
            mem_read_out  <= 0;
            mem_write_out <= 0;
            addr <= address;
            write_data_out <= write_data;

            read_data <= 0;
            stall <= 0;

            // ===== READ =====
            if (mem_read) begin
                if (hit) begin
                    read_data <= data_array[index];
                    waiting <= 0;
                end else begin
                    if (!waiting) begin
                        // Start memory read
                        mem_read_out <= 1;
                        stall <= 1;
                        waiting <= 1;
                    end else begin
                        // Data returned from memory
                        data_array[index] <= read_data_in;
                        tag_array[index]  <= tag;
                        valid_array[index] <= 1;

                        read_data <= read_data_in;
                        waiting <= 0;
                    end
                end
            end

            // ===== WRITE (write-through) =====
            if (mem_write) begin
                data_array[index] <= write_data;

                mem_write_out <= 1;
                addr <= address;
                write_data_out <= write_data;
            end
        end
    end

endmodule
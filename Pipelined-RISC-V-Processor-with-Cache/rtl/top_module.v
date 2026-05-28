module top_module(
    input clk,
    input reset
);

// ================= PC =================
wire [31:0] pc_current, pc_next;
wire stall;

pc pc_inst (
    .clk(clk),
    .reset(reset),
    .stall(stall),
    .pc_next(pc_next),
    .pc(pc_current)
);

assign pc_next = pc_current + 4;

// ================= INSTRUCTION =================
wire [31:0] instruction;

instruction_memory imem (
    .addr(pc_current),
    .instruction(instruction)
);

// ================= IF/ID =================
reg [31:0] if_id_instruction;

always @(posedge clk) begin
    if (reset)
        if_id_instruction <= 0;
    else if (!stall)
        if_id_instruction <= instruction;
end

// ================= REGISTER FILE =================
wire [4:0] rs1 = if_id_instruction[19:15];
wire [4:0] rs2 = if_id_instruction[24:20];
wire [4:0] rd  = if_id_instruction[11:7];

wire [31:0] read_data1, read_data2;

wire [4:0] mem_wb_rd;
wire mem_wb_reg_write;
wire [31:0] write_back_data;

register_file rf (
    .clk(clk),
    .reset(reset),
    .reg_write(mem_wb_reg_write),
    .rs1(rs1),
    .rs2(rs2),
    .rd(mem_wb_rd),
    .write_data(write_back_data),
    .read_data1(read_data1),
    .read_data2(read_data2)
);

// ================= CONTROL =================
wire mem_read, mem_write, reg_write, alu_src;
wire [1:0] alu_op;

control_unit ctrl (
    .opcode(if_id_instruction[6:0]),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .reg_write(reg_write),
    .alu_src(alu_src),
    .alu_op(alu_op)
);

// ================= IMMEDIATE =================
wire [31:0] imm_out;

immediate_generator imm_gen (
    .instruction(if_id_instruction),
    .imm_out(imm_out)
);

// ================= ALU CONTROL =================
wire [3:0] alu_control_signal;

alu_control alu_ctrl (
    .alu_op(alu_op),
    .funct3(if_id_instruction[14:12]),
    .funct7(if_id_instruction[31:25]),
    .alu_control(alu_control_signal)
);

// ================= ID/EX =================
reg [31:0] id_ex_a, id_ex_b, id_ex_imm;
//reg [4:0] id_ex_rd;
reg [4:0] id_ex_rs1, id_ex_rs2, id_ex_rd;
reg id_ex_mem_read, id_ex_mem_write, id_ex_reg_write, id_ex_alu_src;
reg [3:0] id_ex_alu_control;

always @(posedge clk) begin
    if (reset) begin
        id_ex_a <= 0;
        id_ex_b <= 0;
        id_ex_imm <= 0;
        id_ex_rd <= 0;
        id_ex_mem_read <= 0;
        id_ex_mem_write <= 0;
        id_ex_reg_write <= 0;
        id_ex_alu_src <= 0;
        id_ex_alu_control <= 0;
    end else begin
        id_ex_a <= read_data1;
        id_ex_b <= read_data2;
        id_ex_imm <= imm_out;
        id_ex_rd <= rd;
        id_ex_mem_read <= mem_read;
        id_ex_mem_write <= mem_write;
        id_ex_reg_write <= reg_write;
        id_ex_alu_src <= alu_src;
        id_ex_alu_control <= alu_control_signal;
    end
end

// ================= ALU =================
wire [1:0] forward_a;
wire [1:0] forward_b;

wire [31:0] forwarded_a;
wire [31:0] forwarded_b;

//wire [31:0] alu_in2 = id_ex_alu_src ? id_ex_imm : id_ex_b;
wire [31:0] alu_in2 = id_ex_alu_src ? id_ex_imm : forwarded_b;
wire [31:0] alu_result;
wire zero;

alu alu_inst (
    //.a(id_ex_a),
    .a(forwarded_a),
    .b(alu_in2),
    .alu_control(id_ex_alu_control),
    .result(alu_result),
    .zero(zero)
);
forwarding_unit forwarding_unit_inst (
    .ex_mem_reg_write(ex_mem_reg_write),
    .mem_wb_reg_write(mem_wb_reg_write),
    .ex_mem_rd(ex_mem_rd),
    .mem_wb_rd(mem_wb_rd),
    .id_ex_rs1(id_ex_rs1),
    .id_ex_rs2(id_ex_rs2),
    .forward_a(forward_a),
    .forward_b(forward_b)
);
mux3 forward_mux_a (
    //.a(id_ex_a),
    .a(forwarded_a),
    .b(write_back_data),
    .c(ex_mem_alu),
    .sel(forward_a),
    .y(forwarded_a)
);

mux3 forward_mux_b (
    .a(id_ex_b),
    .b(write_back_data),
    .c(ex_mem_alu),
    .sel(forward_b),
    .y(forwarded_b)
);

// ================= EX/MEM =================
reg [31:0] ex_mem_alu, ex_mem_wdata;
reg [4:0] ex_mem_rd;
reg ex_mem_mem_read, ex_mem_mem_write, ex_mem_reg_write;

always @(posedge clk) begin
    if (reset) begin
        ex_mem_alu <= 0;
        ex_mem_wdata <= 0;
        ex_mem_rd <= 0;
        ex_mem_mem_read <= 0;
        ex_mem_mem_write <= 0;
        ex_mem_reg_write <= 0;
    end else begin
        ex_mem_alu <= alu_result;
        ex_mem_wdata <= id_ex_b;
        ex_mem_rd <= id_ex_rd;
        ex_mem_mem_read <= id_ex_mem_read;
        ex_mem_mem_write <= id_ex_mem_write;
        ex_mem_reg_write <= id_ex_reg_write;
    end
end

// ================= CACHE =================
wire [31:0] cache_data;
wire cache_stall;

wire mem_read_out, mem_write_out;
wire [31:0] mem_addr, mem_wdata;
wire [31:0] mem_rdata;

data_cache cache (
    .clk(clk),
    .reset(reset),
    .mem_read(ex_mem_mem_read),
    .mem_write(ex_mem_mem_write),
    .address(ex_mem_alu),
    .write_data(ex_mem_wdata),
    .read_data(cache_data),
    .stall(cache_stall),
    .mem_read_out(mem_read_out),
    .mem_write_out(mem_write_out),
    .addr(mem_addr),
    .write_data_out(mem_wdata),
    .read_data_in(mem_rdata)
);

// ================= DATA MEMORY =================
data_memory dmem (
    .clk(clk),
    .mem_read(mem_read_out),
    .mem_write(mem_write_out),
    .addr(mem_addr),
    .write_data(mem_wdata),
    .read_data(mem_rdata)
);

// ================= STALL =================
assign stall = cache_stall;

// ================= MEM/WB =================
reg [31:0] mem_wb_data;
reg [4:0] mem_wb_rd_reg;
reg mem_wb_reg_write_reg;

assign mem_wb_rd = mem_wb_rd_reg;
assign mem_wb_reg_write = mem_wb_reg_write_reg;

always @(posedge clk) begin
    if (reset) begin
        mem_wb_data <= 0;
        mem_wb_rd_reg <= 0;
        mem_wb_reg_write_reg <= 0;
    end else begin
        mem_wb_data <= cache_data;
        mem_wb_rd_reg <= ex_mem_rd;
        mem_wb_reg_write_reg <= ex_mem_reg_write;
    end
end

// ================= WRITEBACK =================
assign write_back_data = mem_wb_reg_write ? mem_wb_data : 32'b0;

endmodule
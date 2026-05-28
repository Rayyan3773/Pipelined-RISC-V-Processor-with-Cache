module instruction_memory(
    input  [31:0] addr,
    output [31:0] instruction
);

    reg [31:0] memory [0:255];

    integer i;

    initial begin
        //initialize all memory to NOP (no X ever)
        for (i = 0; i < 256; i = i + 1)
            memory[i] = 32'h00000013; // NOP

        // ===== PROGRAM =====
        memory[0] = 32'h00500093; // addi x1, x0, 5
        memory[1] = 32'h00A00113; // addi x2, x0, 10
        memory[2] = 32'h002081B3; // add x3, x1, x2
        memory[3] = 32'h00302023; // sw x3, 0(x0)
        memory[4] = 32'h00002203; // lw x4, 0(x0)
        memory[5] = 32'h00418463; // beq x3, x4, +8
        memory[6] = 32'h00100293; // addi x5, x0, 1
        memory[7] = 32'h00200313; // addi x6, x0, 2

        //looping for prevention of garbage execution
        memory[8] = 32'hFE208AE3; // branch back
    end

    //combinational read
    assign instruction = memory[addr[9:2]];

endmodule
module top(
    input  wire clk,
    input  wire reset
);

    // Internal Wires
    wire [31:0] instruction_top, Rd1_top, Rd2_top, imm_out_top;
    wire [31:0] alu_mux_top, adder_out, toPC_top, PC_in;
    wire [31:0] result_top, data_out_top, write_data_top, PC_top;

    wire        RegWrite_top, ALUSrc_top, Branch_top, zero_top;
    wire        and_out_top, MemWrite_top, MemRead_top, MemtoReg_top;

    wire [3:0]  alu_control_top;
    wire [1:0]  ALUOp_top;

    //////////////////////////////////////////////////
    // Program Counter
    //////////////////////////////////////////////////
    pc PC (
        .clk(clk),
        .reset(reset),
        .pc_in(PC_in),
        .pc_out(PC_top)
    );

    //////////////////////////////////////////////////
    // PC + 4
    //////////////////////////////////////////////////
    PCplus4 PC_ADDER (
        .fromPC(PC_top),
        .toPC(toPC_top)
    );

    //////////////////////////////////////////////////
    // Instruction Memory
    //////////////////////////////////////////////////
    instr_mem INSTR_MEMORY (
        .clk(clk),
        .read_add(PC_top),
        .instr_out(instruction_top)
    );

    //////////////////////////////////////////////////
    // Register File
    //////////////////////////////////////////////////
    reg_file REG_FILE (
        .clk(clk),
        .reset(reset),
        .RegWrite(RegWrite_top),
        .Rs1(instruction_top[19:15]),
        .Rs2(instruction_top[24:20]),
        .Rd(instruction_top[11:7]),
        .write_data(write_data_top),
        .read_data1(Rd1_top),
        .read_data2(Rd2_top)
    );

    //////////////////////////////////////////////////
    // Immediate Generator
    //////////////////////////////////////////////////
    immgen IMM_GEN (
        .instr(instruction_top),
        .imm_out(imm_out_top)
    );

    //////////////////////////////////////////////////
    // Control Unit
    //////////////////////////////////////////////////
    control_unit CONTROL_UNIT (
        .reset(reset),
        .instr(instruction_top[6:0]),
        .Branch(Branch_top),
        .MemRead(MemRead_top),
        .MemtoReg(MemtoReg_top),
        .MemWrite(MemWrite_top),
        .ALUSrc(ALUSrc_top),
        .Regwrite(RegWrite_top),
        .ALUOp(ALUOp_top)
    );

    //////////////////////////////////////////////////
    // ALU Control
    //////////////////////////////////////////////////
    alu_control ALU_CONTROL (
        .op5(instruction_top[5]),
        .funct7(instruction_top[30]),
        .funct3(instruction_top[14:12]),
        .ALUOp(ALUOp_top),
        .control_out(alu_control_top)
    );

    //////////////////////////////////////////////////
    // ALU
    //////////////////////////////////////////////////
    alu ALU (
        .A(Rd1_top),
        .B(alu_mux_top),
        .control_in(alu_control_top),
        .result(result_top),
        .zero(zero_top)
    );

    //////////////////////////////////////////////////
    // ALU Input MUX
    //////////////////////////////////////////////////
    mux2 #(.WIDTH(32)) ALU_MUX (
        .d0(Rd2_top),
        .d1(imm_out_top),
        .sel(ALUSrc_top),
        .y(alu_mux_top)
    );

    //////////////////////////////////////////////////
    // Branch Adder
    //////////////////////////////////////////////////
    adder #(.WIDTH(32)) BRANCH_ADDER (
        .a(PC_top),
        .b(imm_out_top),
        .sum(adder_out)
    );

    //////////////////////////////////////////////////
    // Branch AND Logic
    //////////////////////////////////////////////////
    and_logic AND (
        .branch(Branch_top),
        .zero(zero_top),
        .and_out(and_out_top)
    );

    //////////////////////////////////////////////////
    // PC Select MUX
    //////////////////////////////////////////////////
    mux2 #(.WIDTH(32)) PC_MUX (
        .d0(toPC_top),
        .d1(adder_out),
        .sel(and_out_top),
        .y(PC_in)
    );

    //////////////////////////////////////////////////
    // Data Memory
    //////////////////////////////////////////////////
    data_mem DATA_MEMORY (
        .clk(clk),
        .MemWrite(MemWrite_top),
        .MemRead(MemRead_top),
        .funct3(instruction_top[14:12]),
        .word_add(result_top),
        .data_in(Rd2_top),
        .data_out(data_out_top)
    );

    //////////////////////////////////////////////////
    // Writeback MUX
    //////////////////////////////////////////////////
    mux2 #(.WIDTH(32)) MEMORY_MUX (
        .d0(result_top),
        .d1(data_out_top),
        .sel(MemtoReg_top),
        .y(write_data_top)
    );

endmodule
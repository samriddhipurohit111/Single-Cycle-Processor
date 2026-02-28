module instr_mem(
    input  wire        clk,
    input  wire [31:0] read_add,
    output wire [31:0] instr_out
);

    reg [31:0] I_mem [0:63];

    // Word aligned access
    assign instr_out = I_mem[{2'b00, read_add[31:2]}];

endmodule
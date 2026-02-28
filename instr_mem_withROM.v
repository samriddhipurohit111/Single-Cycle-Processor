module instr_mem (
    input  wire        clk,
    input  wire [31:0] read_add,
    output wire [31:0] instr_out
);

    wire [15:0] q_low;
    wire [15:0] q_high;

    wire [8:0] addr;

    assign addr = read_add[10:2];

    // Lower 16 bits
    rom_512x16A ROM_LOW (
        .CLK (clk),
        .CEN (1'b0),      // Active low enable assumed
        .A   (addr),
        .Q   (q_low)
    );

    // Upper 16 bits
    rom_512x16A ROM_HIGH (
        .CLK (clk),
        .CEN (1'b0),
        .A   (addr),
        .Q   (q_high)
    );

    assign instr_out = {q_high, q_low};

endmodule
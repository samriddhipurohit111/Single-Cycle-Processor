module data_mem (
    input  wire        clk,
    input  wire        MemWrite,
    input  wire        MemRead,
    input  wire [31:0] word_add,
    input  wire [31:0] data_in,
    output wire [31:0] data_out
);

    wire [6:0] addr;
    assign addr = word_add[8:2];

    wire [15:0] q_low;
    wire [15:0] q_high;

    // Active low controls
    wire CEN;
    wire WEN;

    assign CEN = ~(MemRead | MemWrite);
    assign WEN = ~MemWrite;

    // Lower 16 bits
    ram_128x16A RAM_LOW (
        .CLK (clk),
        .CEN (CEN),
        .WEN (WEN),
        .OEN (1'b0),
        .A   (addr),
        .D   (data_in[15:0]),
        .Q   (q_low)
    );

    // Upper 16 bits
    ram_128x16A RAM_HIGH (
        .CLK (clk),
        .CEN (CEN),
        .WEN (WEN),
        .OEN (1'b0),
        .A   (addr),
        .D   (data_in[31:16]),
        .Q   (q_high)
    );

    assign data_out = {q_high, q_low};

endmodule

module PCplus4(
    input  wire [31:0] fromPC,
    output wire [31:0] toPC
);

    assign toPC = fromPC + 32'd4;

endmodule

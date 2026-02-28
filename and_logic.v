module and_logic(
    input  wire branch,
    input  wire zero,
    output wire and_out
);

    assign and_out = branch & zero;

endmodule
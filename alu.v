module alu(
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [3:0]  control_in,

    output reg  [31:0] result,
    output wire        zero
);

always @(*) begin
    result = 32'b0;   // default assignment (prevents latch)

    case (control_in)
        4'b0000:  result = A + B;                                     // ADD
        4'b0001:  result = A << B[4:0];                                // SLL
        4'b0010:  result = {{31{1'b0}}, ($signed(A) < $signed(B))};    // SLT
        4'b0011:  result = {{31{1'b0}}, (A < B)};                      // SLTU
        4'b0100:  result = A ^ B;                                      // XOR
        4'b0101:  result = A >> B[4:0];                                 // SRL
        4'b0110:  result = A | B;                                      // OR
        4'b0111:  result = A & B;                                      // AND
        4'b1000:  result = A - B;                                      // SUB
        4'b1001:  result = $signed(A) >>> B[4:0];                      // SRA
        default:  result = 32'b0;
    endcase
end

assign zero = (result == 32'b0);

endmodule
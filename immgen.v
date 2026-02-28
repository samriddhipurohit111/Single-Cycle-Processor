module immgen(
    input  wire [31:0] instr,
    output reg  [31:0] imm_out
);

always @(*) begin

    // Default assignment (prevents latch inference)
    imm_out = 32'b0;

    case (instr[6:0])

        // I-Type (Load)
        7'b0000011:
            imm_out = {{20{instr[31]}}, instr[31:20]};

        // I-Type (Arithmetic Immediate)
        7'b0010011:
            imm_out = {{20{instr[31]}}, instr[31:20]};

        // S-Type (Store)
        7'b0100011:
            imm_out = {{20{instr[31]}}, instr[31:25], instr[11:7]};

        // SB-Type (Branch)
        7'b1100011:
            imm_out = {{19{instr[31]}}, instr[31], instr[7],
                       instr[30:25], instr[11:8], 1'b0};

        default:
            imm_out = 32'b0;

    endcase
end

endmodule

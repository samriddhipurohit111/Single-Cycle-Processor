module control_unit(
    input  wire       reset,
    input  wire [6:0] instr,  // opcode

    output reg        Branch,
    output reg        MemRead,
    output reg        MemtoReg,
    output reg        MemWrite,
    output reg        ALUSrc,
    output reg        Regwrite,
    output reg [1:0]  ALUOp
);

always @(*) begin

    // Default assignment (prevents latch inference)
    {ALUSrc, MemtoReg, Regwrite, MemRead, MemWrite, Branch, ALUOp} = 8'b0;

    if (!reset) begin
        case (instr)

            // R-type
            7'b0110011:
                {ALUSrc, MemtoReg, Regwrite, MemRead, MemWrite, Branch, ALUOp}
                    = 8'b001000_10;

            // I-type Load
            7'b0000011:
                {ALUSrc, MemtoReg, Regwrite, MemRead, MemWrite, Branch, ALUOp}
                    = 8'b111100_00;

            // I-type Arithmetic Immediate
            7'b0010011:
                {ALUSrc, MemtoReg, Regwrite, MemRead, MemWrite, Branch, ALUOp}
                    = 8'b101000_10;

            // S-type Store
            7'b0100011:
                {ALUSrc, MemtoReg, Regwrite, MemRead, MemWrite, Branch, ALUOp}
                    = 8'b100010_00;

            // B-type Branch
            7'b1100011:
                {ALUSrc, MemtoReg, Regwrite, MemRead, MemWrite, Branch, ALUOp}
                    = 8'b000001_01;

            default:
                {ALUSrc, MemtoReg, Regwrite, MemRead, MemWrite, Branch, ALUOp}
                    = 8'b0;

        endcase
    end
end

endmodule

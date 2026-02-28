module alu_control(
    input  wire       op5,
    input  wire       funct7,
    input  wire [2:0] funct3,
    input  wire [1:0] ALUOp,
    output reg  [3:0] control_out
);

always @(*) begin
    control_out = 4'b0000;   // default assignment (prevents latch)

    case (ALUOp)
        2'b00: control_out = 4'b0000; // S type Add
        2'b01: control_out = 4'b1000; // B type Sub
        2'b10: begin
            case (funct3)
                3'b000: control_out = (funct7 & op5) ? 4'b1000 : 4'b0000;
                3'b001: control_out = 4'b0001;
                3'b010: control_out = 4'b0010;
                3'b011: control_out = 4'b0011;
                3'b100: control_out = 4'b0100;
                3'b101: control_out = (funct7) ? 4'b1001 : 4'b0101;
                3'b110: control_out = 4'b0110;
                3'b111: control_out = 4'b0111;
                default: control_out = 4'b0000;
            endcase
        end
        default: control_out = 4'b0000;
    endcase
end

endmodule
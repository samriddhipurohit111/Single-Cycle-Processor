module data_mem (
    input              clk,
    input              MemWrite,
    input              MemRead,
    input      [2:0]   funct3,
    input      [31:0]  word_add,
    input      [31:0]  data_in,
    output reg [31:0]  data_out
);

reg [31:0] mem [0:63];

/////////////////////////////////////////////////
// WRITE LOGIC (Sequential)
/////////////////////////////////////////////////

always @(posedge clk) begin
    if (MemWrite) begin
        case (funct3)

            3'b000: begin  // SB
                case (word_add[1:0])
                    2'b00: mem[word_add[31:2]][7:0]   <= data_in[7:0];
                    2'b01: mem[word_add[31:2]][15:8]  <= data_in[7:0];
                    2'b10: mem[word_add[31:2]][23:16] <= data_in[7:0];
                    2'b11: mem[word_add[31:2]][31:24] <= data_in[7:0];
                endcase
            end

            3'b001: begin  // SH
                case (word_add[1:0])
                    2'b00: mem[word_add[31:2]][15:0]  <= data_in[15:0];
                    2'b10: mem[word_add[31:2]][31:16] <= data_in[15:0];
                endcase
            end

            3'b010: begin  // SW
                mem[word_add[31:2]] <= data_in;
            end

        endcase
    end
end


/////////////////////////////////////////////////
// READ LOGIC (Combinational)
/////////////////////////////////////////////////

always @(*) begin
    data_out = 32'b0;   // Default (prevents latch)

    case (funct3)

        3'b000: begin  // LB
            case (word_add[1:0])
                2'b00: data_out = {{24{mem[word_add[31:2]][7]}},  mem[word_add[31:2]][7:0]};
                2'b01: data_out = {{24{mem[word_add[31:2]][15]}}, mem[word_add[31:2]][15:8]};
                2'b10: data_out = {{24{mem[word_add[31:2]][23]}}, mem[word_add[31:2]][23:16]};
                2'b11: data_out = {{24{mem[word_add[31:2]][31]}}, mem[word_add[31:2]][31:24]};
            endcase
        end

        3'b001: begin  // LH
            case (word_add[1:0])
                2'b00: data_out = {{16{mem[word_add[31:2]][15]}}, mem[word_add[31:2]][15:0]};
                2'b10: data_out = {{16{mem[word_add[31:2]][31]}}, mem[word_add[31:2]][31:16]};
            endcase
        end

        3'b010: data_out = mem[word_add[31:2]]; // LW

        3'b100: begin  // LBU
            case (word_add[1:0])
                2'b00: data_out = {24'b0, mem[word_add[31:2]][7:0]};
                2'b01: data_out = {24'b0, mem[word_add[31:2]][15:8]};
                2'b10: data_out = {24'b0, mem[word_add[31:2]][23:16]};
                2'b11: data_out = {24'b0, mem[word_add[31:2]][31:24]};
            endcase
        end

        3'b101: begin  // LHU
            case (word_add[1:0])
                2'b00: data_out = {16'b0, mem[word_add[31:2]][15:0]};
                2'b10: data_out = {16'b0, mem[word_add[31:2]][31:16]};
            endcase
        end

    endcase
end

endmodule

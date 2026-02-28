module reg_file(
    input  wire        clk,
    input  wire        reset,
    input  wire        RegWrite,
    input  wire [4:0]  Rs1,
    input  wire [4:0]  Rs2,
    input  wire [4:0]  Rd,
    input  wire [31:0] write_data,
    output wire [31:0] read_data1,
    output wire [31:0] read_data2
);

    reg [31:0] Register [0:31];
    integer k;

    //////////////////////////////////////////////////
    // WRITE + RESET LOGIC (Sequential)
    //////////////////////////////////////////////////

    always @(posedge clk) begin
        if (reset) begin
            for (k = 0; k < 32; k = k + 1)
                Register[k] <= 32'b0;
        end
        else if (RegWrite) begin
            Register[Rd] <= write_data;
        end
        // else: register naturally holds value
    end

    //////////////////////////////////////////////////
    // READ LOGIC (Combinational)
    //////////////////////////////////////////////////

    assign read_data1 = (Rs1 == 5'd0) ? 32'b0 : Register[Rs1];
    assign read_data2 = (Rs2 == 5'd0) ? 32'b0 : Register[Rs2];

endmodule

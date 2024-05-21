module fifo (
    input logic clk,
    input logic reset,
    input logic write_en,
    input logic read_en,
    input logic [7:0] data_in,
    output logic [7:0] data_out,
    output logic full,
    output logic empty
);

    parameter DEPTH = 16;
    logic [7:0] fifo_mem [0:DEPTH-1];
    logic [3:0] write_ptr, read_ptr;
    logic [4:0] count;

    assign full = (count == DEPTH);
    assign empty = (count == 0);

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            write_ptr <= 0;
            read_ptr <= 0;
            count <= 0;
        end else begin
            if (write_en && !full) begin
                fifo_mem[write_ptr] <= data_in;
                write_ptr <= write_ptr + 1;
                count <= count + 1;
            end
            if (read_en && !empty) begin
                data_out <= fifo_mem[read_ptr];
                read_ptr <= read_ptr + 1;
                count <= count - 1;
            end
        end
    end

endmodule

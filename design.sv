module fifo #(
  parameter WIDTH = 8,   // Data width
  parameter DEPTH = 16   // FIFO depth
) (
  input logic clk,
  input logic rst,
  input logic wr_en,     // Write enable
  input logic rd_en,     // Read enable
  input logic [WIDTH-1:0] din,  // Data input
  output logic [WIDTH-1:0] dout, // Data output
  output logic full,     // FIFO full status
  output logic empty     // FIFO empty status
);

  logic [WIDTH-1:0] mem [0:DEPTH-1];  // Memory array
  logic [$clog2(DEPTH):0] rd_ptr, wr_ptr;  // Read and write pointers
  logic [$clog2(DEPTH):0] count;  // Number of elements in FIFO

  // Write logic
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      wr_ptr <= 0;
    end else if (wr_en && !full) begin
      mem[wr_ptr] <= din;
      wr_ptr <= wr_ptr + 1;
    end
  end

  // Read logic
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      rd_ptr <= 0;
      dout <= 0;
    end else if (rd_en && !empty) begin
      dout <= mem[rd_ptr];
      rd_ptr <= rd_ptr + 1;
    end
  end

  // Count logic
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      count <= 0;
    end else begin
      case ({wr_en, rd_en})
        2'b10: if (!full) count <= count + 1; // Write only
        2'b01: if (!empty) count <= count - 1; // Read only
        2'b11: ; // Simultaneous read and write, count remains unchanged
      endcase
    end
  end

  // Status flags
  assign full = (count == DEPTH);
  assign empty = (count == 0);

endmodule

module SubModule (
  input wire clk,
  input wire rst,
  input wire [7:0] data,
  input wire [7:0] addr,
  input wire [7:0] feed_in,
  input wire [7:0] feed_in_addr,
  output reg [7:0] feed_out,
  output reg [7:0] feed_out_addr,
  output reg [7:0] ab,
  output reg [7:0] b
);
  // the comparator
  wire comparator = feed_in >= b;

  // the register  
  always @ (posedge clk or posedge rst) begin 
    if (rst) begin
      // initialize to the min value 
      b <= 'b0;
    end
    else if (comparator) begin 
      b <= feed_in;
      ab <= feed_in_addr;
    end 
  end

  // the output mux
  always @ (*) begin 
    feed_out = comparator ? b : data;
    feed_out_addr = comparator ? ab : addr;
  end

endmodule 

module Sorter # (
  parameter N = 64
)(
  input wire clk,                       // 
  input wire rst,                       // active high async rst
  input wire [7:0] data,                // input data stream
  input wire [7:0] addr,                // and the corresponding addresses
  output reg [N*8 - 1:0] sorted_data,   // the entire array but sorted
  output reg [N*8 - 1:0] sorted_addr    // and the corresponding addresses
); 

  // a 2d array view of the output port
  wire [7:0] out_array_data [0:N-1];
  wire [7:0] out_array_addr [0:N-1];

  // connect each element of the 2d array to 
  // the corresponding bit slice in the port
  // list
  integer i;
  always @(*) begin 
    for (i = 0; i < N; i = i + 1) begin 
      sorted_data[7+8*i -:8] <= out_array_data[i];
      sorted_addr[7+8*i -:8] <= out_array_addr[i];
    end
  end

  // instantiate N submodules
  wire [7:0] feed_outs [0:N-1];
  wire [7:0] feed_out_addrs [0:N-1];

  // the first module is outside generate loop
  // coz it has no feed in
  SubModule u_SubModule_0 (
    .clk              (clk),
    .rst              (rst),
    .data             (data),
    .addr             (addr),
    .feed_in          (data),
    .feed_in_addr     (addr),
    .feed_out         (feed_outs[0]),
    .feed_out_addr    (feed_out_addrs[0]),
    .ab               (out_array_addr[0]),
    .b                (out_array_data[0])
  );

  genvar j;
  generate
    for (j = 1; j < N; j = j + 1) begin : G
      SubModule u_SubModule_0 (
        .clk              (clk),
        .rst              (rst),
        .data             (data),
        .addr             (addr),
        .feed_in          (feed_outs[j-1]),       // chain with output of previous
        .feed_in_addr     (feed_out_addrs[j-1]),
        .feed_out         (feed_outs[j]),
        .feed_out_addr    (feed_out_addrs[j]),
        .ab               (out_array_addr[j]),
        .b                (out_array_data[j])
      );
    end
  endgenerate

endmodule
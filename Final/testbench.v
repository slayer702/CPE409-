`timescale 1ns/1ps


module testbench;
  reg  [7:0] mem [0:63];          // input from file
  reg  [7:0] mem_sorted [0:63];   // expected output (file generated from python)
  reg  clk = 1;
  reg  rst = 1;
  reg  [7:0] data, addr = 0;
  reg  [7:0] sorted_data_array [0:63];        // sorted by circuit
  reg  [7:0] sorted_addr_array [0:63];
  wire [8*64-1:0] sorted_addr, sorted_data;   // the packed repr of array
  
  integer i;
  initial begin 
    $readmemh("Input_8bit_hex_64total.txt", mem);
    $readmemh("sorted_python.txt", mem_sorted);

    // wait 11ns and de-assert reset
    #11
    rst = 0;

    // wait 64 cycles (2ns*64 = 128ns)
    #128

    // check each value against expected result
    for (i = 0; i < 64; i = i + 1) begin 
      if (sorted_data_array[i] != mem_sorted[i]) begin 
        // if fail, print message and exit
        $display("%d failed", i);
        $finish;
      end
    end

    // if successful print the array
    $display("Printing sorted array:");
    for (i = 0; i < 64; i = i + 1) begin 
      $display("data: %x, addr: %d", sorted_data_array[i], sorted_addr_array[i]);
    end
    $display("All pass");
    $finish;
  end

  Sorter #(64) u_Sorter (
    .clk(clk),
    .rst(rst),
    .data(data),
    .addr(addr),
    .sorted_data(sorted_data),
    .sorted_addr(sorted_addr)
  );


  // unpack the packed bits into array
  always @ (*) begin 
    data = mem [addr];
    for (i = 0; i < 64; i = i + 1) begin 
      sorted_data_array[i] = sorted_data[7+8*i -:8];
      sorted_addr_array[i] = sorted_addr[7+8*i -:8];
    end
  end

  // clk 2ns period
  always begin 
    #1 clk = !clk;
  end

  // inc address each clock cycle when not in reset
  always @ (posedge clk) begin 
    if (!rst)
      addr = addr + 1;
  end

endmodule 
`timescale 1ns/1ns

module Register32(clk, rst, en, in, out);
  input clk, rst, en;
  input [31:0]in;
  output reg [31:0]out;
  
  always @(posedge rst, posedge clk) begin
    if (rst) out <= 32'b0;
    else if (en) out <= in;
  end
endmodule

module Mux32_2(a, b, s, out);
  input [31:0]a, b;
  input s;
  output [31:0]out;
  
  assign out = s ? a : b;
endmodule

module Mux4_2(a, b, s, out);
  input [3:0]a, b;
  input s;
  output [3:0]out;
  
  assign out = s ? a : b;
endmodule

module Adder32(a, b, out);
  input [31:0]a, b;
  output [31:0]out;
  
  assign out = a + b;
endmodule

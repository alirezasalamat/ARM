`include "defines.v"

module Register32(clk, rst, en, in, out);
  input clk, rst, en;
  input [31:0]in;
  output reg [31:0]out;
  
  always @(posedge rst, posedge clk) begin
    if (rst) out <= 32'b0;
    else if (en) out <= in;
    $display("@%t: PC: PC is %d", $time, out);
  end
endmodule

module Mux32_2(a, b, s, out);
  input [31:0]a, b;
  input s;
  output [31:0]out;
  
  assign out = s ? b : a;
endmodule

module Mux32_3(a, b, c, s, out);
  input [31:0]a, b, c;
  input [1:0]s;
  output [31:0]out;
  
  assign out = (s == 2'b00) ? a : 
                (s == 2'b01) ? b :
                (s == 2'b10) ? c : 32'b00;
endmodule

module Mux4_2(a, b, s, out);
  input [3:0]a, b;
  input s;
  output [3:0]out;
  
  assign out = s ?  b : a;
endmodule

module Mux9_2(a, b, s, out);
  input [8:0]a, b;
  input s;
  output [8:0]out;
  
  assign out = s ?  b : a;
endmodule

module Adder32(a, b, out);
  input [31:0]a, b;
  output [31:0]out;
  
  assign out = a + b;
endmodule

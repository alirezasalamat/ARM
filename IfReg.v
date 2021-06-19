`include "defines.v"

module IfReg(clk, rst, freeze, flush, PC_in, instruction_in, PC, instruction);
  input clk, rst, freeze, flush;
  input [31:0]PC_in;
  input [31:0]instruction_in;
  output reg [31:0]PC;
  output reg [31:0]instruction;
  
  always @(posedge clk, posedge rst) begin
    if (rst || (~freeze && flush)) begin
      PC <= 0;
      instruction <= 0;
    end

    else if (~freeze) begin
      PC <= PC_in;
      instruction <= instruction_in;
    end

  end
endmodule

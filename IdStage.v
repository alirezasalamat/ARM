`include "defines.v"

module IdStage(clk, rst, PC_in, instruction, result_wb, WB_wb_en, dest_wb, hazard, SR
    , PC_out, wb_en, mem_read, mem_write, B, S, exe_cmd, val_Rn, val_Rm, imm, shift_operand, signed_imm_24, dest, src1, src2, two_src);
  input clk, rst, hazard, WB_wb_en;
  input [31:0]instruction, PC_in, result_wb;
  input [3:0]dest_wb, SR;
  
  output [31:0]PC_out;
  output wb_en, mem_read, mem_write, B, S;
  output [3:0]exe_cmd;
  output [31:0]val_Rn, val_Rm;
  output two_src, imm;
  output [11:0]shift_operand;
  output [23:0]signed_imm_24;
  output [3:0]dest, src1, src2;
  
  Mux4_2 Mux4_2_0(instruction[3:0], instruction[15:12], mem_write, src2);
  RegisterFile RegisterFile_0(clk, rst, src1, src2, dest_wb, result_wb, WB_wb_en, val_Rn, val_Rm);
  Controller Controller_0(instruction[20], instruction[27:26], instruction[24:21], exe_cmd, mem_read, mem_write, wb_en, S, B);
  ConditionCheck ConditionCheck_0();
  
  assign src1 = instruction[19:16];
endmodule

module RegisterFile(clk, rst, src1, src2, dest_wb, result_wb, wb_en, reg1, reg2);
  input clk, rst, wb_en;
  input [3:0]src1, src2, dest_wb;
  input [31:0]result_wb;

  output [31:0] reg1, reg2;

  reg [31:0]reg_data[0:15];

  always @(negedge clk, posedge rst) begin
    if (wb_en)
      reg_data[dest_wb] <= result_wb;
	end

  assign reg1 = reg_data[src1];
	assign reg2 = reg_data[src2];
endmodule

module ConditionCheck();
  
endmodule

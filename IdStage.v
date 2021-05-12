`include "defines.v"

module IdStage(clk, rst, instruction, result_wb, WB_wb_en, dest_wb, hazard, SR
    , wb_en_out, mem_read_out, mem_write_out, B_out, S_out, exe_cmd_out, val_Rn
    , val_Rm, imm, shift_operand, signed_imm_24, dest, src1, src2, two_src);
  
  input clk, rst, hazard, WB_wb_en;
  input [31:0]instruction, result_wb;
  input [3:0]dest_wb, SR;
  
  output wb_en_out, mem_read_out, mem_write_out, B_out, S_out;
  output [3:0]exe_cmd_out;
  output [31:0]val_Rn, val_Rm;
  output two_src, imm;
  output [11:0]shift_operand;
  output [23:0]signed_imm_24;
  output [3:0]dest, src1, src2;
  
  wire condition_state;
  wire [8:0]controller_mux_in1;
  wire controller_mux_s;
  wire [8:0]controller_mux_out;
  wire wb_en, mem_read, mem_write, B, S;
  wire [3:0]exe_cmd;

  Mux4_2 Mux4_2_0(instruction[3:0], instruction[15:12], mem_write, src2);
  RegisterFile RegisterFile_0(clk, rst, src1, src2, dest_wb, result_wb, WB_wb_en, val_Rn, val_Rm);
  Controller Controller_0(instruction[20], instruction[27:26], instruction[24:21], exe_cmd, mem_read, mem_write, wb_en, S, B);
  Mux9_2 Mux9_2_0(controller_mux_in1, 9'b0, controller_mux_s, controller_mux_out);
  ConditionCheck ConditionCheck_0(instruction[31:28], SR, condition_state);
  
  assign src1 = instruction[19:16];
  assign controller_mux_in1 = {S, B, exe_cmd, mem_write, mem_read, wb_en};
  assign controller_mux_s = (~condition_state) | hazard;
  assign {S_out, B_out, exe_cmd_out, mem_write_out, mem_read_out, wb_en_out} = controller_mux_out;
  assign two_src = (~instruction[25]) | mem_write_out;
  assign imm = instruction[25];
  assign shift_operand = instruction[11:0];
  assign signed_imm_24 = instruction[23:0];
  assign dest = instruction[15:12];
endmodule

module RegisterFile(clk, rst, src1, src2, dest_wb, result_wb, wb_en, reg1, reg2);
  input clk, rst, wb_en;
  input [3:0]src1, src2, dest_wb;
  input [31:0]result_wb;

  output [31:0] reg1, reg2;

  reg [31:0]reg_data[0:15];

  always @(negedge clk) begin
    if (wb_en) begin
      reg_data[dest_wb] <= result_wb;
      $display("@%t: REG_FILE::WRITE: value %d stored in register %d", $time, result_wb, dest_wb);
    end
	end

  

  assign reg1 = reg_data[src1];
	assign reg2 = reg_data[src2];
endmodule

module ConditionCheck(condition, status_register, condition_state);
  input [3:0]condition;
  input [3:0]status_register;

  output reg condition_state;

  wire z, c, n ,v;

  assign {z, c, n, v} = status_register;

  always @(*) begin
    case(condition)
      `EQ: condition_state = z;
      `NE: condition_state = ~z;
      `CS_HS: condition_state = c;
      `CC_LO: condition_state = ~c;
      `MI: condition_state = n;
      `PL: condition_state = ~n;
      `VS: condition_state = v;
      `VC: condition_state = ~v;
      `HI: condition_state = c & ~z;
      `LS: condition_state = ~c & z;
      `GE: condition_state = (n & v) | (~n & ~v);
      `LT: condition_state = (n & ~v) | (~n & v);
      `GT: condition_state = ~z & ((n & v) | (~n & ~v));
      `LE: condition_state = z & ((n & ~v) | (~n & v));
      `AL: condition_state = 1'b1;
    endcase
  end
endmodule

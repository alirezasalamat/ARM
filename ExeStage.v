`include "defines.v"

module ExeStage(clk, rst, mem_read, mem_write, imm, exe_cmd, SR, PC, val_Rn,
        val_Rm, shift_operand, signed_imm_24,
        alu_result, br_address, status);
    input clk, rst, mem_read, mem_write, imm;
    input [3:0]exe_cmd, SR;
    input [31:0]PC, val_Rn, val_Rm;
    input [11:0]shift_operand;
    input [23:0]signed_imm_24;
    
    output [31:0]alu_result, br_address;
    output [3:0]status;

    ALU ALU_0();
endmodule

module Val2Generator();

endmodule

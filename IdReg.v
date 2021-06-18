`include "defines.v"

module IdReg(clk, rst, flush, wb_en_in, mem_read_in, mem_write_in, B_in, S_in, SR_in, imm_in, exe_cmd_in
        , PC_in, val_Rn_in, val_Rm_in, shift_operand_in, signed_imm_24_in, dest_in, src1, src2
        , wb_en, mem_read, mem_write, B, S, SR_out, imm, exe_cmd, PC, val_Rn, val_Rm, shift_operand
        , signed_imm_24, dest, src1_out, src2_out);
    input clk, rst, flush, wb_en_in, mem_read_in, mem_write_in, B_in, S_in, imm_in;
    input [3:0]exe_cmd_in;
    input [31:0]PC_in, val_Rn_in, val_Rm_in;
    input [11:0]shift_operand_in;
    input [23:0]signed_imm_24_in;
    input [3:0]dest_in, SR_in;
    input [3:0]src1, src2;

    output reg wb_en, mem_read, mem_write, B, S, imm;
    output reg [3:0]exe_cmd;
    output reg [31:0]PC, val_Rn, val_Rm;
    output reg [11:0]shift_operand;
    output reg [23:0]signed_imm_24;
    output reg [3:0]dest, SR_out;
    output reg [3:0]src1_out, src2_out;

    always @(posedge clk, posedge rst) begin
        if (rst || flush) begin
            wb_en <= 0;
            mem_read <= 0;
            mem_write <= 0;
            B <= 0;
            S <= 0;
            SR_out <= 0;
            imm <= 0;
            exe_cmd <= 0;
            PC <= 0;
            val_Rn <= 0;
            val_Rm <= 0;
            shift_operand <= 0;
            signed_imm_24 <= 0;
            dest <= 0;
            src1_out <= 0;
            src2_out <= 0;
        end
        else begin
            wb_en <= wb_en_in;
            mem_read <= mem_read_in;
            mem_write <= mem_write_in;
            B <= B_in;
            S <= S_in;
            SR_out <= SR_in;
            imm <= imm_in;
            exe_cmd <= exe_cmd_in;
            PC <= PC_in;
            val_Rn <= val_Rn_in;
            val_Rm <= val_Rm_in;
            shift_operand <= shift_operand_in;
            signed_imm_24 <= signed_imm_24_in;
            dest <= dest_in;
            src1_out <= src1;
            src2_out <= src2;
        end
    end
endmodule

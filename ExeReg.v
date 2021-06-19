`include "defines.v"

module ExeReg(clk, rst, frz, wb_en_in, mem_read_in, mem_write_in, alu_result_in, val_Rm_in, dest_in
        , wb_en, mem_read, mem_write, alu_result, val_Rm_out, dest);
    input clk, rst, frz, wb_en_in, mem_read_in, mem_write_in;
    input [31:0]alu_result_in, val_Rm_in;
    input [3:0]dest_in;

    output reg wb_en, mem_read, mem_write;
    output reg [31:0]alu_result, val_Rm_out;
    output reg [3:0]dest;

    always @(posedge clk, posedge rst) begin
        if(rst) begin
            wb_en <= 0;
            mem_read <= 0;
            mem_write <= 0;
            alu_result <= 0;
            val_Rm_out <= 0;
            dest <= 0;
        end
        else if(frz) begin
            wb_en <= wb_en_in;
            mem_read <= mem_read_in;
            mem_write <= mem_write_in;
            alu_result <= alu_result_in;
            val_Rm_out <= val_Rm_in;    
            dest <= dest_in;
        end
    end
endmodule

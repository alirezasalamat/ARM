`include "defines.v"

module ExeReg(clk, rst, wb_en_in, mem_read_in, mem_write_in, alu_result_in, st_val_in, dest_in
        , wb_en, mem_read, mem_write, alu_result, st_val, dest);
    input clk, rst, wb_en_in, mem_read_in, mem_write_in;
    input [31:0]alu_result_in, st_val_in;
    input [3:0]dest_in;

    output reg wb_en, mem_read, mem_write;
    output reg [31:0]alu_result, st_val;
    output reg [3:0]dest;

    always @(posedge clk, posedge rst) begin
        if(rst) begin
            wb_en <= 0;
            mem_read <= 0;
            mem_write <= 0;
            alu_result <= 0;
            st_val <= 0;
            dest <= 0;
        end
        else begin
            wb_en <= wb_en_in;
            mem_read <= mem_read_in;
            mem_write <= mem_write_in;
            alu_result <= alu_result_in;
            st_val <= st_val_in;
            dest <= dest_in;
        end
    end
endmodule

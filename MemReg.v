`include "defines.v"

module MemReg(clk, rst, frz, wb_en_in, mem_read_in, alu_result_in, mem_result_in, dest_in
        , wb_en, mem_read, alu_result, mem_result, dest);
    input clk, rst, frz, wb_en_in, mem_read_in;
    input [31:0]alu_result_in, mem_result_in;
    input [3:0]dest_in;

    output reg wb_en, mem_read;
    output reg [31:0]alu_result, mem_result;
    output reg [3:0]dest;

    always @(posedge clk, posedge rst) begin
    if(rst) begin
        wb_en <= 0;
        mem_read <= 0;
        alu_result <= 0;
        mem_result <= 0;
        dest <= 0;
    end
    else if(frz) begin
        wb_en <= wb_en_in;
        mem_read <= mem_read_in;
        alu_result <= alu_result_in;
        mem_result <= mem_result_in;
        dest <= dest_in;
    end
end
endmodule

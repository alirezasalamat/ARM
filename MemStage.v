`include "defines.v"

module MemStage(clk, rst, mem_read, mem_write, address, data, mem_result);
    input clk, rst, mem_read, mem_write;
    input [31:0]address, data;

    output [31:0]mem_result;

    DataMemory DataMemory_0(clk, rst, mem_read, mem_write, address, data, mem_result);
endmodule

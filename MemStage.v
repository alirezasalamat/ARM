`include "defines.v"

module MemStage(clk, rst, mem_read, mem_write, address, data, mem_result, sram_ready, SRAM_DQ, SRAM_ADDR, SRAM_WE_N);
    input clk, rst, mem_read, mem_write;
    input [31:0]address, data;

    output [31:0]mem_result;
    output sram_ready;
    inout [31:0] SRAM_DQ;
    output[16:0] SRAM_ADDR;
	output SRAM_WE_N;

    SRAM_controller SRAM_controller(
        .clk(clk),
        .rst(rst),
        .read_en(mem_read),
        .write_en(mem_write),
        .address(address),
        .write_data(data),
        .read_data(mem_result),
        .ready(sram_ready),
        .SRAM_dq(SRAM_DQ),
        .SRAM_addr(SRAM_ADDR),
        .SRAM_we_n(SRAM_WE_N)
	);
endmodule

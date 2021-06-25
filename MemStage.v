`include "defines.v"

module MemStage(clk, rst, mem_read, mem_write, address, data, mem_result, ready, SRAM_DQ, SRAM_ADDR, SRAM_WE_N);
    input clk, rst, mem_read, mem_write;
    input [31:0]address, data;

    output [31:0]mem_result;
    output ready;
    inout [63:0] SRAM_DQ;
    output[16:0] SRAM_ADDR;
	output SRAM_WE_N;

    wire[63:0] rdata;
    wire[31:0] sram_address, sram_wdata;

    wire sram_ready, sram_read_en, sram_write_en;

    CacheController CacheController_0(
    	.clk(clk),
        .rst(rst),
        .address(address),
        .wdata(data),
        .MEM_R_EN(mem_read),
        .MEM_W_EN(mem_write),
        .sram_rdata(rdata),
        .sram_ready(sram_ready),
        .rdata(mem_result),
        .ready(ready),
        .sram_address(sram_address),
        .sram_wdata(sram_wdata),
        .write(sram_write_en),
        .read(sram_read_en)
	);

    SRAM_controller SRAM_controller_0(
        .clk(clk),
        .rst(rst),
        .read_en(sram_read_en),
        .write_en(sram_write_en),
        .address(sram_address),
        .write_data(sram_wdata),
        .read_data(rdata),
        .ready(sram_ready),
        .SRAM_dq(SRAM_DQ),
        .SRAM_addr(SRAM_ADDR),
        .SRAM_we_n(SRAM_WE_N)
	);
endmodule

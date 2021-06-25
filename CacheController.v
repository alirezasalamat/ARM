`include "defines.v"

module CacheController(clk, rst, address, wdata, MEM_R_EN, MEM_W_EN, sram_rdata, sram_ready,
        rdata, ready, sram_address, sram_wdata, write, read);
    input clk, rst, MEM_R_EN, MEM_W_EN, sram_ready;  
    input [31:0] address, wdata;
    input [63:0] sram_rdata;

    output ready, write, read;
	output [31:0] rdata;
	output reg [31:0] sram_wdata, sram_address;

    wire[16:0] cache_address;
	wire[31:0] temp_address;
	assign temp_address = address - 1024;
	assign cache_address = temp_address[17:2];

	wire[31:0] read_cache_data;
	wire hit;

	reg [1:0] ps;
	wire [1:0] ns;
	parameter[1:0] IDLE = 2'b00;
	parameter[1:0] WRITE = 2'b01;
	parameter[1:0] READ = 2'b10;

	wire cache_read_en, cache_write_en;

	always @(posedge rst, posedge clk) begin
		if (rst) ps <= 0;
		else ps <= ns;
	end

	Cache c(
		.clk(clk),
		.rst(rst),
		.cache_address(cache_address),
		.read_en(cache_read_en),
		.write_en(cache_write_en), 
		.is_str((ps == IDLE && ns == WRITE)),
		.write_data(sram_rdata),
		.read_data(read_cache_data),
		.hit(hit)
	);

	assign cache_read_en = (ps == IDLE);
	assign cache_write_en = (ps == READ && sram_ready);

	assign ns = (ps == IDLE && MEM_R_EN && ~hit) ? READ :
				(ps == IDLE && MEM_W_EN) ? WRITE :
				(ps == READ && sram_ready) ? IDLE :
				(ps == WRITE && sram_ready) ? IDLE : ps; 

	assign ready = (ns == IDLE);

	assign rdata = (ps == IDLE && hit) ? read_cache_data :
					(ps == READ && sram_ready) ?
					(cache_address[0] ? sram_rdata[63:32] : sram_rdata[31:0] ) : 32'bz;

	always @(ps, address) begin
		sram_address = (ps == READ) ? address : (ps == WRITE) ? address : 32'bz;
	end

	always @(ps, wdata) begin
		sram_wdata = (ps == WRITE) ? wdata : 32'bz;
	end

	assign write = (ps == WRITE);
	assign read = (ps == READ);
endmodule

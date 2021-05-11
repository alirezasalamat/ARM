`include "defines.v"

module DataMemory(clk, rst, mem_read, mem_write, address, data, result);
    input clk, rst, mem_read, mem_write;
    input [31:0]address, data;

    output [31:0]result;

    reg [7:0]memory[0:255];
    wire [31:0]temp_address, final_address;

    assign temp_address = (address - 1024);
    assign final_address = {temp_address[31:2], 1'b0, 1'b0};

    always @(posedge clk)
	begin
		if (mem_write) begin
            memory[final_address] <= data[31:24];
            memory[final_address + 1] <= data[23:16];
            memory[final_address + 2] <= data[15:8];
            memory[final_address + 3] <= data[7:0];
		end
	end

    assign result = mem_read ? {memory[final_address], memory[final_address + 1],
            memory[final_address + 2], memory[final_address + 3]} : 32'b0;
endmodule

`include "defines.v"

module SRAM_controller(clk, rst, write_en, read_en, address, write_data, read_data, ready, SRAM_dq, SRAM_addr, SRAM_we_n);
    input clk, rst, write_en, read_en;
    input [31:0] address, write_data;
    
    inout [31:0] SRAM_dq;

    output ready, SRAM_we_n;
    output [31:0] read_data;
    output [16:0] SRAM_addr;

    parameter [1:0] IDLE = 2'b00;
    parameter [1:0] READ = 2'b01;
    parameter [1:0] WRITE = 2'b11;

    reg [1:0] ps;
    reg [2:0] cnt_out;
    reg [31:0] dq;

    wire [1:0] ns;
    wire [2:0] cnt;

    always @(posedge rst, posedge clk) begin
        if (rst) begin
            ps <= 0;
            cnt_out <= 0;
            dq <= 0;
        end
        else begin
            ps <= ns;
            cnt_out <= cnt;
            dq <= SRAM_dq;
        end
    end

    wire [31:0] temp_address = address - 32'd1024;
    assign SRAM_addr = temp_address[18:2];

    assign cnt = rst ? 3'b0 :
        (ps == READ && cnt_out != 3'b110) ? (cnt_out + 1'b1) :
        (ps == WRITE && cnt_out != 3'b110) ? (cnt_out + 1'b1) : 3'b0;

    assign ns = rst ? IDLE :
        (ps == IDLE && read_en) ? READ :
        (ps == IDLE && write_en) ? WRITE :
        (ps == READ && cnt != 3'b110) ? READ :
        (ps == WRITE && cnt != 3'b110) ? WRITE : 2'b00;

    assign SRAM_dq = (ns == WRITE && cnt < 3'b110) ? write_data : 32'bz;
    assign SRAM_we_n = (ns == WRITE && cnt < 3'b110) ? 1'b0 : 1'b1; 
    assign read_data = read_en ? dq : 32'bz;
    assign ready = (ns == READ && cnt < 3'b110) ? 1'b0 : (ns == WRITE && cnt < 3'b110) ? 1'b0 : 1'b1;
endmodule
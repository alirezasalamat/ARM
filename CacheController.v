`include "defines.v"

module CacheController(clk, rst, address, wdata, MEM_R_EN, MEM_W_EN, sram_rdata, sram_ready,
        rdata, ready, sram_address, sram_wdata, write, read);
    input clk, rst, MEM_R_EN, MEM_W_EN, sram_ready;  
    inout [31:0] address, wdata;
    input [63:0] sram_rdata;

    output ready, write, read;
    output [31:0] rdata, sram_address, sram_wdata;


    wire [16:0] cache_address;
  
    wire [31:0] address_1024;
    assign address_1024 = address - 1024;
    assign cache_address = address_1024[17:2];
    
    //wire [63:0] cache_write_data; it's sram_rdata
    wire [31:0] cache_read_data;
    wire cache_write_en, cache_read_en, cache_invoke;
    wire cache_hit;
    //wire sram_second_ready;
    
    Cache cache(
        .clk(clk), .rst(rst),
        .address(cache_address),
        .write_data(sram_rdata),
    
        .read_en(cache_read_en),
        .write_en(cache_write_en),
        .invoke_set_en(cache_invoke),
    
        .read_data(cache_read_data),
        .hit(cache_hit)
    );
    
    // Controller Regs
    wire[2:0] ps, ns;
    //parameter S_IDLE = 3'b000, S_CACHE_READ = 3'b001, S_SRAM_READ_1 = 3'b010, S_SRAM_READ_2 = 3'b011, S_SRAM_WRITE = 3'b100, S_CACHE_WRITE = 3'b101; // States
    parameter S_IDLE = 3'b000, S_SRAM_READ_CACHE_WRITE = 3'b001, S_SRAM_WRITE = 3'b010, S_INVOKE_CACHE = 3'b011;
    Regular_Register #(.SIZE(3)) ps_reg(.q(ps), .d(ns), .clk(clk), .rst(rst));    
        
        
    // ns Reg
    assign ns = (ps == S_IDLE && MEM_R_EN && ~cache_hit) ? S_SRAM_READ_CACHE_WRITE :
                (ps == S_IDLE && MEM_W_EN) ? S_SRAM_WRITE :
                //(ps == S_IDLE && MEM_W_EN) ? S_INVOKE_CACHE :
                //(ps == S_INVOKE_CACHE) ? S_SRAM_WRITE :
                (ps == S_SRAM_READ_CACHE_WRITE && sram_ready) ? S_IDLE :
                (ps == S_SRAM_WRITE && sram_ready) ? S_IDLE :
                ps; 
                
    //assign sram_second_ready = (ps == S_SRAM_READ_1) && sram_ready;
    
    assign rdata = (ps == S_IDLE && cache_hit) ? cache_read_data :
                    (ps == S_SRAM_READ_CACHE_WRITE && sram_ready) ? (
                        cache_address[0] ? sram_rdata[63:32] : sram_rdata[31:0]
                    ) :
                    32'bz;
                    
    assign ready = (ns == S_IDLE);
    
    //  assign sram_address = (ps == S_SRAM_READ_1) ? {address[31:3], 1'b0, address[1:0]} :
    //                        (ps == S_SRAM_READ_2) ? {address[31:3], 1'b1, address[1:0]} :
    //                        (ps == S_SRAM_WRITE) ? address :
    //                        32'bz;
    
    assign sram_address = (ps == S_SRAM_READ_CACHE_WRITE) ? address :
                            (ps == S_SRAM_WRITE) ? address :
                            64'bz;
    
    assign sram_wdata = (ps == S_SRAM_WRITE) ? wdata : 
                                //32'bz;
                                64'bz;
    
    assign write = (ps == S_SRAM_WRITE);
                            
    assign read = (ps == S_SRAM_READ_CACHE_WRITE);
    
    //Freezable_Register #(.SIZE(64)) cache_write_data_reg0(.q(cache_write_data), .d(sram_rdata), .freeze(~(ps == S_SRAM_READ_CACHE_WRITE && sram_ready)), .clk(clk), .rst(rst));
    //Freezable_Register #(.SIZE(32)) cache_write_data_reg1(.q(cache_write_data[63:32]), .d(sram_rdata), .freeze(~(ps == S_SRAM_READ_2 && sram_ready)), .clk(clk), .rst(rst)); 
    
    assign cache_read_en = (ps == S_IDLE);
    assign cache_write_en = (ps == S_SRAM_READ_CACHE_WRITE && sram_ready);
    assign cache_invoke = (ps == S_IDLE && ns == S_SRAM_WRITE);
            

endmodule
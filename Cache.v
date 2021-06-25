`include "defines.v"

module Cache(clk, rst, cache_address, write_data, read_en, write_en, is_str, read_data, hit);
    input clk, rst, read_en, write_en;
    input [16:0] cache_address;
    input [63:0] write_data;
    input is_str;
    
    output reg [31:0] read_data;
    output reg hit;

    wire [9:0] tag = cache_address[16:7];
    wire [5:0] index = cache_address[6:1];
    wire offset = cache_address[0];

    reg [31:0] left_data [0:1][0:63];
    reg [31:0] right_data [0:1][0:63];

    reg left_valid [0:63];
    reg right_valid [0:63];

    reg lru [0:63];

    reg [9:0] left_tag [0:63];
    reg [9:0] right_tag [0:63];

    integer i;
    always @(posedge rst) begin
        if (rst) begin
            for (i = 0; i <= 63; i = i + 1) begin
                lru[i] = 1'b0;
                left_tag[i] = 10'b0;
                right_tag[i] = 10'b0;
                left_valid[i] = 1'b0;
                right_valid[i] = 1'b0;
            end
        end
    end

    always @(*) begin
        hit = ((left_tag[index] == tag) && left_valid[index]) || ((right_tag[index] == tag) && right_valid[index]);

        if (read_en) begin

            if (hit) begin
                if (((left_tag[index] == tag) && left_valid[index])) begin
                    read_data = left_data[offset][index];
                    lru[index] = 1'b1;
                end
                else if (((right_tag[index] == tag) && right_valid[index])) begin
                    read_data = right_data[offset][index];
                    lru[index] = 1'b0;
                end
            end
        end

        if (is_str && hit) begin
            if (((left_tag[index] == tag) && left_valid[index]) == 1'b1) begin
                left_valid[index] = 1'b0;
                lru[index] = 1'b1;
            end
            else if(((right_tag[index] == tag) && right_valid[index]) == 1'b1) begin
                right_valid[index] = 1'b0;
                lru[index] = 1'b0;
            end
        end

        if (write_en) begin

            if (lru[index] == 1'b0) begin
                right_valid[index] = 1'b1;
                lru[index] = 1'b1;

                right_data[0][index] = write_data[31:0];
                right_data[1][index] = write_data[63:32];

                right_tag[index] = tag;
            end

            else if (lru[index] == 1'b1) begin
                left_valid[index] = 1'b0;
                lru[index] = 1'b0;

                left_data[0][index] = write_data[31:0];
                left_data[1][index] = write_data[63:32];

                left_tag[index] = tag;
            end
        end
    end
endmodule

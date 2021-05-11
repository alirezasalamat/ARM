`include "defines.v"

module StatusRegister(clk, rst, load, SR_in, SR);
    input clk, rst, load;
    input [3:0]SR_in;

    output reg [3:0]SR;

    always @(negedge clk or posedge rst) begin
        if(rst) begin
            SR <= 0;
        end  
        else if(load) begin
            SR <= SR_in;
        end
        else begin
            SR <= SR;
        end    
    end
endmodule


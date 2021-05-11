`include "defines.v"

module WbStage(alu_result, mem_result, mem_read, out);
    input [31:0]alu_result, mem_result;
    input mem_read;

    output [31:0]out;

    Mux32_2 Mux32_2_0(alu_result, mem_result, mem_read, out);
endmodule

`include "defines.v"

module ExeStage(clk, rst, mem_read, mem_write, imm, exe_cmd, SR, PC, val_Rn,
        val_Rm, shift_op, signed_imm_24,
        alu_result, br_address, status);
    input clk, rst, mem_read, mem_write, imm;
    input [3:0]exe_cmd, SR;
    input [31:0]PC, val_Rn, val_Rm;
    input [11:0]shift_op;
    input [23:0]signed_imm_24;
    
    output [31:0]alu_result, br_address;
    output [3:0]status;

    wire is_mem_cmd;
    or or_0 (is_mem_cmd, mem_read, mem_write);

    wire [`WORD - 1 : 0] Val2Generator_out;

    ALU ALU_0(.val1(val_Rn), .val2(Val2Generator_out), .cin(SR[2]), .exe_cmd(exe_cmd),
                                     .result(alu_result), .SR(status));

    Val2Generator Val2Generator_0(.shift_op(shift_op), .val_Rm(val_Rm), .imm(imm), 
                                    .is_mem_cmd(is_mem_cmd), .out(Val2Generator_out));

    Adder32 adder_0(.a({{(8){signed_imm_24[`SIGNED_IMM - 1]}}, signed_imm_24}), .b(PC), .out(br_address));

endmodule

module Val2Generator(shift_op, val_Rm,  imm, is_mem_cmd, out);
    input [`SHIFTER_OPERAND - 1 : 0] shift_op;
    input [`WORD - 1 : 0] val_Rm;
    input imm, is_mem_cmd;
    output reg [`WORD - 1 : 0] out;
    integer i;

    always @(*) begin

        if (is_mem_cmd) begin
            out = {20'b0, shift_op};
        end

        else if (imm) begin
			out = {24'b0, shift_op[7:0]};
        
            for (i = 0; i < {shift_op[11:8], 1'b0}; i = i + 1) begin
                out = {out[0], out[`WORD - 1 : 1]};
            end
        end
    
        else if(!shift_op[4]) begin
            out = val_Rm;
            case(shift_op[6:5])
                `LSL : 
                    out = out << shift_op[11:7];
                `LSR :
                    out = out >> shift_op[11:7];
                `ASR :
                    out = out >>> shift_op[11:7];
                `ROR : begin
                    for (i = 0; i < {shift_op[11:7]}; i = i + 1) begin
                        out = {out[0], out[31:1]}; 
                    end
                end
            endcase
        end
    end
endmodule

`include "defines.v"

module Arm(clk, rst, enable_forwarding);
    input clk, rst, enable_forwarding;

    wire ID_reg_B_out;
    wire detected_hazard;
    wire [`WORD - 1 : 0] IF_stage_pc_out;
    wire [`WORD - 1 : 0] IF_stage_inst_out;
    wire [`WORD - 1 : 0] branch_addr;
    

    IfStage IfStage_0(.clk(clk),
                      .rst(rst),
                      .freeze(detected_hazard),
                      .branch_taken(ID_reg_B_out),
                      .branch_address(branch_addr),
                      .PC(IF_stage_pc_out),
                      .instruction(IF_stage_inst_out));


    wire [`WORD - 1 : 0] IF_reg_pc_out;
    wire [`WORD - 1 : 0] IF_reg_inst_out;

    IfReg IfReg_0(.clk(clk),
                  .rst(rst),
                  .freeze(detected_hazard),
                  .flush(ID_reg_B_out),
                  .PC_in(IF_stage_pc_out),
                  .instruction_in(IF_stage_inst_out),
                  .PC(IF_reg_pc_out),
                  .instruction(IF_reg_inst_out));


    wire [`WORD - 1 : 0] ID_stage_val_Rn, ID_stage_val_Rm, WB_value;
	wire [`REG_FILE - 1 : 0] ID_stage_reg_file_dst, ID_stage_reg_file_src1, ID_stage_reg_file_src2, WB_wb_dst;
	wire [`SIGNED_IMM - 1 : 0] ID_stage_signed_imm;
	wire [`SHIFTER_OPERAND - 1 : 0] ID_stage_shift_op;
	wire [`COMMAND - 1 : 0] ID_stage_exe_cmd_out;
    wire [3:0] status_reg_out;
	wire ID_stage_mem_read_out, ID_stage_mem_write_out, ID_stage_WB_en_out, ID_stage_Imm_out,
		    ID_stage_B_out, ID_stage_S_out, WB_wb_en, has_two_src;

    IdStage IdStage_0(.clk(clk),
                      .rst(rst),
                      .instruction(IF_reg_inst_out),
                      .result_wb(WB_value),
                      .WB_wb_en(WB_wb_en),
                      .dest_wb(WB_wb_dst),
                      .hazard(detected_hazard),
                      .SR(status_reg_out),
                      .wb_en_out(ID_stage_WB_en_out),
                      .mem_read_out(ID_stage_mem_read_out), 
                      .mem_write_out(ID_stage_mem_write_out),
                      .B_out(ID_stage_B_out), 
                      .S_out(ID_stage_S_out), 
                      .exe_cmd_out(ID_stage_exe_cmd_out), 
                      .val_Rn(ID_stage_val_Rn), 
                      .val_Rm(ID_stage_val_Rm),
                      .imm(ID_stage_Imm_out),
                      .shift_operand(ID_stage_shift_op),
                      .signed_imm_24(ID_stage_signed_imm),
                      .dest(ID_stage_reg_file_dst),
                      .src1(ID_stage_reg_file_src1),
                      .src2(ID_stage_reg_file_src2),
                      .two_src(has_two_src));


    wire [`WORD - 1 : 0] ID_reg_pc_out, ID_reg_val_Rn_out, ID_reg_val_Rm_out;
    wire [`REG_FILE - 1 : 0] ID_reg_reg_file_dst_out;
    wire [`SIGNED_IMM - 1 : 0] ID_reg_signed_imm_out;
    wire [`SHIFTER_OPERAND - 1 : 0] ID_reg_shift_op_out;
    wire [`COMMAND - 1 : 0] ID_reg_EX_command_out;
    wire [3 : 0] ID_reg_SR_out;
    wire ID_reg_mem_read_out, ID_reg_mem_write_out, ID_reg_WB_en_out, ID_reg_Imm_out, ID_reg_S_out;
    wire [3:0] ID_src1, ID_src2;

    IdReg IdReg_0(.clk(clk),
                  .rst(rst),
                  .flush(ID_reg_B_out),
                  .wb_en_in(ID_stage_WB_en_out),
                  .mem_read_in(ID_stage_mem_read_out),
                  .mem_write_in(ID_stage_mem_write_out),
                  .B_in(ID_stage_B_out), 
                  .S_in(ID_stage_S_out),
                  .SR_in(status_reg_out),
                  .imm_in(ID_stage_Imm_out),
                  .exe_cmd_in(ID_stage_exe_cmd_out),
                  .PC_in(IF_reg_pc_out),
                  .val_Rn_in(ID_stage_val_Rn),
                  .val_Rm_in(ID_stage_val_Rm),
                  .shift_operand_in(ID_stage_shift_op),
                  .signed_imm_24_in(ID_stage_signed_imm),
                  .dest_in(ID_stage_reg_file_dst),
                  .wb_en(ID_reg_WB_en_out),
                  .mem_read(ID_reg_mem_read_out), 
                  .mem_write(ID_reg_mem_write_out), 
                  .B(ID_reg_B_out),
                  .S(ID_reg_S_out),
                  .SR_out(ID_reg_SR_out),
                  .imm(ID_reg_Imm_out),
                  .exe_cmd(ID_reg_EX_command_out),
                  .PC(ID_reg_pc_out),
                  .val_Rn(ID_reg_val_Rn_out),
                  .val_Rm(ID_reg_val_Rm_out),
                  .shift_operand(ID_reg_shift_op_out),
                  .signed_imm_24(ID_reg_signed_imm_out),
                  .dest(ID_reg_reg_file_dst_out));


    wire [`WORD - 1 : 0 ] ALU_res;
    wire [3:0] EXE_stage_status_out;
    wire [1:0]EXE_sel_src1, EXE_sel_src2;

    ExeStage ExeStage_0(.clk(clk),
                        .rst(rst),
                        .mem_read(ID_reg_mem_read_out),
                        .mem_write(ID_reg_mem_write_out),
                        .imm(ID_reg_Imm_out),
                        .exe_cmd(ID_reg_EX_command_out),
                        .SR(ID_reg_SR_out),
                        .PC(ID_reg_pc_out),
                        .val_Rn(ID_reg_val_Rn_out),
                        .val_Rm(ID_reg_val_Rm_out), 
                        .shift_op(ID_reg_shift_op_out), 
                        .signed_imm_24(ID_reg_signed_imm_out),
                        .alu_result(ALU_res), 
                        .br_address(branch_addr), 
                        .status(EXE_stage_status_out));


    wire [`WORD - 1 : 0] EXE_reg_ALU_result_out, EXE_reg_val_Rm_out;
    wire [`REG_FILE - 1 : 0] EXE_reg_dst_out;
    wire EXE_reg_mem_read_out, EXE_reg_mem_write_out, EXE_reg_WB_en_out;

    ExeReg ExeReg_0(.clk(clk),
                    .rst(rst), 
                    .wb_en_in(ID_reg_WB_en_out),
                    .mem_read_in(ID_reg_mem_read_out),
                    .mem_write_in(ID_reg_mem_write_out),
                    .alu_result_in(ALU_res),
                    .val_Rm_in(ID_reg_val_Rm_out),
                    .dest_in(ID_reg_reg_file_dst_out),
                    .wb_en(EXE_reg_WB_en_out),
                    .mem_read(EXE_reg_mem_read_out),
                    .mem_write(EXE_reg_mem_write_out),
                    .alu_result(EXE_reg_ALU_result_out),
                    .val_Rm_out(EXE_reg_val_Rm_out),
                    .dest(EXE_reg_dst_out));


    wire [`WORD - 1 : 0] Mem_Stage_mem_out;

    MemStage MemStage_0(.clk(clk),
                        .rst(rst),
                        .mem_read(EXE_reg_mem_read_out),
                        .mem_write(EXE_reg_mem_write_out),
                        .address(EXE_reg_ALU_result_out),
                        .data(EXE_reg_val_Rm_out),
                        .mem_result(Mem_Stage_mem_out));

    
    wire [`WORD - 1 : 0] Mem_Reg_ALU_result_out, Mem_Reg_mem_out;
    wire Mem_Reg_read_out;

    MemReg MemReg_0(.clk(clk),
                    .rst(rst),
                    .wb_en_in(EXE_reg_WB_en_out),
                    .mem_read_in(EXE_reg_mem_read_out),
                    .alu_result_in(EXE_reg_ALU_result_out),
                    .mem_result_in(Mem_Stage_mem_out),
                    .dest_in(EXE_reg_dst_out),
                    .wb_en(WB_wb_en),
                    .mem_read(Mem_Reg_read_out),
                    .alu_result(Mem_Reg_ALU_result_out),
                    .mem_result(Mem_Reg_mem_out),
                    .dest(WB_wb_dst));


    WbStage WbStage_0(.alu_result(Mem_Reg_ALU_result_out),
                                .mem_result(Mem_Reg_mem_out),
                                .mem_read(Mem_Reg_read_out),
                                .out(WB_value));


    StatusRegister StatusRegister_0(.clk(clk),
                                    .rst(rst),
                                    .load(ID_reg_S_out),
                                    .SR_in(EXE_stage_status_out),
                                    .SR(status_reg_out));


    HazardDetectionUnit HazardDetectionUnit_0(.enable_forwarding(enable_forwarding),
                                            .two_src(has_two_src),
                                            .EXE_wb_en(ID_reg_WB_en_out),
                                            .MEM_wb_en(EXE_reg_WB_en_out),
                                            .src1(ID_stage_reg_file_src1), 
                                            .src2(ID_stage_reg_file_src2),
                                            .EXE_dest(ID_reg_reg_file_dst_out),
                                            .MEM_dest(EXE_reg_dst_out),
                                            .hazard(detected_hazard));

    ForwardingUnit ForwardingUnit_0(.enable_forwarding(enable_forwarding),
                                    .WB_wb_en(WB_wb_en),
                                    .MEM_wb_en(EXE_reg_WB_en_out),
                                    .MEM_dest(EXE_reg_dst_out),
                                    .WB_dest(WB_wb_dst),
                                    .ID_src1(ID_src1),
                                    .ID_src2(ID_src2), 
                                    .sel_src1(EXE_sel_src1),
                                    .sel_src2(EXE_sel_src2));

endmodule

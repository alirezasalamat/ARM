`include "defines.v"

module Arm(input clk, input rst);
    IfStage IfStage_0(clk, rst);
    IfReg IfReg_0(clk, rst);
    IdStage IdStage_0(clk, rst);
    IdReg IdReg_0(clk, rst);
    ExeStage ExeStage_0(clk, rst);
    ExeReg ExeReg_0(clk, rst);
    MemStage MemStage_0(clk, rst);
    MemReg MemReg_0(clk, rst);
    WbStage WbStage_0(clk, rst);
    StatusRegister StatusRegister_0();
    HazardDetectionUnit HazardDetectionUnit_0();
endmodule

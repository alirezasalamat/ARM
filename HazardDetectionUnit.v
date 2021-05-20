`include "defines.v"

module HazardDetectionUnit(enable_forwarding, two_src, EXE_wb_en, MEM_wb_en, src1, src2, EXE_dest, MEM_dest, hazard);
    input two_src, EXE_wb_en, MEM_wb_en;
    input [3:0]src1, src2;
    input [3:0]EXE_dest, MEM_dest;

    output hazard;

    assign hazard = ((src1 == EXE_dest) && (EXE_wb_en == 1'b1)) ? 1'b1
            : ((src1 == MEM_dest) && (MEM_wb_en == 1'b1)) ? 1'b1
            : ((src2 == EXE_dest) && (EXE_wb_en == 1'b1) && (two_src == 1'b1)) ? 1'b1
            : ((src2 == MEM_dest) && (MEM_wb_en == 1'b1) && (two_src == 1'b1)) ? 1'b1
            : 1'b0;
endmodule

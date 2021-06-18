`include "defines.v"

module HazardDetectionUnit(enable_forwarding, EXE_mem_read_en, two_src, EXE_wb_en, MEM_wb_en, src1, src2, EXE_dest, MEM_dest, hazard);
    input two_src, EXE_wb_en, MEM_wb_en, enable_forwarding, EXE_mem_read_en;
    input [3:0]src1, src2;
    input [3:0]EXE_dest, MEM_dest;

    output hazard;

    wire hazard_without_forwarding, hazard_with_forwarding;

    assign hazard_with_forwarding = ~EXE_mem_read_en ? 1'b0
            : ((src1 == EXE_dest) && (EXE_wb_en == 1'b1)) ? 1'b1
            : ((src2 == EXE_dest) && (EXE_wb_en == 1'b1) && (two_src == 1'b1)) ? 1'b1
            : 1'b0;

    assign hazard_without_forwarding = ((src1 == EXE_dest) && (EXE_wb_en == 1'b1)) ? 1'b1
            : ((src1 == MEM_dest) && (MEM_wb_en == 1'b1)) ? 1'b1
            : ((src2 == EXE_dest) && (EXE_wb_en == 1'b1) && (two_src == 1'b1)) ? 1'b1
            : ((src2 == MEM_dest) && (MEM_wb_en == 1'b1) && (two_src == 1'b1)) ? 1'b1
            : 1'b0;

    assign hazard = enable_forwarding ? hazard_with_forwarding : hazard_without_forwarding;

endmodule

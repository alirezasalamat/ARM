`include "defines.v"

module ForwardingUnit(enable_forwarding, WB_WB_en, MEM_WB_en, MEM_dest, WB_dest, ID_src1, ID_src2, sel_src1, sel_src2);
    input enable_forwarding, WB_WB_en, MEM_WB_en;
    input [3:0] MEM_dest, WB_dest, ID_src1, ID_src2;

    output reg [1:0] sel_src1, sel_src2;

    always @(*) begin
    sel_src1 = 2'b00;
    sel_src2 = 2'b00;
    if(enable_forwarding) begin
        if ((ID_src1 == MEM_dest) && (MEM_WB_en == 1'b1))
            sel_src1 = 2'b01;
        else if ((ID_src1 == WB_dest) && (WB_WB_en == 1'b1))
            sel_src1 = 2'b10;
        if ((ID_src2 == MEM_dest) && (MEM_WB_en == 1'b1))
            sel_src2 = 2'b01;
        else if ((ID_src2 == WB_dest) && (WB_WB_en == 1'b1))
            sel_src2 = 2'b10;
    end
  end
endmodule

`include "defines.v"

module test();
    reg clk = 1'b0;
    reg s_clk = 1'b0;
    reg rst, enable_forwarding;

    wire[63:0] SRAM_DQ;
	wire[16:0] SRAM_ADDR;
    wire SRAM_WE_N;

    always #10 clk = ~clk;
    always #20 s_clk = ~s_clk;

	Arm arm_0(clk, rst, enable_forwarding, SRAM_DQ, SRAM_ADDR, SRAM_WE_N);
	SRAM sram_0(s_clk, rst, SRAM_WE_N, SRAM_ADDR, SRAM_DQ);

    initial begin
        enable_forwarding = 1'b1;
        #10
        rst = 1;
        #5;
        rst = 0;
        #11700;

        $stop;
    end

endmodule

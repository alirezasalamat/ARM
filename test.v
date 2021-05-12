`include "defines.v"

module test();
    reg clk = 1'b0;
    reg rst;

    always #20 clk = ~clk;

    Arm arm_0(clk, rst);

    initial begin
        rst = 1;
        #10;
        rst = 0;
        #20000;
        $stop;
    end

endmodule

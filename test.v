`include "defines.v"

module test();
    reg clk = 1'b0;
    reg rst, enable_forwarding;

    always #20 clk = ~clk;

    Arm arm_0(clk, rst, enable_forwarding);

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

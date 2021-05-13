`include "defines.v"

module test();
    reg clk = 1'b0;
    reg rst;

    always #20 clk = ~clk;

    Arm arm_0(clk, rst);

    initial begin
        #10
        rst = 1;
        #5;
        rst = 0;
<<<<<<< HEAD
        #10000;
=======
        #4000;
>>>>>>> 17e82702a18ac523a8b24539499aef30823b4dc4
        $stop;
    end

endmodule

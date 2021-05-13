`include "defines.v"

module ALU(val1, val2, cin, exe_cmd, result, SR);
    input [31:0]val1, val2;
    input cin;
    input [3:0]exe_cmd;
    
    output [31:0]result;
    output [3:0]SR;

    reg [32:0]temp_result;
    reg cout, v;
    wire n, z;

    always @(*) begin
        v = 1'b0;
        cout = 1'b0;
        case (exe_cmd)
            `MOV_EXE: begin
                temp_result = val2;
            end
            `MVN_EXE: begin
                temp_result = ~val2;
            end
            `ADD_EXE: begin
                temp_result = val1 + val2;
                cout = temp_result[32];
                v = ((val1[31] == val2[31]) & (temp_result[31] != val1[31]));
            end
            `ADC_EXE: begin
                temp_result = val1 + val2 + cin;
                cout = temp_result[32];
                v = ((val1[31] == val2[31]) & (temp_result[31] != val1[31]));
            end
            `SUB_EXE: begin
                temp_result = {val1[31], val1} - {val2[31], val2};
                $display("@%t: ALU::CMP :  val1: %d  val2: %d negative is: %d", $time, val1, val2, n);
                cout = temp_result[32];
                v = ((val1[31] == ~val2[31]) & (temp_result[31] != val1[31]));
            end
            `SBC_EXE: begin
                temp_result = {val1[31], val1} - {val2[31], val2} - {32'b0, ~cin};
                cout = temp_result[32];
                v = ((val1[31] == ~val2[31]) & (temp_result[31] != val1[31]));
            end
            `AND_EXE: begin
                temp_result = val1 & val2;
            end
            `ORR_EXE: begin
                temp_result = val1 | val2;
            end
            `EOR_EXE: begin
                temp_result = val1 ^ val2;
            end
<<<<<<< HEAD
            `CMP_EXE: begin
                temp_result = {val1[31], val1} - {val2[31], val2};
                
                cout = temp_result[32];
                v = ((val1[31] == ~val2[31]) & (temp_result[31] != val1[31]));
            end
=======
>>>>>>> 17e82702a18ac523a8b24539499aef30823b4dc4
            `TST_EXE: begin
                temp_result = val1 & val2;
            end
            //`LDR_EXE: begin
            //    temp_result = val1 + val2;
            //end
            //`STR_EXE: begin
            //    // @TODO: - or + ?
            //    temp_result = val1 + val2;
            //end
        endcase
    end

    assign result = temp_result[31:0];
    assign z = (result == 32'b0) ? 1 : 0;
    assign n = result[31];
    assign SR = {z, cout, n, v};
endmodule

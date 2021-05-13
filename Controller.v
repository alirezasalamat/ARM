`include "defines.v"

module Controller(S, mode, op_code, exe_cmd, mem_read, mem_write, wb_en, S_out, B, is_ldr);
  input S;
  input [1:0] mode;
  input [3:0] op_code;

  output reg [3:0] exe_cmd;
  output reg mem_read;
  output reg mem_write;
  output reg wb_en;
  output reg S_out;
  output reg B;
  output reg is_ldr;

  always @(*) begin
    mem_read = 0;
    mem_write = 0;
    wb_en = 0;
    B = 0;
    S_out = S;
    is_ldr = 0;

    case (mode)
      `MEM_MODE: begin
          case (S)
              0: begin
                  exe_cmd = `ADD_EXE;
                  mem_write = 1;
              end

              1: begin
                  exe_cmd = `ADD_EXE;
                  mem_read = 1;
                  wb_en = 1;
                  is_ldr = 1;
              end
          endcase
      end

      `ARITHMETIC_MODE: begin
          case (op_code)
              `MOV_OP: begin
                  exe_cmd = `MOV_EXE;
                  wb_en = 1;
              end

              `MVN_OP: begin
                  exe_cmd = `MVN_EXE;
                  wb_en = 1;
              end

              `ADD_OP: begin
                  exe_cmd = `ADD_EXE;
                  wb_en = 1;
              end

              `ADC_OP: begin
                  exe_cmd = `ADC_EXE;
                  wb_en = 1;
              end

              `SUB_OP: begin
                  exe_cmd = `SUB_EXE;
                  wb_en = 1;
              end

              `SBC_OP: begin
                  exe_cmd = `SBC_EXE;
                  wb_en = 1;
              end
              `AND_OP: begin
                  exe_cmd = `AND_EXE;
                  wb_en = 1;
              end

              `ORR_OP: begin
                  exe_cmd = `ORR_EXE;
                  wb_en = 1;
              end

              `EOR_OP: begin
                  exe_cmd = `EOR_EXE;
                  wb_en = 1;
              end

              `CMP_OP: begin
                  exe_cmd = `SUB_EXE;
              end

              `TST_OP: begin
                  exe_cmd = `TST_EXE;
              end
          endcase
      end

      `BRANCH_MODE: begin
          B = 1'b1;
          S_out = 1'b0;
      end
    endcase
  end
endmodule

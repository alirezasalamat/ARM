`timescale 1ns/1ns

`define WORD 32
`define REG_FILE 4
`define SIGNED_IMM 24
`difine SHIFTER_OPERAND 12
`define COMMAND 4

`define ARITHMETIC_MODE 2'b00
`define MEM_MODE 2'b01
`define BRANCH_MODE 2'b10

`define MOV_OP 4'b1101
`define MVN_OP 4'b1111
`define ADD_OP 4'b0100
`define ADC_OP 4'b0101
`define SUB_OP 4'b0010
`define SBC_OP 4'b0110
`define AND_OP 4'b0000
`define ORR_OP 4'b1100
`define EOR_OP 4'b0001
`define CMP_OP 4'b1010
`define TST_OP 4'b1000
`define LDR_OP 4'b0100
`define STR_OP 4'b0100

`define MOV_EXE 4'b0001
`define MVN_EXE 4'b1001
`define ADD_EXE 4'b0010
`define ADC_EXE 4'b0011
`define SUB_EXE 4'b0100
`define SBC_EXE 4'b0101
`define AND_EXE 4'b0110
`define ORR_EXE 4'b0111
`define EOR_EXE 4'b1000
`define CMP_EXE 4'b1000
`define TST_EXE 4'b0110
`define LDR_EXE 4'b0010
`define STR_EXE 4'b0010

`define EQ 4'b0000
`define NE 4'b0001
`define CS_HS 4'b0010
`define CC_LO 4'b0011
`define MI 4'b0100
`define PL 4'b0101
`define VS 4'b0110
`define VC 4'b0111
`define HI 4'b1000
`define LS 4'b1001
`define GE 4'b1010
`define LT 4'b1011
`define GT 4'b1100
`define LE 4'b1101
`define AL 4'b1110

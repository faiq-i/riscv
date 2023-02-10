`ifndef RISCV_defs
`define RISCV_defs

`define NO_STALL        1'b0

`define RF_XLEN         32
`define RF_ADDRESSLEN   5
`define RF_SIZE         32

`define IM_XLEN         8
`define IM_INSTLEN      32
`define IM_ADDRESSLEN   32
`define IM_SIZE         4096

`define DM_XLEN         8
`define DM_SIZE         1024

`define PC_INCREMENT    4

`define ALU_OPSLEN      4
`define ALU_OPS_ADD     0
`define ALU_OPS_SUB     1
`define ALU_OPS_SLL     2
`define ALU_OPS_SLT     3
`define ALU_OPS_SLTU    4
`define ALU_OPS_XOR     5
`define ALU_OPS_SRL     6
`define ALU_OPS_SRA     7
`define ALU_OPS_OR      8
`define ALU_OPS_AND     9
`define ALU_OPS_A       10
`define ALU_OPS_B       11
`define ALU_OPS_JALR    12
`define ALU_OPS_DEFAULT 13

`define DM_OPSLEN       4
`define DM_OPS_LB       0
`define DM_OPS_LBU      1
`define DM_OPS_LH       2
`define DM_OPS_LHU      3
`define DM_OPS_LW       4
`define DM_OPS_SB       5
`define DM_OPS_SH       6
`define DM_OPS_SW       7
`define DM_OPS_DEFAULT  8

`define BR_OPSLEN       3
`define BR_OPS_EQ       0
`define BR_OPS_NE       1
`define BR_OPS_LT       2
`define BR_OPS_GE       3
`define BR_OPS_LTU      4
`define BR_OPS_GEU      5
`define BR_OPS_UNCOND   6
`define BR_OPS_DEFAULT  7

`define WB_SEL_ALU      0
`define WB_SEL_DM       1
`define WB_SEL_PC       2
`define WB_SEL_CSR      3

`define CSR_MIP_ADDR        12'h344
`define CSR_MIE_ADDR        12'h304
`define CSR_MSTATUS_ADDR    12'h300
`define CSR_MTVEC_ADDR      12'h305
`define CSR_MEPC_ADDR       12'h341
`define CSR_MCAUSE_ADDR     12'h342

`endif
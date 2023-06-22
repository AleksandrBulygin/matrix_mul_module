// ===========================================================
// RTL generated by ActiveCore framework
// Date: 2022-01-02 17:07:59
// Copyright Alexander Antonov <antonov.alex.alex@gmail.com>
// ===========================================================

`ifndef __riscv_5stage_h_
`define __riscv_5stage_h_

`ifndef __genstructdel_riscv_5stage_busreq_mem_struct_
`define __genstructdel_riscv_5stage_busreq_mem_struct_
typedef struct packed {
	logic unsigned [31:0] addr;
	logic unsigned [3:0] be;
	logic unsigned [31:0] wdata;
} riscv_5stage_busreq_mem_struct;
`endif // __genstructdel_riscv_5stage_busreq_mem_struct_

`ifndef __genstructdel_genpmodule_riscv_5stage_genmcopipe_instr_mem_genstruct_fifo_wdata_
`define __genstructdel_genpmodule_riscv_5stage_genmcopipe_instr_mem_genstruct_fifo_wdata_
typedef struct packed {
	logic unsigned [0:0] we;
	riscv_5stage_busreq_mem_struct wdata;
} genpmodule_riscv_5stage_genmcopipe_instr_mem_genstruct_fifo_wdata;
`endif // __genstructdel_genpmodule_riscv_5stage_genmcopipe_instr_mem_genstruct_fifo_wdata_

`ifndef __genstructdel_genpmodule_riscv_5stage_genmcopipe_data_mem_genstruct_fifo_wdata_
`define __genstructdel_genpmodule_riscv_5stage_genmcopipe_data_mem_genstruct_fifo_wdata_
typedef struct packed {
	logic unsigned [0:0] we;
	riscv_5stage_busreq_mem_struct wdata;
} genpmodule_riscv_5stage_genmcopipe_data_mem_genstruct_fifo_wdata;
`endif // __genstructdel_genpmodule_riscv_5stage_genmcopipe_data_mem_genstruct_fifo_wdata_

`ifndef __genstructdel_riscv_5stage_Ext_coproc_struct_
`define __genstructdel_riscv_5stage_Ext_coproc_struct_
typedef struct packed {
	logic unsigned [31:0] instr_code;
	logic unsigned [31:0] src0;
	logic unsigned [31:0] src1;
} riscv_5stage_Ext_coproc_struct;
`endif // __genstructdel_riscv_5stage_Ext_coproc_struct_

`ifndef __genstructdel_genpmodule_riscv_5stage_genmcopipe_coproc_M_if_genstruct_fifo_wdata_
`define __genstructdel_genpmodule_riscv_5stage_genmcopipe_coproc_M_if_genstruct_fifo_wdata_
typedef struct packed {
	logic unsigned [0:0] we;
	riscv_5stage_Ext_coproc_struct wdata;
} genpmodule_riscv_5stage_genmcopipe_coproc_M_if_genstruct_fifo_wdata;
`endif // __genstructdel_genpmodule_riscv_5stage_genmcopipe_coproc_M_if_genstruct_fifo_wdata_

`ifndef __genstructdel_genpmodule_riscv_5stage_genmcopipe_coproc_custom0_if_genstruct_fifo_wdata_
`define __genstructdel_genpmodule_riscv_5stage_genmcopipe_coproc_custom0_if_genstruct_fifo_wdata_
typedef struct packed {
	logic unsigned [0:0] we;
	riscv_5stage_Ext_coproc_struct wdata;
} genpmodule_riscv_5stage_genmcopipe_coproc_custom0_if_genstruct_fifo_wdata;
`endif // __genstructdel_genpmodule_riscv_5stage_genmcopipe_coproc_custom0_if_genstruct_fifo_wdata_

`endif // __riscv_5stage_h_

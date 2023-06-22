/*
 * sigma.sv
 *
 *  Created on: 24.09.2017
 *      Author: Alexander Antonov <antonov.alex.alex@gmail.com>
 *     License: See LICENSE file for details
 */


`include "sigma_tile.svh"

module sigma
#(
	parameter CPU = "none"
	, UDM_BUS_TIMEOUT = (1024*1024*100)
	, UDM_RTX_EXTERNAL_OVERRIDE = "NO"
	, DEBOUNCER_FACTOR_POW = 20
	, delay_test_flag = 0
	, mem_init_type="elf"
	, mem_init_data = "data.elf"
	, mem_size = 1024
)
(
	input clk_i
	, input arst_i
	, input irq_btn_i
	, input rx_i
	, output tx_o
	, input [31:0] gpio_bi
	, output [31:0] gpio_bo
);

wire srst;
reset_sync reset_sync
(
	.clk_i(clk_i),
	.arst_i(arst_i),
	.srst_o(srst)
);

wire udm_reset;
wire cpu_reset;
assign cpu_reset = srst | udm_reset;

wire irq_btn_debounced;
debouncer
#(
    .FACTOR_POW(DEBOUNCER_FACTOR_POW)
) debouncer (
	.clk_i(clk_i)
	, .rst_i(srst)
	, .in(irq_btn_i)
	, .out(irq_btn_debounced)
);

MemSplit32 hif();
MemSplit32 xif();

localparam IRQ_NUM_POW = 4;

logic start_mat_mul, clear_mat_mul, mul_done;
logic [31:0] A[0:63], B[0:63], C [0:63], Result_mul[0:63];
integer i;

sigma_tile #(
	.corenum(0)
	, .mem_init_type(mem_init_type)
	, .mem_init_data(mem_init_data)
	, .mem_size(mem_size)
	, .CPU(CPU)
	, .PATH_THROUGH("YES")
	, .IRQ_NUM_POW(IRQ_NUM_POW)
) sigma_tile (
	.clk_i(clk_i)
	, .rst_i(cpu_reset)

	, .irq_debounced_bi({1'b0, irq_btn_debounced, 3'h0})
	
	, .hif(hif)
	, .xif(xif)
);
	
udm #(
    .BUS_TIMEOUT(UDM_BUS_TIMEOUT)
    , .RTX_EXTERNAL_OVERRIDE(UDM_RTX_EXTERNAL_OVERRIDE)
) udm (
	.clk_i(clk_i)
	, .rst_i(srst)

	, .rx_i(rx_i)
	, .tx_o(tx_o)

	, .rst_o(udm_reset)
	
	, .bus_req_o(hif.req)
	, .bus_we_o(hif.we)
	, .bus_addr_bo(hif.addr)
	, .bus_be_bo(hif.be)
	, .bus_wdata_bo(hif.wdata)
	, .bus_ack_i(hif.ack)
	, .bus_resp_i(hif.resp)
	, .bus_rdata_bi(hif.rdata)
);

matrix_mul Mat_mul88(.A(A),
                     .B(B),
                     .C(Result_mul),
                     .clk(clk_i),
                     .reset(arst_i),
                     .clear(clear_mat_mul),
                     .start(start_mat_mul),
                     .done(mul_done));

localparam CSR_LED_ADDR         = 32'h80000000;
localparam CSR_SW_ADDR          = 32'h80000004;
localparam start_mat_mul_ADDR   = 32'hc0000004;
localparam clear_mat_mul_ADDR   = 32'hc0000000;
localparam done_ADDR            = 32'h90000000;

logic [31:0] gpio_bo_reg;
assign gpio_bo = gpio_bo_reg;
logic [31:0] gpio_bi_reg;
always @(posedge clk_i) gpio_bi_reg <= gpio_bi;

assign xif.ack = xif.req;   // xif always ready to accept request
logic csr_resp;
logic [31:0] csr_rdata;


// bus request
always @(posedge clk_i)
    begin
    
    csr_resp <= 1'b0;
    
    if (arst_i) begin
        for (i = 0; i < 64; i++) begin: resetCloop
            C[i] <= 0;
            A[i] <= 0;
            B[i] <= 0;
        end
        start_mat_mul <= 0;
        clear_mat_mul <= 0;
        end
    else begin
        if(mul_done)
        for(i = 0; i < 64; i++) begin: assignCloop
            
            C[i] <= Result_mul[i];
        end
   end
    
    if (xif.req && xif.ack)
        begin
        
        if (xif.we)     // writing
            begin
            if (xif.addr == CSR_LED_ADDR) gpio_bo_reg <= xif.wdata;
            
            // matrix multiplication data writing
            if (xif.addr[31:28] == 4'hc && xif.addr[8:0] > 9'h4 && xif.addr[8:0] < 9'h105 && ~arst_i) A[xif.addr[8:2] - 2'h2] <= xif.wdata;
            if (xif.addr[31:28] == 4'hc && xif.addr[9:0] > 10'h104 && xif.addr[9:0] < 10'h205 && ~arst_i) B[xif.addr[9:2] - 10'h42] <= xif.wdata;
            if(xif.addr == start_mat_mul_ADDR && ~arst_i) start_mat_mul <= xif.wdata;
            if(xif.addr == clear_mat_mul_ADDR && ~arst_i) clear_mat_mul <= xif.wdata;
            
            
            end
        
        else            // reading
            begin
            if (xif.addr == CSR_LED_ADDR)
                begin
                csr_resp <= 1'b1;
                csr_rdata <= gpio_bo_reg;
                end
            if (xif.addr == CSR_SW_ADDR)
                begin
                csr_resp <= 1'b1;
                csr_rdata <= gpio_bi_reg;
                end
            end
            
           // matrix multiplication data reading
            if (xif.addr > 32'hc0000204 && xif.addr < 32'hc0000305)
                begin
                csr_resp <= 1'b1;
                csr_rdata <= C[xif.addr[11:2] - 32'h82];
            end
            if (xif.addr == done_ADDR)
                begin
                csr_resp <= 1'b1;
                csr_rdata <= mul_done;
                end
        end
    end

// bus response
always @*
    begin
    xif.resp = csr_resp;
    xif.rdata = 0;
    if (csr_resp) xif.rdata = csr_rdata;
    end

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.10.2022 15:56:20
// Design Name: 
// Module Name: matrix_mul
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define MAT_DIM_LEN 8
`define ITER_DATA_LEN 63

module matrix_mul(input logic [31:0] A [0:`ITER_DATA_LEN], B [0:`ITER_DATA_LEN],
                    input logic reset, clk, clear, start,
                    output logic [31:0] C [0:`ITER_DATA_LEN],
                    output logic done);
                    
                localparam [7:0] line_shift_array[0:7] = {0, 8, 16, 24, 32, 40, 48, 56};
                
                integer i, j, k, c;
                
                logic [2:0]cntr_mul, cntr_MAC,
                 cntr_add[0:`MAT_DIM_LEN-1], cntr_MAC_delay1, cntr_MAC_delay2,
                 cntr_MAC_delay3, cntr_MAC_delay4, cntr_MAC_delay5,
                 cntr_MAC_delay6, cntr_MAC_delay7;
                
                logic [31:0] Result [0:`MAT_DIM_LEN-1], MAC[0:`MAT_DIM_LEN-1][0:`MAT_DIM_LEN-1], 
                mul_reg[0:`MAT_DIM_LEN-1][0:`ITER_DATA_LEN],
                A_REG[0:`ITER_DATA_LEN], B_REG[0:`ITER_DATA_LEN], cntr_mul_reg;
                
                logic [32:0] cntr;
                always @(posedge clk, posedge reset)
                begin
                    if (reset | clear) 
                    begin
                        
                        for(i = 0; i < `ITER_DATA_LEN + 1; i = i + 1) 
                        begin: forloop
                            C[i] <= 0;
                            A_REG[i] <= 0;
                            B_REG[i] <= 0;
                            for(j = 0; j < `MAT_DIM_LEN; j++)
                            mul_reg[j][i] <= 0;
                        end
                        for(k = 0; k < `MAT_DIM_LEN; k++) begin: resetMAC
                            Result[k] <= 0;
                            for(j = 0; j < `MAT_DIM_LEN; j++) begin: resmacCol
                                MAC[k][j] <= 0;
                            end
                        end
                    cntr <= 0;
                    done <= 1'b0;
                    cntr_mul <= 0;
                    cntr_mul_reg <= 0;
                    cntr_MAC <= 0;
                    cntr_MAC_delay1 <= 0;
                    cntr_MAC_delay2 <= 0;
                    cntr_MAC_delay3 <= 0;
                    cntr_MAC_delay4 <= 0;
                    cntr_MAC_delay5 <= 0;
                    cntr_MAC_delay6 <= 0;
                    cntr_MAC_delay7 <= 0;
                    cntr_add <= {0, 0, 0, 0, 0, 0, 0, 0};
                    
                    end
                    else begin 
                    
                    if (cntr_MAC_delay7 == 3'd2) begin C[0:7] <= Result; done <= 1'b0; end
                    else if (cntr_MAC_delay7 == 3'd3) begin C[8:15] <= Result; done <= 1'b0; end
                    else if (cntr_MAC_delay7 == 3'd4) begin C[16:23] <= Result; done <= 1'b0; end 
                    else if (cntr_MAC_delay7 == 3'd5)  begin C[24:31] <= Result; done <= 1'b0; end
                    else if (cntr_MAC_delay7 == 3'd6) begin C[32:39] <= Result; done <= 1'b0; end
                    else if (cntr_MAC_delay7 == 3'd7) begin C[40:47] <= Result; done <= 1'b0; end
                    else if (cntr_MAC_delay7 == 3'd0) begin C[48:55] <= Result; done <= 1'b0; end
                    else if (cntr_MAC_delay7 == 3'd1) begin C[56:63] <= Result; done <= 1'b0; end
                    
                    if(cntr_MAC_delay5 == 3'd0 && cntr > 4'he)
                        done <= 1'b1;
                    
                    if(start) begin
                        cntr <= cntr + 1'b1;
                        cntr_mul <= cntr;
                        cntr_mul_reg <= cntr[2:0]*`MAT_DIM_LEN;
                        cntr_MAC <= cntr_mul;
                        cntr_add <= {cntr_MAC, cntr_MAC_delay1, cntr_MAC_delay2,
                        cntr_MAC_delay3, cntr_MAC_delay4, cntr_MAC_delay5,
                        cntr_MAC_delay6, cntr_MAC_delay7};
                        cntr_MAC_delay1 <= cntr_MAC;
                        cntr_MAC_delay2 <= cntr_MAC_delay1;
                        cntr_MAC_delay3 <= cntr_MAC_delay2;
                        cntr_MAC_delay4 <= cntr_MAC_delay3;
                        cntr_MAC_delay5 <= cntr_MAC_delay4;
                        cntr_MAC_delay6 <= cntr_MAC_delay5;
                        cntr_MAC_delay7 <= cntr_MAC_delay6;
                        A_REG <= A;
                        B_REG <= B;
                     
                    MAC[0] <= {mul_reg[cntr_MAC][0], mul_reg[cntr_MAC][8], 
                    mul_reg[cntr_MAC][16], mul_reg[cntr_MAC][24],
                    mul_reg[cntr_MAC][32], mul_reg[cntr_MAC][40],
                    mul_reg[cntr_MAC][48], mul_reg[cntr_MAC][56]};
                    
                for (i = 0; i < `MAT_DIM_LEN; i++) begin: looprow
                    mul_reg[cntr_mul][line_shift_array[i]] <= A_REG[cntr_mul_reg]*B_REG[i];
                    for(j = 1; j < `MAT_DIM_LEN; j++) begin: loopcolumn
                            mul_reg[cntr_mul][line_shift_array[i] + j] <= A_REG[cntr_mul_reg + j]*B_REG[i + line_shift_array[j]];
                    end
                end
                
                for (i = 1; i < `MAT_DIM_LEN; i++) begin: loop_add_prev
                    for(j = 0; j < `MAT_DIM_LEN; j++) begin: loopcolumn_add_prev
                            MAC[i][j] <= MAC[i-1][j] + mul_reg[cntr_add[i-1]][i + line_shift_array[j]];
                    end
                end
                
                Result <= MAC[`MAT_DIM_LEN-1];
                               
                end 
                end
                end
                
endmodule

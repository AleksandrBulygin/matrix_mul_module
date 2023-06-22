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


module matrix_mul(input logic [31:0] A [0:24], B [0:24],
                    input logic reset, clk, clear, start,
                    output logic [31:0] C [0:24]);
                
                integer i, j, k;
                
                logic [31:0] Result [0:24];
                always @(posedge clk, posedge reset)
                begin
                    if (reset | clear) 
                    begin
                    
                        for(i = 0; i < 25; i = i + 1) 
                        begin: forloop
                        
                            Result[i] <= 0;
                            C[i] <= 0;
                        end
                    end
                    else 
                    C <= Result;
                end
                
                always_comb
                if (start) begin
                
                for (i = 0; i < 5; i++) begin: looprow
                    for(j = 0; j < 5; j++) begin: loopcolumn
                        for(k = 0; k < 5; k++) begin: loopcell
                        if(k == 0)
                            Result[5*i+j] = A[5*i+k]*B[5*k+j];
                         else 
                            Result[5*i+j]  = Result[5*i+j] + A[5*i+k]*B[5*k+j];
                        end
                    end
                end
                
                end
                
                
endmodule

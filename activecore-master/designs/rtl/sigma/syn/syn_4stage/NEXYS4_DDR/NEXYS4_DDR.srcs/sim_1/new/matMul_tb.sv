`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.10.2022 23:52:10
// Design Name: 
// Module Name: matMul_tb
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


module matMul_tb();

logic clk, reset, start, clear;

logic [31:0] A[0:24], B[0:24], C[0:24];

integer i;

matrix_mul dut(.A(A),
               .B(B),
               .C(C),
               .clk(clk),
               .reset(reset),
               .clear(clear),
               .start(start));
               
always
begin

clk = 1; #5; clk = 0; #5;

end

initial
begin

reset = 1; clear = 0; start = 0; #27; reset = 0;

clear = 1; #10; clear = 0;

A = '{32'd10, 32'd12, 32'd58, 32'd95, 32'd75,
      32'd58, 32'd25, 32'd14, 32'd65, 32'd5,
      32'd75, 32'd21, 32'd23, 32'd95, 32'd87,
      32'd45, 32'd21, 32'd89, 32'd17, 32'd65,
      32'd14, 32'd85, 32'd65, 32'd84, 32'd45};
     
B = '{32'd45, 32'd65, 32'd84, 32'd25, 32'd87,
      32'd98, 32'd35, 32'd11, 32'd87, 32'd66,
      32'd12, 32'd87, 32'd65, 32'd12, 32'd56,
      32'd42, 32'd53, 32'd12, 32'd85, 32'd45,
      32'd87, 32'd12, 32'd65, 32'd87, 32'd255};
     
start = 1;     #50; 

for(i = 0; i < 25; i++) begin: checkloop

    $display("%d", C[i]);

end

start = 0; clear = 1; #10;

for(i = 0; i < 25; i++) begin: checkloop2

    $display("%d", C[i]);

end

start = 1; clear = 0; #10;

for(i = 0; i < 25; i++) begin: checkloop3

    $display("%d", C[i]);

end

end


endmodule

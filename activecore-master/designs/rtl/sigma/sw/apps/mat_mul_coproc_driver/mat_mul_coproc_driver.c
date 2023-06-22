#include "io.h"
#include <malloc.h>

#define N 8

#define N2 N*N


// wrapper for instruction activating custom coprocessor
inline unsigned int custom0_instr_wrapper (unsigned int a, unsigned int b) { 
	unsigned int result;
	asm volatile (".insn r 0x0b, 0x0, 0x0, %0, %1, %2" 
		: "=r" (result) 
		: "r" (a), "r" (b)); 
		return result;
	}

int main(int argc, char *argv[]) {

	IO_LED = 0x55aa;
    int i;
    int j;

    unsigned int A[N][N] = {
            {10, 12, 58, 95, 75, 45, 65, 84},
            {58, 25, 14, 65, 5,  21, 95, 14},
            {75, 21, 23, 95, 87, 47, 65, 68},
            {45, 21, 89, 17, 65, 43, 75, 73},
            {14, 85, 65, 84, 45, 36, 84, 16},
            {15, 35, 54, 35, 65, 14, 87, 65},
            {45, 45, 87, 35, 34, 25, 65, 48},
            {98, 25, 65, 48, 65, 45, 21, 88},
    };
    unsigned int B[N][N] = {
            {45, 65, 84, 25, 87,  47, 56, 87},
            {98, 35, 11, 87, 66,  68, 45, 58},
            {12, 87, 65, 12, 56,  57, 65, 45},
            {42, 53, 12, 85, 45,  24, 65, 21},
            {87, 12, 65, 87, 255, 87, 25, 65},
            {45, 68, 48, 68, 48,  68, 78, 32},
            {68, 98, 24, 35, 45,  68, 78, 45},
            {68, 87, 35, 36, 87,  57, 69, 1}
    };
	
	
	
	
	for(i = 0; i < N; i++) {
		for(j = 0; j < N; j++){
			
		custom0_instr_wrapper(A[i][j], B[i][j]);
			
		}
	}
	
	IO_LED = 0;
	for(i = 0; i < N2; i++) {
		
		io_buf_int[i] = custom0_instr_wrapper(0, 0);
	}
	
	IO_LED = 0xdddd;
	
	while (1) {}
	return 0;
	
}
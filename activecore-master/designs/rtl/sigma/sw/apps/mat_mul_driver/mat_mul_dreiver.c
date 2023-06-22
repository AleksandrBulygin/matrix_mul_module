#include "io.h"

#define CLEAR (*(volatile unsigned int*) 0xc0000000)
#define START (*(volatile unsigned int*) 0xc0000004)

#define A_ADDR (*(volatile unsigned int*) 0xc0000008)
#define B_ADDR (*(volatile unsigned int*) 0xc0000108)

#define C_ADDR 0xc0000208

#define IO_MATRIX_INT_LENGTH 0x40

#define io_matrix_int        (*(volatile int (*)[IO_MATRIX_INT_LENGTH])(C_ADDR))

#define done_addr (*(volatile unsigned int*) 0x90000000)

#define N 8

#define N2 N*N

int main(int argc, char *argv[]) {
	
	IO_LED = 0x55aa;
	
    CLEAR = 1;
    START = 0;


    int i;
    int j;
    volatile unsigned int *data_pntr;
    unsigned int data_shift;

    int A[N][N] = {
            {10, 12, 58, 95, 75, 45, 65, 84},
            {58, 25, 14, 65, 5,  21, 95, 14},
            {75, 21, 23, 95, 87, 47, 65, 68},
            {45, 21, 89, 17, 65, 43, 75, 73},
            {14, 85, 65, 84, 45, 36, 84, 16},
            {15, 35, 54, 35, 65, 14, 87, 65},
            {45, 45, 87, 35, 34, 25, 65, 48},
            {98, 25, 65, 48, 65, 45, 21, 88},
    };
    int B[N][N] = {
            {45, 65, 84, 25, 87,  47, 56, 87},
            {98, 35, 11, 87, 66,  68, 45, 58},
            {12, 87, 65, 12, 56,  57, 65, 45},
            {42, 53, 12, 85, 45,  24, 65, 21},
            {87, 12, 65, 87, 255, 87, 25, 65},
            {45, 68, 48, 68, 48,  68, 78, 32},
            {68, 98, 24, 35, 45,  68, 78, 45},
            {68, 87, 35, 36, 87,  57, 69, 1}
    };


    for (i = 0; i < N; i += 1) {
        for (j = 0; j < N; j += 1) {
            data_shift = N * i + j;
            data_pntr = &A_ADDR + data_shift;
            *data_pntr = A[i][j];
            data_pntr = &B_ADDR + data_shift;
            *data_pntr = B[i][j];
        }
    }

    CLEAR = 0;
    START = 1;

    while (1) {
	if(done_addr) break;}
	
	for(i = 0; i < N2; i++) io_buf_int[i] = io_matrix_int[i];
	
	IO_LED = 0xdddd;

	return 0;
}
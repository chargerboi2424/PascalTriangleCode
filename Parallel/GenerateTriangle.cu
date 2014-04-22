#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include <stdlib.h>
#include <ctime>

#define Nglobal 4096

__global__ void add(int *rowP, int *rowC, int i) 
{ 
	if(blockIdx.x == 0 || blockIdx.x == i-1){
		rowC[blockIdx.x] = 1;
	}
	else{
		rowC[blockIdx.x] = rowP[blockIdx.x-1] + rowP[blockIdx.x];
	}
} 

cudaError_t GenerateTriangle(int n){
	int previousRow[Nglobal+1];
	for(int i = 0; i <= n; i++){
		previousRow[i] = 0;
	}
	previousRow[0] = 1;
	previousRow[1] = 1;
	int currentRow[Nglobal+1];
	for(int i = 0; i <= n; i++){
		currentRow[i] = 0;
	}
	int *dPreviousRow, *dCurrentRow;
	cudaMalloc((void **) &dPreviousRow, sizeof(previousRow));
	cudaMalloc((void **) &dCurrentRow, sizeof(currentRow));
	cudaMemcpy(dPreviousRow, previousRow, sizeof (previousRow), cudaMemcpyHostToDevice);
	cudaMemcpy(dCurrentRow, currentRow, sizeof (currentRow), cudaMemcpyHostToDevice);
	for(int i = 3; i <= n+1; i++){
		//actual calculations are done in this loop
		add<<<i,1>>>(dPreviousRow, dCurrentRow, i);
		cudaMemcpy(dPreviousRow, dCurrentRow, (n+1)* sizeof (int), cudaMemcpyDeviceToDevice);
	}
	//at this point currentRow needs to be copied to finRow
	cudaMemcpy(currentRow, dCurrentRow, (n+1)* sizeof (int), cudaMemcpyDeviceToHost);
	for(int i = 0; i < n+1; i++){
		printf("%d ",currentRow[i]);
	}
	printf("\n");
	return cudaSuccess;
}

int main( int argc, const char* argv[] )
{
	clock_t Start = clock();
	int n = Nglobal;
	printf( "N is %d\n", n);
	if(n==1){
		printf("1\n");
		return 0;
	}
	if(n==2){
		printf("1 1\n");
		return 0;
	}
	cudaError_t cudaStatus;
	cudaStatus = GenerateTriangle(n);
	if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "generation failed!");
        return 1;
     }
	cudaStatus = cudaDeviceReset();
     if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaDeviceReset failed!");
        return 1;
     }
	int stopTime = clock();
	printf("Elapsed Time: %i Milliseconds\n",clock() - Start);
     return 0;
}
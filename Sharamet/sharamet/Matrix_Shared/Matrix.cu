#include <stdio.h>
#include <cuda.h>
#define BlockSize 256

__global__ void initA(int *A, int numElements) {
	int i = blockDim.x * blockIdx.x + threadIdx.x;
	int j = blockDim.y * blockIdx.y + threadIdx.y;
	if (i < numElements && j<numElements)
		if(i==j)
			A[i*numElements+j]=1;
		else A[i*numElements+j]=0;
}

__global__ void initB(int *B, int numElements) {
	int i = blockDim.x * blockIdx.x + threadIdx.x;
	if (i < numElements)
		B[i]=i;
}


__global__ void MatMult(int *A, int *B, int *C, int numElements){
	int bx=blockIdx.x;
	int bs=blockDim.x;
	int tx=threadIdx.x;
	int step=bs;
	int sum=0;
	for(int i=0;i<numElements;i+=step){
		
		__shared__ int b[BlockSize];
		
		b[tx]=B[i+bx*bs+tx];
		__syncthreads();
		
		for(int k=0;k<bs;k++)
			sum+=A[(k+i)*numElements +bs*bx+tx]*b[tx];
		__synchthreads();
	}
	C[bs*bx + tx]=sum;
}



__host__ int main(void) {
	cudaError_t err = cudaSuccess;
	cudaEvent_t start, stop;
	float gpuTime=0.0f;
	const int numElements = 21504;
	const int k=16;
	size_t size1 = numElements * numElements * sizeof(int);
	size_t size2 = numElements * sizeof(int);

	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	
	int *h_C  =(int *)malloc(size2);
	
	int *d_A = NULL;
	err = cudaMalloc((void **)&d_A, size1);
	if (err != cudaSuccess){
		printf("malloc_d_A error\n");
		return 0;
	}
	
	int *d_B = NULL;
	err = cudaMalloc((void **)&d_B, size2);
	if (err != cudaSuccess){
		printf("malloc_d_B error\n");
		return 0;
	}

	int *d_C= NULL;
	err = cudaMalloc((void **)&d_C,size2);
	if (err != cudaSuccess){
		printf("malloc_d_C error\n");
		return 0;
	}
	
	dim3 threadsPerBlock(k,k);
	
	int BlockSizeI=((numElements + k -1)/k);
                                              
	int BlockSizeC=((numElements + k*k -1)/(k*k));

	dim3 blocksPerGrid (BlockSizeI, BlockSizeI);
	
	initA<<<blocksPerGrid, threadsPerBlock>>>(d_A, numElements);
	err = cudaGetLastError();
	if (err != cudaSuccess){
		printf("initA error\n");
		return 0;
	}

	threadsPerBlock = k*k;
	blocksPerGrid = BlockSizeC;
	
	initB<<<blocksPerGrid, threadsPerBlock>>>(d_B, numElements);
	err = cudaGetLastError();
	if (err != cudaSuccess){
		printf("initB error\n");
		return 0;
	}
		
	cudaEventRecord(start,0);

	
	MatMult<<<blocksPerGrid, threadsPerBlock>>>(d_A, d_B, d_C, numElements);
	err = cudaGetLastError();
	if (err != cudaSuccess){
		printf("MatAdd error\n");
		return 0;
	}
	
	cudaEventRecord(stop,0);
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&gpuTime,start,stop);
	
	printf("Time: %.9f msec.",gpuTime);
	
	cudaMemcpy(h_C, d_C, size2, cudaMemcpyDeviceToHost);
	
	err = cudaFree(d_A);
	err = cudaFree(d_B);
	err = cudaFree(d_C);
	
	printf("\n");
	for(int i=0; i<numElements;i++)printf("%d ",h_C[i]);
	printf("\n");
	
	free(h_C);
	
	return 0;
}

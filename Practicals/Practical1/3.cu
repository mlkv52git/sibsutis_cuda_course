#include <cuda.h>
#include <stdio.h>

#define CUDA_CHECK_RETURN(value) {							\
	cudaError_t _m_cudaStat = value;						\
	if (_m_cudaStat != cudaSuccess) {						\
		fprintf(stderr, "Error %s at line %d in file %s\n",			\
				cudaGetErrorString(_m_cudaStat), __LINE__, __FILE__);	\
		exit(1);								\
	} }

__global__ void gTest(float* a){
  a[threadIdx.x+blockDim.x*blockIdx.x]=(float)(threadIdx.x+blockDim.x*blockIdx.x);
} 

int main(){
  float *da, *ha;
  int num_of_blocks=10, threads_per_block=32;
  int N=num_of_blocks*threads_per_block;
 
  ha=(float*)calloc(N, sizeof(float));
  CUDA_CHECK_RETURN(cudaMalloc((void**)&da, N*sizeof(float)));
  
  cudaEvent_t  start,stop;
  float elapsedTime;

  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  cudaEventRecord(start,0);
  
  gTest<<<dim3(num_of_blocks), dim3(threads_per_block)>>>(da);
 // cudaThreadSynchronize();
  //CUDA_CHECK_RETURN(cudaDeviceSynchronize());
  //CUDA_CHECK_RETURN(cudaGetLastError());
  
  cudaEventRecord(stop,0);
  cudaEventSynchronize(stop);
  cudaEventElapsedTime(&elapsedTime,start,stop);

  fprintf(stderr,"gTest took %g\n", elapsedTime);
  
  cudaEventDestroy(start);
  cudaEventDestroy(stop);
  
  CUDA_CHECK_RETURN(cudaMemcpy(ha,da,N*sizeof(float), cudaMemcpyDeviceToHost));
  
  for(int i=0;i<N;i++)
	  printf("%g\n", ha[i]);

  free(ha);
  cudaFree(da);
  return 0;
}

#include <thrust/device_vector.h>
#include <thrust/inner_product.h>
#include <stdio.h>

#define REAL float

__global__ void gInit(REAL* v){
  v[threadIdx.x+blockIdx.x*blockDim.x]=0.1F*(threadIdx.x+blockIdx.x*blockDim.x);
 }

int main(int argc, char* argv[]){
  REAL *v1, *v2;

int num_of_blocks=atoi(argv[1]);
int threads_per_block=atoi(argv[2]);

  int N=threads_per_block*num_of_blocks;

  cudaMalloc((void**)&v1, N*sizeof(REAL));
  cudaMalloc((void**)&v2, N*sizeof(REAL));



  gInit<<<num_of_blocks, threads_per_block>>>(v1);
  cudaThreadSynchronize();

  gInit<<<num_of_blocks,threads_per_block >>>(v2);
  cudaThreadSynchronize();

  thrust::device_ptr<float> v1_ptr = thrust::device_pointer_cast(v1);
  thrust::device_ptr<float> v2_ptr = thrust::device_pointer_cast(v2);
  
cudaEvent_t  start,stop;
float elapsedTime;
cudaEventCreate(&start);
cudaEventCreate(&stop);

cudaEventRecord(start,0);

  REAL s=thrust::inner_product(v1_ptr, v1_ptr+N, v2_ptr,0.0);
  fprintf(stderr,"Scalar Product (thrust) s =%g\n",s);

cudaEventRecord(stop,0);
cudaEventSynchronize(stop);
cudaEventElapsedTime(&elapsedTime,start,stop);
fprintf(stderr,"Thrust Reduce: %g\n",elapsedTime);						  
cudaEventDestroy(start);
cudaEventDestroy(stop);	

 return 0;
}
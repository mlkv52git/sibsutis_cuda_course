#define REAL float
#define SHMEM_SIZE  512

#include <stdio.h>

__global__ void gScalarProduct(REAL* v1, REAL* v2, int N, REAL* S){
  __shared__ float s[SHMEM_SIZE];
  
  int i=threadIdx.x;//+blockIdx.x*blockDim.x;
  
  int i_center;
  
  s[i]=v1[threadIdx.x+blockIdx.x*blockDim.x]*v2[threadIdx.x+blockIdx.x*blockDim.x];
  __syncthreads();
  //printf("s=%g\n", s[i]);

  i_center=blockDim.x/2;
  
  while(i_center!=0){
    if(i<i_center)
       s[i]+=s[i+i_center];
  
    __syncthreads();
    i_center/=2;
  }
  
  if(threadIdx.x==0){
    atomicAdd(S,s[0]);
    //printf("S=%g\ts[0]=%g\n",*S, s[0]);    
}
 
}


__global__ void gInit(REAL* v){
  v[threadIdx.x+blockIdx.x*blockDim.x]=0.1F*(threadIdx.x+blockIdx.x*blockDim.x);
 }


int main(int argc, char* argv[]){

int num_of_blocks=atoi(argv[1]);
int threads_per_block=atoi(argv[2]);

int N=threads_per_block*num_of_blocks;

REAL *v1, *v2;
REAL* pS_d;
REAL S_h=0;

cudaMalloc((void**)&v1, N*sizeof(REAL));
cudaMalloc((void**)&v2, N*sizeof(REAL));
cudaMalloc((void**)&pS_d, sizeof(REAL));

  gInit<<<num_of_blocks, threads_per_block>>>(v1);
  cudaThreadSynchronize();

  gInit<<<num_of_blocks,threads_per_block >>>(v2);
  cudaThreadSynchronize();
 
  cudaMemcpy(pS_d,&S_h, sizeof(REAL), cudaMemcpyHostToDevice); 

cudaEvent_t  start,stop;
float elapsedTime;
cudaEventCreate(&start);
cudaEventCreate(&stop); 

cudaEventRecord(start,0);

  gScalarProduct<<<num_of_blocks, threads_per_block>>>(v1, v2, N, pS_d);
  cudaThreadSynchronize();

  cudaMemcpy(&S_h, pS_d,sizeof(REAL), cudaMemcpyDeviceToHost);

  printf("Scalar product is equal to %g\n", S_h);
		
cudaEventRecord(stop,0);
cudaEventSynchronize(stop);
cudaEventElapsedTime(&elapsedTime,start,stop);
fprintf(stderr,"gScalarProduct took: %g\n",elapsedTime);
cudaEventDestroy(start);
cudaEventDestroy(stop);							  

 cudaFree(v1);
 cudaFree(v2);
 cudaFree(pS_d);
 return 0;
}
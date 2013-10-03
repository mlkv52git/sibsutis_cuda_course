#include <cuda.h>
#include <curand_kernel.h>
#include <stdio.h>
#include <malloc.h>

__global__  void gInit(float* a, float* b, int N){
    int thread_id=threadIdx.x+blockIdx.x*blockDim.x;
    
    unsigned int seed=thread_id;
    curandState s;
    curand_init(seed,0,0, &s);  
    
    for(int i=thread_id; i<N; i+=blockDim.x*gridDim.x){
      a[i]=curand_uniform(&s);
      b[i]=curand_uniform(&s);  
    }
}

__global__ void gSum(float* a, float* b, float* c, int N){
    int thread_id=threadIdx.x+blockIdx.x*blockDim.x;
    for(int i=thread_id; i<N; i+=blockDim.x*gridDim.x)
      c[i]=a[i]+b[i];
  }

int main(int argc, char* argv[]){
  float *a, *b, *c;
  float *ha, *hb, *hc;
  if(argc<4) { fprintf(stderr, "USAGE: 1 <vector length> <blocks>  <threads>\n"); return 1;}
  int N=atoi(argv[1]);
  int num_of_blocks=atoi(argv[2]);
  int threads_per_block=atoi(argv[3]);  
  
  cudaMalloc((void**)&a, N*sizeof(float));  
  cudaMalloc((void**)&b, N*sizeof(float));  
  cudaMalloc((void**)&c, N*sizeof(float));

  ha=(float*)calloc(N, sizeof(float));
  hb=(float*)calloc(N, sizeof(float));
  hc=(float*)calloc(N, sizeof(float));
    
  gInit<<<num_of_blocks,threads_per_block>>>(a,b,N);
  cudaThreadSynchronize();
  
cudaEvent_t  start,stop;
float elapsedTime;

cudaEventCreate(&start);
cudaEventCreate(&stop);

cudaEventRecord(start,0);  
  
  gSum<<<num_of_blocks,threads_per_block>>>(a,b,c,N);
//  cudaThreadSynchronize();

cudaEventRecord(stop,0);
cudaEventSynchronize(stop);
cudaEventElapsedTime(&elapsedTime,start,stop); 
fprintf(stderr,"gTest took %g\n", elapsedTime);
  
  cudaMemcpy(ha,a,N*sizeof(float), cudaMemcpyDeviceToHost);
  cudaMemcpy(hb,b,N*sizeof(float), cudaMemcpyDeviceToHost);
  cudaMemcpy(hc,c,N*sizeof(float), cudaMemcpyDeviceToHost);  
  
  for(int i=0;i<N;i++)
    printf("%g\t%g\t%g\n", ha[i],hb[i], hc[i]);
  
  cudaFree(a);
  cudaFree(b);
  cudaFree(c);
  free(ha);
  free(hb);
  free(hc);
  
  return 0;
}

#include <stdio.h>

static void HandleError( cudaError_t err,
                         const char *file,
                         int line ) {
    if (err != cudaSuccess) {
        printf( "%s in %s at line %d\n", cudaGetErrorString( err ),
                file, line );
        exit( EXIT_FAILURE );
    }
}
#define HANDLE_ERROR( err ) (HandleError( err, __FILE__, __LINE__ ))


#define HANDLE_NULL( a ) {if (a == NULL) { \
                            printf( "Host memory failed in %s at line %d\n", \
                                    __FILE__, __LINE__ ); \
                            exit( EXIT_FAILURE );}}

                            
#define N (1024*1024)
#define FULL_DATA_SIZE  (N*20)

__global__ void kernel(int* a, int* b, int* c){
  int idx=threadIdx.x+blockIdx.x*blockDim.x;
  if(idx<N){
    int idx1=(idx+1)%256;
    int idx2=(idx+2)%256;
    float as=(a[idx]+a[idx1]+a[idx2])/3.0f;
    float bs=(b[idx]+b[idx1]+b[idx2])/3.0f;
    c[idx]=(as+bs)/2;
  }
}

int main(){
  cudaDeviceProp prop;
  int whichDevice;
  
  HANDLE_ERROR(
  cudaGetDevice(&whichDevice)
  );
  HANDLE_ERROR(
  cudaGetDeviceProperties(&prop, whichDevice)
  );
  if(!prop.deviceOverlap){
    printf("Device does not support overlapping\n");
    return 0;
  }
  
  cudaEvent_t start, stop;
  float elapsedTime;
  
 /////////////////// cudaStream_t stream;
  int *host_a, *host_b, *host_c;
  //int *h_c;
  int *dev_a, *dev_b, *dev_c;
  
  HANDLE_ERROR(
  cudaEventCreate(&start)
  );
  HANDLE_ERROR(
  cudaEventCreate(&stop)
  );
  
  
  HANDLE_ERROR(
  cudaMalloc( (void**)&dev_a, N*sizeof(int)) 
  );
  HANDLE_ERROR(
  cudaMalloc( (void**)&dev_b, N*sizeof(int)) 
  );
  HANDLE_ERROR(
  cudaMalloc( (void**)&dev_c, N*sizeof(int)) 
  );

  
  HANDLE_ERROR(
  cudaHostAlloc( (void**)&host_a, FULL_DATA_SIZE*sizeof(int), 
		 cudaHostAllocDefault) 
  );
  HANDLE_ERROR(
  cudaHostAlloc( (void**)&host_b, FULL_DATA_SIZE*sizeof(int),
    cudaHostAllocDefault) 
  );
  HANDLE_ERROR(
  cudaHostAlloc( (void**)&host_c, FULL_DATA_SIZE*sizeof(int),
  cudaHostAllocDefault) 
  );
  
//h_c=(int*)calloc(FULL_DATA_SIZE, sizeof(int));  
  
  for(int i=0; i<FULL_DATA_SIZE;i++){
    host_a[i]=rand();
    host_b[i]=rand();    
  }

  cudaStream_t stream;
  HANDLE_ERROR(
  cudaStreamCreate(&stream)
  ); 
 
  HANDLE_ERROR(
  cudaEventRecord(start,0)
  );  
  for(int i=0; i<FULL_DATA_SIZE; i+=N){
      HANDLE_ERROR(
      cudaMemcpyAsync(dev_a, host_a+i, N*sizeof(int), 
		      cudaMemcpyHostToDevice, stream)
      );
      HANDLE_ERROR(
      cudaMemcpyAsync(dev_b, host_b+i, N*sizeof(int), 
		      cudaMemcpyHostToDevice, stream)
      );
    
      kernel<<<N/256, 256, 0, stream>>>(dev_a, dev_b, dev_c);
  
      HANDLE_ERROR(
      cudaMemcpyAsync(host_c+i, dev_c, N*sizeof(int), 
		      cudaMemcpyDeviceToHost, stream)
      );
  }
   
  HANDLE_ERROR( cudaStreamSynchronize( stream ) );

  HANDLE_ERROR( 
  cudaEventRecord(stop,0)  
  );  
  HANDLE_ERROR( 
  cudaEventSynchronize(stop)  
  );  
  HANDLE_ERROR( 
  cudaEventElapsedTime(&elapsedTime, start, stop)  
  );  
  printf("Elapsed time: %3.1f ms\n", elapsedTime );
  
  HANDLE_ERROR(cudaFreeHost(host_a));  
  HANDLE_ERROR(cudaFreeHost(host_b)); 
  HANDLE_ERROR(cudaFreeHost(host_c));
  
  HANDLE_ERROR(cudaFree(dev_a));  
  HANDLE_ERROR(cudaFree(dev_b)); 
  HANDLE_ERROR(cudaFree(dev_c));
  
//free(h_c);
  
  HANDLE_ERROR(cudaStreamDestroy(stream));
  
  return 0;
}
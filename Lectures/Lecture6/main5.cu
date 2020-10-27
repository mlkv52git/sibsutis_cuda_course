#include <stdio.h>
#define REAL float

__global__ void initFun(int* nf, int devnum){
  int n=threadIdx.x + blockIdx.x*blockDim.x;//+
        //devnum*blockDim.x*gridDim.x;
  nf[n]*=10;
  //printf("%d\t%d\t%d\t%d\t%d\n", n, nf[n],devnum, gridDim.x,blockDim.x);
}

int main(int argc, char* argv[]){
  if(argc<2){
  fprintf(stderr, "USAGE: main <num_of_devices>" 
                   "<device_indices>\n");
  return -1;
  }
  
  int* info_devs=(int*)calloc(argc-1, sizeof(int));
  
  info_devs[0]=atoi(argv[1]);
  for(int i=1;i<argc-1;i++){
    info_devs[i]=atoi(argv[i+1]);
  }
  
  fprintf(stderr,"num of devices: %d\n",info_devs[0]);
  for(int i=1;i<argc-1;i++)
          fprintf(stderr,"i_d=%d\n",info_devs[i]);
  
  int N=3*(1<<6);

  cudaStream_t* streams;
  int** nfd=(int**)calloc(info_devs[0], sizeof(int*));
  int** nfh=(int**)calloc(info_devs[0], sizeof(int*));
  //int* Nfh;
  //cudaMallocHost((void**)&Nfh, N*sizeof(int));
  
  streams=(cudaStream_t*)calloc(info_devs[0], sizeof(cudaStream_t));
  
  for(int i=0;i<info_devs[0];i++){
     cudaSetDevice(info_devs[i+1]);
     cudaStreamCreate(&streams[i]);

     cudaMalloc((void**)&nfd[i], (N/info_devs[0])*sizeof(int));
     cudaMallocHost((void**)&nfh[i], (N/info_devs[0])*sizeof(int));
     
     for(int n=0;n<N/info_devs[0]; n++)
        nfh[i][n]=n+i*N/info_devs[0];

     cudaMemcpyAsync(nfd[i],nfh[i], 
                    (N/info_devs[0])*sizeof(int),
                    cudaMemcpyHostToDevice,streams[i]);
       
        
     initFun<<<N/info_devs[0]/32, 32, 0, streams[i]>>>(nfd[i],i);
        
//      cudaMemcpyAsync(Nfh+i*N/info_devs[0],nfd[i], 
//                     (N/info_devs[0])*sizeof(int),
//                     cudaMemcpyDeviceToHost,streams[i]);

     cudaMemcpyAsync(nfh[i],nfd[i], 
                    (N/info_devs[0])*sizeof(int),
                    cudaMemcpyDeviceToHost,streams[i]);

  }       
  
  for(int i=0;i<info_devs[0];i++){
     cudaSetDevice(info_devs[i+1]);
     cudaStreamSynchronize(streams[i]);
     
     for(int n=0;n<N/info_devs[0];n++)
       fprintf(stderr,"nfh[%d][%d]=%d\n",i,n, nfh[i][n]);
  }
  
  for(int i=0;i<info_devs[0];i++){   
     cudaStreamDestroy(streams[i]);
     cudaFree(nfd[i]);
     cudaFreeHost(nfh[i]);
     cudaDeviceReset();
   }
   //cudaFreeHost(Nfh);

   return 0;
} 

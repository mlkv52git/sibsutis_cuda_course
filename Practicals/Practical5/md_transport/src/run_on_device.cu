#include <stdio.h>
#include <iostream>
#include <math.h>
#include "common.h"
#include "kerns.h"
int RunOnDevice(REAL* Df, INPUT& input,int* assigned_devices){
////////////////// Select the used device:///////////////////////////////////////
   int used_device;
   if ( cudaSetDevice(assigned_devices[0]) != cudaSuccess or
        cudaGetDevice( &used_device ) != cudaSuccess or
        used_device != assigned_devices[0]
      ) {
        printf ("Error: unable to set device %d\n", assigned_devices[0]);
        return 1;
    }
    printf ("Used device: %d\n", used_device);
/////////////////////////////////////////////////////////////////////////////////
    if(input.M>8 || input.L> pow(2,15)){
      fprintf(stderr,"Dimension is out of size\n"); 
      return 2; 
    }
    int size_of_df=input.M*input.M*input.M*input.L*sizeof(REAL);    

    REAL hv=(input.vmax-input.vmin)/input.M;
    REAL h=(input.xmax-input.xmin)/input.L;

    REAL *df_device[NGPUS];
    
    cudaStream_t mdStream[NGPUS];
    cudaEvent_t  mdEvent[NGPUS];
  ///////////////MEMORY ALLOCATION//////////////////////////////////////////
    for(int idev=0;idev<NGPUS;idev++){
      cudaSetDevice(assigned_devices[idev]);
      cudaStreamCreate(&mdStream[idev]);
      cudaEventCreate(&mdEvent[idev]);
      cudaMalloc((void **) &df_device[idev], size_of_df/NGPUS);
    }
  
    for(int idev=0;idev<NGPUS;idev++){
      cudaSetDevice(assigned_devices[idev]);
      gInitializeDf<<<dim3(input.L/NGPUS),dim3(input.M,input.M,input.M)>>>(idev, df_device[idev], input.vmin, hv, h);
      cudaEventRecord( mdEvent[idev], mdStream[idev] ); //асинхронный вызов ядер
    }
    for(int idev=0;idev<NGPUS;idev++){
      cudaEventSynchronize(mdEvent[idev]); //синхронизация выполнения ядер
    }
    
    for(int idev=0;idev<NGPUS;idev++){
      cudaSetDevice(assigned_devices[idev]);
      cudaMemcpy(Df+idev*input.L*input.M*input.M*input.M/NGPUS, 
      df_device[idev], size_of_df/NGPUS, cudaMemcpyDeviceToHost);
      cudaEventRecord( mdEvent[idev], mdStream[idev] );
   }
    for(int idev=0;idev<NGPUS;idev++){
      cudaEventSynchronize(mdEvent[idev]);
    }
   
    
    for(int l=0;l<input.L;l++)
    for(int k=0;k<input.M;k++)
      for(int j=0;j<input.M;j++)
	for(int i=0;i<input.M;i++)
	  std::cout<<Df[i + j*input.M + k*input.M*input.M + l*input.M*input.M*input.M]<<std::endl;    
    
    
    
    for(int idev=0;idev<NGPUS;idev++){
      cudaSetDevice(assigned_devices[idev]);
      cudaFree(df_device[idev]);
    }
    
    return 0;
}

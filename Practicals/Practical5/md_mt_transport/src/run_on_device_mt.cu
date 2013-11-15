#include <omp.h>
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
    
    omp_set_num_threads(NGPUS); 
    #pragma omp parallel
    {
      unsigned int idev = omp_get_thread_num();
      cudaSetDevice(assigned_devices[idev]);
      cudaMalloc((void **) &df_device[idev], size_of_df/NGPUS);
      gInitializeDf<<<dim3(input.L/NGPUS),dim3(input.M,input.M,input.M)>>>(idev, df_device[idev], input.vmin, hv, h);
      cudaThreadSynchronize();
      cudaMemcpy(Df+idev*input.L*input.M*input.M*input.M/NGPUS, 
		 df_device[idev], size_of_df/NGPUS, cudaMemcpyDeviceToHost);
      cudaFree(df_device[idev]);
    }
   
    return 0;
}

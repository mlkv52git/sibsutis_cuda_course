#include "windows.h"
#include <cuda_runtime.h>

BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
					 )
{
	switch (ul_reason_for_call)
	{
	case DLL_PROCESS_ATTACH:
		
	case DLL_THREAD_ATTACH:
	case DLL_THREAD_DETACH:
	case DLL_PROCESS_DETACH:
		break;
	}
	return TRUE;
}


__global__  void gSum_vec(float* v1, float* v2, int N){
	int i=threadIdx.x+blockIdx.x*blockDim.x;
	v1[i]+=v2[i];
}

extern "C"{
  __declspec(dllexport)  void Sum_vec(float* v1, float* v2, int N){
	float *u1,*u2;
	cudaMalloc((void **) &u1, N*sizeof(float));
	cudaMalloc((void **) &u2, N*sizeof(float));

	cudaMemcpy(u1, v1, N*sizeof(float), cudaMemcpyHostToDevice);
	cudaMemcpy(u2, v2, N*sizeof(float), cudaMemcpyHostToDevice);	
	
	gSum_vec<<<dim3(N/512+((N%512)?1:0)),dim3(512)>>>(u1,u2,N);
	cudaDeviceSynchronize();  

	cudaMemcpy(v1, u1, N*sizeof(float), cudaMemcpyDeviceToHost);
	
	cudaFree(u1);
	cudaFree(u2);
  }
}

extern "C"{
__declspec(dllexport) void sum_vec(float* v1, float* v2, int N){
	for(int i=0;i<N;i++)
		v1[i]+=v2[i];
  }
}
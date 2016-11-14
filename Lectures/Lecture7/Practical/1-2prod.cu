#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/fill.h>
//#include <thrust/sort.h>
#include <thrust/copy.h>
//#include <cstdlib>
#include <cstdio>
__global__ void gTest(float* d){
  int idx=threadIdx.x+blockDim.x*blockIdx.x;
  d[idx]+=(float)idx;
}

int main(void){
  float *raw_ptr;

  thrust::host_vector<float> h(1 << 8);
  thrust::fill(h.begin(), h.end(), 3.1415f);

  thrust::device_vector<float> d = h;

  raw_ptr = thrust::raw_pointer_cast(&d[0]);//d.data());

  gTest<<<4,64>>>(raw_ptr); 
  cudaDeviceSynchronize();

  thrust::copy(d.begin(), d.end(), h.begin());
  
  for(int i=0;i<(1<<8);i++)
    printf("%g\n",h[i]);

  return 0;
}
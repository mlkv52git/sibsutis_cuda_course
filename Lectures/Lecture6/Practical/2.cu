//#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/sequence.h>

#include <stdio.h>

__global__ void gTest(int* d){
  
  printf("%d\n", d[threadIdx.x+blockDim.x*blockIdx.x]);
}

int main(){
size_t N = 32;
int * raw_ptr;

thrust::device_ptr<int> dev_ptr = thrust::device_malloc<int>(N);
// use device_ptr in thrust algorithms
thrust::sequence(dev_ptr, dev_ptr + N, (int) 523);

raw_ptr = thrust::raw_pointer_cast(dev_ptr);

 gTest<<<2,16>>>(raw_ptr); 
 cudaDeviceSynchronize();
 return 0;
}

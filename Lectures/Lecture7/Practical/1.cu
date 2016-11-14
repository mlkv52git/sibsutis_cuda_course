#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <stdio.h>
__global__ void gTest(int* d){
  
  printf("%d\n", d[threadIdx.x]);
}
int main(){
size_t N = 32;
// raw pointer to device memory
int * raw_ptr;
cudaMalloc((void **) &raw_ptr, N * sizeof(int));
// wrap raw pointer with a device_ptr
thrust::device_ptr<int> dev_ptr(raw_ptr);
// use device_ptr in thrust algorithms
thrust::fill(dev_ptr, dev_ptr + N, (int) 23);

//raw_ptr = thrust::raw_pointer_cast(dev_ptr);

 gTest<<<2,16>>>(raw_ptr); 
 cudaDeviceSynchronize();
 return 0;
}


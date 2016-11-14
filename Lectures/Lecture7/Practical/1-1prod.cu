#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/generate.h>
#include <thrust/sort.h>
#include <thrust/copy.h>
#include <cstdlib>
int main(void)
{
  float *h, *d;
  cudaMallocHost((void**)&h, 1<<24);
  cudaMalloc((void**)&d, 1<<24);
  cudaMemcpyAsync(h,d,2<<10,  cudaMemcpyHostToDevice);
// generate 16M random numbers on the host
thrust::host_vector<int> h_vec(1 << 24);
thrust::generate(h_vec.begin(), h_vec.end(), rand);
// transfer data to the device
thrust::device_vector<int> d_vec = h_vec;
// transfer data back to host
thrust::copy(d_vec.begin(), d_vec.end(), h_vec.begin());

cudaFreeHost(h);
cudaFree(d);
return 0;
}

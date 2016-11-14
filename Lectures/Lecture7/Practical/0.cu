#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/generate.h>
#include <thrust/sort.h>
#include <cstdlib>
int main(void){
  thrust::host_vector<int> h(1 << 8);
  thrust::generate(h.begin(), h.end(), rand);
  thrust::device_vector<int>d  = h;
  thrust::sort(d.begin(), d.end());
  h=d;
  for(int i=0;i<1<<8;i++)
    printf("%g\n", h[i]);;
  return 0;
}
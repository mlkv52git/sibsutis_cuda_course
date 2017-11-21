#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
//#include <thrust/fill.h>
#include <thrust/transform.h>
#include <thrust/sequence.h>
//#include <thrust/generate.h>
#include <thrust/execution_policy.h>
#include <cstdio>
//#include <thrust/for_each.h>
#include <cmath>

struct range_functor
{
  float h;
  range_functor(float _h):h(_h){}
  __host__ __device__
  float operator()(float x){
    return h*x;
  }
};
struct sin_functor
{
  __host__ __device__
  float operator()(float x){
    return sin(x);
  }
};

int main(){
  range_functor rfunc(0.02);
  sin_functor  sfunc;

  thrust::host_vector<float> h1(1 << 8);
  thrust::host_vector<float> h2(1 << 8);
  thrust::device_vector<float> d1(1 << 8);// = h1;  
  thrust::device_vector<float> d2(1 << 8);// = h2;  
  thrust::sequence(thrust::device,d1.begin(), d1.end());
  thrust::transform(d1.begin(), d1.end(), d1.begin(), rfunc);  
  thrust::transform(d1.begin(), d1.end(), d2.begin(), sfunc);  

  h2=d2;
  h1=d1;
 //thrust::for_each(thrust::device, d2.begin(), d2.end(), printf_functor()); 
    for(int i=0;i<(1<<8);i++){
    printf("%g\t%g\n",h1[i], h2[i]);
  }
  
  
  return 0;
}

#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/fill.h>
#include <thrust/transform.h>
#include <thrust/sequence.h>
#include <thrust/execution_policy.h>
#include <cstdio>




struct saxpy_functor
{
  const float a;
  saxpy_functor(float _a) : a(_a) {}
  __host__ __device__
  float operator()(float x, float y){
    return a*x+y;
  }
};

void saxpy(float a, 
	   thrust::device_vector<float>& x, 
	   thrust::device_vector<float>& y){
  // setup functor
  saxpy_functor func(a);
  // call transform
  thrust::transform(x.begin(), x.end(), y.begin(), y.begin(), func);
}

//void init(thrust::device_vector<float>& x, ){
  
//}

int main(){
  // generate 16M random numbers on the host
  //thrust::host_vector<float> h1(1 << 8);
  thrust::host_vector<float> h2(1 << 8);
  thrust::device_vector<float> d1(1 << 8);// = h1;  
  thrust::device_vector<float> d2(1 << 8);// = h2;  
  thrust::sequence(thrust::device,d1.begin(), d1.end());
  thrust::fill(d2.begin(), d2.end(), 2.0);  
  /////thrust::generate(h1.begin(), h1.end(), );
  ////thrust::fill(h2.begin(), h2.end(), 2.0);
  // transfer data to the device
  //thrust::device_vector<float> d1;// = h1;  
  //thrust::device_vector<float> d2;// = h2;
  
  
  
  saxpy(3.0, d1, d2);
  
  h2=d2;
  
  
  for(int i=0;i<(1<<8);i++){
    printf("%g\n",h2[i]);
  }
  
  return 0;
}

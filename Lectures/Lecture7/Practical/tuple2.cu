#include <thrust/tuple.h>
#include <thrust/device_vector.h>
#include <thrust/host_vector.h>
#include <thrust/transform.h>
#include <thrust/fill.h>
#include <thrust/iterator/zip_iterator.h>
#include <cstdio>
#define N 32
 
struct rotate_tuple{
  __host__ __device__
  thrust::tuple<float,float,float> operator()(thrust::tuple<float&,float&,float&>& t){
    float x = thrust::get<0>(t);
    float y = thrust::get<1>(t);
    float z = thrust::get<2>(t);
    
    float rx=0.36*x+0.48*y-0.80*z;
    float ry=-0.80f*x+0.60*y+0.00f*z;
    float rz=0.48f*x+0.64f*y+0.60f*z;
  
    return thrust::make_tuple(rx,ry,rz);
  }
};



int main(){
  thrust::device_vector<float> x(N), y(N), z(N);
  
  thrust::fill(x.begin(), x.end(), 2.0); 
  thrust::fill(y.begin(), y.end(), 3.0); 
  thrust::fill(z.begin(), z.end(), 5.0); 
  



  thrust::transform( thrust::make_zip_iterator( thrust::make_tuple(x.begin(), y.begin(), z.begin() )),
	     thrust::make_zip_iterator( thrust::make_tuple(x.end(),   y.end(),   z.end()   )),
	     thrust::make_zip_iterator( thrust::make_tuple(x.begin(), y.begin(), z.begin() )),
							      rotate_tuple() );

  thrust::host_vector<float> hx(N), hy(N),hz(N);
  hx=x;  hy=y; hz=z;
      for(int i=0;i<N;i++)
	  printf("%g\t%g\t%g\n",hx[i], hy[i], hz[i]);
  
  return 0;
}

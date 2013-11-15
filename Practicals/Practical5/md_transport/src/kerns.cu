#include "common.h"
#include <stdio.h>
__global__  void gInitializeDf(int idev, REAL* df, REAL vmin, REAL hv, REAL h){
  int i=threadIdx.x;//+blockIdx.x*blockDim.x;
  int j=threadIdx.y;//+blockIdx.y*blockDim.y;
  int k=threadIdx.z;//+blockIdx.z*blockDim.z;
  
  int x=idev*gridDim.x+blockIdx.x;
  int l=blockIdx.x;
  int M=blockDim.x;
  int L=gridDim.x*NGPUS;
  
  REAL V=0.1;
  REAL T=1.0;
  REAL Rho=10.0*exp(-(x-L/2.0)*(x-L/2.0)/0.1);
  
  REAL vx=vmin+(i+0.5)*hv;
  REAL vy=vmin+(j+0.5)*hv;
  REAL vz=vmin+(k+0.5)*hv;  
  REAL dummy=df[i+j*M+k*M*M +l*M*M*M]=Rho*exp( -( (vx-V)*(vx-V) + vy*vy + vz*vz )/2.0/T )/pow(2.0*pi*T,1.5);
  printf("%d\t%d\t%d\t%d\t%g\n",i,j,k,l,dummy);
}

#include <windows.h>
#include <stdio.h>
#include <malloc.h>
#include <stdlib.h>
typedef  void (*fun)(float*,float*,int);
//extern "C" {
//void Sum_vec(float*,float*,int);
//}
#define N  555

int main(){
  HINSTANCE hInst;
  float *v1, *v2;
  fun pf;

  v1=(float*)calloc(N, sizeof(float));
  v2=(float*)calloc(N, sizeof(float));
  
  for(int i=0; i<N; i++){
    v2[i]=rand()%N;
    v1[i]=3.0F;
  }

  hInst=LoadLibraryA("C:\\Users\\ewgenij\\dll_gpu2.dll");
  printf("hInst=%x\n",hInst);
  
  pf=(fun)GetProcAddress(hInst, "Sum_vec");
  printf("pf=%x\n",pf);
  
  pf(v1,v2,N);
  //Sum_vec(v1,v2,N);
  FreeLibrary(hInst);
  for(int i=0; i<N; i++)
	printf("%g\t%g\n",v2[i],v1[i]);
	

  return 0;
}
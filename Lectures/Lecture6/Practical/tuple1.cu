#include <thrust/tuple.h>
#include <cstdio>

int main(){
  thrust::tuple<int, float, const char *> test_tuple(23, 4.5, "thrust");
  printf("%d\t%g\t%s\n", thrust::get<0>(test_tuple), 
			 thrust::get<1>(test_tuple),
			 thrust::get<2>(test_tuple));
  return 0;
}

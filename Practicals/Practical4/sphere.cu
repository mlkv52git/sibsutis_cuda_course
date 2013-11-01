#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <cuda.h>

#define M_PI 3.14159265358979323846
#define COEF 48
#define VERTCOUNT COEF*COEF*2//-(COEF-1)*2
#define RADIUS 10.0f
#define FGSIZE 20
#define FGSHIFT FGSIZE/2
#define IMIN(A,B) (A<B?A:B)
#define THREADSPERBLOCK 256
#define BLOCKSPERGRID IMIN(32,(VERTCOUNT+THREADSPERBLOCK-1)/THREADSPERBLOCK)

typedef float(*ptr_f)(float, float, float);

struct Vertex
{
	float x, y, z;
};

__constant__ Vertex vert[VERTCOUNT];
texture<float, 3, cudaReadModeElementType> df_tex;
cudaArray* df_Array = 0;

__global__ void kernel(float *a)
{
	__shared__ float cache[THREADSPERBLOCK];
	int tid = threadIdx.x + blockIdx.x * blockDim.x;
	int cacheIndex = threadIdx.x;
	
	float x = vert[tid].x + FGSHIFT + 0.5f;
	float y = vert[tid].y + FGSHIFT + 0.5f;
	float z = vert[tid].z + FGSHIFT + 0.5f;
	cache[cacheIndex] = tex3D(df_tex, z, y, x);

	__syncthreads();
	for (int s = blockDim.x / 2; s > 0; s >>= 1)
	{
		if (cacheIndex < s)
			cache[cacheIndex] += cache[cacheIndex + s];
		__syncthreads();
	}

	if (cacheIndex == 0)
		a[blockIdx.x] = cache[0];
}	

float func(float x, float y, float z)
{
	return (0.5*sqrtf(15.0/M_PI))*(0.5*sqrtf(15.0/M_PI))*z*z*y*y*sqrtf(1.0f-z*z/RADIUS/RADIUS)/RADIUS/RADIUS/RADIUS/RADIUS;
}

void calc_f(float *arr_f, int x_size, int y_size, int z_size, ptr_f f)
{
	for (int x = 0; x < x_size; ++x)
		for (int y = 0; y < y_size; ++y)
			for (int z = 0; z < z_size; ++z)
				arr_f[z_size * (x * y_size + y) + z] = f(x - FGSHIFT, y - FGSHIFT, z - FGSHIFT);
}

float check(Vertex *v, ptr_f f)
{
	float sum = 0.0f;
	for (int i = 0; i < VERTCOUNT; ++i)
		sum += f(v[i].x, v[i].y, v[i].z);
		
	return sum;
}

void init_vertexes()
{
	Vertex *temp_vert = (Vertex *)malloc(sizeof(Vertex) * VERTCOUNT);
	int i = 0;
	for (int iphi = 0; iphi < 2 * COEF; ++iphi)
	{	
		for (int ipsi = 0; ipsi < COEF; ++ipsi, ++i)
		{
			float phi = iphi * M_PI / COEF;
			float psi = ipsi * M_PI / COEF;
			temp_vert[i].x = RADIUS * sinf(psi) * cosf(phi);
			temp_vert[i].y = RADIUS * sinf(psi) * sinf(phi);
			temp_vert[i].z = RADIUS * cosf(psi);
		}
	}
	printf("sumcheck = %f\n", check(temp_vert, &func)*M_PI*M_PI/ COEF/COEF);
	cudaMemcpyToSymbol(vert, temp_vert, sizeof(Vertex) * VERTCOUNT, 0, cudaMemcpyHostToDevice);
	free(temp_vert);
}

void init_texture(float *df_h)
{
	const cudaExtent volumeSize = make_cudaExtent(FGSIZE, FGSIZE, FGSIZE);
	cudaChannelFormatDesc  channelDesc=cudaCreateChannelDesc<float>();
	cudaMalloc3DArray(&df_Array, &channelDesc, volumeSize);
	cudaMemcpy3DParms  cpyParams={0};
 	cpyParams.srcPtr = make_cudaPitchedPtr( (void*)df_h, volumeSize.width*sizeof(float),  volumeSize.width,  volumeSize.height);
 	cpyParams.dstArray = df_Array;
 	cpyParams.extent = volumeSize;
 	cpyParams.kind = cudaMemcpyHostToDevice; 
	cudaMemcpy3D(&cpyParams);
	df_tex.normalized = false;
	df_tex.filterMode = cudaFilterModeLinear;
 	df_tex.addressMode[0] = cudaAddressModeClamp;
 	df_tex.addressMode[1] = cudaAddressModeClamp;
 	df_tex.addressMode[2] = cudaAddressModeClamp;
	cudaBindTextureToArray(df_tex, df_Array, channelDesc);
}

void release_texture()
{
	cudaUnbindTexture(df_tex); 
	cudaFreeArray(df_Array);
}

int main(void)
{
	init_vertexes();

	float *arr = (float *)malloc(sizeof(float) * FGSIZE * FGSIZE * FGSIZE);
	calc_f(arr, FGSIZE, FGSIZE, FGSIZE, &func);
	init_texture(arr);

	float *sum = (float*)malloc(sizeof(float) * BLOCKSPERGRID);
	float *sum_dev;
	cudaMalloc((void**)&sum_dev, sizeof(float) * BLOCKSPERGRID);	

	cudaEvent_t start, stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	cudaEventRecord(start, 0);	

	kernel<<<BLOCKSPERGRID,THREADSPERBLOCK>>>(sum_dev);

	cudaMemcpy(sum, sum_dev, sizeof(float) * BLOCKSPERGRID, cudaMemcpyDeviceToHost);
	float s = 0.0f;
	for (int i = 0; i < BLOCKSPERGRID; ++i)
		s += sum[i];
	printf("sum = %f\n", s*M_PI*M_PI / COEF/COEF);

	cudaEventRecord(stop, 0);
	cudaEventSynchronize(stop);
	float elapsedTime;
	cudaEventElapsedTime(&elapsedTime, start, stop);
	printf("Time: %3.1f ms\n", elapsedTime);
	cudaEventDestroy(start);
	cudaEventDestroy(stop);

	cudaFree(sum_dev);
	free(sum);
	release_texture();
	free(arr);

	return 0;
}
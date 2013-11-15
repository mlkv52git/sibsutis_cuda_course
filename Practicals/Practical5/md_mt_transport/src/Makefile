transMD_MT : transMD_MT.cpp run_on_device_mt.cu kerns.cu
	nvcc -Xcompiler -fopenmp -arch=sm_20 transMD_MT.cpp  run_on_device_mt.cu kerns.cu -o ../run/transMD_MT


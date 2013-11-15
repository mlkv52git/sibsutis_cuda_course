/* 
 * File:   main.cpp
 * Author: ewgenij
 *
 * Created on November 13, 2013, 11:37 AM
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <malloc.h>
#include <fstream>
#include <iostream>
using namespace std;

#include "common.h"
int RunOnDevice(REAL* Df, INPUT& input,int* assigned_devices);
 
int main(int argc, char** argv) {
   fprintf(stderr, "multiGPU v1.0\n");
   int assigned_devices[NGPUS];
   // Определяем устройства для использования:
    if (argc < NGPUS+1) {
        printf ("Error: device number is absent\n");
        return 1;
    }
    
    fprintf(stderr, "Assigned devices:\n");
    
    for(int idev=0;idev<NGPUS;idev++){
      assigned_devices[idev]=atoi(argv[idev+1]);
      if ( strlen(argv[idev+1]) > 1 or ( assigned_devices[idev] == 0 and strcmp(argv[idev+1],"0") != 0 ) ) {
          printf ("Error: device number is incorrect\n");
          return 2;
      }
      fprintf(stderr, "%i\n", assigned_devices[idev]);
    }

    REAL* Df;
    INPUT input;

    ifstream fp("input.dat");
    fp>>input.vmin>>input.vmax>>
        input.xmin>>input.xmax>>
        input.M>>input.L;
    fp.close();

    cout<<input.vmin<<'\t'<<input.vmax<<'\t'<<endl<<
          input.xmin<<'\t'<<input.xmax<<'\t'<<endl<<
          input.M<<'\t'<<input.L<<'\t'<<endl;
	  
    Df=(REAL*)calloc(input.M*input.M*input.M*input.L, sizeof(REAL));

    RunOnDevice(Df,input,assigned_devices);
       

    ofstream ofp("Df.dat");
    
    for(int l=0;l<input.L;l++)
    for(int k=0;k<input.M;k++)
      for(int j=0;j<input.M;j++)
	for(int i=0;i<input.M;i++)
	  ofp<<i<<'\t'<<j<<'\t'<<k<<'\t'<<l<<'\t'<<
	  Df[i + j*input.M + k*input.M*input.M + l*input.M*input.M*input.M]<<endl;
//    MomsOutput(ofp,input,Df);
    ofp.close();

    free(Df);

    return (EXIT_SUCCESS);
  
}
// CoCUDA.cpp : Implementation of CCoCUDA

#include "stdafx.h"
#include "CoCUDA.h"


// CCoCUDA



STDMETHODIMP CCoCUDA::Greeting(void)
{
	HINSTANCE hInst;
	float *v1, *v2;
	float s1,s2;
	int i;
	wchar_t str[80];
	fun pf;

	v1=(float*)calloc(N, sizeof(float));
	v2=(float*)calloc(N, sizeof(float));
  
	for(i=0; i<N; i++){
		v2[i]=(float)(rand()%N);
		v1[i]=3.0F;
	}

	hInst=LoadLibraryA("C:\\Users\\ewgenij\\dll_gpu2.dll");
	if(!hInst){
	  swprintf_s(str,80,L"hInst=%x  Error: %x\n",hInst,GetLastError());
	  MessageBox(NULL, (LPCWSTR)str,(LPCWSTR)L"Greetings!",MB_OK);
	}

	pf=(fun)GetProcAddress(hInst, "Sum_vec");
	if(!pf){
	  swprintf_s(str,80,L"pf=%x\n",pf);
	  MessageBox(NULL, (LPCWSTR)str,(LPCWSTR)L"Greetings!",MB_OK);
	}
	
	pf(v1,v2,N);
	for(i=0, s1=0.0F, s2=0.0F; i<N; s1+=v1[i],s2+=v2[i],i++);
	FreeLibrary(hInst);

	swprintf_s(str,80,L"s1=%g\ts2=%g\n",s1,s2);
	MessageBox(NULL, (LPCWSTR)str,(LPCWSTR)L"Greetings!",MB_OK);
	return S_OK;
}

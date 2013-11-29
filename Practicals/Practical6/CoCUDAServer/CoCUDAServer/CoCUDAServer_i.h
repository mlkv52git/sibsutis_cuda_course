

/* this ALWAYS GENERATED file contains the definitions for the interfaces */


 /* File created by MIDL compiler version 8.00.0595 */
/* at Thu Nov 28 21:31:56 2013
 */
/* Compiler settings for CoCUDAServer.idl:
    Oicf, W1, Zp8, env=Win32 (32b run), target_arch=X86 8.00.0595 
    protocol : dce , ms_ext, c_ext, robust
    error checks: allocation ref bounds_check enum stub_data 
    VC __declspec() decoration level: 
         __declspec(uuid()), __declspec(selectany), __declspec(novtable)
         DECLSPEC_UUID(), MIDL_INTERFACE()
*/
/* @@MIDL_FILE_HEADING(  ) */

#pragma warning( disable: 4049 )  /* more than 64k source lines */


/* verify that the <rpcndr.h> version is high enough to compile this file*/
#ifndef __REQUIRED_RPCNDR_H_VERSION__
#define __REQUIRED_RPCNDR_H_VERSION__ 475
#endif

#include "rpc.h"
#include "rpcndr.h"

#ifndef __RPCNDR_H_VERSION__
#error this stub requires an updated version of <rpcndr.h>
#endif // __RPCNDR_H_VERSION__

#ifndef COM_NO_WINDOWS_H
#include "windows.h"
#include "ole2.h"
#endif /*COM_NO_WINDOWS_H*/

#ifndef __CoCUDAServer_i_h__
#define __CoCUDAServer_i_h__

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

/* Forward Declarations */ 

#ifndef __ICoCUDA_FWD_DEFINED__
#define __ICoCUDA_FWD_DEFINED__
typedef interface ICoCUDA ICoCUDA;

#endif 	/* __ICoCUDA_FWD_DEFINED__ */


#ifndef __CoCUDA_FWD_DEFINED__
#define __CoCUDA_FWD_DEFINED__

#ifdef __cplusplus
typedef class CoCUDA CoCUDA;
#else
typedef struct CoCUDA CoCUDA;
#endif /* __cplusplus */

#endif 	/* __CoCUDA_FWD_DEFINED__ */


/* header files for imported files */
#include "oaidl.h"
#include "ocidl.h"

#ifdef __cplusplus
extern "C"{
#endif 


#ifndef __ICoCUDA_INTERFACE_DEFINED__
#define __ICoCUDA_INTERFACE_DEFINED__

/* interface ICoCUDA */
/* [unique][nonextensible][dual][uuid][object] */ 


EXTERN_C const IID IID_ICoCUDA;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("35724BDB-B494-47C0-93B5-5B12ECC7FB39")
    ICoCUDA : public IDispatch
    {
    public:
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE Greeting( void) = 0;
        
    };
    
    
#else 	/* C style interface */

    typedef struct ICoCUDAVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE *QueryInterface )( 
            ICoCUDA * This,
            /* [in] */ REFIID riid,
            /* [annotation][iid_is][out] */ 
            _COM_Outptr_  void **ppvObject);
        
        ULONG ( STDMETHODCALLTYPE *AddRef )( 
            ICoCUDA * This);
        
        ULONG ( STDMETHODCALLTYPE *Release )( 
            ICoCUDA * This);
        
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfoCount )( 
            ICoCUDA * This,
            /* [out] */ UINT *pctinfo);
        
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfo )( 
            ICoCUDA * This,
            /* [in] */ UINT iTInfo,
            /* [in] */ LCID lcid,
            /* [out] */ ITypeInfo **ppTInfo);
        
        HRESULT ( STDMETHODCALLTYPE *GetIDsOfNames )( 
            ICoCUDA * This,
            /* [in] */ REFIID riid,
            /* [size_is][in] */ LPOLESTR *rgszNames,
            /* [range][in] */ UINT cNames,
            /* [in] */ LCID lcid,
            /* [size_is][out] */ DISPID *rgDispId);
        
        /* [local] */ HRESULT ( STDMETHODCALLTYPE *Invoke )( 
            ICoCUDA * This,
            /* [annotation][in] */ 
            _In_  DISPID dispIdMember,
            /* [annotation][in] */ 
            _In_  REFIID riid,
            /* [annotation][in] */ 
            _In_  LCID lcid,
            /* [annotation][in] */ 
            _In_  WORD wFlags,
            /* [annotation][out][in] */ 
            _In_  DISPPARAMS *pDispParams,
            /* [annotation][out] */ 
            _Out_opt_  VARIANT *pVarResult,
            /* [annotation][out] */ 
            _Out_opt_  EXCEPINFO *pExcepInfo,
            /* [annotation][out] */ 
            _Out_opt_  UINT *puArgErr);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *Greeting )( 
            ICoCUDA * This);
        
        END_INTERFACE
    } ICoCUDAVtbl;

    interface ICoCUDA
    {
        CONST_VTBL struct ICoCUDAVtbl *lpVtbl;
    };

    

#ifdef COBJMACROS


#define ICoCUDA_QueryInterface(This,riid,ppvObject)	\
    ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define ICoCUDA_AddRef(This)	\
    ( (This)->lpVtbl -> AddRef(This) ) 

#define ICoCUDA_Release(This)	\
    ( (This)->lpVtbl -> Release(This) ) 


#define ICoCUDA_GetTypeInfoCount(This,pctinfo)	\
    ( (This)->lpVtbl -> GetTypeInfoCount(This,pctinfo) ) 

#define ICoCUDA_GetTypeInfo(This,iTInfo,lcid,ppTInfo)	\
    ( (This)->lpVtbl -> GetTypeInfo(This,iTInfo,lcid,ppTInfo) ) 

#define ICoCUDA_GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)	\
    ( (This)->lpVtbl -> GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId) ) 

#define ICoCUDA_Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)	\
    ( (This)->lpVtbl -> Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr) ) 


#define ICoCUDA_Greeting(This)	\
    ( (This)->lpVtbl -> Greeting(This) ) 

#endif /* COBJMACROS */


#endif 	/* C style interface */




#endif 	/* __ICoCUDA_INTERFACE_DEFINED__ */



#ifndef __CoCUDAServerLib_LIBRARY_DEFINED__
#define __CoCUDAServerLib_LIBRARY_DEFINED__

/* library CoCUDAServerLib */
/* [version][uuid] */ 


EXTERN_C const IID LIBID_CoCUDAServerLib;

EXTERN_C const CLSID CLSID_CoCUDA;

#ifdef __cplusplus

class DECLSPEC_UUID("D5928364-F0C4-4CDE-A074-F60C72DF5BDC")
CoCUDA;
#endif
#endif /* __CoCUDAServerLib_LIBRARY_DEFINED__ */

/* Additional Prototypes for ALL interfaces */

/* end of Additional Prototypes */

#ifdef __cplusplus
}
#endif

#endif



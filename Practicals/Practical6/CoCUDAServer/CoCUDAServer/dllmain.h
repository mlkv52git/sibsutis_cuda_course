// dllmain.h : Declaration of module class.

class CCoCUDAServerModule : public ATL::CAtlDllModuleT< CCoCUDAServerModule >
{
public :
	DECLARE_LIBID(LIBID_CoCUDAServerLib)
	DECLARE_REGISTRY_APPID_RESOURCEID(IDR_COCUDASERVER, "{1EBADCA9-CCBB-455A-B97F-CB43D17D338A}")
};

extern class CCoCUDAServerModule _AtlModule;

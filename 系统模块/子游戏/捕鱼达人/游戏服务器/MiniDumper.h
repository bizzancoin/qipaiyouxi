#ifndef _MIN_DUMPER_HEAD_
#define _MIN_DUMPER_HEAD_
#pragma once

#include <Tlhelp32.h>  
#include <dbghelp.h>

class MiniDumper
{
public:
	MiniDumper(bool headless);

protected:
	static MiniDumper *gpDumper;
	static LONG WINAPI Handler( struct _EXCEPTION_POINTERS *pExceptionInfo );

	virtual void VSetDumpFileName(void);
	virtual MINIDUMP_USER_STREAM_INFORMATION *VGetUserStreamArray() { return NULL; }
	virtual const TCHAR *VGetUserMessage() { return _T(""); }

	_EXCEPTION_POINTERS *m_pExceptionInfo;

	TCHAR m_szDumpPath[_MAX_PATH];
	TCHAR m_szAppPath[_MAX_PATH];
	TCHAR m_szAppBaseName[_MAX_PATH];
	LONG WriteMiniDump(_EXCEPTION_POINTERS *pExceptionInfo );
	bool m_bHeadless;
}; 

#endif
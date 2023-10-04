#include "stdafx.h"
#include "CLog.h"
using namespace std::chrono;

namespace EasyLog
{
	CLog CLog::m_log;

	// 将宽字节wchar_t* 转换 单字节char*
	static char* UnicodeToAnsi(const wchar_t* szStr)
	{
		int nLen = WideCharToMultiByte(CP_ACP, 0, szStr, -1, NULL, 0, NULL, NULL);
		if (nLen == 0)
		{
			return NULL;
		}
		char* pResult = new char[nLen];
		WideCharToMultiByte(CP_ACP, 0, szStr, -1, pResult, nLen, NULL, NULL);
		return pResult;
	}

	wchar_t* CLog::GetFileName()
	{
		m_sztmpFileName = m_szFileName;
		
		system_clock::time_point lOldTime = m_lFileCreateTime;
		m_lFileCreateTime = system_clock::now();
		
		int64_t lDiff = duration_cast<hours>(m_lFileCreateTime.time_since_epoch()).count()/24 - 
			duration_cast<hours>(lOldTime.time_since_epoch()).count()/24;
		if (lDiff >= 1)
		{
			m_sztmpFileName.AppendFormat(TEXT("%s.log"), FormatDate(m_lFileCreateTime));
		}
		else 
			m_sztmpFileName.AppendFormat(TEXT("%s.log"), FormatDate(lOldTime));

		return m_sztmpFileName.GetBuffer();
	};
	CString CLog::FormatDate(system_clock::time_point& point)
	{
		CString formatStr;

		std::time_t t = system_clock::to_time_t(point);
		tm* p = std::localtime(&t);

		formatStr.Format(TEXT("%04d-%02d-%02d"), p->tm_year + 1900, p->tm_mon+1, p->tm_mday);
		return formatStr;
	}
	CString CLog::FormatTime(system_clock::time_point& point)
	{
		CString formatStr;

		std::time_t t = system_clock::to_time_t(point);
		tm* p = std::localtime(&t);

		formatStr.Format(TEXT("%d-%d-%d"), p->tm_hour, p->tm_min, p->tm_sec);
		return formatStr;
	}

	void CLog::SyncBufferToFile()
	{
		FILE *pFile = nullptr;

		char* pResult = UnicodeToAnsi(GetFileName());
		fopen_s(&pFile, pResult, "at+");
		delete pResult;
		if (pFile == nullptr)
		{
			ASSERT(false);
			return;
		}

		pResult = UnicodeToAnsi(m_szBuffer.GetBuffer());
		fprintf(pFile, pResult);
		fflush(pFile);
		fclose(pFile);
		delete pResult;
	}; 
	//结束
	void CLog::Write()
	{
		m_szBuffer.AppendFormat(TEXT("\n"));
		SyncBufferToFile();
	};
	/////////////////////////////////////
	template<>
	void CLog::WriteValue(char value){ m_szBuffer.AppendFormat(TEXT("%c"), value); }
	template<>
	void CLog::WriteValue(unsigned char value){ m_szBuffer.AppendFormat(TEXT("%c"), value); }
	template<>
	void CLog::WriteValue(const char* value){ m_szBuffer.AppendFormat(TEXT("%s"), value); }
	template<>
	void CLog::WriteValue(const unsigned char* value){ m_szBuffer.AppendFormat(TEXT("%s"), value); }
	template<>
	void CLog::WriteValue(wchar_t * value){ m_szBuffer.AppendFormat(TEXT("%s"), value); }
	template<>
	void CLog::WriteValue(wchar_t const* value){ m_szBuffer.AppendFormat(TEXT("%s"), value); }
	template<>
	void CLog::WriteValue(short value){ m_szBuffer.AppendFormat(TEXT("%d"), value); }
	template<>
	void CLog::WriteValue(unsigned short value){ m_szBuffer.AppendFormat(TEXT("%d"), value); }
	template<>
	void CLog::WriteValue(int value){ m_szBuffer.AppendFormat(TEXT("%d"), value); }
	template<>
	void CLog::WriteValue(unsigned int value){ m_szBuffer.AppendFormat(TEXT("%d"), value); }
	template<>
	void CLog::WriteValue(long value){ m_szBuffer.AppendFormat(TEXT("%d"), value); }
	template<>
	void CLog::WriteValue(unsigned long value){ m_szBuffer.AppendFormat(TEXT("%d"), value); }
	template<>
	void CLog::WriteValue(long long value){ m_szBuffer.AppendFormat(TEXT("%I64d"), value); }
	template<>
	void CLog::WriteValue(unsigned long long value){ m_szBuffer.AppendFormat(TEXT("%I64d"), value); }
	template<>
	void CLog::WriteValue(float value){ m_szBuffer.AppendFormat(TEXT("%.2f"), value); }
	template<>
	void CLog::WriteValue(double value){ m_szBuffer.AppendFormat(TEXT("%.2lf"), value); }
	template<>
	void CLog::WriteValue(CString value){ m_szBuffer += value; }
}

#ifndef __H_CLOG_H__
#define __H_CLOG_H__
#include <string>
#include <memory>
#include <time.h>
#include <AfxWin.h>
#include <chrono>
#include <ctime>
#include <iomanip>

#define LOG_MAX_BUFFER		2048

namespace EasyLog
{
	enum LogLevel
	{
		LOG_ERROR=0,
		LOG_WARN,
		LOG_INFO,
		LOG_DEBUG,
	};
	class CLog
	{
		bool		m_bInit;
		LogLevel	m_level;
		CString		m_szBuffer;
		CString		m_szFileName;
		CString		m_sztmpFileName;
		std::chrono::system_clock::time_point m_lFileCreateTime;

		//单例
	public:
		static CLog  m_log;

	public:
		CLog()
		{
			m_bInit = false;
			m_level = LOG_DEBUG;
			m_szFileName.Format(TEXT("默认日志.log"));
		}
		virtual ~CLog(){}

	protected:
		wchar_t* GetFileName();
		CString FormatDate(std::chrono::system_clock::time_point& point);
		CString FormatTime(std::chrono::system_clock::time_point& point);

	protected:
		void SyncBufferToFile();
		template<typename T>
		void WriteValue(T value);

		template<typename T,typename ...Args>
		void Write(T first, Args... args)
		{
			WriteValue(first);
			int n = sizeof...(args);
			if (sizeof...(args) != 0)
			{
				//补充空格
				WriteValue(' ');
			}
			Write(args...);
		};
		//结束
		void Write();

	public:
		void SetName(wchar_t* name,LogLevel level = LOG_DEBUG){ 
			if (!m_bInit)
			{
				m_lFileCreateTime = std::chrono::system_clock::now();
				m_szFileName.Format(TEXT("%s"), name);
				m_bInit = true;
				m_level = level;
			}
		}
		template<typename ...Args>
		void log(LogLevel level, Args... args)
		{
			if (m_level < level)
				return;

			m_szBuffer.Empty();

			SYSTEMTIME SystemTime;
			GetLocalTime(&SystemTime);
			m_szBuffer.Format(TEXT("[%02d:%02d:%02d]"), SystemTime.wHour, SystemTime.wMinute, SystemTime.wSecond);

			enTraceLevel traceLevel;
			switch (level)
			{
			case EasyLog::LOG_ERROR:			{m_szBuffer.AppendFormat(TEXT("[ERROR]")); traceLevel = TraceLevel_Exception; } break;
			case EasyLog::LOG_WARN:				{m_szBuffer.AppendFormat(TEXT("[WARN]")); traceLevel = TraceLevel_Warning; } break;
			case EasyLog::LOG_INFO:				{m_szBuffer.AppendFormat(TEXT("[INFO]")); traceLevel = TraceLevel_Info; } break;
			case EasyLog::LOG_DEBUG:			{m_szBuffer.AppendFormat(TEXT("[DEBUG]")); traceLevel = TraceLevel_Debug; } break;
			default:							{m_szBuffer.AppendFormat(TEXT("[UNDEFINED]")); traceLevel = TraceLevel_Normal; } break;
			}
			
			Write(args...);

#ifdef _DEBUG
			//显示到对话框
			CTraceService::TraceString(m_szBuffer, traceLevel);
#endif
		}
	};
}

#if 0
#define LOG_ERROR(...)		EasyLog::CLog::m_log.log(EasyLog::LOG_ERROR,TEXT("行号:"),__LINE__,TEXT(__FUNCTION__),##__VA_ARGS__)
#define LOG_WARN(...)		EasyLog::CLog::m_log.log(EasyLog::LOG_WARN,TEXT("行号:"),__LINE__,TEXT(__FUNCTION__),##__VA_ARGS__)
#define LOG_INFO(...)		EasyLog::CLog::m_log.log(EasyLog::LOG_INFO,TEXT("行号:"),__LINE__,TEXT(__FUNCTION__),##__VA_ARGS__)
#define LOG_DEBUG(...)		EasyLog::CLog::m_log.log(EasyLog::LOG_DEBUG,TEXT("行号:"),__LINE__,TEXT(__FUNCTION__),##__VA_ARGS__)
#else
#define LOG_ERROR(...)		EasyLog::CLog::m_log.log(EasyLog::LOG_ERROR,##__VA_ARGS__)
#define LOG_WARN(...)		EasyLog::CLog::m_log.log(EasyLog::LOG_WARN,##__VA_ARGS__)
#define LOG_INFO(...)		EasyLog::CLog::m_log.log(EasyLog::LOG_INFO,##__VA_ARGS__)
#define LOG_DEBUG(...)		EasyLog::CLog::m_log.log(EasyLog::LOG_DEBUG,##__VA_ARGS__)
#endif
#endif
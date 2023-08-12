
USE master
GO

IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'RYNativeWebDB')
DROP DATABASE [RYNativeWebDB]
GO

IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'RYPlatformManagerDB')
DROP DATABASE [RYPlatformManagerDB]
GO



GO

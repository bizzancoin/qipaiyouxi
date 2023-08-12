
USE master
GO

IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'RYAccountsDB')
DROP DATABASE [RYAccountsDB]
GO

IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'RYGameMatchDB')
DROP DATABASE [RYGameMatchDB]
GO

IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'RYGameScoreDB')
DROP DATABASE [RYGameScoreDB]
GO

IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'RYPlatformDB')
DROP DATABASE [RYPlatformDB]
GO

IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'RYRecordDB')
DROP DATABASE [RYRecordDB]
GO

IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'RYTreasureDB')
DROP DATABASE [RYTreasureDB]
GO

IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'RYEducateDB')
DROP DATABASE [RYEducateDB]
GO

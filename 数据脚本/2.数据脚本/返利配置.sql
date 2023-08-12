USE [RYTreasureDB]
GO

TRUNCATE TABLE TransferReturnConfig
GO

INSERT INTO TransferReturnConfig(ReturnType,ReturnPercent,ConfigDescribe) VALUES(0,0,'普通玩家转给普通玩家')
INSERT INTO TransferReturnConfig(ReturnType,ReturnPercent,ConfigDescribe) VALUES(0,0,'普通玩家转给VIP玩家')
INSERT INTO TransferReturnConfig(ReturnType,ReturnPercent,ConfigDescribe) VALUES(0,0,'VIP玩家转给普通玩家')
INSERT INTO TransferReturnConfig(ReturnType,ReturnPercent,ConfigDescribe) VALUES(0,0,'VIP玩家转给VIP玩家')

GO

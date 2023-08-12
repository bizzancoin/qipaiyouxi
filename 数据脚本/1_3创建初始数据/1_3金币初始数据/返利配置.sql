USE RYTreasureDB
GO

TRUNCATE TABLE TransferReturnConfig

insert TransferReturnConfig(ReturnType,ReturnPercent,ConfigDescribe) values(	0	,	20	,	N'普通玩家转给普通玩家'	)
insert TransferReturnConfig(ReturnType,ReturnPercent,ConfigDescribe) values(	0	,	30	,	N'普通玩家转给VIP玩家'	)
insert TransferReturnConfig(ReturnType,ReturnPercent,ConfigDescribe) values(	0	,	40	,	N'VIP玩家转给普通玩家'	)
insert TransferReturnConfig(ReturnType,ReturnPercent,ConfigDescribe) values(	0	,	50	,	N'VIP玩家转给VIP玩家'	)
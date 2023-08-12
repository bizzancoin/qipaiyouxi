USE RYTreasureDB
GO

-- 转盘配置数据
TRUNCATE TABLE LotteryConfig
GO

INSERT INTO LotteryConfig(FreeCount,ChargeFee,IsCharge) VALUES(3,600,0)

-- 转盘奖品数据
TRUNCATE TABLE LotteryItem
GO

INSERT INTO LotteryItem(ItemIndex,ItemType,ItemQuota,ItemRate) VALUES(1,0,100,22)
INSERT INTO LotteryItem(ItemIndex,ItemType,ItemQuota,ItemRate) VALUES(2,0,200,18)
INSERT INTO LotteryItem(ItemIndex,ItemType,ItemQuota,ItemRate) VALUES(3,0,300,12)
INSERT INTO LotteryItem(ItemIndex,ItemType,ItemQuota,ItemRate) VALUES(4,0,400,10)
INSERT INTO LotteryItem(ItemIndex,ItemType,ItemQuota,ItemRate) VALUES(5,0,500,9)
INSERT INTO LotteryItem(ItemIndex,ItemType,ItemQuota,ItemRate) VALUES(6,0,600,9)
INSERT INTO LotteryItem(ItemIndex,ItemType,ItemQuota,ItemRate) VALUES(7,0,700,6)
INSERT INTO LotteryItem(ItemIndex,ItemType,ItemQuota,ItemRate) VALUES(8,0,800,6)
INSERT INTO LotteryItem(ItemIndex,ItemType,ItemQuota,ItemRate) VALUES(9,0,900,3)
INSERT INTO LotteryItem(ItemIndex,ItemType,ItemQuota,ItemRate) VALUES(10,0,1000,3)
INSERT INTO LotteryItem(ItemIndex,ItemType,ItemQuota,ItemRate) VALUES(11,0,2000,1)
INSERT INTO LotteryItem(ItemIndex,ItemType,ItemQuota,ItemRate) VALUES(12,0,3000,1)

GO
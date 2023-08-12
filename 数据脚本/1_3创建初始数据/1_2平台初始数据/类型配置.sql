USE RYPlatformDB
GO

-- 游戏类型
TRUNCATE TABLE GameTypeItem
GO

INSERT INTO [dbo].[GameTypeItem] ([TypeID], [JoinID], [SortID], [TypeName], [Nullity]) VALUES (1, 0, 500, '牌类游戏', 0)
INSERT INTO [dbo].[GameTypeItem] ([TypeID], [JoinID], [SortID], [TypeName], [Nullity]) VALUES (2, 0, 100, '麻将游戏', 0)
INSERT INTO [dbo].[GameTypeItem] ([TypeID], [JoinID], [SortID], [TypeName], [Nullity]) VALUES (3, 0, 101, '财富游戏', 0)
INSERT INTO [dbo].[GameTypeItem] ([TypeID], [JoinID], [SortID], [TypeName], [Nullity]) VALUES (4, 0, 102, '积分游戏', 0)
INSERT INTO [dbo].[GameTypeItem] ([TypeID], [JoinID], [SortID], [TypeName], [Nullity]) VALUES (5, 0, 103, '捕鱼游戏', 0)
INSERT INTO [dbo].[GameTypeItem] ([TypeID], [JoinID], [SortID], [TypeName], [Nullity]) VALUES (6, 0, 104, '休闲游戏', 0)


GO
USE RYTreasureDB
GO

-- 站点配置
TRUNCATE TABLE GlobalLivcard
GO

INSERT INTO [dbo].[GlobalLivcard] ([CardName], [CardPrice], [Currency], [InputDate]) VALUES (N'10元卡', 10.00, 10.00, '2013-10-16 00:00:00.000')
INSERT INTO [dbo].[GlobalLivcard] ([CardName], [CardPrice], [Currency], [InputDate]) VALUES (N'30元卡', 30.00, 30.00, '2013-10-16 00:00:00.000')
INSERT INTO [dbo].[GlobalLivcard] ([CardName], [CardPrice], [Currency], [InputDate]) VALUES (N'60元卡', 60.00, 60.00, '2013-10-16 00:00:00.000')
INSERT INTO [dbo].[GlobalLivcard] ([CardName], [CardPrice], [Currency], [InputDate]) VALUES (N'120元卡', 120.00, 120.00, '2013-10-16 00:00:00.000')
INSERT INTO [dbo].[GlobalLivcard] ([CardName], [CardPrice], [Currency], [InputDate]) VALUES (N'新手卡', 1.00, 1.00, '2014-03-11 14:40:34.793')

GO
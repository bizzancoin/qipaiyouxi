USE RYNativeWebDB
GO

-- 系统广告
TRUNCATE TABLE Ads
GO

INSERT INTO [dbo].[Ads] ([ID], [Title], [ResourceURL], [LinkURL], [Type], [SortID], [Remark]) VALUES (1, N'', N'/Upload/Initialize/LogonLogo.png', N'http://ry.foxuc.net', 1, 10, N'大厅登陆框广告位 [500*120]')
INSERT INTO [dbo].[Ads] ([ID], [Title], [ResourceURL], [LinkURL], [Type], [SortID], [Remark]) VALUES (2, N'', N'/Upload/Initialize/GameRegister.png', N'http://ry.foxuc.net', 1, 10, N'大厅注册框广告位 [508*80]')
INSERT INTO [dbo].[Ads] ([ID], [Title], [ResourceURL], [LinkURL], [Type], [SortID], [Remark]) VALUES (3, N'', N'/Upload/Initialize/ClosePlaza.png', N'http://ry.foxuc.net', 1, 10, N'大厅关闭框广告位 [440*100]')
INSERT INTO [dbo].[Ads] ([ID], [Title], [ResourceURL], [LinkURL], [Type], [SortID], [Remark]) VALUES (4, N'', N'/Upload/Initialize/PlatformBottom.png', N'http://ry.foxuc.net', 1, 10, N'大厅右下角广告位 [194*120]')
INSERT INTO [dbo].[Ads] ([ID], [Title], [ResourceURL], [LinkURL], [Type], [SortID], [Remark]) VALUES (5, N'', N'/Upload/Initialize/m_banner.png', N'#', 1, 10, N'移动版网站广告位')
INSERT INTO [dbo].[Ads] ([ID], [Title], [ResourceURL], [LinkURL], [Type], [SortID], [Remark]) VALUES (6, N'', N'/Upload/Initialize/GameFrame.png', N'http://ry.foxuc.net', 1, 10, N'游戏右上角广告位 [216*90]')
INSERT INTO [dbo].[Ads] ([ID], [Title], [ResourceURL], [LinkURL], [Type], [SortID], [Remark]) VALUES (7, N'', N'/Upload/Initialize/banner_1.png', N'http://ry.foxuc.net', 0, 10, N'首页轮换广告')
INSERT INTO [dbo].[Ads] ([ID], [Title], [ResourceURL], [LinkURL], [Type], [SortID], [Remark]) VALUES (8, N'', N'/Upload/Initialize/banner_1.png', N'http://ry.foxuc.net', 0, 10, N'首页轮换广告')
INSERT INTO [dbo].[Ads] ([ID], [Title], [ResourceURL], [LinkURL], [Type], [SortID], [Remark]) VALUES (9, N'', N'/Upload/Initialize/banner_1.png', N'http://ry.foxuc.net', 0, 10, N'首页轮换广告')

GO
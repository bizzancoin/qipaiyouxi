USE RYNativeWebDB
GO

-- 站点配置
TRUNCATE TABLE ConfigInfo
GO

SET IDENTITY_INSERT [dbo].[ConfigInfo] ON
INSERT [dbo].[ConfigInfo] ([ConfigID], [ConfigKey], [ConfigName], [ConfigString], [Field1], [Field2], [Field3], [Field4], [Field5], [Field6], [Field7], [Field8], [SortID]) VALUES (1, N'ContactConfig', N'联系方式配置', N'参数说明
字段1：客服电话 
字段2：传真号码 
字段3：邮件地址', N'400-000-7043', N'0755-83547940', N'Sunny@foxuc.cn', N'', N'', N'', N'', N'', 5)
INSERT [dbo].[ConfigInfo] ([ConfigID], [ConfigKey], [ConfigName], [ConfigString], [Field1], [Field2], [Field3], [Field4], [Field5], [Field6], [Field7], [Field8], [SortID]) VALUES (2, N'SiteConfig', N'站点配置', N'参数说明
字段1：站点名称
字段2：站点域名 
字段3：图片域名(修改后30分钟内生效)
字段8：网站底部文字', N'网狐棋牌荣耀版', N'http://ry.foxuc.net', N'http://imagery.foxuc.net', N'', N'', N'', N'', N'Copyright @ 2016 Foxuc.cn , All Rights Reserved.&lt;span&gt;版权所有 深圳市网狐科技有限公司&lt;/span&gt;&lt;br /&gt;
ICP许可证：粤B2-20060706 [粤ICP备11009383号-4] 粤网文[2012]0873-087号&lt;span&gt;E-MAIL：UCBussiess@foxuc.cn&lt;/span&gt;&lt;br /&gt;', 1)
INSERT [dbo].[ConfigInfo] ([ConfigID], [ConfigKey], [ConfigName], [ConfigString], [Field1], [Field2], [Field3], [Field4], [Field5], [Field6], [Field7], [Field8], [SortID]) VALUES (3, N'GameFullPackageConfig', N'大厅整包配置', N'字段1：下载地址
', N'/Download/WHGameFull.exe', N'', N'', N'', N'', N'', N'', N'', 20)
INSERT [dbo].[ConfigInfo] ([ConfigID], [ConfigKey], [ConfigName], [ConfigString], [Field1], [Field2], [Field3], [Field4], [Field5], [Field6], [Field7], [Field8], [SortID]) VALUES (4, N'GameJanePackageConfig', N'大厅简包配置', N'字段1：下载地址
', N'/Download/Plaza.exe', N'', N'', N'', N'', N'', N'', N'', 15)
INSERT [dbo].[ConfigInfo] ([ConfigID], [ConfigKey], [ConfigName], [ConfigString], [Field1], [Field2], [Field3], [Field4], [Field5], [Field6], [Field7], [Field8], [SortID]) VALUES (5, N'EmailConfig', N'邮箱配置', N'字段1：邮箱账号
字段2：邮箱密码
字段3：SmtpServer服务提供地址smtp.qq.com字段4：端口', N'test@foxuc.com', N'test', N'smtp.qq.com', N'25', N'', N'', N'', N'', 30)
INSERT [dbo].[ConfigInfo] ([ConfigID], [ConfigKey], [ConfigName], [ConfigString], [Field1], [Field2], [Field3], [Field4], [Field5], [Field6], [Field7], [Field8], [SortID]) VALUES (6, N'GameAndroidConfig', N'安卓大厅配置', N'参数说明
字段1：下载地址 
字段2：大厅版本号
字段3：大厅否强制更新 1：是 0：否', N'/Download/Plaza.apk', N'V1.0', N'0', N'', N'', N'', N'', N'', 20)
INSERT [dbo].[ConfigInfo] ([ConfigID], [ConfigKey], [ConfigName], [ConfigString], [Field1], [Field2], [Field3], [Field4], [Field5], [Field6], [Field7], [Field8], [SortID]) VALUES (7, N'GameIosConfig', N'苹果大厅配置', N'参数说明
字段1：下载地址   
字段2：大厅版本号 
字段3：大厅否强制更新 1：是 0：否', N'/Download/Plaza.ipa', N'V1.0', N'0', N'', N'', N'', N'', N'', 15)
INSERT [dbo].[ConfigInfo] ([ConfigID], [ConfigKey], [ConfigName], [ConfigString], [Field1], [Field2], [Field3], [Field4], [Field5], [Field6], [Field7], [Field8], [SortID]) VALUES (8, N'MobilePlatformVersion', N'移动版大厅配置', N'参数说明
字段1：下载路径   
字段2：大厅版本号 
字段3：资源版本号', N'http://ry.foxuc.com/download/', 0, N'', N'', N'', N'', N'', N'', 0)
INSERT INTO ConfigInfo(ConfigKey,ConfigName,ConfigString,Field1,Field2,Field3,Field4,Field5,Field6,Field7,Field8,SortID) 
VALUES('DayTaskConfig','手机每日必做',
'参数说明  
字段1：签到(0:显示,1:隐藏)  
字段2：转盘(0:显示,1:隐藏)  
字段3：低保(0:显示,1:隐藏)  
字段4：每日首充(0:显示,1:隐藏)  
字段5：分享有礼(0:显示,1:隐藏)  
字段6：每日任务(0:显示,1:隐藏)','0','0','0','0','0','0','0','0',40)
SET IDENTITY_INSERT [dbo].[ConfigInfo] OFF

GO
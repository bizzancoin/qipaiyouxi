USE RYPlatformDB
GO

-- 任务配置
TRUNCATE TABLE TaskInfo

set IDENTITY_INSERT TaskInfo ON
insert TaskInfo(TaskID,TaskName,TaskDescription,TaskType,UserType,KindID,MatchID,Innings,StandardAwardGold,StandardAwardMedal,MemberAwardGold,MemberAwardMedal,TimeLimit,InputDate) values(	1	,	N'斗地主首胜任务'	,	N'首胜赢金币'	,	4	,	3	,	200	,	0	,	1	,	1000	,	100	,	2000	,	200	,	1800	,	'2014-04-01 19:40:55.203'	)
insert TaskInfo(TaskID,TaskName,TaskDescription,TaskType,UserType,KindID,MatchID,Innings,StandardAwardGold,StandardAwardMedal,MemberAwardGold,MemberAwardMedal,TimeLimit,InputDate) values(	2	,	N'斗地主1局任务'	,	N'斗地主1局，即可完成任务'	,	2	,	3	,	200	,	0	,	1	,	1000	,	100	,	2000	,	200	,	1800	,	'2016-01-14 15:11:00.000'	)
insert TaskInfo(TaskID,TaskName,TaskDescription,TaskType,UserType,KindID,MatchID,Innings,StandardAwardGold,StandardAwardMedal,MemberAwardGold,MemberAwardMedal,TimeLimit,InputDate) values(	3	,	N'斗地主赢1局任务'	,	N'斗地主赢1局，即可完成任务'	,	1	,	3	,	200	,	0	,	1	,	1000	,	100	,	2000	,	200	,	1800	,	'2016-01-14 15:11:00.000'	)
insert TaskInfo(TaskID,TaskName,TaskDescription,TaskType,UserType,KindID,MatchID,Innings,StandardAwardGold,StandardAwardMedal,MemberAwardGold,MemberAwardMedal,TimeLimit,InputDate) values(	4	,	N'诈金花'	,	N'在诈金花游戏中完成两局游戏'	,	1	,	3	,	6	,	0	,	2	,	10000	,	20	,	10	,	1200	,	500	,	'2016-02-26 14:36:22.003'	)
insert TaskInfo(TaskID,TaskName,TaskDescription,TaskType,UserType,KindID,MatchID,Innings,StandardAwardGold,StandardAwardMedal,MemberAwardGold,MemberAwardMedal,TimeLimit,InputDate) values(	5	,	N'诈金花赢两局'	,	N'在诈金花游戏获胜两局'	,	1	,	3	,	6	,	0	,	2	,	20000	,	10	,	200000	,	20	,	600	,	'2016-02-26 14:37:27.847'	)

set IDENTITY_INSERT TaskInfo OFF
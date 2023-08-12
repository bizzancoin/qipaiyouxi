<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Match_Sidebar.ascx.cs" Inherits="Game.Web.Themes.Standard.Match_Sidebar" %>
<ul class="ui-match-submenu">
    <li class="ui-submenu-1"><a <%= MatchPageID==1?" class=\"ui-submenu-active\"":"" %> href="/Match/Index.aspx">比赛中心</a></li>
    <li class="ui-submenu-2"><a <%= MatchPageID==2?" class=\"ui-submenu-active\"":"" %> href="/Match/Activity.aspx">活动中心</a></li>
    <li class="ui-submenu-3"><a <%= MatchPageID==3?" class=\"ui-submenu-active\"":"" %> href="/Match/MatchQuery.aspx">个人成绩</a></li>
</ul>
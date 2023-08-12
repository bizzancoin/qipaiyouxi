<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Rank_Sidebar.ascx.cs" Inherits="Game.Web.Themes.Standard.Rank_Sidebar" %>
<ul class="ui-rank-submenu">
    <li class="ui-submenu-1"><a <%= RankPageID==1?" class=\"ui-submenu-active\"":"" %> href="/Rank/GameChart.aspx">财富排行</a></li>
    <li class="ui-submenu-2"><a <%= RankPageID==2?" class=\"ui-submenu-active\"":"" %> href="/Rank/LoveLinessRank.aspx">魅力排行</a></li>
    <li class="ui-submenu-3"><a <%= RankPageID==3?" class=\"ui-submenu-active\"":"" %> href="/Rank/GradeRank.aspx">等级排行</a></li>
</ul>
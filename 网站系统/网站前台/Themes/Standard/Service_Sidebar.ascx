<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Service_Sidebar.ascx.cs" Inherits="Game.Web.Themes.Standard.Service_Sidebar" %>
<ul class="ui-match-submenu">
    <li class="ui-submenu-1"><a <%= ServicePageID==1?" class=\"ui-submenu-active\"":"" %> href="/Service/Index.aspx">客服中心</a></li>
    <li class="ui-submenu-2"><a <%= ServicePageID==2?" class=\"ui-submenu-active\"":"" %> href="/Service/Course.aspx">新手教程</a></li>
    <li class="ui-submenu-2"><a <%= ServicePageID==3?" class=\"ui-submenu-active\"":"" %> href="/Service/AdCourse.aspx">高级教程</a></li>
    <li class="ui-submenu-3"><a <%= ServicePageID==4?" class=\"ui-submenu-active\"":"" %> href="/Service/Faq.aspx">常见问题</a></li>
    <li class="ui-submenu-1"><a <%= ServicePageID==5?" class=\"ui-submenu-active\"":"" %> href="/Service/PayFaq.aspx">充值帮助</a></li>
    <li class="ui-submenu-2"><a <%= ServicePageID==9?" class=\"ui-submenu-active\"":"" %> href="/Service/VipIntro.aspx">会员特权</a></li>
    <li class="ui-submenu-3"><a <%= ServicePageID==6?" class=\"ui-submenu-active\"":"" %> href="/Service/Instruction.aspx">功能说明</a></li>
    <li class="ui-submenu-4"><a <%= ServicePageID==7?" class=\"ui-submenu-active\"":"" %> href="/Service/Feedback.aspx">在线反馈</a></li>
    <li class="ui-submenu-5"><a <%= ServicePageID==8?" class=\"ui-submenu-active\"":"" %> href="/Service/Contact.aspx">联络客服</a></li>
</ul>
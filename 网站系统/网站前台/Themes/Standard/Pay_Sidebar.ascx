<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Pay_Sidebar.ascx.cs" Inherits="Game.Web.Themes.Standard.Pay_Sidebar" %>
<div class="ui-main-speedy fn-left">
<ul class="ui-member-submenu">
    <li class="ui-submenu-1">
    <p><a href="javascript:;" class="ui-submenu-active fn-clear">账户充值<i></i></a></p>
    <ul class="ui-submenu-list">
        <li><a <%= PayID==0?"class=\"ui-submenu-list-active fn-clear\"":"class=\"fn-clear\"" %> href="/Pay/JFT/Main.aspx?paytype=bank">网上银行<i></i></a></li>
        <li><a <%= PayID==1?"class=\"ui-submenu-list-active fn-clear\"":"class=\"fn-clear\"" %> href="/Pay/PayCardFill.aspx">实卡充值<i></i></a></li>
        <li><a <%= PayID==2?"class=\"ui-submenu-list-active fn-clear\"":"class=\"fn-clear\"" %> href="/Pay/JFT/Main.aspx?paytype=alipay">支付宝充值<i></i></a></li>
        <li><a <%= PayID==12?"class=\"ui-submenu-list-active fn-clear\"":"class=\"fn-clear\"" %> href="/Pay/ZFB/Alipay.aspx">支付宝官方充值<i></i></a></li>
        <li><a <%= PayID==3?"class=\"ui-submenu-list-active fn-clear\"":"class=\"fn-clear\"" %> href="/Pay/JFT/Main.aspx?paytype=wechat">微信支付<i></i></a></li>
        <li><a <%= PayID==13?"class=\"ui-submenu-list-active fn-clear\"":"class=\"fn-clear\"" %> href="/Pay/WX/Wxpay.aspx">微信官方支付<i></i></a></li>
        <li><a <%= PayID==4?"class=\"ui-submenu-list-active fn-clear\"":"class=\"fn-clear\"" %> href="/Pay/PayYB.aspx">易宝支付<i></i></a></li>
        <li><a <%= PayID==5?"class=\"ui-submenu-list-active fn-clear\"":"class=\"fn-clear\"" %> href="/Pay/PayVB.aspx">全国电话充值<i></i></a></li>
        <li><a <%= PayID==106?"class=\"ui-submenu-list-active fn-clear\"":"class=\"fn-clear\"" %> href="/Pay/JFT/Card.aspx?type=106">联通卡充值<i></i></a></li>
        <li><a <%= PayID==112?"class=\"ui-submenu-list-active fn-clear\"":"class=\"fn-clear\"" %> href="/Pay/JFT/Card.aspx?type=112">电信卡充值<i></i></a></li>
        <li><a <%= PayID==103?"class=\"ui-submenu-list-active fn-clear\"":"class=\"fn-clear\"" %> href="/Pay/JFT/Card.aspx?type=103">神州行充值<i></i></a></li>
        <li><a <%= PayID==102?"class=\"ui-submenu-list-active fn-clear\"":"class=\"fn-clear\"" %> href="/Pay/JFT/Card.aspx?type=102">盛大卡充值<i></i></a></li>
        <li><a <%= PayID==109?"class=\"ui-submenu-list-active fn-clear\"":"class=\"fn-clear\"" %> href="/Pay/JFT/Card.aspx?type=109">网易卡充值<i></i></a></li>
        <li><a <%= PayID==104?"class=\"ui-submenu-list-active fn-clear\"":"class=\"fn-clear\"" %> href="/Pay/JFT/Card.aspx?type=104">征途卡充值<i></i></a></li>
        <li><a <%= PayID==111?"class=\"ui-submenu-list-active fn-clear\"":"class=\"fn-clear\"" %> href="/Pay/JFT/Card.aspx?type=111">搜狐卡充值<i></i></a></li>
        <li><a <%= PayID==110?"class=\"ui-submenu-list-active fn-clear\"":"class=\"fn-clear\"" %> href="/Pay/JFT/Card.aspx?type=110">完美卡充值<i></i></a></li>
        <li><a <%= PayID==101?"class=\"ui-submenu-list-active fn-clear\"":"class=\"fn-clear\"" %> href="/Pay/JFT/Card.aspx?type=101">骏网一卡通<i></i></a></li>
        <li><a <%= PayID==105?"class=\"ui-submenu-list-active fn-clear\"":"class=\"fn-clear\"" %> href="/Pay/JFT/Card.aspx?type=105">Q币卡充值<i></i></a></li>
        <li><a <%= PayID==108?"class=\"ui-submenu-list-active fn-clear\"":"class=\"fn-clear\"" %> href="/Pay/JFT/Card.aspx?type=108">易宝e卡通<i></i></a></li>
        <li><a <%= PayID==107?"class=\"ui-submenu-list-active fn-clear\"":"class=\"fn-clear\"" %> href="/Pay/JFT/Card.aspx?type=107">久游卡充值<i></i></a></li>
        <li><a <%= PayID==113?"class=\"ui-submenu-list-active fn-clear\"":"class=\"fn-clear\"" %> href="/Pay/JFT/Card.aspx?type=113">众游一卡通<i></i></a></li>
        <li><a <%= PayID==114?"class=\"ui-submenu-list-active fn-clear\"":"class=\"fn-clear\"" %> href="/Pay/JFT/Card.aspx?type=114">天下一卡通<i></i></a></li>
        <li><a <%= PayID==115?"class=\"ui-submenu-list-active fn-clear\"":"class=\"fn-clear\"" %> href="/Pay/JFT/Card.aspx?type=115">天宏一卡通<i></i></a></li>
    </ul>
    </li>
</ul>
</div>
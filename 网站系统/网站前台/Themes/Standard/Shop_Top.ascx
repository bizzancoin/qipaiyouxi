<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Shop_Top.ascx.cs" Inherits="Game.Web.Themes.Standard.Shop_Top" %>
<!-- S 登录状态 -->
<div class="ui-account-info fn-clear" runat="server" id="divLogon">
    <div class="fn-left">
        <ul class="fn-clear">
            <li class="fn-left"><img src="<%= faceUrl %>"></li>
            <li class="fn-left"><span><%= accounts%></span></li>
            <li class="fn-left"><p class="ui-my-gold">您的元宝数：<span><%= medal %></span>&nbsp;个</p></li>
        </ul>
    </div>
    <div class="fn-right">
        <a href="/Match/Index.aspx" class="ui-acquire-gold" title="玩家参与游戏的各类比赛活动可获得元宝，元宝可用来兑换商城的各类奖品。">如何获得元宝？</a>
        <a href="/Shop/Index.aspx?range=1">查看我能兑换的商品</a>
    </div>
</div>
<!-- E 登录状态 -->
<!-- S 未登录状态 -->
<div class="ui-account-info fn-clear" runat="server" id="divNoLogon" visible="false">
    <div class="fn-left">
        <ul class="fn-clear">
            <li class="fn-left"><a href="/Login.aspx?url=<%= returnUrl %>"><i></i>请您登录</a></li>
        </ul>
    </div>
    <div class="fn-right">
        <a href="/Match/Index.aspx" class="ui-acquire-gold" title="玩家参与游戏的各类比赛活动可获得元宝，元宝可用来兑换商城的各类奖品。">如何获得元宝？</a>
        <a href="/Shop/Index.aspx?range=1">查看我能兑换的商品</a>
    </div>
</div>
<!-- E 未登录状态 -->
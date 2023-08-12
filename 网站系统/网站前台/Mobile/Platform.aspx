<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Platform.aspx.cs" Inherits="Game.Web.Mobile.Platform" %>
<html>
    <head runat="server">
        <title>移动大厅</title>
        <meta content="text/html; charset=utf-8" http-equiv="content-type"/>
        <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
        <meta name="apple-mobile-web-app-capable" content="yes">
        <meta name="apple-touch-fullscreen" content="yes"/>
        <meta name="format-detection" content="telephone=no">
        <link href="/Mobile/Css/mobile/base.css" rel="stylesheet" type="text/css"/>
        <link href="/Mobile/Css/mobile/info.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>
     <div class="ui-head"><a href="/Mobile/"><img src="/Mobile/Img/mobile/left.png"/></a><strong>手机大厅</strong></div>
        <div class="ui-mobile-box fn-clear">
            <div class="ui-game-info fn-clear">
                <div class="ui-game-pic fn-left"><img src="/Mobile/Img/mobile/PlatformIcon.png"/><span>手机大厅</span></div>
               <div class="ui-download-button"><a href="<%= platformDownloadUrl %>" class="ui-button">立即下载</a></div>
            </div>
            <div class="ui-details fn-clear">
                <h1>游戏截图</h1>
                <div class="ui-screenshot" style="visibility: visible;">
                    <div class='ui-screenshot-wrap'>
                        <div><img src="/Mobile/Img/mobile/showcase.jpg"/></div>
                    </div>
                    <ul class="ui-screenshot-nav"></ul>
                </div>
                <h3>内容介绍</h3>
                <div class="ui-introduction"><%= platformIntro%></div>
                <h3>相关推荐</h3>
                <ul class="ui-game-related fn-clear">
                  <asp:Repeater ID="rptMoblieGame" runat="server">
                    <ItemTemplate>
                        <li><a href="/Mobile/Info.aspx?id=<%# Eval("KindID")%>"><img src="<%# Game.Facade.Fetch.GetUploadFileUrl(Eval("ThumbnailUrl").ToString())%>"/><%# Eval("KindName") %> </a></li>
                    </ItemTemplate>
                  </asp:Repeater>
                  <asp:Panel ID="plNotData" runat="server" Visible="false">
                        <li>暂无推荐</li>
                  </asp:Panel>
                </ul>
            </div>
        </div>
        <div id="weixin-tip" class="ui-weixin-tip fn-hide">
          <p>
            <img src="Img/mobile/live_weixin.png" alt="微信打开" />
            <span title="关闭" class="close">×</span>
          </p>
        </div>
        <script type="text/javascript" src="/Mobile/Js/mobile/zepto/1.1.6/zepto.min.js"></script>
        <script type="text/javascript" src="/Mobile/Js/mobile/swipe/2.0.0/swipe.js"></script>
        <script type="text/javascript" src="/Mobile/Js/mobile/info.js"></script>
    </body>
</html>
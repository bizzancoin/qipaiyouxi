<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="Game.Web.Index" %>
<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>
<%@ Register TagPrefix="qp" TagName="Download" Src="~/Themes/Standard/Common_Download.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta charset="UTF-8" />
    <link href="css/base.css" rel="stylesheet" type="text/css" />
    <link href="css/common.css" rel="stylesheet" type="text/css" />
    <link href="css/index/index.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/js/jquery.min.js"></script>
</head>
<body>
    <!--头部开始-->
    <qp:Header ID="sHeader" runat="server" PageID="1"/>
    <!--头部结束-->
    <div class="ui-banner">
      <div class="ui-banner-bg-1"></div>
      <div class="ui-banner-bg-2"></div>
      <div class="ui-banner-page">
        <!--<a class="ui-banner-prev"></a>-->
        <!--<a class="ui-banner-next"></a>-->
      </div>
      <div class="ui-carousel-right">
        <div class="ui-carousel-left">
          <div id="banner-box" class="ui-banner-img">
              <asp:Repeater ID="rptAds" runat="server">
                  <ItemTemplate>
                      <div><a href="<%# Eval("LinkURL") %>" target="_blank"><img src="<%# Game.Facade.Fetch.GetUploadFileUrl( Eval("ResourceURL").ToString() ) %>" alt="<%# Eval("Title") %>"></a></div>
                  </ItemTemplate>
              </asp:Repeater>
          </div>
        </div>
        <ul id="banner-nav" class="ui-banner-btn">
          <!--<li class="ui-banner-active"></li>-->
          <!--<li></li>-->
          <!--<li></li>-->
        </ul>
      </div>
    </div>
    <div class="ui-content">
      <div class="ui-main">
        <ul class="fn-clear">
          <li class="fn-left">
            <!--游戏下载开始-->
            <qp:Download ID="sDownload" runat="server" />
            <!--游戏下载结束-->
          </li>
          <li class="fn-left">
            <div class="ui-news">
              <h2 class="ui-title fn-clear"><a href="/News/NewsList.aspx">更多></a>新闻公告</h2>
              <ul class="ui-news-list">
                <asp:Repeater ID="rptNews" runat="server">
                    <ItemTemplate>
                        <li class="fn-clear"><span><%# Eval("IssueDate","{0:MM/dd}")%></span><a href="/News/NewsView.aspx?param=<%# Eval("NewsID") %>"><%# Eval("Subject")%></a></li>
                    </ItemTemplate>
                </asp:Repeater>                
              </ul>
              <a href="/Spread/Index.aspx" class="ui-generalize"><img src="/images/generalize.gif" /></a>
            </div>
          </li>
          <li class="fn-left">
            <div class="ui-rank">
              <h2 class="ui-title fn-clear"><a href="/Rank/GameChart.aspx">更多></a>财富排行</h2>
              <asp:Literal ID="litRank" runat="server"></asp:Literal>
            </div>
          </li>
        </ul>
        <div class="ui-goodgames">
          <h2 class="ui-title fn-clear"><a href="/Games/Index.aspx">更多></a>精彩游戏</h2>
          <ul class="ui-goodgames-list fn-clear">
              <asp:Repeater ID="rptGame" runat="server">
                  <ItemTemplate>
                    <li>
                      <a href="GameRules.aspx?KindID=<%# Eval("KindID") %>"><img src="<%# Game.Facade.Fetch.GetUploadFileUrl(Eval("ThumbnailUrl").ToString()) %>"><p><%#Eval("KindName") %></p><i></i></a>
                    </li>
                  </ItemTemplate>
              </asp:Repeater>            
          </ul>
        </div>
      </div>
    </div>
    <!--尾部开始-->
    <qp:Footer ID="sFooter" runat="server" />
    <!--尾部结束-->
    <script type="text/javascript" src="/js/jquery-powerSwitch.js"></script>
    <script type="text/javascript" src="/js/view/index/index.js"></script>
  </body>
</html>

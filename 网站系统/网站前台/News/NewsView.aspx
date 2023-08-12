<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NewsView.aspx.cs" Inherits="Game.Web.News.NewsView" %>
<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>
<%@ Register TagPrefix="qp" TagName="Download" Src="~/Themes/Standard/Common_Download.ascx" %>
<%@ Register TagPrefix="qp" TagName="Speedy" Src="~/Themes/Standard/Common_Speedy.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <link href="/css/news/news-text.css" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="/js/jquery.min.js"></script>
</head>
<body>
    <!--头部开始-->
    <qp:Header ID="sHeader" runat="server" PageID="3"/>
    <!--头部结束-->
    <div class="ui-banner">
      <div class="ui-banner-bg-1"></div>
      <div class="ui-banner-bg-2"></div>
      <div class="ui-carousel-right">
        <div class="ui-carousel-left">
          <div class="ui-banner-img">
            <a href="javascript:;"><img src="/images/banner_2.png" /></a>
          </div>
        </div>
      </div>
    </div>

    <div class="ui-content">
      <div class="ui-main">
        <div class="ui-page-title fn-clear">
          <a href="/index.aspx"><i class="ui-page-title-home"></i>首页</a>
          <i class="ui-page-title-current"></i>
          <a href="/News/NewsList.aspx">新闻公告</a>
          <i class="ui-page-title-current"></i>
          <span>正文</span>
          <div class="ui-page-title-right"><span>NEWS & NOTICE</span><strong>新闻公告</strong></div>
        </div>
        <div class="ui-adapt fn-clear">
          <div class="ui-main-speedy fn-left">
            <!--游戏下载开始-->
            <qp:Download ID="sDownload" runat="server" />
            <!--游戏下载结束-->
            <!--快速通道开始-->
            <qp:Speedy ID="sSpeedy" runat="server" />
            <!--快速通道结束-->
          </div>
          <div class="ui-main-details fn-right">
            <div class="ui-news-text-header">
              <h2><%= title %></h2>
              <p>
                <span>类别：<%= type %></span><!--
                --><span class="ui-news-span-middle">来源：<%=source %></span><!--
                --><span>发布于：<%= issueDate %></span>
                <strong id="switch-font">
                  <a href="javascript:;" data-size="12" class="ui-fontsize-s">小</a><!--
                  --><a href="javascript:;" data-size="14" class="ui-fontsize-m ui-fontsize-active">中</a><!--
                  --><a href="javascript:;" data-size="16" class="ui-fontsize-l">大</a>
                </strong>
              </p>
            </div>
            <div id="news-content" class="ui-news-text">
                <%= content %>
            </div>
            <div class="ui-news-paging">
              <a id="next1" runat="server" class="ui-news-text-prev"><&nbsp;上一篇</a><!--
              --><a href="/News/NewsList.aspx" class="ui-news-text-back"><i></i>返回新闻列表</a><!--
              --><a id="last1" runat="server" class="ui-news-text-next">下一篇&nbsp;></a>
            </div>
          </div>
          <div class="ui-adapt-bottom"></div>
        </div>
      </div>
    </div>

    <!--尾部开始-->
    <qp:Footer ID="sFooter" runat="server" />
    <!--尾部结束-->
    <script type="text/javascript" src="/js/view/news/newsview.js"></script>
</body>
</html>

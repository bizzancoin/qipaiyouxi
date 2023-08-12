<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Monitor.aspx.cs" Inherits="Game.Web.Monitor" %>
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
    <link href="/css/monitor/monitor.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <!--头部开始-->
    <qp:Header ID="sHeader" runat="server" PageID="1"/>
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
          <span>家长监控工程</span>
          <div class="ui-page-title-right"><span>PARENT MONITORING & PROJECT</span><strong>家长监控工程</strong></div>
        </div>
        <div class="fn-clear">
          <div class="ui-main-speedy fn-left">
            <!--游戏下载开始-->
            <qp:Download ID="sDownload" runat="server" />
            <!--游戏下载结束-->
            <!--快速通道开始-->
            <qp:Speedy ID="sSpeedy" runat="server" />
            <!--快速通道结束-->
          </div>
          <div class="ui-main-details fn-right">
            <%=contents %>
          </div>
      </div>
    </div>
    </div>
    <!--尾部开始-->
    <qp:Footer ID="sFooter" runat="server" />
    <!--尾部结束-->
</body>
</html>
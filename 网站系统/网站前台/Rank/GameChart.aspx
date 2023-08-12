<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GameChart.aspx.cs" Inherits="Game.Web.Rank.GameChart" %>
<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>
<%@ Register TagPrefix="qp" TagName="RankSidebar" Src="~/Themes/Standard/Rank_Sidebar.ascx" %>
<%@ Register TagPrefix="qp" TagName="Download" Src="~/Themes/Standard/Common_Download.ascx" %>
<%@ Register TagPrefix="qp" TagName="Speedy" Src="~/Themes/Standard/Common_Speedy.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <link href="/css/rank/rank.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/js/jquery.min.js"></script>
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
          <span>排行榜</span>
          <div class="ui-page-title-right"><span>RANKING</span><strong>排行榜</strong></div>
        </div>
        <div class="fn-clear">
          <div class="ui-main-speedy fn-left">
            <!--排行左边开始-->
            <qp:RankSidebar ID="sRankSidebar" runat="server" RankPageID="1" />
            <!--排行左边结束-->
            <!--游戏下载开始-->
            <qp:Download ID="sDownload" runat="server" />
            <!--游戏下载结束-->
            <!--快速通道开始-->
            <qp:Speedy ID="sSpeedy" runat="server" />
            <!--快速通道结束-->
          </div>
          <div class="ui-main-details fn-right">
            <h2 class="ui-title-solid">财富排行</h2>
            <div class="ui-rank-list">
              <table cellpadding="0" cellspacing="0">
                <thead>
                  <tr>
                    <th>名次</th>
                    <th>昵称</th>
                    <th>财富</th>
                    <%--<th>赢局</th>
                    <th>输局</th>--%>
                  </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptRank" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td><%# Eval("RankID") %></td>
                                <td><%# Game.Utils.TextUtility.CutStringProlongSymbol(Eval("NickName").ToString(), 25)%></td>
                                <td><%# Convert.ToInt64(Eval("RankValue")).ToString("N0")%></td>
                                <%--<td><%# Eval( "WinCount" )%></td>
                                <td><%# Eval( "LostCount" )%></td>--%>
                            </tr>
                        </ItemTemplate>
                        <AlternatingItemTemplate>
                            <tr class="ui-bg-color">
                                <td><%# Eval("RankID") %></td>
                                <td><%# Game.Utils.TextUtility.CutStringProlongSymbol(Eval("NickName").ToString(), 25)%></td>
                                <td><%# Convert.ToInt64(Eval("RankValue")).ToString("N0")%></td>
                                <%--<td><%# Eval( "WinCount" )%></td>
                                <td><%# Eval( "LostCount" )%></td>--%>
                            </tr>
                        </AlternatingItemTemplate>
                    </asp:Repeater>                  
                </tbody>
              </table>
            </div>            
          </div>
        </div>
      </div>
    </div>

    <!--尾部开始-->
    <qp:Footer ID="sFooter" runat="server" />
    <!--尾部结束-->
</body>
</html>

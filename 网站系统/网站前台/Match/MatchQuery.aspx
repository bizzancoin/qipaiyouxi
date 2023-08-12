<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MatchQuery.aspx.cs" Inherits="Game.Web.Match.MatchQuery" %>
<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>
<%@ Register TagPrefix="qp" TagName="MatchSidebar" Src="~/Themes/Standard/Match_Sidebar.ascx" %>
<%@ Register TagPrefix="qp" TagName="Download" Src="~/Themes/Standard/Common_Download.ascx" %>
<%@ Register TagPrefix="qp" TagName="Speedy" Src="~/Themes/Standard/Common_Speedy.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <link href="/css/activity/activity-result.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/js/jquery.min.js"></script>
    <script src="/js/My97DatePicker/WdatePicker.js" type="text/javascript"></script>
</head>
<body>
    <!--头部开始-->
    <qp:Header ID="sHeader" runat="server" PageID="6"/>
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
          <a href="activity-details.html">活动赛事</a>
          <i class="ui-page-title-current"></i>
          <span>个人成绩</span>
          <div class="ui-page-title-right"><span>ACTIVITY&nbsp;&&nbsp;MATCH</span><strong>活动赛事</strong></div>
        </div>
        <div class="ui-center fn-clear">
          <div class="ui-main-speedy fn-left">
            <!--比赛左边开始-->
            <qp:MatchSidebar ID="sMatchSidebar" runat="server" MatchPageID="3" />
            <!--比赛左边结束-->
            <!--游戏下载开始-->
            <qp:Download ID="sDownload" runat="server" />
            <!--游戏下载结束-->
            <!--快速通道开始-->
            <qp:Speedy ID="sSpeedy" runat="server" />
            <!--快速通道结束-->
          </div>
          <div class="ui-main-details fn-right">
            <form id="form1" name="form1" runat="server">
            <h2 class="ui-title-solid">个人成绩</h2>
            <div class="ui-deal-search">
                <span>比赛时间:</span><!--
                --><span><asp:TextBox ID="txtStartDate" runat="server" CssClass="ui-text" MaxLength="10" onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'txtEndDate\')}'})"></asp:TextBox></span><!--
                --><span><img src="/Images/calendar.png" onclick="WdatePicker({el:'txtStartDate',skin:'whyGreen',dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'txtEndDate\')}'})" /></span><!--
                --><span>至</span><!--
                --><span><asp:TextBox ID="txtEndDate" runat="server" CssClass="ui-text" onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'txtStartDate\')}'})"></asp:TextBox></span><!--
                --><span><img src="/Images/calendar.png" onclick="WdatePicker({el:'txtEndDate',skin:'whyGreen',dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'txtStartDate\')}'})"/></span><!--
                --><span><asp:Button ID="btnSelect" Text="查 询" runat="server" CssClass="ui-deal-submit" onclick="btnSelect_Click" /></span>
            </div>
            <div class="ui-activity-award">
              <table cellspacing="0">
                <thead>
                  <tr>
                    <th>比赛名称</th>
                    <th>比赛场次</th>
                    <th>取得排名</th>
                    <th>奖励游戏币</th>
                    <th>奖励元宝</th>
                    <th>奖励经验</th>
                    <th>比赛开始时间</th>
                  </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptRank" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td><%# Eval("MatchName").ToString()%></td>
                                <td><%# Eval("MatchNo").ToString()%></td>
                                <td><%# Eval("RankID").ToString()%></td>
                                <td><%# Eval("RewardGold").ToString()%></td>
                                <td><%# Eval("RewardIngot").ToString()%></td>
                                <td><%# Eval("RewardExperience").ToString()%></td>
                                <td><%# Eval("MatchStartTime").ToString()%></td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:Literal runat="server" ID="litNoData" Text="<tr><td colspan='100'><br>没有任何信息<br><br></td></tr>"></asp:Literal>                    
                </tbody>
              </table>
            </div>
            <div class="ui-news-paging fn-clear">
              <webdiyer:AspNetPager ID="anpPage" runat="server" AlwaysShow="true" FirstPageText="首页" FirstLastButtonClass="ui-news-paging-prev" NextPrevButtonClass="ui-news-paging-prev"  
                    LastPageText="末页" PageSize="20" NextPageText="下一页&nbsp;>" PrevPageText="<&nbsp;上一页" ShowBoxThreshold="0" OnPageChanging="anpPage_PageChanging" 
                    LayoutType="Table" NumericButtonCount="5" CustomInfoHTML="共 %PageCount% 页" ShowPageIndexBox="Never"
                    UrlPaging="false" ShowCustomInfoSection="Never" CurrentPageButtonClass="null">
                </webdiyer:AspNetPager>
            </div>
            </form>
          </div>
          <div class="ui-adapt-bottom"></div>
        </div>
      </div>
    </div>

    <!--尾部开始-->
    <qp:Footer ID="sFooter" runat="server" />
    <!--尾部结束-->
</body>
</html>

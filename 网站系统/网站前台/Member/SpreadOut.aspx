<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SpreadOut.aspx.cs" Inherits="Game.Web.Member.SpreadOut" %>
<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>
<%@ Register TagPrefix="qp" TagName="UserSidebar" Src="~/Themes/Standard/User_Sidebar.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <link href="/css/member/member-spread.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/js/jquery.min.js"></script>
    <script src="/js/formvalidator/formValidatorRegex.js" type="text/javascript"></script>
    <script src="/js/My97DatePicker/WdatePicker.js" type="text/javascript"></script>
</head>
<body>
    <!--头部开始-->
    <qp:Header ID="sHeader" runat="server" PageID="4"/>
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
          <a href="index.aspx">个人中心</a>
          <i class="ui-page-title-current"></i>
          <span>结算明细查询</span>
          <div class="ui-page-title-right"><span>MEMBER&nbsp;CENTER</span><strong>个人中心</strong></div>
        </div>
        <div class="fn-clear">
          <!--左边开始-->
          <qp:UserSidebar ID="sUserSidebar" runat="server" MemberID="26" />
          <!--左边结束-->
          <div class="ui-main-details fn-right">
            <h2>结算明细查询</h2>
            <form id="form1" name="form1" runat="server">
            <div class="ui-deal-search">
            <span>日期查询:</span><!--
            --><span><asp:TextBox ID="txtStartDate" runat="server" CssClass="ui-text" MaxLength="10" onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'txtEndDate\')}'})"></asp:TextBox></span><!--
            --><span><img src="/images/calendar.png" onclick="WdatePicker({el:'txtStartDate',skin:'whyGreen',dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'txtEndDate\')}'})" /></span><!--
            --><span>至</span><!--
            --><span><asp:TextBox ID="txtEndDate" runat="server" CssClass="ui-text" MaxLength="10" onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'txtStartDate\')}'})"></asp:TextBox></span><!--
            --><span><img src="/images/calendar.png" onclick="WdatePicker({el:'txtEndDate',skin:'whyGreen',dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'txtStartDate\')}'})" /></span><!--
            --><!--
            --><span><asp:Button ID="btnSelect" Text="查 询" runat="server" CssClass="ui-deal-submit" OnClick="btnSelect_Click" /></span>
            </div>
            <div class="ui-deal-list">
              <table cellspacing="0">
                <thead>
                  <tr>
                    <th>日期</th>
                    <th>结算</th>
                    <th>原银行游戏币</th>
                    <th>结算后银行游戏币</th>
                    <th>备注</th>
                  </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptSpreaderList" runat="server">
                        <ItemTemplate>
                            <tr class="ui-bg-color">
                                <td><%# Eval("CollectDate")%></td>
                                <td><%# (0 - Convert.ToInt32(Eval("Score"))).ToString("N") %></td>
                                <td><%# Eval("InsureScore","{0:N}")%></td>
                                <td><%# (Convert.ToInt64(Eval("InsureScore")) - Convert.ToInt64(Eval("Score"))).ToString("N") %></td>
                                <td><%# Eval("CollectNote")%></td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                    <tr id="divTotal" runat="server" align="center">
                        <td>合计：</td>
                        <td class="leftTop trBg"><%= total %></td>
                        <td colspan="100"></td>
                    </tr>   
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
        </div>
      </div>
    </div>

    <!--尾部开始-->
    <qp:Footer ID="sFooter" runat="server" />
    <!--尾部结束-->
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SpreadInfo.aspx.cs" Inherits="Game.Web.Member.SpreadInfo" %>
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
          <span>推广明细查询</span>
          <div class="ui-page-title-right"><span>MEMBER&nbsp;CENTER</span><strong>个人中心</strong></div>
        </div>
        <div class="fn-clear">
          <!--左边开始-->
          <qp:UserSidebar ID="sUserSidebar" runat="server" MemberID="25" />
          <!--左边结束-->
          <div class="ui-main-details fn-right">
            <h2>推广明细查询</h2>
            <form id="form1" name="form1" runat="server">
            <div id="divSpread" runat="server">
                <div class="ui-deal-list">
                  <table cellspacing="0">
                    <thead>
                      <tr>
                        <th>昵称</th>
                        <th>游戏ＩＤ</th>
                        <th>单用户贡献游戏币</th>
                        <th>最早推荐时间</th>
                        <th>贡献明细</th>
                      </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptSpreaderList" runat="server" onitemcommand="rptSpreaderList_ItemCommand">
                            <ItemTemplate>
                                <tr class="ui-bg-color">
                                    <td><%# GetNickNameByUserID( Convert.ToInt32( Eval( "ChildrenID" ) ) )%></td>
                                    <td><%# GetGameIDByUserID(Convert.ToInt32(Eval("ChildrenID")))%></td>
                                    <td><%# Eval("Score","{0:N}")%></td>
                                    <td><%# Eval("CollectDate")%></td>
                                    <td><asp:LinkButton ID="lbtnContribution" runat="server" CommandArgument='<%# Eval("ChildrenID")+"$"+Eval("Score","{0:N}") %>' CommandName="sel" Text="贡献明细"></asp:LinkButton></td>
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
            </div>

            <div id="divContribution" runat="server">
                <div class="ui-deal-search">
                    <span>被推荐人：</span><span><asp:Label ID="lblAccounts" runat="server"></asp:Label><asp:LinkButton ID="lbtnBack" runat="server" ToolTip="返回推广明细" Text="返回推广明细" onclick="lbtnBack_Click"></asp:LinkButton></span>
                </div>
                <div class="ui-deal-list">
                  <table cellspacing="0">
                    <thead>
                      <tr>
                        <th>日期</th>
                        <th>贡献游戏币</th>
                        <th>类别</th>
                        <th>备注</th>
                      </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptContributionList" runat="server">
                            <ItemTemplate>
                                <tr class="ui-bg-color">
                                    <td><%# Eval("CollectDate") %></td>
                                    <td><%# Eval("Score","{0:N}") %></td>
                                    <td><%# (Convert.ToInt32(Eval("TypeID")) == 1 ? "注册" : Convert.ToInt32(Eval("TypeID")) == 2 ? "游戏时长30小时" : "结算")%></td>
                                    <td><%# Eval("CollectNote")%></td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>                                                      
                    </tbody>
                  </table>
                </div>
                <div class="ui-news-paging fn-clear">
                  <webdiyer:AspNetPager ID="anpPage2" runat="server" AlwaysShow="true" FirstPageText="首页" FirstLastButtonClass="ui-news-paging-prev" NextPrevButtonClass="ui-news-paging-prev"  
                        LastPageText="末页" PageSize="20" NextPageText="下一页&nbsp;>" PrevPageText="<&nbsp;上一页" ShowBoxThreshold="0" OnPageChanging="anpPage_PageChanging" 
                        LayoutType="Table" NumericButtonCount="5" CustomInfoHTML="共 %PageCount% 页" ShowPageIndexBox="Never"
                        UrlPaging="false" ShowCustomInfoSection="Never" CurrentPageButtonClass="null">
                    </webdiyer:AspNetPager>
                </div>
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

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ExchRecord.aspx.cs" Inherits="Game.Web.RoomCard.ExchRecord" %>

<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>
<%@ Register TagPrefix="qp" TagName="ShopSidebar" Src="~/Themes/Standard/Shop_Sidebar.ascx" %>
<%@ Register TagPrefix="qp" TagName="Download" Src="~/Themes/Standard/Common_Download.ascx" %>
<%@ Register TagPrefix="qp" TagName="Speedy" Src="~/Themes/Standard/Common_Speedy.ascx" %>
<%@ Register TagPrefix="qp" TagName="ShopTop" Src="~/Themes/Standard/Shop_Top.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <link href="/css/shop/shop-order.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/js/jquery.min.js"></script>
</head>
<body>
    <!--头部开始-->
    <qp:Header ID="sHeader" runat="server" PageID="7"/>
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
          <span>游戏商城</span>
          <i class="ui-page-title-current"></i>
          <span>我的房卡</span>
          <div class="ui-page-title-right"><span>GAME&nbsp;SHOP</span><strong>游戏商城</strong></div>
        </div>
        <div class="fn-clear">
          <div class="ui-main-speedy fn-left">
            <!--商城左边开始-->
            <qp:ShopSidebar ID="sShopSidebar" runat="server" ShopPageID="100" />
            <!--商城左边结束-->
            <!--游戏下载开始-->
            <qp:Download ID="sDownload" runat="server" />
            <!--游戏下载结束-->
            <!--快速通道开始-->
            <qp:Speedy ID="sSpeedy" runat="server" />
            <!--快速通道结束-->
          </div>
          <div class="ui-main-details fn-right">
            <!--商城用户登录开始-->
            <qp:ShopTop ID="sShopTop" runat="server" />
            <!--商城用户登录结束-->
            <div class="ui-order-detail">
              <p>您的房卡数：&nbsp;<span><%= RoomCardCount %></span>&nbsp; <em class="ui-link-a"><a href="/RoomCard/Buy.aspx">游戏豆购买房卡</a>&nbsp;<a href="/RoomCard/BuyByGold.aspx">游戏币购买房卡</a>&nbsp;<a href="/RoomCard/Exch.aspx">房卡兑换</a></em></p>
              <div class="ui-order-list">
                <a href="/RoomCard/Index.aspx">游戏豆购买</a>
                <a href="/RoomCard/GoldBuyRecord.aspx">游戏币购买</a>
                <a href="/RoomCard/ExchRecord.aspx" class="ui-order-active">兑换记录</a>
                <a href="/RoomCard/RebateRecord.aspx">返利记录</a>
              </div>
              <div class="ui-activity-award">
                <table cellspacing="0" id="order-lists">
                  <thead>
                    <tr>
                      <th class="ui-font-weight">兑换时间</th>
                      <th class="ui-font-weight">兑换前房卡</th>
                      <th class="ui-font-weight">支付房卡</th>
                      <th class="ui-font-weight">兑换前游戏豆</th>
                      <th class="ui-font-weight">兑换游戏豆</th>
                      <th class="ui-font-weight">兑换地址</th>
                    </tr>
                  </thead>
                  <tbody>
                      <asp:repeater id="rptData" runat="server">
                          <ItemTemplate>
                                <tr class="order-item">
                                    <td><%# Eval( "CollectDate" )%></td>
                                    <td><%# Eval( "SBeforeCard" )%></td>
                                    <td><%# Eval( "RoomCard" )%></td>
                                    <td><%# Eval( "SBeforeGold" )%></td>
                                    <td><%# Eval( "Gold" )%></td>
                                    <td><%# Eval( "ClientIP" )%></td>
                                </tr>
                            </ItemTemplate>
                      </asp:repeater>                   
                      <asp:Literal runat="server" ID="litNoData" Text="<tr><td colspan='100'><br>没有任何信息<br><br></td></tr>"></asp:Literal>                    
                  </tbody>
                </table>
              </div>
            </div>
            <div class="ui-news-paging fn-clear">
              <webdiyer:AspNetPager ID="anpPage" runat="server" OnPageChanged="anpPage_PageChanged" AlwaysShow="true" FirstPageText="首页" FirstLastButtonClass="ui-news-paging-prev" NextPrevButtonClass="ui-news-paging-prev"  
                    LastPageText="末页" PageSize="20" NextPageText="下一页&nbsp;>" PrevPageText="<&nbsp;上一页" ShowBoxThreshold="0" 
                    LayoutType="Table" NumericButtonCount="5" CustomInfoHTML="共 %PageCount% 页" ShowPageIndexBox="Never"
                    UrlPaging="true" ShowCustomInfoSection="Never" CurrentPageButtonClass="null">
                </webdiyer:AspNetPager>
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

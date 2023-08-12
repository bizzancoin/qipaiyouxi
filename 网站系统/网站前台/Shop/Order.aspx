<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Order.aspx.cs" Inherits="Game.Web.Shop.Order" %>
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
    <script type="text/javascript">
     $(function() {
         var orderLists = $("#order-lists");
         orderLists.on("click", ".revert-goods", function(e) {
             e.preventDefault();
             var revert = $(this);
             if (revert.data("data-requesting")) return;
             revert.data("data-requesting", true);
             $.ajax({
                 url: $(this).attr('href'),
                 type: 'get',
                 success: function(result) {
                     if (result.data.valid) {
                         revert.closest(".order-item").find(".order-status").html("申请退货");
                         revert.remove();
                         alert("已成功申请，请等待客服处理");
                     } else {
                         alert(result.msg);
                     }
                 },
                 complete: function() {
                     $(this).data('data-submiting', false);
                 }
             });
         });
     });
    </script>
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
          <span>我的订单</span>
          <div class="ui-page-title-right"><span>GAME&nbsp;SHOP</span><strong>游戏商城</strong></div>
        </div>
        <div class="fn-clear">
          <div class="ui-main-speedy fn-left">
            <!--商城左边开始-->
            <qp:ShopSidebar ID="sShopSidebar" runat="server" ShopPageID="1" />
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
              <p>您目前有&nbsp;<span><%= ProcessingCount%></span>&nbsp;个订单在处理</p>
              <div class="ui-order-list">
                <a href="/Shop/Order.aspx" <%= typeID==0?"class=\"ui-order-active\"":"" %>>所有订单</a>
                <a href="/Shop/Order.aspx?TypeID=1" <%= typeID==1?"class=\"ui-order-active\"":"" %>>处理中订单</a>
                <a href="/Shop/Order.aspx?TypeID=2" <%= typeID==2?"class=\"ui-order-active\"":"" %>>成功订单</a>
                <a href="/Shop/Order.aspx?TypeID=3" <%= typeID==3?"class=\"ui-order-active\"":"" %>>退货订单</a>
              </div>
              <div class="ui-activity-award">
                <table cellspacing="0" id="order-lists">
                  <thead>
                    <tr>
                      <th class="ui-font-weight">订单号</th>
                      <th class="ui-font-weight">订单商品</th>
                      <th class="ui-font-weight">购买时间</th>
                      <th class="ui-font-weight">交易费用（元宝）</th>
                      <th class="ui-font-weight">交易状态</th>
                      <th class="ui-font-weight">操作</th>
                    </tr>
                  </thead>
                  <tbody>
                      <asp:repeater id="rptData" runat="server">
                          <ItemTemplate>
                                <tr class="order-item">
                                    <td><%# Eval( "OrderID" )%></td>
                                    <td><a href="Detail.aspx?param=<%# Eval( "AwardID" )%>" title="<%# Eval( "AwardName" )%>" target="_blank"> <img src="<%# Game.Facade.Fetch.GetUploadFileUrl( Eval( "SmallImage" ).ToString())%>" width="60" height="40"/></a></td>
                                    <td><%# Eval( "BuyDate","{0:yyyy-MM-dd HH:mm:ss}" )%></td>
                                    <td><%# Eval( "TotalAmount" )%></td>
                                    <td class="order-status"><%# Enum.GetName( typeof( Game.Facade.AppConfig.AwardOrderStatus ), Eval( "OrderStatus" ) )%></td>
                                    <td class="order-operate">
                                        <a title="查看详情" href="OrderInfo.aspx?param=<%# Eval( "OrderID" )%>" target="_blank">查看详情</a><br/>
                                        <%# Convert.ToBoolean( Eval( "IsReturn" ) ) && ( Convert.ToInt32( Eval( "OrderStatus" ) ) == 1 || Convert.ToInt32( Eval( "OrderStatus" ) ) == 2 ) ? "<a class=\"revert-goods\" title=\"申请退货\" href=\"/WS/Shop.ashx?action=returnaward&orderid=" + Eval( "OrderID" ).ToString() + "\" onclick=\"return false;\">申请退货</a>" : ""%>
                                    </td>
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

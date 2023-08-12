<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OrderInfo.aspx.cs" Inherits="Game.Web.Shop.OrderInfo" %>
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
    <link href="/css/shop/shop-exchange.css" rel="stylesheet" type="text/css" />
    <script src="/js/jquery.min.js" type="text/javascript"></script>
    <script src="/js/areacombox/area.js" type="text/javascript"></script>
    <script src="/js/areacombox/areacombox.js" type="text/javascript"></script>
    <script src="/js/areacombox/es5-safe.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function() {
            var area = $("#area");

            var idPro = area.attr("data-province");
            var idCity = area.attr("data-city");
            var idArea = area.attr("data-area");

            var areaArray = AreaCombox.prototype.getAreas(idPro, idCity, idArea);
            var province = typeof (areaArray[0]) == "undefined" ? "" : areaArray[0];
            var city = typeof (areaArray[1]) == "undefined" ? "" : areaArray[1];
            var area = typeof (areaArray[2]) == "undefined" ? "" : areaArray[2];

            $("#area").text(province + " " + city + " " + area);
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
            <div class="ui-exchange-info">
                <h2 class="ui-title-solid">订单信息</h2>
                <ul>
                    <li>
                        <label>订单号：</label>
                        <%= IntParam %>
                    </li>
                    <li>
                        <label>订单状态：</label>
                        <%= Enum.GetName( typeof( Game.Facade.AppConfig.AwardOrderStatus ), orderStatus )%>
                    </li>
                </ul>
                <h2 class="ui-title-solid">收货信息</h2>
                <ul>
                    <li runat="server" id="liName" visible="false">
                        <label>收货人：</label>
                        <%= compellation%>
                    </li>
                    <li runat="server" id="liPhone" visible="false">
                        <label>手机号码：</label>
                        <%= mobilePhone%>
                    </li>
                    <li runat="server" id="liQQ" visible="false">
                        <label>QQ 号码：</label>
                        <%= qq %>
                    </li>
                    <asp:placeholder runat="server" id="plAddress" visible="false">
                        <li>
                            <label>地区：</label>
                            <span id="area" data-province="<%= province%>" data-city="<%= city%>" data-area="<%= area%>"></span>
                        </li>
                        <li>
                            <label>详细地址：</label>
                            <%= dwellingPlace %>
                        </li>
                        <li>
                            <label>邮编号码：</label>
                            <%= postalCode != "" ? postalCode : "未填写" %>
                        </li>
                    </asp:placeholder>
                </ul>
                <h2 class="ui-title-solid">商品属性</h2>
                <div class="ui-goods-info">
                    <table>
                        <thead>
                            <tr>
                              <th>订单商品</th>
                              <th>购买时间</th>
                              <th>商品单价</th>
                              <th>购买数量</th>
                              <th>交易费用（元宝）</th>
                              <th>交易状态</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><span class="ui-order-pic"><a href="Detail.aspx?param=<%= awardID %>" title="<%= awardName %>" target="_blank"> <img src="<%=  Game.Facade.Fetch.GetUploadFileUrl(smallImage) %>" width="60" height="40" /></a></span></td>
                                <td><%= buyDate.ToString("yyyy-MM-dd")%><br/> <%= buyDate.ToString("HH:mm:ss")%></td>
                                <td><%= price %></td>
                                <td><%= counts %></td>
                                <td><%= totalAmount %></td>
                                <td><%= Enum.GetName( typeof( Game.Facade.AppConfig.AwardOrderStatus ), orderStatus )%></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
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

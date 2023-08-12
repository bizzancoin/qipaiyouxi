<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="Game.Web.Shop.Index" %>
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
    <link href="/css/shop/shop.css" rel="stylesheet" type="text/css" />
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
          <div class="ui-page-title-right"><span>GAME&nbsp;SHOP</span><strong>游戏商城</strong></div>
        </div>
        <div class="fn-clear">
          <div class="ui-main-speedy fn-left">
            <!--商城左边开始-->
            <qp:ShopSidebar ID="sShopSidebar" runat="server" />
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
            <div class="ui-merch-list">
              <ul class="ui-merch-rank fn-clear">
                <li><span>排序方式：</span></li>
                <li class="ui-rank-down"><a href="<%= orderDefault %>" title="默认"<%= orderField==0?" class=\"ui-rank-active\"":"" %>>默认<i></i></a></li>
                <li <%= orderField==1?" class=\"ui-rank-"+orderMethod+"\"":"" %>><a href="<%= orderCountLink %>" title="人气"<%= orderField==1?" class=\"ui-rank-active\"":"" %>>人气<i></i></a></li>
                <li <%= orderField==2?" class=\"ui-rank-"+orderMethod+"\"":"" %>><a href="<%= orderPriceLink %>" title="价格"<%= orderField==2?" class=\"ui-rank-active\"":"" %>>价格<i></i></a></li>
                <li <%= orderField==3?" class=\"ui-rank-"+orderMethod+"\"":"" %>><a href="<%= orderTimeLink %>" title="上架时间"<%= orderField==3?" class=\"ui-rank-active\"":"" %>>上架时间<i></i></a></li>
              </ul>
              <ul class="ui-merch-detail fn-clear">
                  <asp:repeater id="rptShop" runat="server">
                      <ItemTemplate>                          
                          <li>
                              <a href="Detail.aspx?param=<%# Eval( "AwardID" )%>" target="_blank" class="ui-shop-pic">
                                <i></i>
                                <img src="<%# Game.Facade.Fetch.GetUploadFileUrl(Eval("SmallImage").ToString())%>" title="<%# Eval( "AwardName" )%>" alt="<%# Eval( "AwardName" )%>" target="_blank"/>
                              </a>
                              <div class="ui-goods-detail">
                                <p class="ui-font-black"><%# Eval( "AwardName" )%></p>
                                <p class="ui-font-orange">元宝：<%# Eval( "Price" )%> 个</p>
                                <p class="ui-font-red">VIP9折起</p>
                              </div>
                              <div class="ui-shop-operation fn-clear">
                                <a href="Detail.aspx?param=<%# Eval( "AwardID" )%>" target="_blank" class="ui-shop-detail fn-left">查看详情</a>
                                <a href="Buy.aspx?param=<%# Eval( "AwardID" )%>" target="_blank" class="ui-shop-exchange fn-right">立即兑换</a>
                              </div>
                          </li>
                      </ItemTemplate>
                  </asp:repeater>                    
              </ul>
            </div>
            <div class="ui-news-paging fn-clear">
              <webdiyer:AspNetPager ID="anpPage" runat="server" AlwaysShow="true" FirstPageText="首页" FirstLastButtonClass="ui-news-paging-prev" NextPrevButtonClass="ui-news-paging-prev"  
                    LastPageText="末页" PageSize="12" NextPageText="下一页&nbsp;>" PrevPageText="<&nbsp;上一页" ShowBoxThreshold="0" 
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

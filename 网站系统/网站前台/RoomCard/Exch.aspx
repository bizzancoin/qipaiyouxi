<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Exch.aspx.cs" Inherits="Game.Web.RoomCard.Exch" %>

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
          <div class="ui-main-details fn-right" style="min-height:941px;">
            <!--商城用户登录开始-->
            <qp:ShopTop ID="sShopTop" runat="server" />
            <!--商城用户登录结束-->
            <form id="form" runat="server" method="post">
              <div class="ui-exchange-info">
                <div class="ui-gold-info"><span>您的房卡数：<asp:Label ID="lbRoomCard" runat="server" Text="0"></asp:Label></span><span>您的银行游戏币：<asp:Label ID="lbGold" runat="server" Text="0"></asp:Label></span></div>
                <h2 class="ui-title-solid">房卡兑换游戏币 <a href="/RoomCard/Buy.aspx" class="ui-title-a">游戏豆购买房卡</a></h2>
                <ul>
                  <li>
                    <label>兑换数量：</label>
                      <asp:TextBox ID="txtBuyNum" runat="server" CssClass="ui-text-1" placeholder="请输入兑换房卡数"></asp:TextBox>
                  </li>
                  <li>
                    <label>兑换游戏币：</label>
                      <span id="gold" data-rate="<%=rate %>" data-max="<%=maxNum %>">0</span> 游戏币
                  </li>
                  <li >
                    <label>银行密码：</label>
                      <asp:TextBox ID="txtPassword" runat="server" CssClass="ui-text-1" TextMode="Password" placeholder="请输入银行密码"></asp:TextBox>
                  </li>
                  <li class="ui-shop-submit">
                      <asp:Button ID="btnSubmit" runat="server" Text="确定兑换" CssClass="ui-btn-1" OnClick="btnSubmit_Click" />
                      <a href="/RoomCard/Index.aspx" class="ui-btn-1">我的房卡</a>
                  </li>
                </ul>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>

    <!--尾部开始-->
    <qp:Footer ID="sFooter" runat="server" />
    <!--尾部结束-->
    <script type="text/javascript">
        $(function () {
            var gold = $('#gold');
            var reg = /^\d+$/;
            var value;
            var max = parseInt(gold.attr('data-max'));
            var rate = parseInt(gold.attr('data-rate'));
            $('#txtBuyNum').on('input', function () {
                value = $(this).val();
                if (reg.test(value)) {
                    if (value > max) {
                        $(this).val(max);
                        gold.html(rate * max);
                    } else {
                        gold.html(rate * parseInt(value));
                    }
                } else {
                    $(this).val('');
                    gold.html('0');
                }
            });
        })
    </script>
</body>
</html>

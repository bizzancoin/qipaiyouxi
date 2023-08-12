<%@ Page Title="充值" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="Game.Card.Pay.Index" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Css" runat="server">
    <link href="/css/buy.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <form runat="server">
    <div class="ui-content">
        <div>
          剩余房卡：
          <span><asp:Label ID="lbRoomCard" runat="server" Text=""></asp:Label></span>
        </div>
        <div>
          游戏豆：
          <span><asp:Label ID="lbCurrency" runat="server" Text=""></asp:Label></span>
        </div>
      </div>
      <div class="ui-title">
        房卡充值
      </div>
       <div class="ui-pay-box">
        <div class="ui-flex-item">
          <a href="/Pay/ZFB/Alipay.aspx?id=<%=payId %>">
          <img src="/image/alipay.png">
          <p>支付宝官方充值</p>
          </a>
        </div>
         <div class="ui-flex-item">
             <a href="/Pay/WX/Wxpay.aspx?id=<%=payId %>">
            <img src="/image/wxpay.png">
            <p>微信官方充值</p>
             </a>
          </div>
        </div>
    </form>
</asp:Content>

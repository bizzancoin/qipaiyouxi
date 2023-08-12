<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ExchangeSuccess.aspx.cs" Inherits="Game.Card.Menu.ExchangeSuccess" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Css" runat="server">
    <link href="/css/exchange.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="ui-content">
        <div>
          剩余房卡：
          <span><asp:Label ID="lbRoomCard" runat="server" Text=""></asp:Label></span>
        </div>
        <div>
          游戏币：
          <span><asp:Label ID="lbGold" runat="server" Text=""></asp:Label></span>
        </div>
      </div>
      <div class="ui-title">
        房卡兑换
      </div>
       <div class="ui-correct" style=" text-align: center; margin-top: 2rem"><img src="/image/correct.png"></div>
    <div style="font-size:25px;text-align:center;margin-top:30px; color: #53de54; font-weight: bold">恭喜您，兑换成功！</div>
          <div class="ui-btn-box">
          <a href="/Menu/Exchange.aspx"></a>
          <a href="/Menu/RecordExch.aspx"></a>
          </div>

</asp:Content>

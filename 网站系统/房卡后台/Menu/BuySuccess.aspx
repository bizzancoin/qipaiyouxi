<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BuySuccess.aspx.cs" Inherits="Game.Card.Menu.BuySuccess" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Css" runat="server">
    <link href="/css/buy.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
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
        <span><img src="/image/nav_ico/2_active.png"></span>房卡购买
      </div>
      <div class="ui-correct" style=" text-align: center; margin-top: 2rem"><img src="/image/correct.png"></div>
      <div style="font-size:25px;text-align:center;margin-top:30px;color: #53de54; font-weight: bold">恭喜您，购买成功！</div>
      <div class="ui-btn-box">
      <a href="/Menu/Buy.aspx"></a>
      <a href="/Menu/Record.aspx"></a>
      </div>
</asp:Content>

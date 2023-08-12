<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PresentSuccess.aspx.cs" Inherits="Game.Card.Menu.PresentSuccess" %>
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
          今日赠送：
          <span><asp:Label ID="lbPresentCard" runat="server" Text=""></asp:Label></span>
        </div>
      </div>
    <div class="ui-title">
        房卡赠送
      </div>
      <div class="ui-correct" style=" text-align: center; margin-top: 2rem"><img src="/image/correct.png"></div>
    <div style="font-size:25px;text-align:center;margin-top:30px; color: #53de54; font-weight: bold">恭喜您，赠送成功！</div>
              <div class="ui-btn-box"><a href="/Menu/Present.aspx"></a><a href="/Menu/RecordPresent.aspx"></a></div>

</asp:Content>

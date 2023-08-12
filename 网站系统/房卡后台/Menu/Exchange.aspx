<%@ Page Title="兑换" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Exchange.aspx.cs" Inherits="Game.Card.Menu.Exchange" %>
<asp:Content ID="Css1" ContentPlaceHolderID="Css" runat="server">
    <link href="/css/exchange.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="ui-content">
        <div>
          剩余房卡：
          <span><asp:Label ID="lbRoomCard" runat="server" cssClass="ui-count" Text=""></asp:Label></span>
        </div>
        <div>
          游戏币：
          <span><asp:Label ID="lbGold" runat="server" cssClass="ui-price" Text=""></asp:Label></span>
        </div>
      </div>
      <div class="ui-title">
        房卡兑换
      </div>
      <form runat="server">
        <label>
          <span>兑换比例：</span>
          <em><span class="ui-count">1</span>&nbsp;张房卡&nbsp;=&nbsp;<span class="ui-price"><%=rateRoomCard %></span>&nbsp;游戏币</em>
        </label>
        <label>
          <span>兑换数量：</span>
          <em id="roomcard"><asp:TextBox ID="txtCardCount" runat="server" placeholder="请输入兑换数量"></asp:TextBox></em>
        </label>
          <label>
            <span>兑换游戏币：</span>
            <em><span id="getgold" class="ui-price" data-rate="<%=rateRoomCard %>">0</span>&nbsp;游戏币</em>
          </label>
          <label class="ui-password">
            <span>银行密码：</span>
            <em><asp:TextBox ID="txtPassword" TextMode="Password" runat="server" placeholder="请输入银行密码"></asp:TextBox></em>
          </label>
          <label>
              <asp:Button ID="btnExch" runat="server" Text="" OnClick="btnExch_Click" />
          </label>
        </form>
    <script type="text/javascript" src="/Scripts/exchange.js"></script>
</asp:Content>

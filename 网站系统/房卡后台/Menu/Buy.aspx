<%@ Page Title="购买" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Buy.aspx.cs" Inherits="Game.Card.Menu.Buy" %>
<asp:Content ID="Css1" ContentPlaceHolderID="Css" runat="server">
    <link href="/css/buy.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <form runat="server">
    <div class="ui-content">
        <div>
          剩余房卡：
          <span><asp:Label ID="lbRoomCard" runat="server" cssClass="ui-count" Text=""></asp:Label></span>
        </div>
        <div>
          游戏豆：
          <span><asp:Label ID="lbCurrency" runat="server" cssClass="ui-price" Text=""></asp:Label></span>
        </div>
      </div>
      <div class="ui-title">
        <span><img src="/image/nav_ico/2_active.png"></span>房卡购买
      </div>
      <ul class="ui-exchange" id="list">
          <asp:Repeater ID="rpData" runat="server">
                <ItemTemplate>
                    <li class="fn-clear">
                      <span class="fn-left"><span class="ui-count"><%# Eval("RoomCard") %>&nbsp;</span>张房卡</span>
                      <em class="fn-right"><a data-card='<%# Eval("RoomCard") %>' data-id ="<%# Eval("ConfigID") %>" href="javascript:;"><span class="ui-price"><%# Convert.ToInt32(Eval("Currency")) %></span>&nbsp;游戏豆&nbsp;/&nbsp;<span class="ui-amount"><%# Convert.ToInt32(Eval("Amount")) %></span>&nbsp;RMB</a></em>
                    </li>
                </ItemTemplate>
            </asp:Repeater>
      </ul>
      </form>
    <script src="/Scripts/buy.js"></script>
</asp:Content>

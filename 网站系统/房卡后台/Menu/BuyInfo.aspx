<%@ Page Title="购买" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BuyInfo.aspx.cs" Inherits="Game.Card.Menu.BuyInfo" %>
<asp:Content ID="Css1" ContentPlaceHolderID="Css" runat="server">
    <link href="/css/buyinfo.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
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
      <form runat="server">
          <label>
            <span>购买比例：</span>
            <em><asp:Label ID="lbPayCurrency" runat="server" Text=""></asp:Label>&nbsp;游戏豆 = <asp:Label ID="lbExchCard" runat="server" Text=""></asp:Label>&nbsp;张房卡</em>
          </label>
          <label>
            <span>银行密码：</span>
            <em><asp:TextBox ID="txtPassword" TextMode="Password" runat="server" placeholder="请输入银行密码"></asp:TextBox></em>
          </label>
          <label>
            <asp:Button ID="btnBuy" runat="server" Text="" OnClick="btnBuy_Click" />
          </label>
      </form>
</asp:Content>

<%@ Page Title="首页" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="Game.Card.Index" %>
<asp:Content ID="Css1" ContentPlaceHolderID="Css" runat="server">
    <link href="/css/index.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="ui-content">
        <div class="ui-leftBox">
          <div>
            <span>代理账号：</span>
            <em><asp:Label ID="lbAccount" runat="server" Text=""></asp:Label></em>
          </div>
          <div>
            <span>真实姓名：</span>
            <em><asp:Label ID="lbRealName" runat="server" Text=""></asp:Label></em>
          </div>
          <div>
            <span>剩余房卡：</span>
            <em><asp:Label ID="lbRoomCard" runat="server" Text=""></asp:Label></em>
          </div>
          <div>
            <span>联系电话：</span>
            <em><asp:Label ID="lbMobile" runat="server" Text=""></asp:Label></em>
          </div>
        </div>
        <div class="ui-right">
          <div>
            <span>代理编号：</span>
            <em><asp:Label ID="lbNumber" runat="server" Text=""></asp:Label></em>
          </div>
          <div>
            <span>代理域名：</span>
            <em><asp:Label ID="lbDomain" runat="server" Text=""></asp:Label></em>
          </div>
          <div>
            <span>游戏币：</span>
            <em><asp:Label ID="lbGold" runat="server" Text=""></asp:Label></em>
          </div>
          <div>
            <span>微信号：</span>
            <em><asp:Label ID="lbWechat" runat="server" Text=""></asp:Label></em>
          </div>
        </div>
      </div>
      <div class="ui-title">
        <span><img src="/image/nav_ico/7.png"></span>系统公告
      </div>
      <div class="ui-details">
        <asp:Repeater ID="rpData" runat="server">
            <ItemTemplate>
                <p><%# Eval("Body") %></p>
            </ItemTemplate>
        </asp:Repeater>
      </div>
</asp:Content>

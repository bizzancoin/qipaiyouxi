<%@ Page Title="赠送" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Present.aspx.cs" Inherits="Game.Card.Menu.Present" %>
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
          今日赠送：
          <span><asp:Label ID="lbPresentCard" runat="server" cssClass="ui-price" Text=""></asp:Label></span>
        </div>
      </div>
    <div class="ui-title">
        <span><img src="/image/nav_ico/4_active.png"></span>房卡赠送
      </div>
     <form runat="server">
        <label>
          <span>赠送对象：</span>
          <em><asp:TextBox ID="txtGameID" runat="server" placeholder="请输入赠送GameID"></asp:TextBox></em>
        </label>
        <label>
          <span>赠送账号：</span>
          <em id="account">输入赠送对象验证对象账号</em>
        </label>
        <label>
          <span>赠送数量：</span>
          <em><asp:TextBox ID="txtPresentCount" runat="server" placeholder="请输入赠送数量"></asp:TextBox></em>
        </label>
        <label>
          <span>银行密码：</span>
          <em><asp:TextBox ID="txtPassword" TextMode="Password" runat="server" placeholder="请输入银行密码"></asp:TextBox></em>
        </label>
        <label class="ui-present">
            <asp:Button ID="btnPresent" runat="server" Text="" OnClick="btnPresent_Click" />
        </label>
      <%--<div class="ui-tip">
        备注：赠送房卡请核对对方的资料信息，确认无误！
      </div>--%>
    </form>
    <script src="/Scripts/present.js"></script>
</asp:Content>

<%@ Page Title="修改密码" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UpdatePass.aspx.cs" Inherits="Game.Card.UpdatePass" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Css" runat="server">
    <link href="/css/change_data.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <form runat="server">
        <label>
          <span>原登陆密码：</span>
          <em>
              <asp:TextBox ID="txtLoginPass" TextMode="Password" runat="server" placeholder="请输入原密码"></asp:TextBox>
          </em>
        </label>
        <label>
          <span>新登陆密码：</span>
          <em>
            <asp:TextBox ID="txtNewPass" TextMode="Password" runat="server" placeholder="请输入新密码"></asp:TextBox>
          </em>
        </label>
        <label>
          <span>确认登陆密码：</span>
          <em>
            <asp:TextBox ID="txtRePass" TextMode="Password" runat="server" placeholder="请输入确认密码"></asp:TextBox>
          </em>
        </label>
        <label>
            <asp:Button ID="btnSave" runat="server" Text="" OnClick="btnSave_Click" />
        </label>
    </form>
</asp:Content>

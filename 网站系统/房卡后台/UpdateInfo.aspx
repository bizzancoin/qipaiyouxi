<%@ Page Title="修改资料" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UpdateInfo.aspx.cs" Inherits="Game.Card.UpdateInfo" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Css" runat="server">
    <link href="/css/change_data.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <form runat="server">
        <label>
         <span>联系电话：</span>
         <em>
            <asp:TextBox ID="txtPhone" runat="server" placeholder="请输入手机号码"></asp:TextBox>
         </em>
       </label>
       <label>
         <span>微信号：</span>
         <em>
            <asp:TextBox ID="txtWeiXin" runat="server" placeholder="请输入微信号"></asp:TextBox>
         </em>
       </label>
       <label>
            <asp:Button ID="btnSave" runat="server" Text="" OnClick="btnSave_Click" />
       </label>
    </form>
</asp:Content>

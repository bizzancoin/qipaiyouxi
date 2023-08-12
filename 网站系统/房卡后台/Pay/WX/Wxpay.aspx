<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Wxpay.aspx.cs" Inherits="Game.Card.Pay.WX.Wxpay" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Css" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <form id="fmStep2" runat="server" action="/Pay/WX/Wxcode.aspx" method="post">
       <%= formData %>
   </form>
    <%= js %>
</asp:Content>

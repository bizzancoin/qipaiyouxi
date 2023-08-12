<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Wxcode.aspx.cs" Inherits="Game.Card.Pay.WX.Wxcode" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Css" runat="server">
 <link href="/css/wxcode.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <p style="text-align:center;color:red;font-size:1rem;">保存二维码图片，使用微信扫码完成支付</p>

    <p><img class="ui-code" src="data:image/png;base64,<%=imagecode %>" /></p>

    <p style="text-align:center;">订单号码：<br/>
        <span class="ui-num"><%=orderid %></span>
    </p>
    <p style="text-align:center;">订单金额：<br/>
        <span class="ui-price"><%=amountcode %></span>
    </p>
</asp:Content>

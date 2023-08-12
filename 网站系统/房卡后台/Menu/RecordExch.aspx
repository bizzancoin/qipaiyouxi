<%@ Page Title="兑换记录" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RecordExch.aspx.cs" Inherits="Game.Card.Menu.RecordExch" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Css" runat="server">
    <link href="/css/record.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <ul class="ui-tab fn-clean-space">
       <li><a href="/Menu/Record.aspx">购买记录</a></li>
       <li class="active"><a href="/Menu/RecordExch.aspx">兑换记录</a></li>
       <li><a href="/Menu/RecordPresent.aspx">赠送记录</a></li>
       <li><a href="/Menu/RecordCost.aspx">消耗记录</a></li>
     </ul>
      <div class="ui-table-box">
      <form runat="server">
      <div id="wrapper">
      <table class="ui-detail active">
        <thead>
          <tr>
            <th>兑换时间</th>
            <th>兑换游戏币</th>
            <th>消耗房卡</th>
            <th>兑换后房卡</th>
          </tr>
        </thead>
        <tbody data-url="/Handler.ashx?action=getroomcardexchlist" id="list">
        </tbody>
      </table>
      </div>
      </form>
      </div>
    <script src="/Scripts/zepto.min.js"></script>
    <script src="/iscroll/iscroll.js"></script>
    <script src="/iscroll/pullup-refresh.js"></script>
    <script src="/iscroll/load.js"></script>
</asp:Content>

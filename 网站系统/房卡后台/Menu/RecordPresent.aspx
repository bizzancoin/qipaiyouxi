<%@ Page Title="赠送记录" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RecordPresent.aspx.cs" Inherits="Game.Card.Menu.RecordPresent" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Css" runat="server">
    <link href="/css/record.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <ul class="ui-tab fn-clean-space">
       <li><a href="/Menu/Record.aspx">购买记录</a></li>
       <li><a href="/Menu/RecordExch.aspx">兑换记录</a></li>
       <li class="active"><a href="/Menu/RecordPresent.aspx">赠送记录</a></li>
       <li><a href="/Menu/RecordCost.aspx">消耗记录</a></li>
     </ul>
      <div class="ui-table-box">
      <form runat="server">
      <div id="wrapper">
      <table class="ui-detail active">
        <thead>
          <tr>
            <th>赠送时间</th>
            <th>赠送 I D</th>
            <th>赠送前房卡</th>
            <th>赠送房卡</th>
          </tr>
        </thead>
        <tbody data-url="/Handler.ashx?action=getroomcardpresentlist" id="list">
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

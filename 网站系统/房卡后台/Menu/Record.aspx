<%@ Page Title="购买记录" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Record.aspx.cs" Inherits="Game.Card.Menu.Record" %>
<asp:Content ID="Css1" ContentPlaceHolderID="Css" runat="server">
    <link href="/css/record.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <ul class="ui-tab fn-clean-space">
       <li class="active"><a href="/Menu/Record.aspx">购买记录</a></li>
       <li><a href="/Menu/RecordExch.aspx">兑换记录</a></li>
       <li><a href="/Menu/RecordPresent.aspx">赠送记录</a></li>
       <li><a href="/Menu/RecordCost.aspx">消耗记录</a></li>
     </ul>
      <div class="ui-table-box">
      <form runat="server">
      <div id="wrapper">
      <table class="ui-detail active">
        <thead>
          <tr>
            <th>购买时间</th>
            <th>购买数量</th>
            <th>消耗数量</th>
            <th>购买后数量</th>
          </tr>
        </thead>
        <tbody data-url="/Handler.ashx?action=getroomcardbuylist" id="list">
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

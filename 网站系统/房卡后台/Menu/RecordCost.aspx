<%@ Page Title="消耗记录" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RecordCost.aspx.cs" Inherits="Game.Card.Menu.RecordCost" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Css" runat="server">
    <link href="/css/record.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <ul class="ui-tab fn-clean-space">
       <li><a href="/Menu/Record.aspx">购买记录</a></li>
       <li><a href="/Menu/RecordExch.aspx">兑换记录</a></li>
       <li><a href="/Menu/RecordPresent.aspx">赠送记录</a></li>
       <li class="active"><a href="/Menu/RecordCost.aspx">消耗记录</a></li>
     </ul>
      <div class="ui-table-box">
      <form runat="server">
        <div id="wrapper">
        <table class="ui-detail active">
          <thead>
            <tr>
              <th>创建时间</th>
              <th>消耗房卡</th>
              <th>房间ID</th>
              <th>查看战绩</th>
            </tr>
          </thead>
          <tbody data-url="/Handler.ashx?action=getroomcardcostlist" id="list">
          </tbody>
        </table>
        </div>
       </form>
      </div>
    <script src="/Scripts/zepto.min.js"></script>
    <script src="/iscroll/iscroll.js"></script>
    <script src="/iscroll/pullup-refresh.js"></script>
    <script src="/iscroll/load.js"></script>
    <script src="/layer_mobile/layer.js"></script>
    <script src="/Scripts/recordcost.js"></script>
</asp:Content>

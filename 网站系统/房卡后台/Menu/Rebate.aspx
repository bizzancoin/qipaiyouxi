<%@ Page Title="返利" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Rebate.aspx.cs" Inherits="Game.Card.Menu.Rebate" %>
<asp:Content ID="Css1" ContentPlaceHolderID="Css" runat="server">
    <link href="/css/return.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="ui-content">
        <div class="ui-btn-check">
            <a id="look-total" data-id ="<%=userid %>"></a>
        </div>
        <div class="ui-btn-check">
            <a id="look-today" data-id ="<%=userid %>"></a>
        </div>
      </div>
    <div class="ui-table-box">
      <form runat="server">
      <div id="wrapper">
      <table class="ui-detail active">
        <thead>
          <tr>
            <th>房间ID</th>
            <th>创建消耗</th>
            <th>返利金额</th>
            <th>返利时间</th>
          </tr>
        </thead>
        <tbody data-url="/Handler.ashx?action=getroomcardrebatelist" id="list">
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
    <script src="/Scripts/rebate.js"></script>
</asp:Content>

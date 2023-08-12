<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PublicReturn.aspx.cs" Inherits="Game.Web.UserService.JFT.PublicReturn" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/js/jquery.min.js"></script>
    <script src="/js/Check.js" type="text/javascript"></script>
    <script src="/js/utils.js" type="text/javascript"></script>    
    <title></title>
    <style>
      body {width: 696px; height: 420px; padding: 5px; background: #251b14 url("/images/pay/pay_bg.png") no-repeat;}
      .ui-pay-menu {padding: 0 26px; font-size: 0;}
      .ui-pay-menu span, .ui-pay-menu a {display: inline-block; *zoom: 1; *display: inline; font-size: 0;}
      .ui-pay-menu a {
        width: 210px; height: 40px;
        background: url("/images/pay/menu.png") no-repeat;
      }
      .ui-pay-menu-2 {margin: 0 7px;}
      .ui-pay-menu-1 a {background-position: 0 0;}
      .ui-pay-menu-1 a.ui-pay-active {background-position: 0 -120px;}
      .ui-pay-menu-2 a {background-position: 0 -40px;}
      .ui-pay-menu-2 a.ui-pay-active {background-position: 0 -160px;}
      .ui-pay-menu-3 a {background-position: 0 -80px;}
      .ui-pay-menu-3 a.ui-pay-active {background-position: 0 -200px;}
      .ui-pay-content {padding-top: 20px;}
      .ui-pay-title {font-size: 15px; line-height: 22px; color: #fc9; text-align: center; margin-bottom: 50px;
        background: url("/images/popup/feedback_line.png") center bottom no-repeat;}
      .ui-pay-title span {font-size: 15px; line-height: 22px; color: #f60;}
      .ui-result-pic-1, .ui-result-pic-2 {margin-bottom: 0;}
      .ui-result-fail, .ui-result-success {font-size: 14px;}
      .ui-pay-btn {font-size: 0; border: none; width: 92px; height: 34px; cursor: pointer;
        background: url("/images/pay/go_on.png") no-repeat;}
      .ui-result-fail {color: #ea2121;}
    </style>
</head>
<body>
    <div class="ui-pay-menu">
      <span class="ui-pay-menu-1"><a href="pay.html">选择充值方式</a></span><!--
      --><span class="ui-pay-menu-2"><a href="pay-info.html">填写充值信息</a></span><!--
      --><span class="ui-pay-menu-3"><a href="pay-finish.html" class="ui-pay-active">充值完成</a></span>
    </div>
    <div class="ui-pay-content">
      <div class="ui-pay-title"><span>充值结果</span></div>
      <div>
        <div class="ui-result">
          <p>
            <asp:Label ID="lblAlertIcon" runat="server"></asp:Label>
            <asp:Label ID="lblAlertInfo" runat="server" Text="操作提示"></asp:Label>
          </p>
          <p>
            <input type="button" value="继续充值" class="ui-pay-btn" onclick="goURL('/UserService/PayIndex.aspx');" />
          </p>
        </div>        
      </div>
    </div>
  </body>
</html>

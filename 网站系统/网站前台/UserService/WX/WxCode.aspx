<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WxCode.aspx.cs" Inherits="Game.Web.UserService.WX.WxCode" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/js/jquery.min.js"></script>
    <script src="/js/Check.js" type="text/javascript"></script>
    <script src="/js/utils.js" type="text/javascript"></script>    
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
      .ui-pay-content {padding: 20px;}
      .ui-pay-title {font-size: 15px; line-height: 36px; color: #fc9; text-align: center; margin-bottom: 14px;
        background: url("/images/popup/feedback_line.png") center bottom no-repeat;}
      .ui-pay-title span {font-size: 15px; line-height: 22px; color: #f60;}
      .ui-pay-info {text-align: center; padding-bottom: 20px;}
      .ui-pay-info li {margin-bottom: 10px; position: relative;}
      .ui-pay-info li>label { font-size: 14px; line-height: 20px; color: #FF9F4A;}
      .ui-pay-info li>p {font-size: 12px; color: #ccc;}
      .ui-text-1 {background: #2b190e; border: none; color: #fc9; font-size: 12px;}
      .ui-pay-alert {padding: 0 120px;}
      .ui-pay-alert p {font-size: 12px; line-height: 16px; color: #875d38; margin-bottom: 10px;}
      .ui-text-1 {height: 21px;}
      input.ui-pay-btn {font-size: 0; border: none; width: 92px; height: 34px; cursor: pointer;
      background: url("/images/pay/submit.png") no-repeat;}
      .ui-pay-btn-go {background: url("/images/pay/go_on.png") no-repeat;font-size: 0; border: none; width: 92px; height: 34px; cursor: pointer;}
      .ui-pay-info li>span {position: absolute; left: 460px; font-size: 12px; color: #f00;}
      .ui-text-1:focus {border: 1px solid #f60; outline: none; width: 168px; height: 20px; line-height: 20px;}
    </style>
</head>
<body>
    <div class="ui-pay-menu">
      <span class="ui-pay-menu-1"><a href="/UserService/PayIndex.aspx">选择充值方式</a></span><!--
      --><span class="ui-pay-menu-2"><a href="javascript:;" class="ui-pay-active">填写充值信息</a></span><!--
      --><span class="ui-pay-menu-3"><a href="javascript:;">充值完成</a></span>
    </div>
    <div class="ui-pay-content">
      <div class="ui-pay-way" style="margin-bottom:20px;">
              <%--<h2 class="ui-title-solid">请打开微信扫一扫下面二维码</h2>--%>
              <form name="fmStep1" runat="server" id="fmStep1">
              <ul>
                  <li style="color:#ccc;">
                    <label style="margin-left:200px;color:#d79f4a;">订单号码：</label>  
                    <%=orderid %>                  
                  </li>
                  <li style="color:#ccc;">
                    <label style="margin-left:200px;color:#d79f4a;">订单金额：</label>      
                    <%=amountcode %>              
                  </li>
                  <li>
                    <label></label>      
                    <img style="width:150px;height:150px;margin-top:20px;margin-left:255px;" class="ui-code" src="data:image/png;base64,<%=imagecode %>" />
                  </li>
              </ul>
              </form>
       </div>
      <div class="ui-pay-alert">
        <h2 class="ui-pay-title">请打开微信扫一扫上面二维码</h2>
        <p>1、请确保您填写的帐号正确无误。</p>        
        <p>2、遇到任何充值问题，请您联系客服中心。</p>
      </div>
    </div>
  </body>
</html>

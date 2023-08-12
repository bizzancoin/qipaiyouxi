<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Main.aspx.cs" Inherits="Game.Web.UserService.JFT.Main" %>

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
        .fn-clean-space {
            letter-spacing:0;
            font-size:0;
            line-height:0;
            -webkit-text-size-adjust: none;
        }
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
      .ui-pay-title {font-size: 15px; line-height: 22px; color: #fc9; text-align: center; margin-bottom: 10px;
        background: url("/images/popup/feedback_line.png") center bottom no-repeat;}
      .ui-pay-title span {font-size: 15px; line-height: 22px; color: #f60;}
      .ui-pay-info {text-align: center; padding-bottom: 20px;}
      .ui-pay-info li {margin-bottom: 10px; text-align:center; }
      .ui-pay-info li>label { font-size: 14px; line-height: 20px; color: #FF9F4A; width:95px;text-align:right;display:inline-block;}
      .ui-pay-info li>p {font-size: 12px; color: #ccc;}
      .ui-text-1 {background: #2b190e; border: none; color: #fc9; font-size: 12px;}
      .ui-text-select {font-size: 14px;text-indent: 5px;width: 170px;height: 20px;line-height: 20px;background: #2b190e; border: none; color: #fc9;}
      .ui-pay-alert {padding: 0 120px;}
      .ui-pay-alert p {font-size: 12px; line-height: 16px; color: #875d38; margin-bottom: 10px;}
      .ui-text-1 {height: 21px;}
      input.ui-pay-btn {font-size: 0; border: none; width: 92px; height: 34px; cursor: pointer;
      background: url("/images/pay/submit.png") no-repeat;}
      .ui-pay-btn-go {background: url("/images/pay/go_on.png") no-repeat;font-size: 0; border: none; width: 92px; height: 34px; cursor: pointer;}
      .ui-pay-info li>span { font-size: 12px; color: #f00;}
      .ui-text-1:focus {border: 1px solid #f60; outline: none; width: 168px; height: 20px; line-height: 20px;}
      .ui-text-select:focus {border: 1px solid #f60; outline: none; width: 170px; height: 20px; line-height: 20px;}
      #amount {font-size: 16px; color: #f00;}
      /*.ui-pay-box{text-align:left;color:#FF9F4A;}*/
      .ui-pay{ text-align:left; }
    </style>
</head>
<body>
    <div class="ui-pay-menu">
      <span class="ui-pay-menu-1"><a href="/UserService/PayIndex.aspx">选择充值方式</a></span><!--
      --><span class="ui-pay-menu-2"><a href="javascript:;" class="ui-pay-active">填写充值信息</a></span><!--
      --><span class="ui-pay-menu-3"><a href="javascript:;">充值完成</a></span>
    </div>
    <div class="ui-pay-content">
      <div class="ui-pay-title">您选择了&nbsp;<span><%= payName %></span>&nbsp;方式</div>
      <form runat="server" id="fmStep1">
        <script type="text/javascript">
            $(document).ready(function () {
                $("#txtPayAccounts").blur(function () { checkAccounts(); });
                $("#txtPayReAccounts").blur(function () { checkReAccounts(); });
                $("#txtPayAmount").blur(function () { checkAmount(); });

                $("#btnPay").click(function () {
                    return checkInput();
                });

                $('#ddlCurrenry').change(function () {
                    $('#amount').html($(this).val());
                });
            });

            function checkAccounts() {
                if ($.trim($("#txtPayAccounts").val()) == "") {
                    $("#txtPayAccountsTips").html("请输入您的游戏帐号");
                    return false;
                }
                $("#txtPayAccountsTips").html("");
                return true;
            }

            function checkReAccounts() {
                if ($.trim($("#txtPayReAccounts").val()) == "") {
                    $("#txtPayReAccountsTips").html("请再次输入游戏帐号");
                    return false;
                }
                if ($("#txtPayReAccounts").val() != $("#txtPayAccounts").val()) {
                    $("#txtPayReAccountsTips").html("两次输入的帐号不一致");
                    return false;
                }
                $("#txtPayReAccountsTips").html("");
                return true;
            }

            function checkAmount() {
                var amount = $('#ddlCurrenry').val();
                if (amount == "0") {
                    $("#ddlCurrenryTips").html("请选择充值额度");
                    return false;
                }
                $("#ddlCurrenryTips").html("");
                return true;
            }

            function checkInput() {
                if (!checkAccounts()) { $("#txtPayAccounts").focus(); return false; }
                if (!checkReAccounts()) { $("#txtPayReAccounts").focus(); return false; }
                if (!checkAmount()) { return false; }
            }
        </script>
        <ul class="ui-pay-info">
          <li>
            <label>游戏帐号：</label>
            <asp:TextBox ID="txtPayAccounts" runat="server" CssClass="ui-text-1"></asp:TextBox>
            <span id="txtPayAccountsTips" style=" color:Red"></span>
          </li>
          <li>
            <label>确认帐号：</label>
            <asp:TextBox ID="txtPayReAccounts" runat="server" CssClass="ui-text-1"></asp:TextBox>
            <span id="txtPayReAccountsTips" style="color:Red;"></span>
          </li>
          <li class="ui-position" style="z-index: 1;">
            <label>充值游戏豆：</label>
            <asp:DropDownList ID="ddlCurrenry" runat="server" CssClass="ui-text-select">
            </asp:DropDownList>
            <span id="ddlCurrenryTips" style="color:Red;"></span>
          </li>
          <li class="ui-position ui-pay-box">
            <label>支付金额：</label><span style="width:170px;display:inline-block;text-align:left; color:#FF9F4A;"><strong id="amount">0</strong>&nbsp;元</span>
          </li>
          <li>
            <asp:Button ID="btnPay" runat="server" CssClass="ui-pay-btn" Text="确定" onclick="btnPay_Click" />
          </li>
        </ul>
      </form>

      <form id="fmStep2" runat="server" action="http://pay.jtpay.com/form/pay" method="post">
            <div class="ui-result">
            <p>
                <asp:Label ID="lblAlertIcon" runat="server"></asp:Label>
                <asp:Label ID="lblAlertInfo" runat="server" Text="操作提示"></asp:Label>
                <%= formData%>
            </p>
            <p id="pnlContinue" runat="server">
                <input id="btnReset1" type="button" value="继续充值" onclick="goURL('/UserService/JFT/Main.aspx?paytype=<%= payType%> ');" class="ui-pay-btn-go" />
            </p>
        </div>
     </form>
      <%= js %>
      <div class="ui-pay-alert">
        <h2 class="ui-pay-title">温馨提示</h2>
        <p>1、请确保您填写的帐号正确无误。</p>        
        <p>2、遇到任何充值问题，请您联系客服中心。</p>
      </div>
    </div>
  </body>
</html>

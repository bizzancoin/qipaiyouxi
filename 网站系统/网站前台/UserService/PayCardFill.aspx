<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PayCardFill.aspx.cs" Inherits="Game.Web.UserService.PayCardFill" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/js/jquery.min.js"></script>
    <script src="/js/inputCheck.js" type="text/javascript"></script>
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
      .ui-pay-title {font-size: 15px; line-height: 22px; color: #fc9; text-align: center; margin-bottom: 10px;
        background: url("/images/popup/feedback_line.png") center bottom no-repeat;}
      .ui-pay-title span {font-size: 15px; line-height: 22px; color: #f60;}
      .ui-pay-info {text-align: center; padding-bottom: 20px;}
      .ui-pay-info li {margin-bottom: 10px; position: relative;}
      .ui-pay-info li>span {position: absolute; left: 460px; font-size: 12px; color: #f00;}
      .ui-pay-info li>label { font-size: 14px; line-height: 20px; color: #FF9F4A;}
      .ui-text-1 {background: #2b190e; border: none; color: #fc9; font-size: 12px; height: 21px;}
      .ui-pay-btn-1,
      .ui-pay-btn-2 {font-size: 0; border: none; width: 92px; height: 34px; cursor: pointer;}
      .ui-pay-btn-1 {background: url("/images/pay/submit.png") no-repeat;}
      .ui-pay-btn-2 {background: url("/images/pay/reset.png") no-repeat;}
      .ui-pay-btn-go {background: url("/images/pay/go_on.png") no-repeat;font-size: 0; border: none; width: 92px; height: 34px; cursor: pointer;}
      .ui-text-1:focus {border: 1px solid #f60; outline: none; width: 168px; height: 20px; line-height: 20px;}
      select.ui-text-1:focus {width: 170px; height: 21px; line-height: 21px; text-indent: 4px;}
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            //页面验证
            $("#txtAccounts").blur(function () {
                checkAccounts();
            });

            $("#txtAccounts2").blur(function () { checkAccounts2(); });
            $("#txtSerialID").blur(function () { checkSerial(); });
            $("#txtPassword").blur(function () { checkPassword(); });

            $("#btnPay").click(function () {
                return checkInput();
            });
        });

        function checkInput() {
            if (!checkAccounts()) {
                $("#txtAccounts").focus(); return false;
            }

            if (!checkAccounts2()) { $("#txtAccounts2").focus(); return false; }
            if (!checkSerial()) { $("#txtSerialID").focus(); return false; }
            if (!checkPassword()) { $("#txtPassword").focus(); return false; }
        }

        function checkAccounts() {
            if ($.trim($("#txtAccounts").val()) == "") {
                $("#txtAccountsTip").html("请输入您的游戏帐号");
                return false;
            }
            var reg = /^[a-zA-Z0-9_\u4e00-\u9fa5]+$/;
            if (!reg.test($("#txtAccounts").val())) {
                $("#txtAccountsTip").html("游戏帐号是由字母、数字、下划线和汉字的组合！");
                return false;
            }

            if (byteLength($("#txtAccounts").val()) < 4) {
                $("#txtAccountsTip").html("游戏帐号的长度至少为4个字符");
                return false;
            }
            if ($("#txtAccounts").val().length > 31) {
                $("#txtAccountsTip").html("游戏帐号的长度不能超过31个字符");
                return false;
            }
            $("#txtAccountsTip").html("");
            return true;
        }

        function checkAccounts2() {
            if ($.trim($("#txtAccounts2").val()) == "") {
                $("#txtAccounts2Tip").html("请输入您的游戏帐号");
                return false;
            }
            if ($("#txtAccounts2").val() != $("#txtAccounts").val()) {
                $("#txtAccounts2Tip").html("两次输入的游戏帐号不一致");
                return false;
            }
            $("#txtAccounts2Tip").html("");
            return true;
        }

        function checkSerial() {
            if ($.trim($("#txtSerialID").val()) == "") {
                $("#txtSerialIDTip").html("请输入您的充值卡号");
                return false;
            }
            $("#txtSerialIDTip").html("");
            return true;
        }

        function checkPassword() {
            if ($.trim($("#txtPassword").val()) == "") {
                $("#txtPasswordTip").html("请输入您的充值密码");
                return false;
            }
            $("#txtPasswordTip").html("");
            return true;
        }
    </script>
</head>
<body>
    <div class="ui-pay-menu">
      <span class="ui-pay-menu-1"><a href="/UserService/PayIndex.aspx">选择充值方式</a></span><!--
      --><span class="ui-pay-menu-2"><a href="javascript:;" class="ui-pay-active">填写充值信息</a></span><!--
      --><span class="ui-pay-menu-3"><a href="javascript:;">充值完成</a></span>
    </div>
    <div class="ui-pay-content">
      <div class="ui-pay-title">您选择了&nbsp;<span>实卡充值</span>&nbsp;方式</div>
      <form runat="server" id="fmStep1">        
        <ul class="ui-pay-info">
          <li>
            <label>游戏帐号：</label>
            <asp:TextBox ID="txtAccounts" runat="server" CssClass="ui-text-1"></asp:TextBox>
            <span id="txtAccountsTip" style="padding-top:5px; color:Red;"></span>
          </li>
          <li>
            <label>确认帐号：</label>
            <asp:TextBox ID="txtAccounts2" runat="server" CssClass="ui-text-1"></asp:TextBox>
            <span id="txtAccounts2Tip" style="padding-top:5px; color:Red;"></span>
          </li>
          <li>
            <label>充值卡号：</label>
            <asp:TextBox ID="txtSerialID" runat="server" CssClass="ui-text-1"></asp:TextBox>
            <span id="txtSerialIDTip" style="padding-top:5px; color:Red;"></span>
          </li>
          <li>
            <label>充值密码：</label>
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="ui-text-1"></asp:TextBox>
            <span id="txtPasswordTip" style="padding-top:5px; color:Red;"></span>
          </li>
          <li>
            <asp:Button ID="btnPay" runat="server" CssClass="ui-pay-btn-1" Text="确定" onclick="btnPay_Click" />
          </li>
        </ul>
      </form>

      <form id="fmStep2" runat="server" action="http://pay.jtpay.com/form/pay" method="post">
            <div class="ui-result">
            <p>
                <asp:Label ID="lblAlertIcon" runat="server"></asp:Label>
                <asp:Label ID="lblAlertInfo" runat="server" Text="操作提示"></asp:Label>
            </p>
            <p id="pnlContinue" runat="server">
                <input id="btnReset1" type="button" value="继续充值" onclick="goURL('/UserService/PayCardFill.aspx');" class="ui-pay-btn-go" />
            </p>
        </div>
     </form>
    </div>
  </body>
</html>
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PayCardFill.aspx.cs" Inherits="Game.Web.Pay.PayCardFill" %>
<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>
<%@ Register TagPrefix="qp" TagName="PaySidebar" Src="~/Themes/Standard/Pay_Sidebar.ascx" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <link href="/css/pay/pay-card.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/js/jquery.min.js"></script>
    <script src="/js/inputCheck.js" type="text/javascript"></script>
    <script src="/js/utils.js" type="text/javascript"></script>

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
    <!--头部开始-->
    <qp:Header ID="sHeader" runat="server" PageID="5"/>
    <!--头部结束-->
    <div class="ui-banner">
      <div class="ui-banner-bg-1"></div>
      <div class="ui-banner-bg-2"></div>
      <div class="ui-carousel-right">
        <div class="ui-carousel-left">
          <div class="ui-banner-img">
            <a href="javascript:;"><img src="/images/banner_2.png" /></a>
          </div>
        </div>
      </div>
    </div>

    <div class="ui-content">
      <div class="ui-main">
        <div class="ui-page-title fn-clear">
          <a href="/index.aspx"><i class="ui-page-title-home"></i>首页</a>
          <i class="ui-page-title-current"></i>
          <a href="index.aspx">充值中心</a>
          <i class="ui-page-title-current"></i>
          <span>实卡充值</span>
          <div class="ui-page-title-right"><span>PAY&nbsp;CENTER</span><strong>账户充值</strong></div>
        </div>
        <div class="fn-clear">
          <!--左边开始-->
          <qp:PaySidebar ID="sPaySidebar" runat="server"/>
          <!--左边结束-->
          <div class="ui-main-details fn-right">
            <div class="ui-pay-step">
              <h2 class="ui-title-solid">充值流程</h2>
              <img src="/images/pay_step.png" />
            </div>
            <div class="ui-pay-way">
              <h2 class="ui-title-solid">您选择了&nbsp;<span>实卡充值</span>&nbsp;方式</h2>
              <form name="fmStep1" runat="server" id="fmStep1">
                <ul>
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
                  <li class="ui-pay-operation">
                    <asp:Button ID="btnPay" runat="server" Text="充值" CssClass="ui-btn-1" OnClick="btnPay_Click" />
                    <input type="reset" value="重置" class="ui-btn-1" />
                  </li>
                </ul>
              </form>
              
              <form id="fmStep2" runat="server">
        	     <div class="ui-result">
                    <p>
                        <asp:Label ID="lblAlertIcon" runat="server"></asp:Label>
                        <asp:Label ID="lblAlertInfo" runat="server" Text="操作提示"></asp:Label>
                    </p>
                    <p id="pnlContinue" runat="server">
                        <input id="btnReset1" type="button" value="继续充值" onclick="goURL('/Pay/PayCardFill.aspx');" class="ui-btn-1" />
                    </p>
                </div>
            </form>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!--尾部开始-->
    <qp:Footer ID="sFooter" runat="server" />
    <!--尾部结束-->
</body>
</html>

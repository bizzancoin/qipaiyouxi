<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PayVB.aspx.cs" Inherits="Game.Web.Pay.PayVB" %>
<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>
<%@ Register TagPrefix="qp" TagName="PaySidebar" Src="~/Themes/Standard/Pay_Sidebar.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <link href="/css/pay/pay-vb.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/js/jquery.min.js"></script>
    <script src="/js/Check.js" type="text/javascript"></script>
    <script src="/js/utils.js" type="text/javascript"></script>    
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
            <a href="javascript:;"><img src="/images/banner_2.png"></a>
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
          <span>账户充值</span>
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
              <h2 class="ui-title-solid">您选择了&nbsp;<span>电话充值</span>&nbsp;方式</h2>
              <form name="fmStep1" runat="server" id="fmStep1">
                <script type="text/javascript">
                    $(document).ready(function () {
                        $("#txtPayAccounts").blur(function () { checkAccounts(); });
                        $("#txtPayReAccounts").blur(function () { checkReAccounts(); });

                        $("#btnPay").click(function () {
                            return checkInput();
                        });

                        $('#ddlCurrenry').change(function () {
                            $('#amount').html($(this).val());
                        });
                    });

                    function checkAccounts() {
                        if ($.trim($("#txtPayAccounts").val()) == "") {
                            $("#txtPayAccountsTips").html("请输入您的充值帐号");
                            return false;
                        }
                        $("#txtPayAccountsTips").html("");
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
                <ul>
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
                  <li>
                    <label>充值游戏豆：</label>
                    <asp:DropDownList ID="ddlCurrenry" runat="server" CssClass="text">
                    </asp:DropDownList>
                    <span id="ddlCurrenryTips" style="color:Red;"></span>
                  </li>
                  <li>
                    <label>支付金额：</label>
                    <span id="amount">0</span>&nbsp;元
                  </li>
                  <li>
                      <br/>
                    <p>提示：1.您选择的金额与获取的V币面额必须一致，否则将可能导致支付不成功、或支付余额丢失！<br/>
                      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.本站只支持10V币，20V币，
                      30V币，50V币，100V币面额的V币！</p>
                  </li>
                  <li>
                    <asp:Button ID="btnPay" runat="server" CssClass="ui-btn-1" Text="确定" onclick="btnPay_Click" />
                  </li>
                </ul>                
              </form> 
            </div>
            
            <asp:Panel ID="pnlStep2" runat="server">
                 <div class="ui-result">
                     <p>
                         <asp:Label ID="lblAlertIcon" runat="server" Text=""></asp:Label>
                         <asp:Label ID="lblAlertInfo" runat="server" Text="提示信息"></asp:Label>
                     </p>
                     <p id="pnlContinue" runat="server">
                         <input id="btnReset1" type="button" value="继续充值" onclick="goURL('/Pay/PayVB.aspx');" class="ui-btn-1" />
                     </p>
                     <p id="pnlSubmit" runat="server" visible="false">
                         <form id="fmStep2" action="http://s2.vnetone.com/Default.aspx" method="post">
                             <asp:Literal ID="litVB" runat="server"></asp:Literal>
                             <script type="text/javascript">
                                 window.onload = function () {
                                     document.forms[0].submit();
                                 }
                             </script>
     	                </form>
                     </p>
                 </div>
             </asp:Panel>   
             <div class="ui-pay-tips">
                <h2 class="ui-title-solid">充值说明</h2>
                <div class="ui-pay-vb"><img src="/images/pay_vb.gif"></div>
                <iframe  width="600" name="iframe"  height="357"  frameborder="0" src="http://map.vnetone.com/default.aspx" scrolling="no"></iframe>
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

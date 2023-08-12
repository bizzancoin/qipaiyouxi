<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Complaint-Setp-3.aspx.cs" Inherits="Game.Web.Member.Complaint_Setp_3" %>
<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>
<%@ Register TagPrefix="qp" TagName="UserSidebar" Src="~/Themes/Standard/User_Sidebar.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <link href="/css/member/member-complaint.css" rel="stylesheet" type="text/css" />
    <script src="/js/jquery.min.js" type="text/javascript"></script>
</head>
<body>
    <!--头部开始-->
    <qp:Header ID="sHeader" runat="server" PageID="4"/>
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
          <a href="index.aspx">个人中心</a>
          <i class="ui-page-title-current"></i>
          <span>帐号申述</span>
          <div class="ui-page-title-right"><span>MEMBER&nbsp;CENTER</span><strong>个人中心</strong></div>
        </div>
        <div class="fn-clear">
          <!--左边开始-->
          <qp:UserSidebar ID="sUserSidebar" runat="server" MemberID="6" />
          <!--左边结束-->
          <div class="ui-main-details fn-right">
            <asp:Panel ID="pnlStep1" runat="server">
            <form class="ui-complaint" id="form" action="/WS/Account.ashx?action=resetpwdbyreport" method="post">              
              <div class="ui-complaint-history">
                <h2 class="ui-title-solid">重设密码</h2>
                <p>为了您的帐户安全，请您不要使用过于简单的密码，请您牢记密码不要告诉他人。</p>
                <ul>
                  <li>
                    <label>重置登录密码：</label>
                    <input id="pwd" type="password" name="txtPassword" class="ui-text-1" />
                  </li>
                  <li>
                    <label>确认新密码：</label>
                    <input id="pwdConfirm" type="password" name="txtConfirmPassword" class="ui-text-1" />
                  </li>
                  <li>
                    <label>验证码：</label>
                    <input id="captcha" type="text" name="txtCode" class="ui-text-1" />
                    <img src="/ValidateImage.aspx" id="picVerifyCode" height="23px" style=" height:26px;cursor:pointer;vertical-align:middle;" onclick="UpdateImage()" title="点击更换验证码图片!" />
                    <a href="javascript:void(0)" onclick="UpdateImage()" id="ImageCheck2">看不清楚？ 换一个</a>
                  </li>                  
                </ul>
              </div>
              <div class="ui-complaint-submit">
                <p>
                    <input type="hidden" value="<%= number %>" name="number" />
                    <input type="hidden" value="<%= sign %>" name="sign" />
                    <input type="submit" name="submit" value="提交资料" class="ui-btn-1" />
                </p>
              </div>
            </form>  
            </asp:Panel>
            
            <asp:Panel ID="pnlStep2" runat="server">
                <h2 class="ui-title-solid">重设密码</h2>
                <div class="ui-result" style="padding-top:30px;">
                    <p>
                        <asp:Label ID="lblAlertIcon" runat="server"></asp:Label>
                        <asp:Label ID="lblAlertInfo" runat="server" Text="操作提示"></asp:Label>
                    </p>                    
                </div>
            </asp:Panel>         
          </div>
        </div>
      </div>
    </div>

    <!--尾部开始-->
    <qp:Footer ID="sFooter" runat="server" />
    <!--尾部结束-->
<script src="/js/formvalidator/formValidator.js" type="text/javascript"></script>
<script src="/js/formvalidator/formValidatorRegex.js" type="text/javascript"></script>
<script type="text/javascript">
    $.formValidator.initConfig({
        formID: 'form',
        ajaxForm: {
            success: function (result) {
                try {
                    result = $.parseJSON(result);
                } catch (e) {
                    alert('服务器错误，请刷新重试');
                    return false;
                }
                //alert(result.msg);
                if (result.code === 0 && result.data.valid) {
                    alert(result.msg);
                    window.location.href = "/Login.aspx";
                } else {
                    alert(result.msg);
                }
            }
        }
    });

    $("#pwd").formValidator({ onShow: "请输入密码，至少需要6位！", onFocus: "请输入密码，至少需要6位！", required: true })
        .inputValidator({ min: 6, onError: "你输入的密码非法,请确认" });

    $("#pwdConfirm").formValidator({ onShow: "确认密码必须和新密码完全一致！", onFocus: "请输入密码，至少需要6位！", required: true })
        .inputValidator({ min: 6, onError: "你输入的密码非法,请确认" })
        .compareValidator({ desID: "pwd", operateor: "=", onError: "两次密码不一致,请确认" });

    $('#captcha').formValidator({
        tipCss: { left: 205 },
        required: true,
        onFocus: "请输入验证码"
    });
</script>
</body>
</html>

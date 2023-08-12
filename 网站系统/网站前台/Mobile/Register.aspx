<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="Game.Web.Mobile.Register" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <link rel="stylesheet" href="./Css/ry_login.css" />
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport" />
    <meta name="screen-orientation" content="portrait" />
    <meta name="x5-orientation" content="portrait" />
    <script src="/js/jquery.min.js"type="text/javascript"></script>
    <script src="/js/passwordStrength.js" type="text/javascript"></script>
    <script src="/js/inputCheck.js" type="text/javascript"></script>
    <script src="/js/Common.js" type="text/javascript"></script>
    <script type="text/javascript">
        function UpdateImage()
        {
            $("#picVerifyCode").attr("src", "/ValidateImage2.aspx?r=" + Math.random());
        }
        
        function checkAccounts(){
            if($.trim($("#txtAccounts").val())==""){
                alert("请输入您的帐号");
                return false;
            }
            var reg = /^[a-zA-Z0-9_\u4e00-\u9fa5]+$/;
            if(!reg.test($("#txtAccounts").val())){
                alert("由字母、数字、下划线和汉字组合");
                return false;
            }
            if (GetByteLength($("#txtAccounts").val()) < 6 || GetByteLength($("#txtAccounts").val()) > 32) {
                alert("帐号的长度为6-32个字符");
                return false;
            }
            return true;
        }        
        
        //验证帐号是否存在
        var isExitsUserName = false;
        function checkUserName() {
            $.ajax({
                async: false,
                contentType: "application/json",
                url: "/WS/WSAccount.asmx/CheckName",
                data: "{userName:'" + $("#txtAccounts").val() + "'}",
                type: "POST",
                dataType: "json",
                success: function (json) {
                    json = eval("(" + json.d + ")");

                    if (json.success == "error") {
                        alert(json.msg);
                        isExitsUserName = true;
                    } 
                }
            });
        }
        
        function checkLoginPass(){
            if ($("#txtLogonPass").val() == ""){
                alert("请输入您的登录密码");
                return false;
            }
            if($("#txtLogonPass").val().length<6||$("#txtLogonPass").val().length>32){
                alert("登录密码长度为6到32个字符");
                return false;
            }
            return true;
        }
        
        function checkLoginConPass(){
            if($("#txtLogonPass2").val()==""){
                 alert("请输入登录确认密码");
                 return false;
            }
            if($("#txtLogonPass2").val() != $("#txtLogonPass").val()){
                alert("登录确认密码与原密码不同");
                return false;
            }
            return true;
        }        
        function checkVerifyCode(){
            if($("#txtCode").val()==""){
                alert("请输入验证码");
                return false;
            }
            return true;
        }
        
        function checkInput() {
            if (!checkAccounts()) {
                $("#txtAccounts").focus(); return false;
            } else {
                if (isExitsUserName) {
                    $("#txtAccounts").focus();
                    hintMessage("txtAccountsTip", "error", "很遗憾，该帐号已经被注册");
                    return false;
                }
            }
            if(!checkLoginPass()){$("#txtLogonPass").focus(); return false; }
            if(!checkLoginConPass()){$("#txtLogonPass2").focus(); return false; }         
            if(!checkVerifyCode()){ $("#txtCode").focus(); return false;}
            if(!checkService()){ return false;}
        }

        $(document).ready(function () {

            var ua = navigator.userAgent.toLowerCase();
            var isWeixin = /MicroMessenger/i.test(ua);

            if (isWeixin) {
                var weixinPopup = $('#weixin-tip');

                // 关闭弹出
                weixinPopup.on('click', '.close', function (e) {
                    e.preventDefault();

                    weixinPopup.addClass('fn-hide');
                });

                weixinPopup.removeClass('fn-hide');
            }

            $("#txtAccounts").blur(function () {
                if (checkAccounts()) {
                    checkUserName();
                }
            });
            $("#btnSave").click(function () {
                return checkInput();
            });
        });
    </script>
</head>
<body>
    <header></header>    
    <asp:Panel ID="pnlStep1" runat="server">
    <main style="display: block">    
       <div class="ui-login">
         <img src="<%= Game.Facade.Fetch.GetUploadFileUrl("/Site/MobileRegLogo.png")%>" />
       </div>
      <div class="ui-login-detail">
        <img src="./Image/login_bg.png">
       <form runat="server">
       <p><span>游戏帐号：</span><asp:TextBox runat="server" ID="txtAccounts" placeholder="6-32位字符"></asp:TextBox></p>
       <p><span>登录密码：</span><asp:TextBox ID="txtLogonPass" runat="server" TextMode="Password" placeholder="6-32位英文字母、数字、下划线组合"></asp:TextBox></p>
       <p><span>确认密码：</span><asp:TextBox ID="txtLogonPass2" runat="server" TextMode="Password" placeholder="6-32位英文字母、数字、下划线组合"></asp:TextBox></p>
       <p class="ui-identify-box"><span>验证码：</span><asp:TextBox ID="txtCode" runat="server" CssClass="ui-identify"></asp:TextBox><a class="fn-right" href="#"><img src="/ValidateImage2.aspx" id="picVerifyCode" height="23" style=" height:26px;cursor:pointer;vertical-align:middle;" onclick="UpdateImage()" title="点击更换验证码图片!"/></a></p>
       <div class="ui-agree-term">
         <a href="javascript:;"><img src="./Image/agree_term.png"></a>
         <span>我已阅读并同意<a href="javascript:;">《游戏中心服务条款》</a></span>
         <asp:TextBox ID="txtSpreader" runat="server" Visible="false"></asp:TextBox>
       </div>
         <div class="ui-submit">
           <button id="btnSave"><img src="./Image/register_btn.png" /></button>
         </div>
      </form>
      </div>
    </main>    
    </asp:Panel>
    <asp:Panel ID="pnlStep2" runat="server">
    <div class="ui-main">
      <div class="ui-login">
        <img src="<%= Game.Facade.Fetch.GetUploadFileUrl("/Site/MobileRegLogo.png")%>" />
      </div>
      <div class="ui-mask-content">
        <img src="./Image/ry_tip_bg.png">
        <div class="ui-details">
          <img src="./Image/register_success.png">
          <p>您的帐号：<span><%=accounts %></span></p>
          <p>获赠 <span class="ui-gold"><%=score %></span> 游戏币</p>
          <div><a href="<%=downLoadUrl %>"><img src="./Image/ry_download.png"></a></div>
        </div>
      </div>
    </div>
    </asp:Panel>
    <div id="weixin-tip" class="ui-weixin-tip fn-hide">
      <p>
        <img src="Img/mobile/live_weixin.png" alt="微信打开" />
        <span title="关闭" class="close">×</span>
      </p>
    </div>
  </body>
</html>

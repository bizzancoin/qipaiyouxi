<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Game.Web.Login" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id=Head1 runat="server">
    <link href="styles/layout.css" rel="stylesheet" type="text/css" />
    <script src="scripts/JQuery.js" type="text/javascript"></script>
    <script type="text/javascript">
        function redirect() {
            window.top.location = "/Login.aspx";
        }
        function ChangeCodeimg() {
            Images = document.getElementById("ImageCheck");
            Images.src = "Tools/VerifyImagePage.aspx?" + Math.random();
        }

        function showMsg(msgId, method, txt) {
            var msg, msgTemplate;

            msg = {
                errorUserName: "您输入的用户帐号不正确，请重新输入。",
                emptyUserName: "请填写您的用户帐号。",
                emptyPassword: "请填写登录密码。",
                emptyVerifyCode: "请填写验证码。",
                errorPassowrdTooLong: "登录密码不能超过100个字符。",

                errorNamePassowrd: "您填写的帐号或密码不正确，请再次尝试。",
                errorVerifyCode: "您填写的验证码不正确。",
                errorUserRole: "您的用户帐号不具有管理员身份,不能登陆。",
                errorLogonTimeout: "您的用户帐号登录超时，请重新登陆。",
                frequent: "您登录次数过于频繁，为保障安全，请输入验证码。",
                errorBlockIPErr: "您的IP已被暂时屏蔽，不能登陆，请迟一些时候再尝试。",
                errorBindIP: "您的管理帐号已经绑定指定的IP地址登录。",
                errorNullity: "您的帐号已被禁止使用，请联系管理员了解详细情况。",
                errorUnknown: "服务器未知错误，请稍后再试！"
            };

            if (msgId != undefined && msgId != "") {
                if (!txt) txt = msg[msgId];
                alert(txt);
                return true;
            }
            else {
                return false;
            }
        }

        function CheckInput() {
            var accounts = $("#txtLoginName").val();
            var pass = $("#txtLoginPass").val();
            var verifyCode = $("#txtVerifyCode").val();

            if (accounts == "") {
                showMsg("emptyUserName");
                $("#txtLoginName").focus();
                return false;
            }
            if (pass == "") {
                showMsg("emptyPassword");
                $("#txtLoginPass").focus();
                return false;
            }
            if (pass.length >= 100) {
                showMsg("errorPassowrdTooLong");
                $("#txtLoginPass").focus();
                return false;
            }
            if (verifyCode == "") {
                showMsg("emptyVerifyCode");
                $("#txtVerifyCode").focus();
                return false;
            }
        }
        $(document).ready(function() {
            $("#txtLoginName").focus();
        });
    </script>

    <title> <%=SiteName%></title>
    <style type="text/css">
        <!-- 
        body
        {
            background-image: url(images/loginBg.jpg);
            font-family: "宋体";
        }
        -->
        
    </style>
</head>
<body>
    <br /><br /><br /><br /><br /><br /><br /><br /><br />
    <form id="form1" runat="server">
    <table width="705" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <table width="705" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td width="125">
                            &nbsp;
                        </td>
                        <td width="581">
                            <span style=" padding:110px;"><img src="/Upload/Site/AdminLogo.png" /></span>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="background-image:url(images/login01.png)" width="705" height="50">
              
            </td>
        </tr>
        <tr>
            <td background="images/login02.png" width="705" height="235">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td width="301" height="33">
                            &nbsp;
                        </td>
                        <td width="73" height="33" class="f14" align="right">
                            帐 号：
                        </td>
                        <td width="331" height="33">
                            <asp:TextBox ID="txtLoginName" runat="server" CssClass="text"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td width="301" height="33">
                            &nbsp;
                        </td>
                        <td height="33" class="f14" align="right">
                            密 码：
                        </td>
                        <td height="33">
                            <asp:TextBox ID="txtLoginPass" runat="server" CssClass="text" TextMode="Password"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td width="301" height="33">
                            &nbsp;
                        </td>
                        <td height="33" class="f14" align="right">
                            验证码：
                        </td>
                        <td height="33">
                            <asp:TextBox ID="txtVerifyCode" runat="server" CssClass="text"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td width="301" height="30">
                            &nbsp;
                        </td>
                        <td height="30">
                            &nbsp;
                        </td>
                        <td height="30" class="hui6">
                            验证码请按下图中的数字填写
                        </td>
                    </tr>
                    <tr>
                        <td width="301" height="30">
                            &nbsp;
                        </td>
                        <td height="30">
                            &nbsp;
                        </td>
                        <td height="30">
                            <img src="Tools/VerifyImagePage.aspx" id="ImageCheck" style="cursor: pointer" title="点击更换验证码图片!" onclick="ChangeCodeimg();" />
                        </td>
                    </tr>
                    <tr>
                        <td width="301" height="30">
                            &nbsp;
                        </td>
                        <td height="30">
                            &nbsp;
                        </td>
                        <td height="30" class="lan">
                            <a href="javascript:void(0)" class="l" onclick="ChangeCodeimg()">看不清楚？ 换一个</a>
                        </td>
                    </tr>
                    <tr>
                        <td width="301" height="30">
                            &nbsp;
                        </td>
                        <td height="30">
                            &nbsp;
                        </td>
                        <td height="30">
                            <asp:ImageButton ID="btnLogin" runat="server" ImageUrl="images/loginBtn.jpg" Width="86" Height="34" OnClick="btnLogin_Click"
                                OnClientClick="return CheckInput()" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td width="705" height="54" align="center" background="images/login03.png" style="color: #115287;">
            </td>
        </tr>
        <tr>
            <td>
                <img src="images/login04.png" width="705" height="46" />
            </td>
        </tr>
        <tr>
            <td>
                <img src="images/login05.png" width="705" height="53" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

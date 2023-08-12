<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RetrieveCheck.aspx.cs" Inherits="Game.Web.Mobile.RetrieveCheck" %>

<!DOCTYPE html>

<html lang="en">
  <head runat="server">
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport">
    <meta name="screen-orientation" content="portrait">
    <meta name="x5-orientation" content="portrait">
    <link rel="stylesheet" href="/Mobile/Css/mobile/retrievePassword.css">
    <link rel="stylesheet" href="/Mobile/Css/mobile/base.css">
  </head>
  <body>
    <header></header>
    <main>
      <div class="ui-login">
        <img src="<%= Game.Facade.Fetch.GetUploadFileUrl("/Site/MobileRegLogo.png")%>" />
      </div>
        <form id="fmStep2" runat="server">
          <ul>
            <li><label>问题1：</label><span><asp:Label ID="lbQuestion1" runat="server" Text=""></asp:Label></span></li>
            <li><label>答案1：</label><input type="text" id="txtAnswer1" placeholder="请输入问题答案" /></li>
            <li><label>问题2：</label><span><asp:Label ID="lbQuestion2" runat="server" Text=""></asp:Label></span></li>
            <li><label>答案2：</label><input type="text" id="txtAnswer2" placeholder="请输入问题答案" /></li>
            <li><label>问题3：</label><span><asp:Label ID="lbQuestion3" runat="server" Text=""></asp:Label></span></li>
            <li><label>答案3：</label><input type="text" id="txtAnswer3" placeholder="请输入问题答案" /></li>
            <li><label>新密码：</label><input type="password" id="txtPassword" placeholder="请输入新密码" /></li>
            <li><label>确认密码：</label><input type="password" id="txtRePassword" placeholder="请输入确认密码" /><asp:HiddenField ID="hfUser" runat="server" /> </li>
          </ul>
        </form>
        <form id="fmStep3" runat="server" visible="false">
          <img src="/Mobile/Image/retrieve_wrong.png">
          <asp:Label ID="lbTip" runat="server" Text="抱歉，此帐号还没有申请密码保护功能！"></asp:Label>
          <p><a href="/Mobile/RetrievePassword.aspx">返回重新找回</a></p>
        </form>
        <div class="ui-submit" id="btnSubmit" runat="server">
          <button id="btnSave"><img src="/Mobile/Image/confirm_btn_retrieve.png"></button>
        </div>
    </main>
    <script src="/Mobile/Js/jquery/3.0.0/jquery.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $('#btnSave').on('click', function () {
                if ($('#txtAnswer1').val() == ''||$('#txtAnswer2').val() == ''||$('#txtAnswer3').val() == '') {
                    alert('请输入正确答案');
                    return false;
                }
                if ($('#txtPassword').val() == '') {
                    alert('请输入新密码');
                    return false;
                }
                if ($('#txtPassword').val().length < 6) {
                    alert('输入新密码不能少于6位');
                    return false;
                }
                if ($('#txtPassword').val() != $('#txtRePassword').val()) {
                    alert('两次密码输入不一致');
                    return false;
                }
                
                $.ajax({
                    url: '/WS/Account.ashx?action=retrievepassword',
                    type: 'POST',
                    data: {
                        Answer1: $('#txtAnswer1').val(), Answer2: $('#txtAnswer2').val(), Answer3: $('#txtAnswer3').val(),
                        Password: $('#txtPassword').val(), RePassword: $('#txtRePassword').val(), UserID: $('#hfUser').val()
                    },
                    dataType: "json",
                    success: function (data) {
                        if (data.data.valid) {
                            location.href = '/Mobile/RetrieveSuccess.aspx';
                        } else {
                            alert(data.msg);
                        }
                    }
                });
            });
        });
    </script>
  </body>
</html>

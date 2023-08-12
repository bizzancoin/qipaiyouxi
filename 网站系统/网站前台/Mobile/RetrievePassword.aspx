<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RetrievePassword.aspx.cs" Inherits="Game.Web.Mobile.RetrievePassword" %>

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
       <form id="fmStep1" action="/Mobile/RetrieveCheck.aspx" method="post">
         <p><input type="radio" id="account" name="typeid" value="1" checked="checked"><label for="account">按账号找回</label><input type="radio" value="2" name="typeid" id="IDGame"><label for="IDGame">按ID号码找回</label></p>
         <p><input type="text" id="content" name="content" placeholder="请输入找回的方式信息"></p>
         <div class="ui-submit">
            <button id="btnSave"><img src="/Mobile/Image/confirm_btn_retrieve.png"></button>
         </div>
       </form>
    </main>
    <script src="/Mobile/Js/jquery/3.0.0/jquery.min.js"></script>
    <script type="text/javascript">
        $(function () {
            var formSubmit = $('#fmStep1');
            var content = $('#content');

            $('#btnSave').on('click', function () {
                if (content.val().trim() == '') {
                    alert('请输入需要找回的方式');
                    return false;
                }
                formSubmit.submit();
            });
        });
    </script>
  </body>
</html>

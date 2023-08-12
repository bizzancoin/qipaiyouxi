<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RetrieveSuccess.aspx.cs" Inherits="Game.Web.Mobile.RetrieveSuccess" %>

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
      <form id="fmStep3">
          <img src="/Mobile/Image/retrieve_sucess.png">
          <p>恭喜您，密码已重置成功！</p>
      </form>
    </main>
  </body>
</html>

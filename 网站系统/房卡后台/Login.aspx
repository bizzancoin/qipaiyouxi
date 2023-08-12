﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Game.Card.Login" %><!DOCTYPE html><html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport">
    <title>账号登录 - 房卡管理中心</title>
    <link href="/css/base.css" rel="stylesheet" />
    <link href="/css/login.css" rel="stylesheet" />
    <script src="/Scripts/zepto.min.js"></script>
    <script src="/layer_mobile/layer.js"></script>
    <script src="/Scripts/login.js"></script>
</head>
<body>
    <main>
    <div class="ui-bg">
        <img src="/image/bg-login.jpg" id="background">
    </div>
      <div class="ui-logo"><img src="/image/logo.png"></div>
      <div class="ui-title"><img src="/image/title.png"></div>
      <form class="ui-login-box" runat="server">
           <asp:TextBox ID="txtAccounts" placeholder="请输入登录账号" autocomplete='off' runat="server" class="ui-name"></asp:TextBox>
            <asp:TextBox ID="txtPassword" placeholder="请输入登录密码" TextMode="Password" runat="server" autocomplete='off' class="ui-password"></asp:TextBox>
        <div class="ui-identify">
            <span class="textCode"><asp:TextBox ID="txtCode" placeholder="验证码" runat="server"></asp:TextBox></span>
            <span><img src="/ValidateImage2.aspx" id="picVerifyCode" width="100" height="35" style="cursor:pointer;" title="点击更换验证码图片!" /></span>
        </div>
        <div class="ui-submit">
            <asp:Button ID="btnLogin" runat="server" OnClick="btnLogin_Click" />
        </div>
      </form>
    </main>
</body>
</html>

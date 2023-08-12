<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LoginOut.aspx.cs" Inherits="Game.Web.LoginOut" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="refresh" content="3; url=Login.aspx">
    <title>已成功退出系统控制面板！</title>
    <link href="styles/layout.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        #userLogon
        {
            text-align: center;
            margin-top: 20px;
        }
        a
        {
            color: #039;
        }
    </style>
</head>
<body>
    <div style="width: 100%" id="userLogon">
        <div align="center" style="width: 600px; border: 1px dotted #FF6600; background-color: #FFFCEC; margin: auto; padding: 20px;">
            <img src="images/hint.gif" border="0" alt="提示:" align="absmiddle" width="11" height="13" />
            &nbsp; 您已成功退出系统控制面板！<br />
            <br />
            <a href="Login.aspx" class="l">重新登录</a>
        </div>
    </div>
</body>
</html>

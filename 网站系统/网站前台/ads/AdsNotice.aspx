<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdsNotice.aspx.cs" Inherits="Game.Web.ads.AdsNotice" %>

<!DOCTYPE html>

<html>
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
 <style type="text/css">
     html {
        overflow:hidden;
     }
     body{
         overflow:hidden;
     }
 </style>
</head>
<body style="background-color:#272564;margin:0;padding:0;">
    <img src="<%= Game.Facade.Fetch.GetUploadFileUrl("/Site/AdsPCAlert.png")%>" />
</body>
</html>

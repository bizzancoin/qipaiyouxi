<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdsNotice.aspx.cs" Inherits="Game.Web.Mobile.AdsNotice" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=no" />
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
    <div style="position:absolute; left:0; top:0; bottom:0; right:0;margin:auto;">
        <img src="<%= Game.Facade.Fetch.GetUploadFileUrl("/Site/AdsMobileAlert.png")%>" style="width:100%;height:100%;display:block;" />
    </div>
</body>
</html>

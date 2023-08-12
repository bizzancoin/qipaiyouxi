<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Faq.aspx.cs" Inherits="Game.Web.Mobile.Faq" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <link type="text/css" rel="stylesheet" href="/Mobile/Css/mobile/base.css" />
    <link type="text/css" rel="stylesheet" href="/Mobile/Css/Agent/commonproblem.css" />
</head>
<body>
    <main>
                <div class="ui-notice-details" id="wrapper">
                  <div class="ui-list" data-url="/WS/MobileInterface.ashx?action=getmobilefaq" id="order-list">                  
                  </div>
                </div>
    </main>
    <script src="/Mobile/Js/mobile/zepto/1.1.6/zepto.min.js" type="text/javascript"></script>
    <script src="/Mobile/Js/iscroll/iscroll.js" type="text/javascript"></script>
    <script src="/Mobile/Js/iscroll/pull-refresh.js" type="text/javascript"></script>
    <script src="/Mobile/Js/mobile/faq.js" type="text/javascript"></script>
  </body>
</html>

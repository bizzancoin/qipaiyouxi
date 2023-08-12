<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Myfeedback.aspx.cs" Inherits="Game.Web.Mobile.Myfeedback" %>

<!DOCTYPE html>
<html>
  <head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <link type="text/css" rel="stylesheet" href="/Mobile/Css/mobile/base.css">
    <link type="text/css" rel="stylesheet" href="/Mobile/Js/iscroll/pull-refresh.css" />
    <link type="text/css" rel="stylesheet" href="/Mobile/Css/mobile/myfeedback.css">
    <style type="text/css">
      .pullUp, .pullDown { color: #fff; }
    </style>
  </head>
  <body>
    <main>
        <div class="ui-content">
          <div class="ui-main">
                <div class="ui-myfeed-details">
                  <img src="/Mobile/Img/mobile/feed-title.png" width="100%" height="auto" />
                  <div id="wrapper" style="height: 100%;">
                    <div class="ui-list" data-url="/WS/MobileInterface.ashx?action=getmobilefeedback" id="order-list">
                    </div>
                  </div>
                </div>
              </div>
            </div>
    </main>
    <script src="/Mobile/Js/mobile/zepto/1.1.6/zepto.min.js" type="text/javascript"></script>
    <script src="/Mobile/Js/iscroll/iscroll.js" type="text/javascript"></script>
    <script src="/Mobile/Js/iscroll/pull-refresh.js" type="text/javascript"></script>
    <script src="/Mobile/Js/mobile/feedback.js" type="text/javascript"></script>
  </body>
</html>

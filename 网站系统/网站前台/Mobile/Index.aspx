<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="Game.Web.Mobile.Index" %>

<!DOCTYPE html>
<html>
    <head>
        <title><%=title %></title>
        <meta content="text/html; charset=utf-8" http-equiv="content-type"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <meta name="apple-mobile-web-app-capable" content="yes">
        <meta name="apple-touch-fullscreen" content="yes"/>
        <meta name="format-detection" content="telephone=no">
        <link href="/Mobile/Css/mobile/base.css?v=3.0" rel="stylesheet" type="text/css"/>
        <link href="/Mobile/Css/mobile/index.css?v=3.0" rel="stylesheet" type="text/css"/>
    </head>
    <body>
      <div class="ui-main">
      <img src="<%= Game.Facade.Fetch.GetUploadFileUrl("/Site/MobileBg.png") %>" class="ui-bg">
        <div class="ui-content">
        <div class="ui-top fn-clear">
          <i></i>
          <div class="ui-logo">
            <img src="<%= Game.Facade.Fetch.GetUploadFileUrl("/Site/MobileLogo.png") %>">
          </div>
          <div class="bdsharebuttonbox ui-share">
            <img src="/Mobile/Image/share.png">
            <a href="javascript:;" data-cmd="weixin" title="分享到微信"></a>
          </div>
        </div>
        <a href="<%= platformDownloadUrl %>" class="ui-download-btn"><img src="<%= Game.Facade.Fetch.GetUploadFileUrl("/Site/MobileDownLad.png") %>"></a>
        </div>
      </div>
        <div class="ui-bottom fn-clean-space">
          <a href="http://wpa.b.qq.com/cgi/wpa.php?ln=2&uin=<%= qq %>" class="ui-qq"><i></i><img src="/Mobile/Image/qq.png"></a>
          <a href="tel:<%= tel %>" class="ui-phone"><i></i><img src="/Mobile/Image/phone.png"></a>
        </div>
        <div id="weixin-tip" class="ui-weixin-tip fn-hide">
          <p>
            <img src="Img/mobile/live_weixin.png" alt="微信打开" />
            <span title="关闭" class="close">×</span>
          </p>
        </div>
        <script type="text/javascript" src="/Mobile/Js/mobile/zepto/1.1.6/zepto.min.js"></script>
        <script type="text/javascript" src="/Mobile/Js/mobile/swipe/2.0.0/swipe.js"></script>
        <script type="text/javascript" src="/Mobile/Js/mobile/index.js"></script>
        <script>window._bd_share_config={"common":{"bdSnsKey":{},"bdText":"","bdMini":"1","bdMiniList":["weixin"],"bdPic":"","bdStyle":"1","bdSize":"16"},"share":{}};with(document)0[(getElementsByTagName('head')[0]||body).appendChild(createElement('script')).src='http://bdimg.share.baidu.com/static/api/js/share.js?v=89860593.js?cdnversion='+~(-new Date()/36e5)];</script>
    </body>
</html>
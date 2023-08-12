<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SystemMessage.aspx.cs" Inherits="Game.Web.SystemMessage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link href="css/base.css" rel="stylesheet" type="text/css" />
    <link href="css/common.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/js/jquery.min.js"></script>
    <script type="text/javascript" src="/js/MSClass.js"></script>
    <style>
        body, img, a, div, ul, li, p, span, font, table { margin: 0px; padding: 0px; border: none; }
        html { overflow: hidden; }
        body {
            font-family: Verdana, Arial, Helvetica, sans-serif;
            font-size: 12px; height: 19px; line-height: 19px;
            letter-spacing: 0.1em; overflow: hidden;
        }
        #notice { float: left; height: 15px; width: 100px; text-align: left; overflow: hidden; font-size: 11px;}
        #content-box { float: left;  height: 15px;}
        .content-1, .content-2 { float: left; color: #ff9933; font-size: 12px; line-height: 15px; padding-right: 30px;}
        .ui-message {font-size: 12px; line-height: 15px; background: url("/images/message_bg.png") repeat-x;}
        .ui-message-title { width: 42px; color: #ff9933; font-size: 12px; line-height: 15px; margin-right: 10px;}
        .ui-message-title img {vertical-align: -3px;}
        .ui-message a {color:#f93;}
    </style>
</head>
<body>
    <div class="ui-message fn-clear">
        <div class="ui-message-title fn-left">公告<img src="/images/message_horn.png"/></div>
        <div id="notice">
            <div id="content-box">
                <div class="content-1"></div>
                <div class="content-2"></div>
            </div>
        </div>
    </div>
</body>
</html>
<script type="text/javascript">
    $(document).ready(function () {
        var notice = $('#notice');
        var parent = notice.parent();

        function getnotice(callback) {
            $.ajax({
                dataType: "text",
                url: "/WS/NativeWeb.ashx?action=getnoticelist&num=" + Math.random(),
                success: function (html) {
                    notice.find(".content-1").html(html);
                    notice.find(".content-2").html(html);
                    callback();
                }
            });
        }

        function resize() {
            var width = parent.width() - 52;

            notice.width(width);
        }

        getnotice(function () {
           new Marquee(["notice", "content-box"], 2, 2, 1920, 15, 60, 0, 0);
           resize();
        });

        $(window).on('resize', resize);
    });
</script>

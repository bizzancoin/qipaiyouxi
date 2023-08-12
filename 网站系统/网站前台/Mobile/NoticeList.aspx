<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NoticeList.aspx.cs" Inherits="Game.Web.Mobile.NoticeList" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
  <head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <link type="text/css" rel="stylesheet" href="/Mobile/Css/mobile/base.css">
    <link type="text/css" rel="stylesheet" href="/Mobile/Js/iscroll/pull-refresh.css">
    <link type="text/css" rel="stylesheet" href="/Mobile/Css/Agent/noticelist.css">
    <title>公告</title>
  </head>
  <body>
      <main>
        <div class="ui-content-box">
          <div class="ui-content">
            <div id="list" data-url="/ws/MobileInterface.ashx?action=GetMobileNotice" class="ui-left-content">
              <ul>
                <!--<li><a href="javascript:;"><img src="/Mobile/Img/agent/notice-pic1.png"></a></li>-->
                <!--<li><a href="javascript:;"><img src="/Mobile/Img/agent/notice-pic1.png"></a></li>-->
                <!--<li><a href="javascript:;"><img src="/Mobile/Img/agent/notice-pic1.png"></a></li>-->
                <!--<li><a href="javascript:;"><img src="/Mobile/Img/agent/notice-pic1.png"></a></li>-->
              </ul>
            </div>
            <div class="ui-right-content">
              <div class="ui-right-box">
                <div class="ui-notice-content">
                  <div id="details" class="ui-notice-details">
                    <!--<h2>系统公告标题！<span>发布时间：2016-05-01 11:00:00</span></h2>-->
                    <!--<p>对这支部队，习主席可谓“十分熟悉”。那么，这次来到第13集团军军-->
                      <!--部视察，习主席在集团军军史馆重点看了些什么内容？从央视新闻联播的电视-->
                      <!--画面中可以看到，习主席在3件展品前驻足的时间最长——其一，长征中红军战-->
                      <!--士周国才过草地时保留下来的半截皮带；其二，国防部授予边境自卫反击作战-->
                      <!--英雄集体“阳廷安班”的锦旗；其三，反映我军干部“下连当兵”-->
                    <!--</p>-->
                    <!--<div><a><img src="/Mobile/Img/agent/notice-pic1.png"></a></div>-->
                  </div>
              </div>
              </div>
            </div>
          </div>
        </div>
      </main>
      <script src="/Mobile/Js/mobile/zepto/1.1.6/zepto.min.js" type="text/javascript"></script>
      <script src="/Mobile/Js/iscroll/iscroll.js" type="text/javascript"></script>
      <script src="/Mobile/Js/iscroll/pull-refresh.js" type="text/javascript"></script>
      <script src="/Mobile/Js/mobile/noticelist.js" type="text/javascript"></script>
  </body>
</html>

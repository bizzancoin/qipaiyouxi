<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="Game.Web.Games.Index" %>
<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <link href="/css/download/download.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/js/jquery.min.js"></script>
</head>
<body>
    <!--头部开始-->
    <qp:Header ID="sHeader" runat="server" PageID="2"/>
    <!--头部结束-->
    <div class="ui-banner">
      <div class="ui-banner-bg-1"></div>
      <div class="ui-banner-bg-2"></div>
      <div class="ui-carousel-right">
        <div class="ui-carousel-left">
          <div class="ui-banner-img">
            <a href="javascript:;"><img src="/images/banner_2.png" /></a>
          </div>
        </div>
      </div>
    </div>

    <div class="ui-content">
      <div class="ui-main">
        <div class="ui-page-title fn-clear">
            <a href="/index.aspx"><i class="ui-page-title-home"></i>首页</a>
            <i class="ui-page-title-current"></i>
            <span>游戏下载</span>
            <div class="ui-page-title-right"><span>DOWNLOAD</span><strong>游戏下载</strong></div>
        </div>
        <div class="ui-download-detail fn-clear">
          <h2 class="fn-left">优化体验，全新架构</h2>
          <div class="ui-download-detail-box fn-left">
            <p><span>震撼大作源于精雕细琢</span><span>精彩游戏弘扬棋牌文化</span></p>
            <h3>网狐棋牌荣耀版<img src="/images/download_6609.png" /></h3>
          </div>
        </div>
        <div class="ui-download-middle fn-clear">
          <div class="ui-download-box fn-left">
            <div class="ui-download-pc fn-clear">
              <h2 class="ui-title fn-clear">PC客户端下载</h2>
              <a href="/DownSimply.aspx" class="ui-download-pic-1 fn-left">下载1</a>
              <a href="/DownFull.aspx" class="ui-download-pic-2 fn-right">下载2</a>
            </div>
            <div class="ui-download-mobile fn-clear">
              <h2 class="ui-title fn-clear">移动客户端下载</h2>
              <a href="<%=androidDownloadURL %>" class="ui-download-pic-3 fn-left">下载3</a>
              <a href="<%=iosDownloadURL %>" class="ui-download-pic-4 fn-right">下载4</a>
            </div>
          </div>
          <img src="/images/banner_3.png" />
        </div>
        <div class="ui-goodgames">
          <h2 class="ui-title fn-clear">精彩游戏</h2>
          <ul class="ui-goodgames-list fn-clear">
              <asp:Repeater ID="rptGame" runat="server">
                  <ItemTemplate>
                      <li class="fn-clear">
                          <div class="ui-goodgames-pic fn-left">
                            <a href="/GameRules.aspx?KindID=<%#Eval("KindID") %>"><img src="<%# Game.Facade.Fetch.GetUploadFileUrl(Eval("ThumbnailUrl").ToString()) %>"><p><%#Eval("KindName") %></p><i></i></a>
                          </div>
                          <div class="ui-goodgames-detail fn-left fn-clear">
                            <p><%#Game.Utils.Utility.HtmlDecode(Eval("HelpIntro").ToString()) %></p>
                            <a href="/GameRules.aspx?KindID=<%#Eval("KindID") %>" class="ui-goodgames-more-intro fn-left">更多介绍</a>
                            <%--<a href="/DownLoad.aspx?KindID=<%#Eval("KindID") %>" class="ui-goodgames-download fn-right">游戏下载</a>--%>
                          </div>
                      </li>
                  </ItemTemplate>
              </asp:Repeater>            
          </ul>
          <%--<div class="ui-goodgames-more"><a href="javascript:;"></a></div>--%>
        </div>
        <div class="ui-goodgames <%=isShowMoblieDownload==1?"":"fn-hide" %>">
          <h2 class="ui-title fn-clear">手机游戏</h2>
          <ul id="game-download" class="ui-game-download">
              <asp:Repeater ID="rptMoblieGame" runat="server">
                  <ItemTemplate>
                      <li>
                          <img src="<%# Game.Facade.Fetch.GetUploadFileUrl(Eval("ThumbnailUrl").ToString())%>" />
                          <p><%# Eval("KindName") %></p>
                          <div class="ui-download-link">
                            <a href="javascript:;" data-src="/WS/QRCode.ashx?qt=<%# domain+"/DownLoadMB.aspx?KindID="+Eval("KindID")%>&qm=<%# Eval("ThumbnailUrl") %>&qs=125">手机下载</a>
                            <a href="javascript:;" data-android="<%# Eval("AndroidDownloadUrl") %>" data-ios="<%# Eval("IOSDownloadUrl") %>">电脑下载</a>
                          </div>
                      </li>
                  </ItemTemplate>
              </asp:Repeater>            
          </ul>
        </div>
      </div>
    </div>
    <div id="ui-mask" class="ui-mask fn-hide"></div>
    <div id="download-computer" class="ui-pop fn-hide">
        <div class="ui-poy-title">
            电脑下载提示
            <a title="关闭" href="#" class="ui-pop-close">×</a>
        </div>
        <div class="ui-pop-bd">
            <div class="ui-pop-system">
                <a href="#" class="ui-pop-android" title="安卓系统"></a>
                <a href="#" class="ui-pop-ios" title="ISO系统"></a>
            </div>
        </div>
    </div>
    <div id="download-mobile" class="ui-pop fn-hide">
        <div class="ui-poy-title">
            手机下载提示
            <a title="关闭" href="#" class="ui-pop-close">×</a>
        </div>
        <div class="ui-pop-bd">
            <div class="ui-pop-other">
                <h1>方式一：用手机上的二维码扫描软件拍摄下面二维码即可</h1>
                <div class="ui-pop-list">
                    <div class="ui-qrcode">
                        <img src="/Mobile/Img/mobile/qrcode.jpg">
                    </div>
                </div>
                <h1>方式二：使用手机浏览器访问http://m.foxuc.cn，可直接下载游戏。</h1>
            </div>
        </div>
    </div>
    <!--尾部开始-->
    <qp:Footer ID="sFooter" runat="server" />
    <!--尾部结束-->
    <script type="text/javascript">
      var mask = $('#ui-mask');
      var mobile = $('#download-mobile');
      var computer = $('#download-computer');

      $('#game-download').on('click', '.ui-download-link a', function(e) {
        e.preventDefault();

          var popup;
          var target = $(this);
          var qrsrc = target.attr('data-src');

          if (qrsrc) {
            popup = mobile;

            var qrcode = popup.find('.ui-qrcode img');

            qrcode.attr('src', qrsrc);
          } else {
            var andriod = target.attr('data-android');
            var ios = target.attr('data-ios');

            popup = computer;
            popup.find('.ui-pop-android').attr('href', andriod);
            popup.find('.ui-pop-ios').attr('href', ios);
          }

          // 显示遮罩层
          mask.fadeIn();
          popup.removeClass('fn-hide');

          // 动画
          clearTimeout(popup.data('data-tick'));

          popup.data('data-tick', setTimeout(function (){
              popup.addClass('ui-pop-animate');
          }, 16));
      });

      // 关闭弹窗
      computer.add(mobile).on('click', '.ui-pop-close', function (e){
        e.preventDefault();

        var popup = $(this).closest('.ui-pop');

        // 隐藏遮罩层
        mask.fadeOut();
        popup.removeClass('ui-pop-animate');

        clearTimeout(popup.data('data-tick'));
        popup.data('data-tick', setTimeout(function (){
            popup.addClass('fn-hide');
        }, hasTransform ? 1000 : 16));
      });
    </script>
</body>
</html>

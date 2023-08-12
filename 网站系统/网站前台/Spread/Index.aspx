<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="Game.Web.Spread.Index" %>
<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>
<%@ Register TagPrefix="qp" TagName="Download" Src="~/Themes/Standard/Common_Download.ascx" %>
<%@ Register TagPrefix="qp" TagName="Speedy" Src="~/Themes/Standard/Common_Speedy.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <link href="/css/spread/spread.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/js/jquery.min.js"></script>
    <script src="/js/ZeroClipboard.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function() {
            var client = new ZeroClipboard(document.getElementById("copyBtn"), {
                moviePath: "/flash/ZeroClipboard.swf"
            });

            client.on("load", function(client) {
                client.on("complete", function(client, args) {
                    alert("复制成功")
                });
            });
        });
    </script>
</head>
<body>
    <!--头部开始-->
    <qp:Header ID="sHeader" runat="server" PageID="6"/>
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
          <span>推广系统</span>
          <div class="ui-page-title-right"><span>SPREAD</span><strong>推广系统</strong></div>
        </div>
        <div class="fn-clear">
          <div class="ui-main-speedy fn-left">
            <!--游戏下载开始-->
            <qp:Download ID="sDownload" runat="server" />
            <!--游戏下载结束-->
            <!--快速通道开始-->
            <qp:Speedy ID="sSpeedy" runat="server" />
            <!--快速通道结束-->            
          </div>
          <div class="ui-main-details fn-right">
            <div class="ui-gain-link">
              <h3>获取推广链接</h3>
              <p runat="server" id="spanLogon">我的二级域名：<span><a href="/Login.aspx?url=<%= RawUrl %>">立即登录获取推广链接</a></span></p>
              <p runat="server" id="spanSpread">我的二级域名：
                <span>
                  <input type="text" value="<%= spreadUrl %>" class="ui-text-2" readonly="true" />
                  <a href="#" id="copyBtn" data-clipboard-text="<%= spreadUrl %>">复制推广链接</a>
                </span>
              </p>
            </div>
            <div class="ui-spread-way">
              <h2 class="ui-title-solid">1.如何推广</h2>
              <b>【方式一】：</b>
              <p>（1）将您的二级域名推广链接(<%= spreadUrl%>)发给好友。</p>
              <b>【方式二】：</b>
              <p>（1）在公共上网场所（如网吧），进入官网下载游戏并安装；</p>
              <p>（2）在安装游戏的目录下建立文件Spreader.ini，文件内容设置为：[SpreaderInfo] SpreaderName = 您的游戏帐号；
                举例：您把游戏安装在D:\Program Files\ttmdm下，你的游戏帐号为aaaa 。 那么就先在ttmdm目录下建立
                Spreader.ini文件，文件内容为</p>
              <p>[SpreaderInfo]</p>
              <p>SpreaderInfo = "aaaa"</p>
              <h2 class="ui-title-solid">2.推广如何获益？</h2>
              <p>（1）每推广一个玩家，您将获得<%= registerGold%>游戏币的一次性奖励； </p>
              <p>（2）被推荐玩家游戏时间达到<%= gameTime%>分钟，您将获得<%= presentGold%>游戏币的一次性奖励；游戏时间是指在各个游戏中，进行
                游戏的总时间，不包含挂机时间。游戏时间一旦达到<%= gameTime%>分钟，该玩家则成为有效用户；</p>
              <p>（3）被推荐玩家充值，您将获得此次被推荐玩家充值游戏币的<%= fillGrantRate * 100%>%；</p>
              <p>（4）推荐玩家推广业绩的<%= balanceRate*100%>%。当您所推荐的玩家，也推荐了其他人时，他（她）每次结算推广业绩时（将推广获得
                的游戏币转入游戏帐户中），系统同时赠送您<%= balanceRate*100%>%的游戏币，他的提成收入保持不变。因此间接推荐的玩家同样能为
                您带来业绩；</p>
              <b>例如：您推荐了玩家A，A又推荐了好多其他的玩家。当A结算业绩时，获得了2000万游戏币提成，您的业绩同时也增加
                <%= Convert.ToInt32(2000 * balanceRate)%>万游戏币。</b>
              <h2 class="ui-title-solid">3.推广员业绩查询</h2>
              <p>推广员业绩查询和结算请登录会员中心&nbsp;<a href="/Member/SpreadIn.aspx">业绩查询</a>&nbsp;及&nbsp;<a href="/Member/SpreadBalance.aspx">业绩结算</a></p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!--尾部开始-->
    <qp:Footer ID="sFooter" runat="server" />
    <!--尾部结束-->
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Sitemap.aspx.cs" Inherits="Game.Web.Sitemap" %>
<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <link href="/css/sitemap/sitemap.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <!--头部开始-->
    <qp:Header ID="sHeader" runat="server" PageID="1"/>
    <!--头部结束-->

    <div class="ui-banner">
      <div class="ui-banner-bg-1"></div>
      <div class="ui-banner-bg-2"></div>
      <div class="ui-carousel-right">
        <div class="ui-carousel-left">
          <div class="ui-banner-img">
            <a href="javascript:;"><img src="images/banner_2.png"></a>
          </div>
        </div>
      </div>
    </div>

    <div class="ui-content">
      <div class="ui-main">
        <div class="ui-page-title fn-clear">
          <a href="index.aspx"><i class="ui-page-title-home"></i>首页</a>
          <i class="ui-page-title-current"></i>
          <span>网站地图</span>
          <div class="ui-page-title-right"><span>SITEMAP</span><strong>网站地图</strong></div>
        </div>
        <div class="ui-sitemap">
          <ul class="ui-sitemap-list">
            <li class="ui-site-map">
              <h2 class="ui-title fn-clear">网站导航</h2>
              <ul class="fn-clear">
                <li><a href="/Index.aspx">网站首页</a></li>
                <li><a href="/Games/Index.aspx">游戏下载</a></li>
                <li><a href="/GameRules.aspx">游戏规则</a></li>
                <li><a href="/Match/Index.aspx">比赛规则</a></li>
                <li><a href="/News/NewsList.aspx">新闻公告</a></li>
                <li><a href="/Match/Index.aspx">活动赛事</a></li>
                <li><a href="/Shop/Index.aspx">游戏商城</a></li>
                <li><a href="/About/Index.aspx">关于我们</a></li>
                <li><a href="/Service/Contact.aspx">联系我们</a></li>
                <li><a href="/Agreement.aspx">服务条款</a></li>
                <li><a href="/Spread/Index.aspx">推广中心</a></li>
              </ul>
            </li>
            <li class="ui-personal-center">
              <h2 class="ui-title fn-clear">个人中心</h2>
              <ul class="fn-clear">
                <li><a href="/Login.aspx">登录</a></li>
                <li><a href="/Register.aspx">注册</a></li>
                <li><a href="/Member/ModifyNikeName.aspx">修改昵称</a></li>
                <li><a href="/Member/ModifyFace.aspx">修改头像</a></li>
                <li><a href="/Member/ModifyUserInfo.aspx">修改资料</a></li>
              </ul>
            </li>
            <li class="ui-about-password">
              <h2 class="ui-title fn-clear">密码相关</h2>
              <ul class="fn-clear">
                <li><a href="/Member/ModifyLogonPass.aspx">修改登录密码</a></li>
                <li><a href="/Member/ReLogonPass.aspx">找回登录密码</a></li>
                <li><a href="/Member/ApplyProtect.aspx">申请密码保护</a></li>
                <li><a href="/Member/ModifyProtect.aspx">修改密码保护</a></li>
                <li><a href="/Member/ModifyInsurePass.aspx">修改银行密码</a></li>
                <li><a href="/Member/ReInsurePass.aspx">找回银行密码</a></li>
                <li><a href="/Member/ApplyPasswordCard.aspx">申请密保卡</a></li>
                <li><a href="/Member/ExitPasswordCard.aspx">取消密保卡</a></li>
              </ul>
            </li>
            <li class="ui-account-info">
              <h2 class="ui-title fn-clear">账户信息</h2>
              <ul class="fn-clear">
                <li><a href="/Member/InsureIn.aspx">存款</a></li>
                <li><a href="/Member/InsureOut.aspx">取款</a></li>
                <li><a href="/Member/InsureTransfer.aspx">赠送</a></li>
                <li><a href="/Member/InsureRecord.aspx">交易明细</a></li>
                <li><a href="/Member/ConvertRecord.aspx">魅力值兑换记录</a></li>
                <li><a href="/Member/ConvertMedalRecord.aspx">元宝兑奖/录</a></li>
                <li><a href="/Member/SpreadIn.aspx">推广业绩查询</a></li>
                <li><a href="/Member/SpreadOut.aspx">业绩结算/明细查询</a></li>
              </ul>
            </li>
            <li class="ui-pay-center">
              <h2 class="ui-title fn-clear">充值中心</h2>
              <ul class="fn-clear">
                <li><a href="/Pay/PayCardFill.aspx">实卡充值</a></li>
                <li><a href="/Pay/JFT/Main.aspx?paytype=bank">网银充值</a></li>
                <li><a href="/Pay/JFT/Card.aspx?type=103">手机充值卡</a></li>
                <li><a href="/Pay/JFT/Card.aspx?type=102">第三方游戏卡</a></li>
                <li><a href="/Pay/PayVB.aspx">电话充值</a></li>
                <li><a href="/Member/PayRecord.aspx">充值记录查询</a></li>
              </ul>
            </li>
            <li class="ui-service-center">
              <h2 class="ui-title fn-clear">客服中心</h2>
              <ul class="fn-clear">
                <li><a href="/Service/Course.aspx">新手教程</a></li>
                <li><a href="/Service/Faq.aspx">常见问题</a></li>
                <li><a href="/Service/Feedback.aspx">在线反馈</a></li>
                <li><a href="/Service/Contact.aspx">联络客服</a></li>
              </ul>
            </li>
          </ul>
        </div>
      </div>
    </div>

    <!--尾部开始-->
    <qp:Footer ID="sFooter" runat="server" />
    <!--尾部结束-->
</body>
</html>

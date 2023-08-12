<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VipIntro.aspx.cs" Inherits="Game.Web.Service.VipIntro" %>
<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>
<%@ Register TagPrefix="qp" TagName="ServiceSidebar" Src="~/Themes/Standard/Service_Sidebar.ascx" %>
<%@ Register TagPrefix="qp" TagName="Download" Src="~/Themes/Standard/Common_Download.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <link href="/css/service/privilege.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/js/jquery.min.js"></script>
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
          <a href="index.aspx">客服中心</a>
          <i class="ui-page-title-current"></i>
          <span>会员特权</span>
          <div class="ui-page-title-right"><span>SERVICE CENTER</span><strong>客服中心</strong></div>
        </div>
        <div class="fn-clear">
          <div class="ui-main-speedy fn-left">
            <!--客服左边开始-->
            <qp:ServiceSidebar ID="sServiceSidebar" runat="server" ServicePageID="9" />
            <!--客服左边结束-->
            <!--游戏下载开始-->
            <qp:Download ID="sDownload" runat="server" />
            <!--游戏下载结束-->
          </div>
          <div class="ui-main-details fn-right">
            <h2 class="ui-title-solid">会员特权</h2>
            <div class="ui-privilege">
              <div class="ui-privilege-title"><img src="/images/privilege/privilege.png"/></div>
              <div class="ui-privilege-detail"><img src="/images/privilege/privilege_detail.png"/></div>
              <div class="ui-privilege-tips">VIP会员作为游戏平台的高级用户，在充分体验精彩游戏的同时，还享受诸多特权和VIP级的服务；VIP等级越高，享有的特权越多。</div>
              <ul class="ui-privilege-list fn-clear">
                <li class="ui-list-margin">
                  <div class="ui-privilege-pic"><img src="/images/privilege/1.png"/></div>
                  <p class="ui-privilege-explain">高峰时间VIP会员可以比普通游戏用户优先进入游戏房间。当游戏房间达到人数上限时，VIP会员将挤掉非游戏状态下的普通游戏用户从而进入房间。</p>
                  <p>注：当房间内全部为会员时或房间内的普通用户均在游戏中时，此特权将失效。</p>
                </li>
                <li>
                  <div class="ui-privilege-pic"><img src="/images/privilege/2.png"/></div>
                  <p class="ui-privilege-explain">会员的特殊身份标志是会员最直观的表现，加入VIP会员，马上将在游戏大厅里面显示您的闪靓会员标志。</p>
                </li>
                <li class="ui-list-margin">
                  <div class="ui-privilege-pic"><img src="/images/privilege/3.png"/></div>
                  <p class="ui-privilege-explain">在牌局未开始之前，VIP会员可以踢同桌的其他人出去牌室（除网管、VIP会员外）。此特权仅限于非游戏状态，游戏过程中无法使用此功能。如果对方也是VIP会员，则无法将其踢出牌室。</p>
                </li>
                <li>
                  <div class="ui-privilege-pic"><img src="/images/privilege/4.png"/></div>
                  <p class="ui-privilege-explain">在完成大厅游戏任务时，VIP会员将额外获得完成任务的奖励加成；VIP等级越高，享受的任务奖励加成也越高！</p>
                </li>
                <li class="ui-list-margin">
                  <div class="ui-privilege-pic"><img src="/images/privilege/5.png"/></div>
                  <p class="ui-privilege-explain">VIP会员在大厅的商城进行购买道具礼物时，如果商品有促销打折；VIP会员将可以使用折扣价买下物品，VIP等级越高，享受的商城折扣加成也越高！</p>
                </li>
                <li>
                  <div class="ui-privilege-pic"><img src="/images/privilege/6.png"/></div>
                  <p class="ui-privilege-explain">使用银行的金币转账功能时，VIP会员将可以获得特殊的转账手续优惠；VIP等级越高，享受的商城折扣加成也越高！</p>
                </li>
                <li class="ui-list-margin">
                  <div class="ui-privilege-pic"><img src="/images/privilege/7.png"/></div>
                  <p class="ui-privilege-explain">VIP会员每天首次登录大厅时，除了可以领取每日签到的金币奖励外；将额外可以获得每日送金币的领取特权。</p>
                </li>
                <li>
                  <div class="ui-privilege-pic"><img src="/images/privilege/8.png"/></div>
                  <p class="ui-privilege-explain">VIP会员每天登录游戏房间后，如果在线时长超过25分钟，隔天将获得在线送金奖励；在线时间越长，金币奖励越丰厚哦！</p>
                </li>
                <li class="ui-list-margin">
                  <div class="ui-privilege-pic"><img src="/images/privilege/9.png"/></div>
                  <p class="ui-privilege-explain">VIP会员享有免费超值礼包赠送，VIP会员等级越高，赠送礼包越丰厚！</p>
                </li>
                <li>
                  <div class="ui-privilege-pic"><img src="/images/privilege/10.png"/></div>
                  <p class="ui-privilege-explain">VIP会员等级越高，享受的特殊权限也越多哦！</p>
                </li>
              </ul>
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

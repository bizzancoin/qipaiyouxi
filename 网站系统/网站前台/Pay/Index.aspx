<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="Game.Web.Pay.Index" %>
<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <link href="/css/pay/pay.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/js/jquery.min.js"></script>
</head>
<body>
    <!--头部开始-->
    <qp:Header ID="sHeader" runat="server" PageID="5"/>
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
          <span>充值中心</span>
          <div class="ui-page-title-right"><span>PAY&nbsp;CENTER</span><strong>充值中心</strong></div>
        </div>
        <div class="ui-pay">
          <div class="ui-pay-recommend">
            <h2 class="ui-title fn-clear">推荐充值方式<a href="/Service/PayFaq.aspx">充值遇到困难？点击这里寻求帮助</a></h2>
            <ul class="ui-recommend-list fn-clear">
              <li>
                <a href="/Pay/JFT/Main.aspx?paytype=bank" class="ui-pay-detail-pic"><img src="/images/pay/1.png" /></a><!--
                --><div class="ui-pay-detail">
                  <h4>网上银行</h4>
                  <p>网银大额充值，安全、快捷的在线充值服务。</p>
                  <a href="/Pay/JFT/Main.aspx?paytype=bank">立即充值&nbsp;></a>
                </div>
              </li>
              <li class="ui-pay-detail-center">
                <a href="/Pay/PayCardFill.aspx" class="ui-pay-detail-pic"><img src="/images/pay/2.png" /></a><!--
                --><div class="ui-pay-detail">
                <h4>实卡充值</h4>
                <p>本站发行的充值卡，安全、快捷，购买后便可充值！</p>
                <a href="/Pay/PayCardFill.aspx">立即充值&nbsp;></a>
              </div>
              </li>
              <li>
                <a href="/Pay/JFT/Main.aspx?paytype=alipay" class="ui-pay-detail-pic"><img src="/images/pay/3.png" /></a><!--
                --><div class="ui-pay-detail">
                <h4>支付宝充值</h4>
                <p>支付宝，安全、快捷的在线充值服务。</p>
                <a href="/Pay/JFT/Main.aspx?paytype=alipay">立即充值&nbsp;></a>
              </div>
              </li>
              <li>
                <a href="/Pay/ZFB/Alipay.aspx" class="ui-pay-detail-pic"><img src="/images/pay/3.png" /></a><!--
                --><div class="ui-pay-detail">
                <h4>支付宝官方充值</h4>
                <p>支付宝，安全、快捷的在线充值服务。</p>
                <a href="/Pay/ZFB/Alipay.aspx">立即充值&nbsp;></a>
              </div>
              </li>
              <li class="ui-pay-detail-center">
                <a href="/Pay/JFT/Main.aspx?paytype=wechat" class="ui-pay-detail-pic"><img src="/images/pay/4.png" /></a><!--
                --><div class="ui-pay-detail">
                <h4>微信支付</h4>
                <p>微信支付</p>
                <a href="/Pay/JFT/Main.aspx?paytype=wechat">立即充值&nbsp;></a>
              </div>
              </li>
              <li>
                <a href="/Pay/WX/Wxpay.aspx" class="ui-pay-detail-pic"><img src="/images/pay/4.png" /></a><!--
                --><div class="ui-pay-detail">
                <h4>微信官方支付</h4>
                <p>微信支付</p>
                <a href="/Pay/WX/Wxpay.aspx">立即充值&nbsp;></a>
              </div>
              </li>
              <li>
                <a href="/Pay/PayYB.aspx" class="ui-pay-detail-pic"><img src="/images/pay/5.png" /></a><!--
                --><div class="ui-pay-detail">
                <h4>易宝支付</h4>
                <p>易宝支付，包含网银，充值卡充值等主流支付。</p>
                <a href="/Pay/PayYB.aspx">立即充值&nbsp;></a>
              </div>
              </li>
              <li class="ui-pay-detail-center">
                <a href="/Pay/PayVB.aspx" class="ui-pay-detail-pic"><img src="/images/pay/6.png" /></a><!--
                --><div class="ui-pay-detail">
                <h4>全国电话手机充值</h4>
                <p>全国电话用户通过当地电信业务获取V币，再凭借V币到网站</p>
                <a href="/Pay/PayVB.aspx">立即充值&nbsp;></a>
              </div>
              </li>
            </ul>
          </div>
          <div class="ui-pay-other">
            <h2 class="ui-title fn-clear">其他充值方式<a href="contact.html">充值遇到困难？点击这里寻求帮助</a></h2>
            <ul class="ui-other-list fn-clear">
              <li>
                <a href="/Pay/JFT/Card.aspx?type=106" class="ui-pay-detail-pic"><img src="/images/pay/7.png" /></a><!--
                --><div class="ui-pay-detail">
                <h4>联通卡充值</h4>
                <p>支持全国通用的联通手机充值卡（卡号15位，密码19位）。</p>
                <a href="/Pay/JFT/Card.aspx?type=106">立即充值&nbsp;></a>
              </div>
              </li>
              <li class="ui-pay-detail-center">
                <a href="/Pay/JFT/Card.aspx?type=112" class="ui-pay-detail-pic"><img src="/images/pay/8.png" /></a><!--
                --><div class="ui-pay-detail">
                <h4>电信卡充值</h4>
                <p>支持全国通用的电信手机充值卡（卡号19位，密码18位）。</p>
                <a href="/Pay/JFT/Card.aspx?type=112">立即充值&nbsp;></a>
              </div>
              </li>
              <li>
                <a href="/Pay/JFT/Card.aspx?type=103" class="ui-pay-detail-pic"><img src="/images/pay/9.png" /></a><!--
                --><div class="ui-pay-detail">
                <h4>神州行充值</h4>
                <p>支持全国通用的神州行手机充值卡（卡号17位，密码18位）。</p>
                <a href="/Pay/JFT/Card.aspx?type=103">立即充值&nbsp;></a>
              </div>
              </li>
              <li>
                <a href="/Pay/JFT/Card.aspx?type=102" class="ui-pay-detail-pic"><img src="/images/pay/10.png" /></a><!--
                --><div class="ui-pay-detail">
                <h4>盛大卡充值</h4>
                <p>支持全国通用的盛大一卡通（卡号 15 位，密码 8 位）</p>
                <a href="/Pay/JFT/Card.aspx?type=102">立即充值&nbsp;></a>
              </div>
              </li>
              <li class="ui-pay-detail-center">
                <a href="/Pay/JFT/Card.aspx?type=109" class="ui-pay-detail-pic"><img src="/images/pay/11.png" /></a><!--
                --><div class="ui-pay-detail">
                <h4>网易卡充值</h4>
                <p>支持全国通用的网易一卡通（卡号 13 位，密码 9 位）</p>
                <a href="/Pay/JFT/Card.aspx?type=109">立即充值&nbsp;></a>
              </div>
              </li>
              <li>
                <a href="/Pay/JFT/Card.aspx?type=104" class="ui-pay-detail-pic"><img src="/images/pay/12.png" /></a><!--
                --><div class="ui-pay-detail">
                <h4>征途卡充值</h4>
                <p>支持全国通用的征途游戏卡（卡号 16 位，密码 8 位）</p>
                <a href="/Pay/JFT/Card.aspx?type=104">立即充值&nbsp;></a>
              </div>
              </li>
              <li>
                <a href="/Pay/JFT/Card.aspx?type=111" class="ui-pay-detail-pic"><img src="/images/pay/13.png" /></a><!--
                --><div class="ui-pay-detail">
                <h4>搜狐卡充值</h4>
                <p>支持全国通用的搜狐一卡通（卡号 20 位，密码 12 位）</p>
                <a href="/Pay/JFT/Card.aspx?type=111">立即充值&nbsp;></a>
              </div>
              </li>
              <li class="ui-pay-detail-center">
                <a href="/Pay/JFT/Card.aspx?type=110" class="ui-pay-detail-pic"><img src="/images/pay/14.png" /></a><!--
                --><div class="ui-pay-detail">
                <h4>完美卡充值</h4>
                <p>支持全国通用的完美一卡通（卡号 10 位，密码 15 位）。</p>
                <a href="/Pay/JFT/Card.aspx?type=110">立即充值&nbsp;></a>
              </div>
              </li>
              <li>
                <a href="/Pay/JFT/Card.aspx?type=101" class="ui-pay-detail-pic"><img src="/images/pay/15.png" /></a><!--
                --><div class="ui-pay-detail">
                <h4>骏网一卡通</h4>
                <p>支持全国通用的骏网一卡通。</p>
                <a href="/Pay/JFT/Card.aspx?type=101">立即充值&nbsp;></a>
              </div>
              </li>
              <li>
                <a href="/Pay/JFT/Card.aspx?type=105" class="ui-pay-detail-pic"><img src="/images/pay/16.png" /></a><!--
                --><div class="ui-pay-detail">
                <h4>Q币卡充值</h4>
                <p>支持全国通用的Q币卡。</p>
                <a href="/Pay/JFT/Card.aspx?type=105">立即充值&nbsp;></a>
              </div>
              </li>
              <li class="ui-pay-detail-center">
                <a href="/Pay/JFT/Card.aspx?type=108" class="ui-pay-detail-pic"><img src="/images/pay/17.png" /></a><!--
                --><div class="ui-pay-detail">
                <h4>易宝e卡通</h4>
                <p>支持全国通用的易宝e卡通。</p>
                <a href="/Pay/JFT/Card.aspx?type=108">立即充值&nbsp;></a>
              </div>
              </li>
              <li>
                <a href="/Pay/JFT/Card.aspx?type=107" class="ui-pay-detail-pic"><img src="/images/pay/18.png" /></a><!--
                --><div class="ui-pay-detail">
                <h4>久游卡充值</h4>
                <p>支持全国通用的久游卡。</p>
                <a href="/Pay/JFT/Card.aspx?type=107">立即充值&nbsp;></a>
              </div>
              </li>
              <li>
                <a href="/Pay/JFT/Card.aspx?type=113" class="ui-pay-detail-pic"><img src="/images/pay/19.png" /></a><!--
                --><div class="ui-pay-detail">
                <h4>众游一卡通</h4>
                <p>支持全国通用的众游一卡通。</p>
                <a href="/Pay/JFT/Card.aspx?type=113">立即充值&nbsp;></a>
              </div>
              </li>
              <li class="ui-pay-detail-center">
                <a href="/Pay/JFT/Card.aspx?type=114" class="ui-pay-detail-pic"><img src="/images/pay/20.png" /></a><!--
                --><div class="ui-pay-detail">
                <h4>天下一卡通</h4>
                <p>支持全国通用的天下一卡通。</p>
                <a href="/Pay/JFT/Card.aspx?type=114">立即充值&nbsp;></a>
              </div>
              </li>
              <li>
                <a href="/Pay/JFT/Card.aspx?type=115" class="ui-pay-detail-pic"><img src="/images/pay/21.png" /></a><!--
                --><div class="ui-pay-detail">
                <h4>天宏一卡通</h4>
                <p>支持全国通用的天宏一卡通。</p>
                <a href="/Pay/JFT/Card.aspx?type=115">立即充值&nbsp;></a>
              </div>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>

    <!--尾部开始-->
    <qp:Footer ID="sFooter" runat="server" />
    <!--尾部结束-->
</body>
</html>

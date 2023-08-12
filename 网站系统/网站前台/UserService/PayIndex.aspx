<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PayIndex.aspx.cs" Inherits="Game.Web.UserService.PayIndex" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <style>
      body {width: 696px; height: 420px; padding: 5px; background: #251b14 url("/images/pay/pay_bg1.png") no-repeat;overflow:hidden;}
      .ui-pay-menu {padding: 0 26px; font-size: 0;}
      .ui-pay-menu span, .ui-pay-menu a {display: inline-block; *zoom: 1; *display: inline; font-size: 0;}
      .ui-pay-menu a {
        width: 210px; height: 40px;
        background: url("/images/pay/menu.png") no-repeat;
      }
      .ui-pay-content {position:relative;}
      .ui-pay-menu-2 {margin: 0 7px;}
      .ui-pay-menu-1 a {background-position: 0 0;}
      .ui-pay-menu-1 a.ui-pay-active {background-position: 0 -120px;}
      .ui-pay-menu-2 a {background-position: 0 -40px;}
      .ui-pay-menu-2 a.ui-pay-active {background-position: 0 -160px;}
      .ui-pay-menu-3 a {background-position: 0 -80px;}
      .ui-pay-menu-3 a.ui-pay-active {background-position: 0 -200px;}
      .ui-pay-list {width: 428px; margin: 14px 0 0 34px;}
      .ui-pay-list a {display: inline-block; *zoom: 1; *display: inline;
        font-size: 0; text-align: center; margin: 0 23px 8px 0;}
      .ui-pay-list a>p {font-size: 12px; line-height: 18px; color: #ccc; text-align: center;}
      .ui-pay-list a>img {opacity:.9; filter:alpha(opacity=90)}
      .ui-pay-list a:hover {text-decoration: none;}
      .ui-pay-list a:hover p {color: #fff;}
      .ui-pay-list a:hover img {opacity:1; filter:alpha(opacity=100)}
      .ui-pay-help {width: 171px; height: 332px;
        /*background: url("/images/pay/help_bg.png") no-repeat;*/
      margin: 14px 23px 0 0; padding: 11px 14px 0 18px;}
      .ui-pay-help h2 {font-size: 14px; line-height: 20px; font-weight: bold; color: #d79f4a; margin-bottom: 10px;}
      .ui-help-list {max-height: 270px; overflow: hidden;}
      .ui-help-list li {font-size: 0; margin-bottom: 8px;}
      .ui-help-list p,
      .ui-pay-help p>a {font-size: 12px; line-height: 16px;}
      p.ui-help-question {color: #f60;}
      p.ui-help-answer {color: #e6bb71;}
      .ui-pay-help p {line-height: 16px;}
      .ui-pay-help p>a {color: #09f; text-decoration: underline;}
      .ui-pay-help p>a:hover {color: #09f; text-decoration: none;}
      .ui-change-box{width:100px;  position:absolute; bottom:-10px;left:210px;}
      .ui-btn-left,.ui-btn-right {display:inline-block; width:20px; height:20px;}
      .ui-btn-left {background:url(/images/right_btn.png) no-repeat center;} 
      .ui-btn-right {background:url(/images/left_btn.png) no-repeat center; margin-left:15px;} 
      .fn-hide{display:none; }
    </style>
</head>
<body>
    <div class="ui-pay-menu">
      <span class="ui-pay-menu-1"><a href="/UserService/PayIndex.aspx" class="ui-pay-active">选择充值方式</a></span><!--
      --><span class="ui-pay-menu-2"><a href="javascript:;">填写充值信息</a></span><!--
      --><span class="ui-pay-menu-3"><a href="javascript:;">充值完成</a></span>
    </div>
    <div class="ui-pay-content fn-clear">
      <div class="ui-pay-list fn-left" id="first">
          <a href="/UserService/ZFB/Alipay.aspx"><img src="/images/pay/3.png"/><p>支付宝官方</p></a><!--
        --><a href="/UserService/WX/Wxpay.aspx"><img src="/images/pay/4.png"/><p>微信官方</p></a><!--
        --><a href="/UserService/JFT/Main.aspx?paytype=bank"><img src="/images/pay/1.png"/><p>网上银行</p></a><!--
        --><a href="/UserService/JFT/Main.aspx?paytype=alipay"><img src="/images/pay/3.png"/><p>支付宝</p></a><!--
        --><a href="/UserService/PayCardFill.aspx"><img src="/images/pay/2.png"/><p>实卡充值</p></a><!--
        --><a href="/UserService/JFT/Card.aspx?type=103"><img src="/images/pay/9.png"/><p>神州行充值卡</p></a><!--
        --><a href="/UserService/JFT/Card.aspx?type=106"><img src="/images/pay/7.png"/><p>联通充值卡</p></a><!--
        --><a href="/UserService/JFT/Card.aspx?type=112"><img src="/images/pay/8.png"/><p>电信充值卡</p></a><!--
        --><a href="/UserService/JFT/Main.aspx?paytype=wechat"><img src="/images/pay/4.png"/><p>微信充值</p></a><!--
        --><a href="/UserService/JFT/Card.aspx?type=102"><img src="/images/pay/10.png"/><p>盛大充值卡</p></a><!--
        --><a href="/UserService/JFT/Card.aspx?type=109"><img src="/images/pay/11.png"/><p>网易充值卡</p></a><!--
        --><a href="/UserService/JFT/Card.aspx?type=104"><img src="/images/pay/12.png"/><p>征途充值卡</p></a>
      </div>
      <div class="ui-pay-list fn-left fn-hide" id="second">
        <a href="/UserService/JFT/Card.aspx?type=110"><img src="/images/pay/14.png"/><p>完美世界充值卡</p></a><!--
        --><a href="/UserService/JFT/Card.aspx?type=111"><img src="/images/pay/13.png"/><p>搜狐充值卡</p></a>
      </div>
      <div class="ui-pay-help fn-right">
        <h2>充值帮助</h2>
        <ul class="ui-help-list">
            <asp:Repeater ID="rptIssueList" runat="server">
                <ItemTemplate>
                    <li>
                        <p class="ui-help-question">问：<%# Eval("IssueTitle") %></p>
                        <p class="ui-help-answer">答：<%#GetIssueContent((string)Eval("IssueContent")) %></p>
                    </li>
                </ItemTemplate>
            </asp:Repeater>            
        </ul>
        <p><a href="/Service/PayFaq.aspx" target="_blank">更多帮助&nbsp;></a></p>
      </div>
        <div class="ui-change-box" id="select-box">
            <a href="javascript:;" class="ui-btn-left" data-div="first"></a>
            <a href="javascript:;" class="ui-btn-right" data-div="second"></a>
        </div>
    </div>
    <script src="/js/jquery.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $('#select-box').on('click', 'a', function () {
                var selectDiv = $(this).attr('data-div');
                if (selectDiv == "first") {
                    $('#first').removeClass("fn-hide");
                    $('#second').addClass("fn-hide");
                } else {
                    $('#second').removeClass("fn-hide");
                    $('#first').addClass("fn-hide");
                }
                $(this).css('background-image', 'url(/images/right_btn.png)').siblings('a').css('background-image', 'url(/images/left_btn.png)');
            });
        });
    </script>
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ConvertMedal.aspx.cs" Inherits="Game.Web.Member.ConvertMedal" %>
<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>
<%@ Register TagPrefix="qp" TagName="UserSidebar" Src="~/Themes/Standard/User_Sidebar.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <link href="/css/member/member-charm.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/js/jquery.min.js"></script>
    <script src="/js/formvalidator/formValidator.js" type="text/javascript"></script>
    <script src="/js/formvalidator/formValidatorRegex.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            //页面验证
            $.formValidator.initConfig({ formID: "form1" });
            $("#txtMedals").formValidator({ tipCss: { left: 120 } })
                .regexValidator({ regExp: "intege1", dataType: "enum", onError: "兑换的元宝数必须为正整数" });
        })
    </script>
</head>
<body>
    <!--头部开始-->
    <qp:Header ID="sHeader" runat="server" PageID="4"/>
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
          <a href="index.aspx">个人中心</a>
          <i class="ui-page-title-current"></i>
          <span>元宝兑换</span>
          <div class="ui-page-title-right"><span>MEMBER&nbsp;CENTER</span><strong>个人中心</strong></div>
        </div>
        <div class="fn-clear">
          <!--左边开始-->
          <qp:UserSidebar ID="sUserSidebar" runat="server" MemberID="19" />
          <!--左边结束-->
          <div class="ui-main-details fn-right">
            <div>
              <h2>业绩结算</h2>
              <ul class="ui-balance-detail fn-clear">
                <li><p><span>ID：</span><asp:Literal ID="lblGameID" runat="server"></asp:Literal></p></li>
                <li><p><span>帐号：</span><asp:Literal ID="lblAccounts" runat="server"></asp:Literal></p></li>                
                <li><p><span>剩余元宝：</span><span class="ui-color-red"><asp:Literal ID="lblMedals" runat="server"></asp:Literal></span></p></li>
                <li><p><span>银行游戏币：</span><span class="ui-color-red"><asp:Literal ID="lblInsureScore" runat="server" Text="0"></asp:Literal></span></p></li>
              </ul>
            </div>
            <form class="ui-spread-balance" id="form1" name="form1" runat="server">
              <p>将&nbsp;<asp:TextBox ID="txtMedals" runat="server" CssClass="ui-text-1" autocomplete="off" MaxLength="8"></asp:TextBox>&nbsp;元宝兑换成游戏币</p>
              <p><asp:Button ID="btnUpdate" Text="兑 换" runat="server" CssClass="ui-btn-1" onclick="btnUpdate_Click" /></p>
            </form>
            <div class="ui-balance-tips">
              <h2 class="ui-title-solid">温馨提示</h2>
              <p>1.元宝:游戏币 = 1:<%= rate %>。</p>
              <p>2.游戏币直接兑换到银行。</p>
              <p>3.有任何问题，请您联系客服中心。</p>
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

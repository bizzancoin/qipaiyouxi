<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SpreadBalance.aspx.cs" Inherits="Game.Web.Member.SpreadBalance" %>
<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>
<%@ Register TagPrefix="qp" TagName="UserSidebar" Src="~/Themes/Standard/User_Sidebar.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <link href="/css/member/member-balance.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/js/jquery.min.js"></script>
    <script src="/js/formvalidator/formValidator.js" type="text/javascript"></script>
    <script src="/js/formvalidator/formValidatorRegex.js" type="text/javascript"></script>
    
    <script type="text/javascript">
        $(document).ready(function(){
            //页面验证
           $.formValidator.initConfig({formID:"form1"});
            $("#txtScore").formValidator({required:true,tipCss:{left:180}})
                .regexValidator({regExp:"intege1",dataType:"enum",onerror:"结算金额必须为整数！"});
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
          <span>业绩结算</span>
          <div class="ui-page-title-right"><span>MEMBER&nbsp;CENTER</span><strong>个人中心</strong></div>
        </div>
        <div class="fn-clear">
          <!--左边开始-->
          <qp:UserSidebar ID="sUserSidebar" runat="server" MemberID="24" />
          <!--左边结束-->
          <div class="ui-main-details fn-right">
            <div>
              <h2>业绩结算</h2>
              <ul class="ui-balance-detail fn-clear">
                <li><p><span>ID：</span><asp:Literal ID="lblGameID" runat="server"></asp:Literal></p></li>
                <li><p><span>账号：</span><asp:Literal ID="lblAccounts" runat="server"></asp:Literal></p></li>
                <li><p><span>提成总收入：</span><asp:Literal ID="lblScore" runat="server"></asp:Literal></p></li>
                <li><p><span>结算总支出：</span><asp:Literal ID="lblInsure" runat="server"></asp:Literal></p></li>
                <li><p><span>当前推广余额：</span><span class="ui-color-red"><asp:Literal ID="lblRecord" runat="server"></asp:Literal></span></p></li>
                <li><p><span>当前银行存款：</span><span class="ui-color-red"><asp:Literal ID="lblInsureScore" runat="server"></asp:Literal></span></p></li>
              </ul>
            </div>
            <form class="ui-spread-balance" id="form1" name="form1" runat="server">
              <p>将&nbsp;<asp:TextBox ID="txtScore" runat="server" CssClass="ui-text-1"></asp:TextBox>&nbsp;推广游戏币结算到游戏账户</p>
              <p><asp:Button ID="btnUpdate" Text="结 算" runat="server" CssClass="ui-btn-1" onclick="btnUpdate_Click" /></p>
            </form>
            <div class="ui-balance-tips">
              <h2 class="ui-title-solid">温馨提示</h2>
              <p>1、结算游戏币直接转入银行。</p>
              <p>2、有任何问题，请您联系客服中心。</p>
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

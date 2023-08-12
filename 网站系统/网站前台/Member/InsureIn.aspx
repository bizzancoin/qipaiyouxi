<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InsureIn.aspx.cs" Inherits="Game.Web.Member.InsureIn" %>
<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>
<%@ Register TagPrefix="qp" TagName="UserSidebar" Src="~/Themes/Standard/User_Sidebar.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <link href="/css/member/member-deposit.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/js/jquery.min.js"></script>
    <script src="/js/formvalidator/formValidator.js" type="text/javascript"></script>
    <script src="/js/formvalidator/formValidatorRegex.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(function(){
            //页面验证
            $.formValidator.initConfig({
                formID: "form1"
            });
            $("#txtScore")
                .formValidator({required: true})
                .regexValidator({regExp:"intege1",dataType:"enum",onError:"游戏币必须为正整数！"});
        });
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
          <span>存款</span>
          <div class="ui-page-title-right"><span>MEMBER&nbsp;CENTER</span><strong>个人中心</strong></div>
        </div>
        <div class="fn-clear">
          <!--左边开始-->
          <qp:UserSidebar ID="sUserSidebar" runat="server" MemberID="13" />
          <!--左边结束-->
          <div class="ui-main-details fn-right">
            <form name="form1" id="form1" runat="server">
              <div class="ui-treasure">
                <h2 class="ui-title-solid">财富信息</h2>
                <p><span>银行存款：&nbsp;</span><asp:Label ID="lblInsureScore" CssClass="ui-color-red" runat="server" Text="0"></asp:Label>&nbsp;游戏币&nbsp;<a href="/Pay/Index.aspx">我要充值</a></p>
                <p><span>现金余额：&nbsp;</span><asp:Label ID="lblScore" runat="server" CssClass="ui-color-red" Text="0"></asp:Label>&nbsp;游戏币</p>
              </div>
              <div class="ui-deposit">
                <h2 class="ui-title-solid">存入游戏币</h2>
                <p><span>游戏币数目：</span><asp:TextBox ID="txtScore" runat="server" CssClass="ui-text-1" Text="0"></asp:TextBox></p>
                <p><span>备注信息：</span><asp:TextBox ID="txtNote" runat="server" TextMode="MultiLine"></asp:TextBox></p>
                <p><asp:Button ID="btnUpdate" Text="存入游戏币" runat="server" CssClass="ui-btn-1" onclick="btnUpdate_Click" /></p>
              </div>
              <div class="ui-deposit-tips">
                <h2 class="ui-title-solid">温馨提示</h2>
                <p>1.如果您在游戏币类游戏中，您将不能够存入游戏币。</p>
                <p>2.有任何问题，请您联系客服中心。</p>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>

    <!--尾部开始-->
    <qp:Footer ID="sFooter" runat="server" />
    <!--尾部结束-->
</body>
</html>

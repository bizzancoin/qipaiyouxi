<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Game.Web.Login" %>
<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <link href="/css/member/member.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/js/jquery.min.js"></script>

    <script type="text/javascript">
        function UpdateImage() {
            $("#picVerifyCode").attr("src", "/ValidateImage2.aspx?r=" + Math.random());
        }
        
        $(document).ready(function(){     
            $("#txtAccounts").focus();
        });
        
        function checkInput(){    
            if($("#txtAccounts").val()==""){
                alert("请输入您的帐号！");
                $("#txtAccounts").focus();
                return false;
            }
            if($("#txtLogonPass").val()==""){
                alert("请输入您的密码！");
                $("#txtLogonPass").focus();
                return false;
            }
            if($("#txtCode").val()==""){
                alert("请输入您的验证码！");
                $("#txtCode").focus();
                return false;
            }
            return true;
        }
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
            <a href="javascript:;"><img src="images/banner_2.png" /></a>
          </div>
        </div>
      </div>
    </div>    
    <div class="ui-content">
      <div class="ui-main">
        <div class="ui-page-title fn-clear">
          <a href="/index.aspx"><i class="ui-page-title-home"></i>首页</a>
          <i class="ui-page-title-current"></i>
          <span>个人中心</span>
          <div class="ui-page-title-right"><span>MEMBER&nbsp;CENTER</span><strong>个人中心</strong></div>
        </div>
        <div class="ui-member fn-clear">
          <a href="javascript:;" class="fn-left"><img src="/images/member.png" /></a>
          <div class="ui-member-form">
            <h2 class="fn-clear"><i></i>用户登录<a href="/Register.aspx" class="fn-right">注册帐号</a></h2>
            <form name="form1" runat="server">
              <div class="ui-account">
                <label>游戏帐号:</label><!--
                --><asp:TextBox ID="txtAccounts" runat="server" placeholder="请输入游戏帐号"></asp:TextBox>
              </div>
              <div class="ui-password">
                <label>帐号密码:</label><!--
                --><asp:TextBox ID="txtLogonPass" TextMode="Password" runat="server" placeholder="请输入帐号密码"></asp:TextBox>
              </div>
              <div class="ui-auth">
                <label>验&nbsp;&nbsp;证&nbsp;&nbsp;码:</label><!--
                --><asp:TextBox ID="txtCode" runat="server" placeholder="输入验证码"></asp:TextBox><!--
                --><img src="/ValidateImage2.aspx" id="picVerifyCode" onclick="UpdateImage()" width="100" height="35" style="cursor:pointer;" title="点击更换验证码图片!" />
              </div>
              <div class="ui-forget fn-clear">
                <a href="/Member/ReLogonPass.aspx">忘记密码？</a>
                <a href="javascript:;" onclick="UpdateImage()" class="fn-right">看不清？换一张</a>
              </div>
              <asp:Button ID="btnLogon" OnClientClick="return checkInput()" runat="server" CssClass="ui-btn-submit" OnClick="btnLogon_Click" />
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

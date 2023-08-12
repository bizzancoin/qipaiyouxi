<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ModifyLogonPass.aspx.cs" Inherits="Game.Web.Member.ModifyLogonPass" %>
<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>
<%@ Register TagPrefix="qp" TagName="UserSidebar" Src="~/Themes/Standard/User_Sidebar.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <link href="/css/member/member-password.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/js/jquery.min.js"></script>
    <script src="/js/formvalidator/formValidator.js" type="text/javascript"></script>
    <script src="/js/formvalidator/formValidatorRegex.js" type="text/javascript"></script>
    
    <script type="text/javascript">
        $(document).ready(function(){
            //页面验证
            $.formValidator.initConfig({formID:"form1"});
            $("#txtOldPass").formValidator({onShow:"请输入原始密码！",onFocus:"请输入密码，至少需要6位！",required:true})
                .inputValidator({min:6,onError:"你输入的密码非法,请确认"});
            $("#txtNewPass").formValidator({onShow:"请输入密码，至少需要6位！",onFocus:"请输入密码，至少需要6位！",required:true})
                .inputValidator({min:6,onError:"你输入的密码非法,请确认"})
                .compareValidator({desID:"txtOldPass",operateor:"!=",onError:"新密码不能与原密码一样"});
            $("#txtNewPass2").formValidator({onShow:"确认密码必须和新密码完全一致！",onFocus:"请输入密码，至少需要6位！",required:true})
                .inputValidator({min:6,onError:"你输入的密码非法,请确认"})
                .compareValidator({desID:"txtNewPass",operateor:"=",onError:"两次密码不一致,请确认"});
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
          <a href="/Member/Index.aspx">个人中心</a>
          <i class="ui-page-title-current"></i>
          <span>修改登录密码</span>
          <div class="ui-page-title-right"><span>MEMBER&nbsp;CENTER</span><strong>个人中心</strong></div>
        </div>
        <div class="fn-clear">
          <!--左边开始-->
          <qp:UserSidebar ID="sUserSidebar" runat="server" MemberID="4" />
          <!--左边结束-->
          <div class="ui-main-details fn-right">
            <h2 class="ui-title-solid">修改登录密码</h2>
            <form class="ui-member-password" id="form1" name="form1" runat="server">
              <ul class="ui-game-info">
                <li>
                  <label>原密码：</label>
                  <asp:TextBox ID="txtOldPass" runat="server" TextMode="Password" CssClass="ui-text-1"></asp:TextBox>
                </li>
                <li>
                  <label>新密码：</label>
                  <asp:TextBox ID="txtNewPass" runat="server" TextMode="Password" CssClass="ui-text-1"></asp:TextBox>
                </li>
                <li>
                  <label>确认新密码：</label>
                  <asp:TextBox ID="txtNewPass2" runat="server" TextMode="Password" CssClass="ui-text-1"></asp:TextBox>
                </li>
                <li>
                  <label></label>
                  <asp:Button ID="btnUpdate" Text="确 定" runat="server" CssClass="ui-btn-1" onclick="btnUpdate_Click" />
                  <input name="button" type="reset" class="ui-btn-1" value="取 消" />
                </li>
              </ul>
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

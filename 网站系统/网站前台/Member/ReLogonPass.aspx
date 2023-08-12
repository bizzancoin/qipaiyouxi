<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReLogonPass.aspx.cs" Inherits="Game.Web.Member.ReLogonPass" %>
<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>
<%@ Register TagPrefix="qp" TagName="UserSidebar" Src="~/Themes/Standard/User_Sidebar.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <link href="/css/member/member-retrieve.css" rel="stylesheet" type="text/css" />
    <link href="/css/member/member-applyprotect.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/js/jquery.min.js"></script>
    <script src="/js/formvalidator/formValidator.js" type="text/javascript"></script>
    <script src="/js/formvalidator/formValidatorRegex.js" type="text/javascript"></script>
    
    <script type="text/javascript">
        $(document).ready(function(){            
            $("#fmStep1").bind("submit", function () {
                if($("#txtContect").val()=="")
                {
                    alert("内容不能为空！");
                    return false;
                }
            })
            
            //页面验证
            $.formValidator.initConfig({ formID: "fmStep2" });
            $("#txtNewPass").formValidator({onShow:"请输入密码，至少需要6位！",onFocus:"请输入密码，至少需要6位！"})
                .inputValidator({min:6,onError:"你输入的密码非法,请确认"});
            $("#txtNewPass2").formValidator({onShow:"确认密码必须和新密码完全一致！",onFocus:"请输入密码，至少需要6位！"})
                .compareValidator({desID:"txtNewPass",operateor:"=",onError:"两次密码不一致,请确认"});
            
            $("#btnUpdate").click(function (){
                return checkInput();
            });
        })    
        
        function checkResponse1(){
            if($("#txtResponse1").val()==""){
                alert("请输入您的密保答案")
                return false;
            }
            return true;
        }
        function checkResponse2(){    
            if($("#txtResponse2").val()==""){
                alert("请输入您的密保答案")
                return false;
            }
            return true;
        }
        function checkResponse3(){
            if($("#txtResponse3").val()==""){
                alert("请输入您的密保答案")
                return false;
            }
            return true;
        }
        
        function checkInput(){
            if(!checkResponse1()){$("#txtResponse1").focus(); return false; }
            if(!checkResponse2()){$("#txtResponse2").focus(); return false; }
            if(!checkResponse3()){$("#txtResponse3").focus(); return false; }
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
          <span>找回登录密码</span>
          <div class="ui-page-title-right"><span>MEMBER&nbsp;CENTER</span><strong>个人中心</strong></div>
        </div>
        <div class="fn-clear">
          <!--左边开始-->
          <qp:UserSidebar ID="sUserSidebar" runat="server" MemberID="9" />
          <!--左边结束-->
          <div class="ui-main-details fn-right">
            <h2 class="ui-title-solid">找回登录密码</h2>
            <form class="ui-member-retrieve" runat="server" id="fmStep1">
              <p>
                <input type="radio" id="radType1" name="radType" value="0" runat="server" checked="true" /><label for="radType1" hidefocus="true">按帐号找回</label>
                <input type="radio" id="radType2" name="radType" value="1" runat="server" /><label for="radType2" hidefocus="true">按ID号码找回</label>
              </p>
              <p><asp:TextBox ID="txtContect" runat="server" CssClass="ui-text-1"></asp:TextBox></p>
              <p><asp:Button ID="btnConfirm" Text="确 定" runat="server" CssClass="ui-btn-1" onclick="btnConfirm_Click" /></p>
            </form>

            <form class="ui-member-applyprotect" runat="server" id="fmStep2">
              <ul class="">
                <li class="ui-li-bg">
                  <label>问题：</label>
                  <asp:Label ID="lblQuestion1" runat="server"></asp:Label>
                </li>
                <li>
                  <label>答案：</label>
                  <asp:TextBox ID="txtResponse1" runat="server" Width="162" CssClass="ui-text-1"></asp:TextBox>
                </li>
                <li class="ui-li-bg">
                  <label>问题：</label>
                  <asp:Label ID="lblQuestion2" runat="server"></asp:Label>
                </li>
                <li>
                  <label>答案：</label>
                  <asp:TextBox ID="txtResponse2" runat="server" CssClass="ui-text-1" Width="162"></asp:TextBox>
                </li>
                <li class="ui-li-bg">
                  <label>问题：</label>
                  <asp:Label ID="lblQuestion3" runat="server"></asp:Label>
                </li>
                <li>
                  <label>答案：</label>
                  <asp:TextBox ID="txtResponse3" runat="server" CssClass="ui-text-1" Width="162"></asp:TextBox>
                </li>
                <li>
                  <label>新密码：</label>
                  <asp:TextBox ID="txtNewPass" runat="server" TextMode="Password" CssClass="ui-text-1" ></asp:TextBox>
                </li>
                <li>
                  <label>确认：</label>
                  <asp:TextBox ID="txtNewPass2" runat="server" TextMode="Password" CssClass="ui-text-1" ></asp:TextBox>
                </li>
                <li class="ui-submit-list">
                  <asp:Button ID="btnUpdate" Text="确 定" runat="server" CssClass="ui-btn-1" onclick="btnUpdate_Click" />
                  <input name="button243" type="button" class="ui-btn-1" value="取消" hidefocus="true" onclick="javascript: history.go(-1)" />
                </li>
              </ul>
            </form>

            <form id="fmStep3" runat="server">                
        	     <div class="ui-result" style="padding-top:30px;">
                    <p>
                        <asp:Label ID="lblAlertIcon" runat="server"></asp:Label>
                        <asp:Label ID="lblAlertInfo" runat="server" Text="操作提示"></asp:Label>
                    </p>
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

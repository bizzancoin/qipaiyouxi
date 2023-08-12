<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ModifyNikeName.aspx.cs" Inherits="Game.Web.Member.ModifyNikeName" %>
<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>
<%@ Register TagPrefix="qp" TagName="UserSidebar" Src="~/Themes/Standard/User_Sidebar.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <link href="/css/member/member-name.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/js/jquery.min.js"></script>
    <script src="../js/inputCheck.js" type="text/javascript"></script>
    
    <script type="text/javascript">
	    function checkNickname(){
	        if($.trim($("#txtNickName").val())==""){
	            alert("请输入您的新昵称!");
	            $("#txtNickName").focus();
	            return false;
	        }
	        
	        var reg = /^[a-zA-Z0-9_\u4e00-\u9fa5]+$/;
            if(!reg.test($("#txtNickName").val())){
                alert("昵称是由字母、数字、下划线和汉字的组合！");
                return false;
            }
            
            if(byteLength($("#txtNickName").val())<6){
                alert("昵称的长度至少为6个字符");
                return false;
            }
            
            if($("#txtNickName").val().length>31){
                alert("昵称的长度不能超过31个字符");
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
          <span>修改昵称</span>
          <div class="ui-page-title-right"><span>MEMBER&nbsp;CENTER</span><strong>个人中心</strong></div>
        </div>
        <div class="fn-clear">
          <!--左边开始-->
          <qp:UserSidebar ID="sUserSidebar" runat="server" MemberID="1" />
          <!--左边结束-->
          <div class="ui-main-details fn-right">
            <h2 class="ui-title-solid">修改昵称</h2>
            <form id="form1" name="form1" runat="server" class="ui-member-name">
              <p><span>当前昵称：</span><asp:Literal ID="lblNickname" runat="server"></asp:Literal></p>
              <p><span>ID号码：</span><asp:Literal ID="lblGameID" runat="server"></asp:Literal></p>
              <p><span>新昵称：</span><asp:TextBox ID="txtNickName" CssClass="ui-text-1" runat="server"></asp:TextBox></p>
              <p class="ui-member-submit"><asp:Button ID="btnUpdate" Text="确 定" OnClientClick="return checkNickname();" runat="server" CssClass="ui-btn-1" onclick="btnUpdate_Click" /></p>
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

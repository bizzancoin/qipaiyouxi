<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ModifyFace.aspx.cs" Inherits="Game.Web.Member.ModifyFace" %>
<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>
<%@ Register TagPrefix="qp" TagName="UserSidebar" Src="~/Themes/Standard/User_Sidebar.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <link href="/css/member/member-face.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/js/jquery.min.js"></script>
    <script src="/js/lhgdialog/lhgdialog.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function() {
            //弹出页面
            $('#btnSwitchFace,#picFace').dialog({
                id: 'winUserfaceList',
                title: '更换头像',
                width: 540,
                height: 385,
                content: 'url:/FaceList.aspx',
                min: false,
                max: false,
                top: "45%",
                left:"62%",
                fixed: true,
                drag: false,
                resize: false
            });
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
          <span>修改头像</span>
          <div class="ui-page-title-right"><span>MEMBER&nbsp;CENTER</span><strong>个人中心</strong></div>
        </div>
        <div class="fn-clear">
          <!--左边开始-->
          <qp:UserSidebar ID="sUserSidebar" runat="server" MemberID="3" />
          <!--左边结束-->
          <div class="ui-main-details fn-right">
            <h2 class="ui-title-solid">修改头像</h2>
            <form class="ui-member-face" id="form1" name="form1" runat="server">
              <p>
                  <span>
                      <asp:HiddenField ID="hfFaceID" runat="server"/>
                      <img id="picFace" src="<%=faceUrl %>" style="vertical-align: middle;" alt="" width="90" height="90" />
                  </span>
                  <a href="javascript:void(0)" id="btnSwitchFace">选择其他头像</a>
              </p>
              <p class="ui-member-submit"><asp:Button ID="btnUpdate" Text="确定更换" runat="server" CssClass="ui-btn-1" onclick="btnUpdate_Click" /></p>
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

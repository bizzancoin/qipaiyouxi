<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="Game.Web.Member.Index" %>
<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>
<%@ Register TagPrefix="qp" TagName="UserSidebar" Src="~/Themes/Standard/User_Sidebar.ascx" %>
<%@ Register TagPrefix="qp" TagName="Speedy" Src="~/Themes/Standard/Common_Speedy2.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <link href="/css/member/member-details.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/js/jquery.min.js"></script>
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
          <span>基本信息</span>
          <div class="ui-page-title-right"><span>MEMBER&nbsp;CENTER</span><strong>个人中心</strong></div>
        </div>
        <div class="fn-clear">
          <!--左边开始-->
          <qp:UserSidebar ID="sUserSidebar" runat="server" MemberID="0"/>
          <!--左边结束-->
          <div class="ui-main-details fn-right">
            <div class="ui-info-title">
              <h2>基本信息</h2>
              <p>尊敬的&nbsp;<span><%=accounts %></span>&nbsp;，欢迎您来到用户个人中心！</p>
            </div>
            <div class="ui-info-detail fn-clear">
              <div class="ui-info-face fn-left">
                <p class="ui-face-pic"><img src="<%=faceUrl %>" width="90" height="90" /></p>
                <p class="ui-face-change"><a href="/Member/ModifyFace.aspx">修改头像</a></p>
              </div>
              <ul class="ui-info-id fn-left">
                <li>
                  <p><span>ID:</span><%=gameID %></p>
                </li>
                <li>
                  <p><span>帐号:</span><%=accounts %></p>
                </li>
                <li>
                  <p><span>昵称:</span><%=nickName %></p>
                </li>
                <li>
                  <p><span>性别:</span><%=gender %></p>
                </li>
                <li>
                  <p><span>经验:</span><%=experience %></p>
                </li>
                <li>
                  <p class="ui-grade-vip">
                    <span>VIP等级:</span>
                    <%=member %>
                  </p>
                </li>
                <li>
                  <p class="ui-signature"><span>签名:</span><%=underWrite %></p>
                </li>
              </ul>
            </div>
            <div class="ui-info-game">
              <ul class="fn-clear">
                <li><p><span>携带游戏币:</span><%=score %></p></li>
                <li><p><span>银行游戏币:</span><%=insureScore %></p></li>
                <li><p><span>游戏豆:</span><%=currency %></p></li>
                <li><p><span>元宝:</span><%=medal %></p></li>
                <li><p><span>魅力值:</span><%=loveLiness %></p></li>
              </ul>
            </div>
            <!--快速通道开始-->
            <qp:Speedy ID="sSpeedy" runat="server" />
            <!--快速通道结束-->
          </div>
        </div>
      </div>
    </div>
    <!--尾部开始-->
    <qp:Footer ID="sFooter" runat="server" />
    <!--尾部结束-->
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ExitPasswordCard.aspx.cs" Inherits="Game.Web.Member.ExitPasswordCard" %>
<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>
<%@ Register TagPrefix="qp" TagName="UserSidebar" Src="~/Themes/Standard/User_Sidebar.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <link href="/css/member/member-passwordcard.css" rel="stylesheet" type="text/css" />
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
          <span>取消密保卡</span>
          <div class="ui-page-title-right"><span>MEMBER&nbsp;CENTER</span><strong>个人中心</strong></div>
        </div>
        <div class="fn-clear">
          <!--左边开始-->
          <qp:UserSidebar ID="sUserSidebar" runat="server" MemberID="12" />
          <!--左边结束-->
          <div class="ui-main-details fn-right">
            <form class="ui-member-passwordcard" name="fmStep1" id="fmStep1" runat="server">             
              <div class="ui-passwordcard-binding">
                <h2 class="ui-title-solid">请输入密保卡对应的坐标数字进行解绑</h2>
                <table>
                  <tbody>
                    <tr class="ui-title-bg">
                      <td colspan="100" class="ui-font-weight">序列号：<asp:Label ID="lbSerialNumber" runat="server" Text=""></asp:Label></td>
                    </tr>
                    <tr>
                      <td></td>
                      <td class="ui-font-weight"><asp:Label ID="lbNumber1" runat="server" Text=""></asp:Label></td>
                      <td class="ui-font-weight"><asp:Label ID="lbNumber2" runat="server" Text=""></asp:Label></td>
                      <td class="ui-font-weight"><asp:Label ID="lbNumber3" runat="server" Text=""></asp:Label></td>
                    </tr>
                    <tr>
                      <td class="ui-font-weight">坐标码</td>
                      <td><asp:TextBox ID="txtNumber1" runat="server" CssClass="ui-text-1"></asp:TextBox></td>
                      <td><asp:TextBox ID="txtNumber2" runat="server" CssClass="ui-text-1"></asp:TextBox></td>
                      <td><asp:TextBox ID="txtNumber3" runat="server" CssClass="ui-text-1"></asp:TextBox></td>
                    </tr>
                  </tbody>
                </table>
                <p><asp:Button ID="Button2" runat="server" Text="取消密保卡" OnClick="ClearPasswordCard" CssClass="ui-btn-1" /></p>
              </div>
            </form>

            <form id="fmStep2" runat="server">
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

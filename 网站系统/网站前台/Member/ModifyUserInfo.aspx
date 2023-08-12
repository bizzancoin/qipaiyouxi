<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ModifyUserInfo.aspx.cs" Inherits="Game.Web.Member.ModifyUserInfo" %>
<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>
<%@ Register TagPrefix="qp" TagName="UserSidebar" Src="~/Themes/Standard/User_Sidebar.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <link href="/css/member/member-data.css" rel="stylesheet" type="text/css">
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
          <a href="/Member/Index.aspx">个人中心</a>
          <i class="ui-page-title-current"></i>
          <span>修改资料</span>
          <div class="ui-page-title-right"><span>MEMBER&nbsp;CENTER</span><strong>个人中心</strong></div>
        </div>
        <div class="fn-clear">
          <!--左边开始-->
          <qp:UserSidebar ID="sUserSidebar" runat="server" MemberID="2" />
          <!--左边结束-->
          <div class="ui-main-details fn-right">
            <form id="form1"  runat="server">
              <div>
                <h2 class="ui-title-solid">帐号资料</h2>
                <ul class="ui-game-id fn-clear">
                  <li><p><span>帐号：</span><asp:Label ID="lblAccounts" runat="server"></asp:Label></p></li>
                  <li><p><span>ID号码：</span><asp:Label ID="lblGameID" runat="server"></asp:Label></p></li>
                </ul>
              </div>
              <div>
                <h2 class="ui-title-solid">基本资料</h2>
                <ul class="ui-game-basic">
                  <li>
                    <label>性别：</label>
                    <asp:DropDownList ID="ddlGender" runat="server">
                        <asp:ListItem Text="女性" Value="0"></asp:ListItem>
                        <asp:ListItem Text="男性" Value="1"></asp:ListItem>
                    </asp:DropDownList>
                  </li>
                  <li>
                    <label>个性签名：</label>
                    <asp:TextBox ID="txtUnderWrite" runat="server" CssClass="ui-text-2"></asp:TextBox>
                  </li>
                </ul>
              </div>
              <div>
                <h2 class="ui-title-solid">我的身份资料</h2>
                <ul class="ui-game-info">
                  <li>
                    <label>真实姓名：</label>
                    <asp:TextBox ID="txtCompellation" runat="server" CssClass="ui-text-1" ReadOnly="true"></asp:TextBox>
                  </li>
                  <li>
                    <label>手机号码：</label>
                    <asp:TextBox ID="txtMobilePhone" runat="server" CssClass="ui-text-1" MaxLength="11"></asp:TextBox>
                  </li>
                  <li>
                    <label>固定电话：</label>
                    <asp:TextBox ID="txtSeatPhone" runat="server" CssClass="ui-text-1" MaxLength="16"></asp:TextBox>
                  </li>
                  <li>
                    <label>QQ：</label>
                    <asp:TextBox ID="txtQQ" runat="server" CssClass="ui-text-1" MaxLength="16"></asp:TextBox>
                  </li>
                  <li>
                    <label>Email：</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="ui-text-1" MaxLength="32"></asp:TextBox>
                  </li>
                  <li>
                    <label>详细地址：</label>
                    <asp:TextBox ID="txtAddress" runat="server" CssClass="ui-text-2"></asp:TextBox>
                  </li>
                </ul>
              </div>
              <div>
                <h2 class="ui-title-solid">我的其他说明</h2>
                <asp:TextBox ID="txtUserNote" runat="server" CssClass="ui-textarea " TextMode="MultiLine"></asp:TextBox>
              </div>
              <div class="ui-data-submit"><asp:Button ID="btnUpdate" runat="server" OnClientClick="return checkEmail()" CssClass="ui-btn-1" Text="确 定" onclick="btnUpdate_Click" /></div>
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

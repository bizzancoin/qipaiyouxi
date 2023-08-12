<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ApplyPasswordCard.aspx.cs" Inherits="Game.Web.Member.ApplyPasswordCard" %>
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
          <span>申请密保卡</span>
          <div class="ui-page-title-right"><span>MEMBER&nbsp;CENTER</span><strong>个人中心</strong></div>
        </div>
        <div class="fn-clear">
          <!--左边开始-->
          <qp:UserSidebar ID="sUserSidebar" runat="server" MemberID="11" />
          <!--左边结束-->
          <div class="ui-main-details fn-right">
            <form class="ui-member-passwordcard" name="fmStep1" id="fmStep1" runat="server">
              <div class="ui-tips">
                <h2 class="ui-title-solid">温馨提示</h2>
                <p>1.密保卡图片保存后，建议您立即进行绑卡操作。</p>
                <p>2.为了方便使用，可将密保卡打印、手抄或存到手机。</p>
                <p>3.尽量不要保存在QQ邮箱、QQ网络硬盘。 </p>
                <p>4.有任何问题，请您联系客服中心。</p>
              </div>
              <div class="ui-passwordcard">
                <h2 class="ui-title-solid">第一步：请保存好您的电子密保卡</h2>
                <table>
                  <tbody>
                    <tr class="ui-title-bg">
                      <td colspan="100" class="ui-font-weight">序列号：<asp:Label ID="lbSerialNumber" runat="server" Text=""></asp:Label></td>
                    </tr>
                    <tr>
                      <td></td>
                      <td class="ui-font-weight">1</td>
                      <td class="ui-font-weight">2</td>
                      <td class="ui-font-weight">3</td>
                      <td class="ui-font-weight">4</td>
                    </tr>
                    <tr class="ui-tr-bg">
                      <td class="ui-font-weight">A</td>
                      <td><asp:Label ID="lbA1" runat="server" Text=""></asp:Label></td>
                      <td><asp:Label ID="lbA2" runat="server" Text=""></asp:Label></td>
                      <td><asp:Label ID="lbA3" runat="server" Text=""></asp:Label></td>
                      <td><asp:Label ID="lbA4" runat="server" Text=""></asp:Label></td>
                    </tr>
                    <tr>
                      <td class="ui-font-weight">B</td>
                      <td><asp:Label ID="lbB1" runat="server" Text=""></asp:Label></td>
                      <td><asp:Label ID="lbB2" runat="server" Text=""></asp:Label></td>
                      <td><asp:Label ID="lbB3" runat="server" Text=""></asp:Label></td>
                      <td><asp:Label ID="lbB4" runat="server" Text=""></asp:Label></td>
                    </tr>
                    <tr class="ui-tr-bg">
                      <td class="ui-font-weight">C</td>
                      <td><asp:Label ID="lbC1" runat="server" Text=""></asp:Label></td>
                      <td><asp:Label ID="lbC2" runat="server" Text=""></asp:Label></td>
                      <td><asp:Label ID="lbC3" runat="server" Text=""></asp:Label></td>
                      <td><asp:Label ID="lbC4" runat="server" Text=""></asp:Label></td>
                    </tr>
                    <tr>
                      <td class="ui-font-weight">D</td>
                      <td><asp:Label ID="lbD1" runat="server" Text=""></asp:Label></td>
                      <td><asp:Label ID="lbD2" runat="server" Text=""></asp:Label></td>
                      <td><asp:Label ID="lbD3" runat="server" Text=""></asp:Label></td>
                      <td><asp:Label ID="lbD4" runat="server" Text=""></asp:Label></td>
                    </tr>
                    <tr class="ui-tr-bg">
                      <td class="ui-font-weight">E</td>
                      <td><asp:Label ID="lbE1" runat="server" Text=""></asp:Label></td>
                      <td><asp:Label ID="lbE2" runat="server" Text=""></asp:Label></td>
                      <td><asp:Label ID="lbE3" runat="server" Text=""></asp:Label></td>
                      <td><asp:Label ID="lbE4" runat="server" Text=""></asp:Label></td>
                    </tr>
                    <tr>
                      <td class="ui-font-weight">F</td>
                      <td><asp:Label ID="lbF1" runat="server" Text=""></asp:Label></td>
                      <td><asp:Label ID="lbF2" runat="server" Text=""></asp:Label></td>
                      <td><asp:Label ID="lbF3" runat="server" Text=""></asp:Label></td>
                      <td><asp:Label ID="lbF4" runat="server" Text=""></asp:Label></td>
                    </tr>
                  </tbody>
                </table>
                <p><asp:Button ID="Button1" runat="server" Text="保存密保卡" OnClick="DownloadImg" CssClass="ui-btn-1" /></p>
              </div>
              <div class="ui-passwordcard-binding">
                <h2 class="ui-title-solid">第二步：请输入以上密保卡对应的坐标数字，并绑定</h2>
                <table>
                  <tbody>
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
                <p><asp:Button ID="Button2" runat="server" Text="绑定密保卡" OnClick="BindPasswordCard" CssClass="ui-btn-1" /></p>
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

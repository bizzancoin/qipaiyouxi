<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AccountsScoreInfo.aspx.cs" Inherits="Game.Web.Module.AccountManager.AccountsScoreInfo" %>

<%@ Register Src="~/Themes/TabUser.ascx" TagPrefix="Fox" TagName="Tab" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="../../scripts/common.js"></script>

    <script type="text/javascript" src="../../scripts/jquery.js"></script>

</head>
<body>
    <!-- 头部菜单 Start -->
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="title">
        <tr>
            <td width="19" height="25" valign="top" class="Lpd10">
                <div class="arr">
                </div>
            </td>
            <td width="1232" height="25" valign="top" align="left">
                目前操作功能：用户信息
            </td>
        </tr>
    </table>
    <!-- 头部菜单 End -->
    <Fox:Tab ID="fab1" runat="server" NavActivated="D"></Fox:Tab>
    <form runat="server" id="form1">
    <table width="99%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="关闭" class="btn wd1" onclick="window.close();" />
            </td>
        </tr>
    </table>
    <table width="99%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                <div class="hg3  pd7">
                    积分信息</div>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                ID号码(GameID)：
            </td>
            <td>
                <span class="Rpd20 lan bold">
                    <asp:Literal ID="ltGameID" runat="server"></asp:Literal></span>
                帐号：
                <span class="Rpd20 lan bold">
                    <asp:Literal ID="ltAccounts" runat="server"></asp:Literal></span>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                游戏：
            </td>
            <td>
                <asp:DropDownList ID="ddlGame" runat="server" OnSelectedIndexChanged="ddlGame_SelectedIndexChanged" AutoPostBack="True">
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                积分：
            </td>
            <td>
                <asp:Literal ID="ltScore" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                赢局：
            </td>
            <td>
                <asp:Literal ID="ltWinCount" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                输局：
            </td>
            <td>
                <asp:Literal ID="ltLostCount" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                和局：
            </td>
            <td>
                <asp:Literal ID="ltDrawCount" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                逃局：
            </td>
            <td>
                <asp:Literal ID="ltFleeCount" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                <div class="hg3  pd7">
                    登录信息</div>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                登录房间次数：
            </td>
            <td>
                <asp:Literal ID="ltGameLogonTimes" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                在线时长（秒）：
            </td>
            <td>
                <asp:Literal ID="ltOnLineTimeCount" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                游戏时长（秒）：
            </td>
            <td>
                <asp:Literal ID="ltPlayTimeCount" runat="server"></asp:Literal>
                <span style="padding-left: 10px;"></span>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                登录房间时间：
            </td>
            <td>
                <asp:Literal ID="ltLastLogonDate" runat="server"></asp:Literal>&nbsp;&nbsp;
                <asp:Literal ID="ltLogonSpacingTime" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                登录地址：
            </td>
            <td>
                <asp:Literal ID="ltLastLogonIP" runat="server"></asp:Literal>&nbsp;&nbsp;
                <asp:Literal ID="ltLogonIPInfo" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                登录机器：
            </td>
            <td>
                <asp:Literal ID="ltLastLogonMachine" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                注册时间：
            </td>
            <td>
                <asp:Literal ID="ltRegisterDate" runat="server"></asp:Literal>&nbsp;&nbsp;
                <asp:Literal ID="ltRegSpacingTime" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                注册地址：
            </td>
            <td>
                <asp:Literal ID="ltRegisterIP" runat="server"></asp:Literal>&nbsp;&nbsp;
                <asp:Literal ID="ltRegIPInfo" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                注册机器：
            </td>
            <td>
                <asp:Literal ID="ltRegisterMachine" runat="server"></asp:Literal>
            </td>
        </tr>
    </table>
    <table width="99%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="关闭" class="btn wd1" onclick="window.close();" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

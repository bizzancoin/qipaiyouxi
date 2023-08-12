<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GrantScore.aspx.cs" Inherits="Game.Web.Module.AccountManager.GrantScore" %>

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
                目前操作功能：用户系统 - 赠送积分
            </td>
        </tr>
    </table>
    <!-- 头部菜单 End -->
    <form runat="server" id="form1">
    <table width="99%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="关闭" class="btn wd1" onclick="window.close();" />
                <asp:Button ID="btnSave" runat="server" Text="确认" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    <table width="99%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td class="listTdLeft">
                游戏：
            </td>
            <td>
                <asp:DropDownList ID="ddlGame" runat="server">
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                赠送积分：
            </td>
            <td>
                <asp:TextBox ID="txtScore" runat="server" CssClass="text wd4" MaxLength="9"></asp:TextBox>
                <asp:RequiredFieldValidator ID=RequiredFieldValidator1 runat="server" ErrorMessage="请输入赠送的游戏币数" ControlToValidate="txtScore"></asp:RequiredFieldValidator>
                <asp:RangeValidator ID=RangeValidator1 runat="server" ErrorMessage="只能为数字" Type="Integer" ControlToValidate="txtScore" MaximumValue="999999999" MinimumValue="-99999999"></asp:RangeValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                赠送原因：
            </td>
            <td>
                <asp:TextBox ID="txtReason" runat="server" TextMode="MultiLine" Height="50" Width="300"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td colspan="2">
            </td>
        </tr>
        <tr>
            <td colspan="2">
            </td>
        </tr>
    </table>
    <table width="99%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="关闭" class="btn wd1" onclick="window.close();" />
                <asp:Button ID="btnSave1" runat="server" Text="确认" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

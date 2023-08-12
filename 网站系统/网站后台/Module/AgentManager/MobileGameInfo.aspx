<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MobileGameInfo.aspx.cs" Inherits="Game.Web.Module.AgentManager.MobileGameInfo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="../../scripts/common.js"></script>

    <script type="text/javascript" src="../../scripts/jquery.js"></script>
    <script type="text/javascript" src="../../scripts/jquery.validate.js"></script>

    <script type="text/javascript" src="../../scripts/messages_cn.js"></script>

    <script type="text/javascript" src="../../scripts/jquery.metadata.js"></script>
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
                目前操作功能：代理系统 - 代理用户 - 手机游戏列表
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
                游戏列表：
            </td>
            <td>
                <asp:DropDownList ID="ddlKindID" runat="server" Width="158px">                
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                排序：
            </td>
            <td>
                <asp:TextBox ID="txtSortID" runat="server" CssClass="text wd4" MaxLength="16" onkeyup="if(isNaN(value))execCommand('undo');"></asp:TextBox>
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

    <script type="text/javascript">
        jQuery(document).ready(function () {
            jQuery.metadata.setType("attr", "validate");
            jQuery("#<%=form1.ClientID %>").validate();
    });
    </script>
    </form>
</body>
</html>

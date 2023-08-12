<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GameGameItemInfo.aspx.cs" Inherits="Game.Web.Module.AppManager.GameGameItemInfo" %>

<%@ Register Src="~/Themes/TabGame.ascx" TagPrefix="Fox" TagName="Tab" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="../../scripts/common.js"></script>

    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <!-- 头部菜单 Start -->
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="title">
        <tr>
            <td width="19" height="25" valign="top" class="Lpd10">
                <div class="arr">
                </div>
            </td>
            <td width="1232" height="25" valign="top" align="left">
                你当前位置：游戏系统 - 游戏管理
            </td>
        </tr>
    </table>
    <Fox:Tab ID="fab1" runat="server" NavActivated="A"></Fox:Tab>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="返回" class="btn wd1" onclick="Redirect('GameGameItemList.aspx')" />
                <input class="btnLine" type="button" />
                <asp:Button ID="btnSave" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                <div class="hg3  pd7">
                    <asp:Literal ID="litInfo" runat="server"></asp:Literal>模块信息</div>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                模块标识：
            </td>
            <td>
                <asp:TextBox ID="txtGameID" runat="server" CssClass="text" onkeyup="if(isNaN(value))execCommand('undo')" MaxLength="9"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                模块名称：
            </td>
            <td>
                <asp:TextBox ID="txtGameName" runat="server" CssClass="text" MaxLength="31"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                数据库名：
            </td>
            <td>
                <asp:TextBox ID="txtDataBaseName" runat="server" CssClass="text" MaxLength="31"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                数据库地址：
            </td>
            <td>
                <asp:DropDownList ID="ddlDataBaseAddr" runat="server" Width="158px">
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                服务端版本：
            </td>
            <td>
                <asp:TextBox ID="txtServerVersion" runat="server" CssClass="text" Text="0.0.0.0"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                客户端版本：
            </td>
            <td>
                <asp:TextBox ID="txtClientVersion" runat="server" CssClass="text" Text="0.0.0.0"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                服务端名称：
            </td>
            <td>
                <asp:TextBox ID="txtServerDLLName" runat="server" CssClass="text" MaxLength="32"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                客户端名称：
            </td>
            <td>
                <asp:TextBox ID="txtClientExeName" runat="server" CssClass="text" MaxLength="32"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                支持类型：
            </td>
            <td>
                <asp:CheckBoxList ID="chklSupporType" runat="server" RepeatDirection="Horizontal">
                </asp:CheckBoxList>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="返回" class="btn wd1" onclick="Redirect('GameGameItemList.aspx')" />
                <input class="btnLine" type="button" />
                <asp:Button ID="Button1" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

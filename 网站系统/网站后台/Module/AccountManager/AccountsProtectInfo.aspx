<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AccountsProtectInfo.aspx.cs" Inherits="Game.Web.Module.AccountManager.AccountsProtectInfo" %>

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
                目前操作功能：用户密码保护修改
            </td>
        </tr>
    </table>
    <!-- 头部菜单 End -->   

    <form name="form1" runat="server">
    <table width="99%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="关闭" class="btn wd1" onclick="window.close();" />
                <asp:Button ID="btnSave" runat="server" CssClass="btn wd2" Text="修改密保" OnClick="btnSave_Click" />
                <asp:Button ID="btnDel" runat="server" CssClass="btn wd2" Text="取消密保" OnClientClick="return confirm('确定要取消密码保护吗？')" OnClick="btnDel_Click" />
            </td>
        </tr>
    </table>
    <table width="99%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td class="listTdLeft">
                用户帐号：
            </td>
            <td>
                <asp:Literal ID="ltAccounts" runat="server"></asp:Literal>
            </td>
            <td class="listTdLeft">
                安全邮箱：
            </td>
            <td>
                <asp:TextBox ID="txtSafeEmail" runat="server" CssClass="text wd4" MaxLength="32"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                问题一：
            </td>
            <td>
            <asp:DropDownList ID="ddlQuestion1" runat="server"></asp:DropDownList>
                
            </td>
            <td class="listTdLeft">
                答案一：
            </td>
            <td>
                <asp:TextBox ID="txtResponse1" runat="server" CssClass="text wd4" MaxLength="30"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                问题二：
            </td>
            <td>
                   <asp:DropDownList ID="ddlQuestion2" runat="server"></asp:DropDownList>
            </td>
            <td class="listTdLeft">
                答案二：
            </td>
            <td>
                <asp:TextBox ID="txtResponse2" runat="server" CssClass="text wd4" MaxLength="30"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                问题三：
            </td>
            <td>
                    <asp:DropDownList ID="ddlQuestion3" runat="server"></asp:DropDownList>
            </td>
            <td class="listTdLeft">
                答案三：
            </td>
            <td>
                <asp:TextBox ID="txtResponse3" runat="server" CssClass="text wd4" MaxLength="30"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                证件类型：
            </td>
            <td>
                <asp:Literal ID="ltPassportType" runat="server"></asp:Literal>
            </td>
            <td class="listTdLeft">
                证件号码：
            </td>
            <td>
                <asp:Literal ID="ltPassportID" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                创建地址：
            </td>
            <td>
                <asp:Literal ID="ltCreateIP" runat="server"></asp:Literal>
            </td>
            <td class="listTdLeft">
                创建日期：
            </td>
            <td>
                <asp:Literal ID="ltCreateDate" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                最后修改地址：
            </td>
            <td>
                <asp:Literal ID="ltModifyIP" runat="server"></asp:Literal>
            </td>
            <td class="listTdLeft">
                最后修改日期：
            </td>
            <td>
                <asp:Literal ID="ltModifyDate" runat="server"></asp:Literal>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

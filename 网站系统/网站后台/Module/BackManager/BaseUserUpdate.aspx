<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BaseUserUpdate.aspx.cs" Inherits="Game.Web.Module.BackManager.BaseUserUpdate" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
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
            <td width="19" height="25" valign="top"  class="Lpd10"><div class="arr"></div></td>
            <td width="1232" height="25" valign="top" align="left">目前操作功能：管理员密码修改</td>
        </tr>
    </table>
    <!-- 头部菜单 End -->
    <table width="99%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="关闭" class="btn wd1" onclick="window.close()" />                
                <asp:Button ID="btnSave" runat="server" Text="保存" CssClass="btn wd1" 
                    onclick="btnSave_Click" />
            </td>
        </tr>
    </table>        
    <table width="99%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td class="listTdLeft">帐号：</td>
            <td> 
                <asp:Label ID="lblAccounts" runat="server" ForeColor="Blue"></asp:Label>     
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                权限组别：
            </td>
            <td>                
                <asp:Label ID="lblRoleID" runat="server"></asp:Label>     
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">原始密码：</td>
            <td>
                <asp:TextBox ID="txtOldLogonPass" runat="server" CssClass="text" TextMode="Password"></asp:TextBox>       
                <asp:HiddenField ID="hdfOldLogonPass" runat="server" />        
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">新密码：</td>
            <td> 
                <asp:TextBox ID="txtLogonPass" runat="server" CssClass="text" TextMode="Password"></asp:TextBox>              
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">确认新密码：</td>
            <td>      
                <asp:TextBox ID="txtConfirmLogonPass" runat="server" CssClass="text" TextMode="Password"></asp:TextBox>                      
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">登录次数：</td>
            <td>
                <asp:Label ID="lblLoginTimes" runat="server"></asp:Label>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">最后登录地址：</td>
            <td>
                <asp:Label ID="lblLastLogonIP" runat="server"></asp:Label>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">最后登录时间：</td>
            <td>
                <asp:Label ID="lblLastLogonDate" runat="server"></asp:Label>
            </td>
        </tr>
    </table>   
    </form>
</body>
</html>

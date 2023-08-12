<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AccountsControlInfo.aspx.cs" Inherits="Game.Web.Module.AccountManager.AccountsControlInfo" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link href="/styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/scripts/common.js"></script>
    <script type="text/javascript" src="/scripts/My97DatePicker/WdatePicker.js"></script>
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
                你当前位置：用户系统 - 用户控制配置
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td height="28">
                <ul>
                    <li class="tab2" onclick="Redirect('AccountsControlConfig.aspx')">控制配置</li>
                    <li class="tab1">黑白名单</li>
                     <li class="tab2" onclick="Redirect('AccountsControlRecord.aspx')">控制记录</li>
                </ul>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="返回" class="btn wd1" onclick="Redirect('AccountsControlList.aspx')" />
                <asp:Button ID="btnSave" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                <div class="hg3  pd7">
                    <asp:Literal ID="litInfo" runat="server"></asp:Literal>黑白名单</div>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                用户：
            </td>
            <td>
                 <asp:DropDownList ID="ddlAddType" runat="server">
                    <asp:ListItem Text="用户帐号" Value="0"></asp:ListItem>
                    <asp:ListItem Text="用户ID" Value="1"></asp:ListItem>
                </asp:DropDownList>
                <asp:TextBox ID="txtUser" runat="server" CssClass="text"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvUser" runat="server" ErrorMessage="请输入" ControlToValidate="txtUser" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                <asp:Label ID="lbUser" runat="server" Text=""></asp:Label>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                控制状态：
            </td>
            <td>
                <asp:DropDownList ID="ddlControlStatus" runat="server" Width="150">
                    <asp:ListItem Text="请选择" Value="0"></asp:ListItem>
                    <asp:ListItem Text="黑名单" Value="1"></asp:ListItem>
                    <asp:ListItem Text="白名单" Value="2"></asp:ListItem>
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                激活时间：
            </td>
            <td>
                 <asp:TextBox ID="txtActiveDateTime" runat="server" CssClass="text" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:ss:mm',mixDate:'%y-%M-%d'})"></asp:TextBox>
                 <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="请输入" ControlToValidate="txtActiveDateTime" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
            </td>
        </tr>
         <tr>
            <td class="listTdLeft">
                控制类型：
            </td>
            <td>
                <asp:DropDownList ID="ddlControlType" runat="server" Width="150">
                    <asp:ListItem Text="请选择" Value="0"></asp:ListItem>
                    <asp:ListItem Text="游戏币变化" Value="1"></asp:ListItem>
                    <asp:ListItem Text="持续时间" Value="2"></asp:ListItem>
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                退出名单输赢金币配置：
            </td>
            <td>
                <asp:TextBox ID="txtChangeScore" runat="server" CssClass="text" onkeyup="if(isNaN(value))execCommand('undo');" MaxLength="20" ></asp:TextBox> 游戏币
                <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ErrorMessage="请输入" ControlToValidate="txtChangeScore" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator6" runat="server" ErrorMessage="请输入正确的游戏币数" Display="Dynamic" ControlToValidate="txtChangeScore" ValidationExpression="^([0-9]){1,20}?$" ForeColor="Red"></asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                退出名单所需时间配置：
            </td>
            <td>
                <asp:TextBox ID="txtSustainedTimeCount" runat="server" CssClass="text" onkeyup="if(isNaN(value))execCommand('undo');" MaxLength="8" ></asp:TextBox> 秒
                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="请输入" ControlToValidate="txtSustainedTimeCount" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator5" runat="server" ErrorMessage="请输入正确的时长" Display="Dynamic" ControlToValidate="txtSustainedTimeCount" ValidationExpression="^([0-9]){1,8}?$" ForeColor="Red"></asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                胜率：
            </td>
            <td>
                <asp:TextBox ID="txtWinRate" runat="server" CssClass="text" onkeyup="if(isNaN(value))execCommand('undo');" MaxLength="3" ></asp:TextBox> %
                <asp:RequiredFieldValidator ID="RequiredFieldValidator11" runat="server" ErrorMessage="请输入" ControlToValidate="txtWinRate" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator11" runat="server" ErrorMessage="请输入正确的游戏币数" Display="Dynamic" ControlToValidate="txtWinRate" ValidationExpression="^([0-9]){1,3}?$" ForeColor="Red"></asp:RegularExpressionValidator>
                <asp:RangeValidator ID="RangeValidator1" runat="server" ErrorMessage="胜率为1%至100%之间" Type="Integer" MaximumValue="100" MinimumValue="1" ControlToValidate="txtWinRate"></asp:RangeValidator>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                 <input type="button" value="返回" class="btn wd1" onclick="Redirect('AccountsControlList.aspx')" />
                <asp:Button ID="Button1" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>
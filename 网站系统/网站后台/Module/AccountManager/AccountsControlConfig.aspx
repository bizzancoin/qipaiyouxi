<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AccountsControlConfig.aspx.cs" Inherits="Game.Web.Module.AccountManager.AccountsControlConfig" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link href="/styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/scripts/common.js"></script>
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
     <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="Tmg7">
        <tr>
            <td height="28">
                <ul>
                    <li class="tab1">控制配置</li>
                    <li class="tab2" onclick="Redirect('AccountsControlList.aspx')">控制列表</li>
                    <li class="tab2" onclick="Redirect('AccountsControlRecord.aspx')">控制记录</li>
                </ul>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <asp:Button ID="btnSave" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                <div class="hg3  pd7">
                    <asp:Literal ID="litInfo" runat="server"></asp:Literal>用户控制配置</div>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                是否允许自动控制：
            </td>
            <td>
                <asp:RadioButtonList ID="rblAutoControlEnable" runat="server" RepeatDirection="Horizontal">
                    <asp:ListItem Text="是" Value="1" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="否" Value="0"></asp:ListItem>
                </asp:RadioButtonList>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                赢多少自动加入黑名单：
            </td>
            <td>
                <asp:TextBox ID="txtJoinBlackWinScore" runat="server" CssClass="text" onkeyup="if(isNaN(value))execCommand('undo');" MaxLength="20" ></asp:TextBox> 游戏币
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="请输入" ControlToValidate="txtJoinBlackWinScore" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ErrorMessage="请输入正确的游戏币数" Display="Dynamic" ControlToValidate="txtJoinBlackWinScore" ValidationExpression="^([0-9]){1,9}?$" ForeColor="Red"></asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                输多少自动加入白名单：
            </td>
            <td>
                <asp:TextBox ID="txtJoinWhiteLoseScore" runat="server" CssClass="text" onkeyup="if(isNaN(value))execCommand('undo');" MaxLength="20" ></asp:TextBox> 游戏币
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="请输入" ControlToValidate="txtJoinWhiteLoseScore" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" ErrorMessage="请输入正确的游戏币数" Display="Dynamic" ControlToValidate="txtJoinWhiteLoseScore" ValidationExpression="^([0-9]){1,20}?$" ForeColor="Red"></asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                黑名单结束方式：
            </td>
            <td>
                <asp:DropDownList ID="ddlBlackControlType" runat="server" Width="150">
                    <asp:ListItem Text="请选择" Value="0"></asp:ListItem>
                    <asp:ListItem Text="累计输分" Value="1"></asp:ListItem>
                    <asp:ListItem Text="持续时间" Value="2"></asp:ListItem>
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                黑名单持续时间：
            </td>
            <td>
                <asp:TextBox ID="txtBSustainedTimeCount" runat="server" CssClass="text" onkeyup="if(isNaN(value))execCommand('undo');" MaxLength="8" ></asp:TextBox> 秒
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="请输入" ControlToValidate="txtBSustainedTimeCount" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="请输入正确的时长" Display="Dynamic" ControlToValidate="txtBSustainedTimeCount" ValidationExpression="^([0-9]){1,8}?$" ForeColor="Red"></asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                输多少分退出黑名单：
            </td>
            <td>
                <asp:TextBox ID="txtQuitBlackLoseScore" runat="server" CssClass="text" onkeyup="if(isNaN(value))execCommand('undo');" MaxLength="20" ></asp:TextBox> 游戏币
                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="请输入" ControlToValidate="txtQuitBlackLoseScore" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator4" runat="server" ErrorMessage="请输入正确的游戏币数" Display="Dynamic" ControlToValidate="txtQuitBlackLoseScore" ValidationExpression="^([0-9]){1,20}?$" ForeColor="Red"></asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                白名单结束方式：
            </td>
            <td>
                <asp:DropDownList ID="ddlWhiteControlType" runat="server" Width="150">
                    <asp:ListItem Text="请选择" Value="0"></asp:ListItem>
                    <asp:ListItem Text="累计赢分" Value="1"></asp:ListItem>
                    <asp:ListItem Text="持续时间" Value="2"></asp:ListItem>
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                白名单持续时间：
            </td>
            <td>
                <asp:TextBox ID="txtWSustainedTimeCount" runat="server" CssClass="text" onkeyup="if(isNaN(value))execCommand('undo');" MaxLength="8" ></asp:TextBox> 秒
                <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ErrorMessage="请输入" ControlToValidate="txtWSustainedTimeCount" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator8" runat="server" ErrorMessage="请输入正确的时长" Display="Dynamic" ControlToValidate="txtWSustainedTimeCount" ValidationExpression="^([0-9]){1,8}?$" ForeColor="Red"></asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                赢多少分退出白名单：
            </td>
            <td>
                <asp:TextBox ID="txtQuitWhiteWinScore" runat="server" CssClass="text" onkeyup="if(isNaN(value))execCommand('undo');" MaxLength="20" ></asp:TextBox> 游戏币
                <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ErrorMessage="请输入" ControlToValidate="txtQuitWhiteWinScore" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator9" runat="server" ErrorMessage="请输入正确的游戏币数" Display="Dynamic" ControlToValidate="txtQuitWhiteWinScore" ValidationExpression="^([0-9]){1,20}?$" ForeColor="Red"></asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                黑名单胜率：
            </td>
            <td>
                <asp:TextBox ID="txtBlackWinRate" runat="server" CssClass="text" onkeyup="if(isNaN(value))execCommand('undo');" MaxLength="3" ></asp:TextBox> %
                <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" ErrorMessage="请输入" ControlToValidate="txtBlackWinRate" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator10" runat="server" ErrorMessage="请输入正确的时长" Display="Dynamic" ControlToValidate="txtBlackWinRate" ValidationExpression="^([0-9]){1,3}?$" ForeColor="Red"></asp:RegularExpressionValidator>
                <asp:RangeValidator ID="RangeValidator2" runat="server" ErrorMessage="胜率为1%至100%之间" Type="Integer" MaximumValue="100" MinimumValue="1" ControlToValidate="txtBlackWinRate"></asp:RangeValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                白名单胜率：
            </td>
            <td>
                <asp:TextBox ID="txtWhiteWinRate" runat="server" CssClass="text" onkeyup="if(isNaN(value))execCommand('undo');" MaxLength="3" ></asp:TextBox> %
                <asp:RequiredFieldValidator ID="RequiredFieldValidator11" runat="server" ErrorMessage="请输入" ControlToValidate="txtWhiteWinRate" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator11" runat="server" ErrorMessage="请输入正确的游戏币数" Display="Dynamic" ControlToValidate="txtWhiteWinRate" ValidationExpression="^([0-9]){1,3}?$" ForeColor="Red"></asp:RegularExpressionValidator>
                <asp:RangeValidator ID="RangeValidator1" runat="server" ErrorMessage="胜率为1%至100%之间" Type="Integer" MaximumValue="100" MinimumValue="1" ControlToValidate="txtWhiteWinRate"></asp:RangeValidator>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <asp:Button ID="Button1" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

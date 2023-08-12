<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SigninConfig.aspx.cs" Inherits="Game.Web.Module.AppManager.SigninConfig" %>

<%@ Register Src="~/Themes/TabGame.ascx" TagPrefix="Fox" TagName="Tab" %>
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
                你当前位置：游戏系统 - 签到设置
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
                    <asp:Literal ID="litInfo" runat="server"></asp:Literal>签到奖励游戏币设置</div>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                第一天奖励：
            </td>
            <td>
                <asp:TextBox ID="txtGold1" runat="server" CssClass="text wd3" onkeyup="if(isNaN(value))execCommand('undo');" MaxLength="9" ></asp:TextBox> 游戏币
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="请输入第一天奖励" ControlToValidate="txtGold1" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="请输入正确的奖励额度，必须为整数" Display="Dynamic" ControlToValidate="txtGold1" ValidationExpression="^([0-9]){1,9}?$" ForeColor="Red"></asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                第二天奖励：
            </td>
            <td>
                <asp:TextBox ID="txtGold2" runat="server" CssClass="text wd3" onkeyup="if(isNaN(value))execCommand('undo');" MaxLength="9" ></asp:TextBox> 游戏币
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="请输入第二天奖励" ControlToValidate="txtGold2" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ErrorMessage="请输入正确的奖励额度，必须为整数" Display="Dynamic" ControlToValidate="txtGold2" ValidationExpression="^([0-9]){1,9}?$" ForeColor="Red"></asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                第三天奖励：
            </td>
            <td>
                <asp:TextBox ID="txtGold3" runat="server" CssClass="text wd3" onkeyup="if(isNaN(value))execCommand('undo');" MaxLength="9" ></asp:TextBox> 游戏币
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="请输入第三天奖励" ControlToValidate="txtGold3" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" ErrorMessage="请输入正确的奖励额度，必须为整数" Display="Dynamic" ControlToValidate="txtGold3" ValidationExpression="^([0-9]){1,9}?$" ForeColor="Red"></asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                第四天奖励：
            </td>
            <td>
                <asp:TextBox ID="txtGold4" runat="server" CssClass="text wd3" onkeyup="if(isNaN(value))execCommand('undo');" MaxLength="9" ></asp:TextBox> 游戏币
                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="请输入第四天奖励" ControlToValidate="txtGold4" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator4" runat="server" ErrorMessage="请输入正确的奖励额度，必须为整数" Display="Dynamic" ControlToValidate="txtGold4" ValidationExpression="^([0-9]){1,9}?$" ForeColor="Red"></asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                第五天奖励：
            </td>
            <td>
                <asp:TextBox ID="txtGold5" runat="server" CssClass="text wd3" onkeyup="if(isNaN(value))execCommand('undo');" MaxLength="9" ></asp:TextBox> 游戏币
                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="请输入第五天奖励" ControlToValidate="txtGold5" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator5" runat="server" ErrorMessage="请输入正确的奖励额度，必须为整数" Display="Dynamic" ControlToValidate="txtGold5" ValidationExpression="^([0-9]){1,9}?$" ForeColor="Red"></asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                第六天奖励：
            </td>
            <td>
                <asp:TextBox ID="txtGold6" runat="server" CssClass="text wd3" onkeyup="if(isNaN(value))execCommand('undo');" MaxLength="9" ></asp:TextBox> 游戏币
                <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ErrorMessage="请输入第六天奖励" ControlToValidate="txtGold6" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator6" runat="server" ErrorMessage="请输入正确的奖励额度，必须为整数" Display="Dynamic" ControlToValidate="txtGold6" ValidationExpression="^([0-9]){1,9}?$" ForeColor="Red"></asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                第七天奖励：
            </td>
            <td>
                <asp:TextBox ID="txtGold7" runat="server" CssClass="text wd3" onkeyup="if(isNaN(value))execCommand('undo');" MaxLength="9" ></asp:TextBox> 游戏币
                <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ErrorMessage="请输入第六天奖励" ControlToValidate="txtGold7" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator7" runat="server" ErrorMessage="请输入正确的奖励额度，必须为整数" Display="Dynamic" ControlToValidate="txtGold7" ValidationExpression="^([0-9]){1,9}?$" ForeColor="Red"></asp:RegularExpressionValidator>
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

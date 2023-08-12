<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GlobalLivcardInfo.aspx.cs" Inherits="Game.Web.Module.FilledManager.GlobalLivcardInfo" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="../../scripts/common.js"></script>

    <script type="text/javascript" src="../../scripts/comm.js"></script>

    <script type="text/javascript" src="../../scripts/jquery.js"></script>

    <script type="text/javascript" src="../../scripts/jquery.validate.js"></script>

    <script type="text/javascript" src="../../scripts/messages_cn.js"></script>

    <script type="text/javascript" src="../../scripts/jquery.metadata.js"></script>

    <script type="text/javascript">
        jQuery(document).ready(function() {
            jQuery.metadata.setType("attr", "validate");
            jQuery("#<%=form1.ClientID %>").validate();
        });
    </script>

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
                你当前位置：充值系统 - 实卡管理
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input id="btnReturn" type="button" value="返回" class="btn wd1" onclick="Redirect('GlobalLivcardList.aspx')" />
                <asp:Button ID="btnCreate" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                <div class="hg3  pd7">
                    实卡信息</div>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                会员卡名称：
            </td>
            <td>
                <asp:TextBox ID="txtCardTypeName" runat="server" CssClass="text" MaxLength="16"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                实卡RMB价格：
            </td>
            <td>
                <asp:TextBox ID="txtCardPrice" runat="server" CssClass="text" MaxLength="7" onkeyup="if(isNaN(value))execCommand('undo');"></asp:TextBox>&nbsp;元 (生成点卡时使用)
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                实卡游戏豆数：
            </td>
            <td>
                <asp:TextBox ID="txtCurrency" runat="server" CssClass="text" MaxLength="9"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="请输入游戏豆数" ControlToValidate="txtCurrency" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator10" runat="server" ErrorMessage="只能为整数或小数，且小数位最多为2位"
										ControlToValidate="txtCurrency" Display="Dynamic" ValidationExpression="[0-9]{1,9}(.\d{1,2})?" ForeColor="red"></asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                实卡游戏币数：
            </td>
            <td>
                <asp:TextBox ID="txtGold" runat="server" CssClass="text" MaxLength="8"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="请输入游戏币" ControlToValidate="txtGold" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="游戏币只能为整数"
										ControlToValidate="txtGold" Display="Dynamic" ValidationExpression="[0-9]{1,8}" ForeColor="red"></asp:RegularExpressionValidator>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input id="btnReturn2" type="button" value="返回" class="btn wd1" onclick="Redirect('GlobalLivcardList.aspx')" />
                <asp:Button ID="btnSave2" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

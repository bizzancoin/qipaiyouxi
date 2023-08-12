<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LivcardAssociatorInfo.aspx.cs" Inherits="Game.Web.Module.FilledManager.LivcardAssociatorInfo" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="../../scripts/common.js"></script>

    <script type="text/javascript" src="../../scripts/comm.js"></script>

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
                你当前位置：充值系统 - 实卡信息
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="关闭" class="btn wd1" onclick="javascript:window.close()" />
                 <input class="btnLine" type="button" />
                <asp:Button ID="btnDisable" runat="server" Text="禁用" CssClass="btn wd1" OnClick="btnDisable_Click"  />
                <asp:Button ID="btnEnable" runat="server" Text="启用" CssClass="btn wd1" OnClick="btnEnable_Click"  />
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                <div class="hg3  pd7">
                    基本信息</div>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                实卡卡号：
            </td>
            <td>
                <asp:Literal ID="ltSerialID" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                实卡名称：
            </td>
            <td>
                <asp:Literal ID="ltCardTypeName" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                生产批次：
            </td>
            <td>
                <asp:Literal ID="ltBuildID" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                实卡价格：
            </td>
            <td>
                <asp:Literal ID="ltCardPrice" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                实卡游戏豆：
            </td>
            <td>
                <asp:Literal ID="ltCurrency" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                实卡游戏币：
            </td>
            <td>
                <asp:Literal ID="ltGold" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                使用范围：
            </td>
            <td>
                <asp:Literal ID="ltUseRange" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                销售商：
            </td>
            <td>
                <asp:Literal ID="ltSalesPerson" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                禁用状态：
            </td>
            <td>
                <asp:Literal ID="ltNullity" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                生成日期：
            </td>
            <td>
                <asp:Literal ID="ltBuildDate" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                有效日期：
            </td>
            <td>
                <asp:Literal ID="ltValidDate" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                <div class="hg3  pd7">
                    <asp:Literal ID=lbPayCardMsg runat="server" Text="充值信息不存在"></asp:Literal></div>
            </td>
        </tr>
        <asp:Panel ID=plPyaCard runat="server" Visible="false">
        <tr>
            <td class="listTdLeft">
                充值日期：
            </td>
            <td>
                <asp:Literal ID="ltPayDate" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                帐号(游戏ID)：
            </td>
            <td>
                <asp:Literal ID="ltPayUser" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                操作用户：
            </td>
            <td>
                <asp:Literal ID="ltPayOperUser" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                充值前游戏豆：
            </td>
            <td>
                <asp:Literal ID="ltPayBeforeCurrency" runat="server"></asp:Literal>
            </td>
        </tr>
         <tr>
            <td class="listTdLeft">
                充值地址：
            </td>
            <td>
                <asp:Literal ID="ltPayAddress" runat="server"></asp:Literal>
            </td>
        </tr>
        </asp:Panel>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="关闭" class="btn wd1" onclick="javascript:window.close()" />
                 <input class="btnLine" type="button" />
                <asp:Button ID="btnDisable2" runat="server" Text="禁用" CssClass="btn wd1" OnClick="btnDisable_Click"  />
                <asp:Button ID="btnEnable2" runat="server" Text="启用" CssClass="btn wd1" OnClick="btnEnable_Click"  />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

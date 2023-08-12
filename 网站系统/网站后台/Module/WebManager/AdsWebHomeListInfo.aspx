<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdsWebHomeListInfo.aspx.cs" Inherits="Game.Web.Module.WebManager.AdsWebHomeListInfo" %>

<%@ Register Src="/Tools/ImageUploader.ascx" TagName="ImageUploader" TagPrefix="GameImg" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/scripts/common.js"></script>
    <script type="text/javascript" src="/scripts/comm.js"></script>
    <script type="text/javascript" src="/scripts/jquery.js"></script>
    <script type="text/javascript" src="/scripts/jquery.validate.js"></script>
    <script type="text/javascript" src="/scripts/messages_cn.js"></script>
    <script type="text/javascript" src="/scripts/jquery.metadata.js"></script>
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
                你当前位置：网站系统 - 网站首页广告
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input id="btnReturn" type="button" value="返回" class="btn wd1" onclick="Redirect('AdsWebHomeList.aspx')" />
                <asp:Button ID="btnCreate" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                <div class="hg3 pd7">
                    网站首页广告</div>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                广告标题：
            </td>
            <td>
                <asp:TextBox ID="txtTitle" runat="server" CssClass="text wd5" MaxLength="200" Width="200"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="请输入广告标题" ControlToValidate="txtTitle" Display="Dynamic"></asp:RequiredFieldValidator>
            </td>
        </tr>
         <tr>
            <td class="listTdLeft">
               排序ID：
            </td>
            <td>
                <asp:TextBox ID="txtSortID" runat="server" CssClass="text" MaxLength="9" Width="200" Text="0"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="请输入排序ID" ControlToValidate="txtSortID" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator10" runat="server" ErrorMessage="只能为整数" ControlToValidate="txtSortID" Display="Dynamic" ValidationExpression="[0-9]{1,9}" ForeColor="red"></asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
               广告链接地址：
            </td>
            <td>
                <asp:TextBox ID="txtLinkURL" runat="server" CssClass="text" MaxLength="500" Width="200"></asp:TextBox>&nbsp;
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                广告图片[705*234]：
            </td>
            <td style="line-height:35px;">
                <GameImg:ImageUploader ID="upImage" runat="server" DeleteButtonClass="l2" DeleteButtonText="删除" Folder="/Upload/Ads" ViewButtonClass="l2" ViewButtonText="查看" TextBoxClass="text"/> <span>[尺寸：705*234 体积：不大于1M]</span>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
               广告备注：
            </td>
            <td>
               <asp:TextBox ID="txtRemark" runat="server" CssClass="text" TextMode="MultiLine" Height="150" Width="200"></asp:TextBox>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input id="btnReturn2" type="button" value="返回" class="btn wd1" onclick="Redirect('AdsWebHomeList.aspx')" />
                <asp:Button ID="btnSave2" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>
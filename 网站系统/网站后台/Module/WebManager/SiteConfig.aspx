<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SiteConfig.aspx.cs" Inherits="Game.Web.Module.AppManager.SiteConfig" %>

<%@ Register Src="~/Themes/TabSiteConfig.ascx" TagName="Config" TagPrefix="qp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="/styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/scripts/common.js"></script>
    <script type="text/javascript" src="/scripts/jquery.js"></script>
    <script type="text/javascript" src="/scripts/kindEditor/kindeditor.js"></script>
    <script type="text/javascript">
        KE.show({
            id: 'txtField8',
            imageUploadJson: '/Tools/KindEditorUpload.ashx?type=Config',
            fileManagerJson: '/Tools/KindEditorFileManager.ashx?type=config',
            allowFileManager: true
        });
    </script> 
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="title">
        <tr>
            <td width="19" height="25" valign="top" class="Lpd10">
                <div class="arr">
                </div>
            </td>
            <td width="1232" height="25" valign="top" align="left">
                你当前位置：网站系统 - 站点设置
            </td>
        </tr>
    </table>
    <qp:Config runat="server" ID="config"></qp:Config>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td class="listTdLeft">
                键名：
            </td>
            <td>
                <asp:TextBox ID="txtConfigKey" runat="server" CssClass="text" ReadOnly="true" Width="250"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                名称：
            </td>
            <td>
                <asp:TextBox ID="txtConfigName" runat="server" CssClass="text" ReadOnly="true" Width="250"></asp:TextBox>&nbsp;&nbsp;&nbsp;
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                字段说明：
            </td>
            <td>
                <asp:TextBox ID="txtConfigString" runat="server" CssClass="text" TextMode="MultiLine" Width="250" Height="80"></asp:TextBox>&nbsp;&nbsp;&nbsp;
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                字段1：
            </td>
            <td>
                <asp:TextBox ID="txtField1" runat="server" CssClass="text" Width="250"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                字段2：
            </td>
            <td>
                <asp:TextBox ID="txtField2" runat="server" CssClass="text" Width="250"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                字段3：
            </td>
            <td>
                <asp:TextBox ID="txtField3" runat="server" CssClass="text" Width="250"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                字段4：
            </td>
            <td>
                <asp:TextBox ID="txtField4" runat="server" CssClass="text" Width="250"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                字段5：
            </td>
            <td>
                <asp:TextBox ID="txtField5" runat="server" CssClass="text" Width="250"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                字段6：
            </td>
            <td>
                <asp:TextBox ID="txtField6" runat="server" CssClass="text" Width="250"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                字段7：
            </td>
            <td>
                <asp:TextBox ID="txtField7" runat="server" CssClass="text" Width="250"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                字段8：
            </td>
            <td>
                <asp:TextBox ID="txtField8" runat="server" CssClass="text" Width="530px" Height="200px" TextMode="MultiLine"></asp:TextBox>  
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

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LogoSet.aspx.cs" Inherits="Game.Web.Module.WebManager.LogoSet" %>

<%@ Register Src="~/Themes/TabSiteConfig.ascx" TagName="Config" TagPrefix="qp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
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
                网站前台LOGO：
            </td>
            <td>
               <asp:FileUpload ID="fuLogo" runat="server" />
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
            </td>
            <td>
               <img src="/Upload/Site/logo.png"/>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                网站后台LOGO：
            </td>
            <td>
                <asp:FileUpload ID="fuAdminLogo" runat="server" />
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
            </td>
            <td>
               <img src="/Upload/Site/AdminLogo.png"/>
            </td>
        </tr>
          <tr>
            <td class="listTdLeft">
                移动版网站LOGO：
            </td>
            <td>
                <asp:FileUpload ID="fuMobileLogo" runat="server" />
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
            </td>
            <td>
               <img src="/Upload/Site/MobileLogo.png"/>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                移动版网站背景：
            </td>
            <td>
                <asp:FileUpload ID="fuMobileBg" runat="server" />
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
            </td>
            <td>
               <img src="/Upload/Site/MobileBg.png"/>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                移动版网站下载按钮：
            </td>
            <td>
                <asp:FileUpload ID="fuMobileDownLad" runat="server" />
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
            </td>
            <td>
               <img src="/Upload/Site/MobileDownLad.png"/>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                移动版注册网站LOGO：
            </td>
            <td>
                <asp:FileUpload ID="fuMobileRegLogo" runat="server" />
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
            </td>
            <td>
               <img src="/Upload/Site/MobileRegLogo.png"/>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                移动版广告图：
            </td>
            <td>
                <asp:FileUpload ID="fuAdsMobileAlert" runat="server" />
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
            </td>
            <td>
               <img src="/Upload/Site/AdsMobileAlert.png"/>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                PC版广告图：
            </td>
            <td>
                <asp:FileUpload ID="fuAdsPCAlert" runat="server" />
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
            </td>
            <td>
               <img src="/Upload/Site/AdsPCAlert.png"/>
            </td>
        </tr>
        <tr>
            <td style="height:10px;">
                &nbsp;
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

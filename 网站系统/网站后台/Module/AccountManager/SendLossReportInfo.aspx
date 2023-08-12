<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SendLossReportInfo.aspx.cs" Inherits="Game.Web.Module.AccountManager.SendLossReportInfo" ValidateRequest="false"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="/styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/scripts/common.js"></script>
    <script type="text/javascript" src="/scripts/jquery.js"></script>
    <script type="text/javascript" src="/scripts/kindEditor/kindeditor.js"></script>
    <script type="text/javascript">
         KE.show({
             id: 'txtContent',
             imageUploadJson: '/Tools/KindEditorUpload.ashx?type=news',
             fileManagerJson: '/Tools/KindEditorFileManager.ashx?type=news',
             allowFileManager: true
         });
    </script>
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
                目前操作功能：用户系统 - 发送申诉失败邮件
            </td>
        </tr>
    </table>
    <!-- 头部菜单 End -->
    <form runat="server" id="form1">
    <table width="99%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="关闭" class="btn wd1" onclick="window.close();" />
                <asp:Button ID="btnSave" runat="server" Text="发送失败邮件" CssClass="btn wd3" OnClick="btnSend_Click" />
            </td>
        </tr>
    </table>
    <table width="99%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td class="listTdLeft">
                收件人：
            </td>
            <td>
                  <asp:TextBox ID="txtReceive" CssClass="text" runat="server"></asp:TextBox>
                   &nbsp;<span class="hong">*</span>
                  <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ControlToValidate="txtReceive" ForeColor="Red" runat="server" ErrorMessage="请输入收件人"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                失败原因：
            </td>
            <td>
                 <asp:TextBox ID="txtContent" runat="server" TextMode="MultiLine" Height="350px" Width="550"></asp:TextBox>
            </td>
        </tr>
    </table>
    <table width="99%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="关闭" class="btn wd1" onclick="window.close();" />
                <asp:Button ID="btnSave1" runat="server" Text="发送失败邮件" CssClass="btn wd3" OnClick="btnSend_Click" OnClientClick="return confirm('确定发送申诉失败邮件吗？');"/>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

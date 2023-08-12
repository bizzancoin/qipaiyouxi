<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LivcardEdit.aspx.cs" Inherits="Game.Web.Module.FilledManager.LivcardEdit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id=Head1 runat="server">
    <title></title>
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../../scripts/common.js"></script>
    <script type="text/javascript" src="../../scripts/jquery.js"></script>
    <script type="text/javascript" src="../../scripts/My97DatePicker/WdatePicker.js"></script>
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
                目前操作功能：充值系统 - 批量修改实物卡
            </td>
        </tr>
    </table>
    <!-- 头部菜单 End -->
    <form runat="server" id="form1">
    <table width="99%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="关闭" class="btn wd1" onclick="window.close();" />
                <asp:Button ID="btnSave" runat="server" Text="确认" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    <table width="99%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
         <tr>
            <td class="listTdLeft">
                有效期：
            </td>
            <td>
               <asp:TextBox ID="txtEnjoinOverDate" runat="server" CssClass="text wd2" onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd HH:mm:ss'})" Width="150px"></asp:TextBox>
               <img src="../../Images/btn_calendar.gif" onclick="WdatePicker({el:'txtEnjoinOverDate',skin:'whyGreen',dateFmt:'yyyy-MM-dd HH:mm:ss'})" style="cursor: pointer; vertical-align: middle" /> 
               <span style="color:Red;">不修改留空</span> 
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                密码：
            </td>
            <td>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="text wd4"></asp:TextBox> <span style="color:Red;">不修改留空</span> 
            </td>
        </tr>
        <tr>
            <td colspan="2">
            </td>
        </tr>
    </table>
    <table width="99%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="关闭" class="btn wd1" onclick="window.close();" />
                <asp:Button ID="btnSave1" runat="server" Text="确认" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

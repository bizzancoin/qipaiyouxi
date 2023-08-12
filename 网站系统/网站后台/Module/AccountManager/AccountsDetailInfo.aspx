<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AccountsDetailInfo.aspx.cs" Inherits="Game.Web.Module.AccountManager.AccountsDetailInfo" %>

<%@ Register Src="~/Themes/TabUser.ascx" TagPrefix="Fox" TagName="Tab" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="../../scripts/common.js"></script>

    <script type="text/javascript" src="../../scripts/jquery.js"></script>

    <script type="text/javascript" src="../../scripts/jquery.validate.js"></script>

    <script type="text/javascript" src="../../scripts/messages_cn.js"></script>

    <script type="text/javascript" src="../../scripts/jquery.metadata.js"></script>

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
                目前操作功能：用户信息
            </td>
        </tr>
    </table>
    <!-- 头部菜单 End -->
    <Fox:Tab ID="fab1" runat="server" NavActivated="B"></Fox:Tab>
    <form runat="server" id="form1">
    <table width="99%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="关闭" class="btn wd1" onclick="window.close();" />
                <asp:Button ID="btnSave" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    <table width="99%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                <div class="hg3  pd7">
                    详细信息</div>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                ID号码(GameID)：
            </td>
            <td>
             <span class="Rpd20 lan bold"><asp:Literal ID="ltGameID" runat="server"></asp:Literal></span>
                帐号：
                <span class="Rpd20 lan bold"><asp:Literal ID="ltAccounts" runat="server"></asp:Literal></span>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                身份证号码：
            </td>
            <td>
               <asp:Literal ID="ltCardNum" runat="server" Text="未填写"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                真实姓名：
            </td>
            <td>
                <asp:Literal ID="ltName" runat="server" Text="未填写"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                QQ号码：
            </td>
            <td>
                <asp:TextBox ID="txtQQ" runat="server" CssClass="text wd4" MaxLength="16" onkeyup="if(isNaN(value))execCommand('undo');"></asp:TextBox>&nbsp;QQ字符长度不可超过16个字符
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                电子邮箱：
            </td>
            <td>
                <asp:TextBox ID="txtEMail" runat="server" CssClass="text wd4" MaxLength="32" validate="{email:true}"></asp:TextBox>&nbsp;电子邮箱字符长度不可超过32个字符
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                固定电话：
            </td>
            <td>
                <asp:TextBox ID="txtSeatPhone" runat="server" CssClass="text wd4" MaxLength="32" onkeyup="if(isNaN(value))execCommand('undo');"></asp:TextBox>&nbsp;固定电话字符长度不可超过32个字符
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                手机号码：
            </td>
            <td>
                <asp:TextBox ID="txtMobilePhone" runat="server" CssClass="text wd4" MaxLength="16" onkeyup="if(isNaN(value))execCommand('undo');"></asp:TextBox>&nbsp;手机号码字符长度不可超过16个字符
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                邮政编码：
            </td>
            <td>
                <asp:TextBox ID="txtPostalCode" runat="server" CssClass="text wd4" MaxLength="8" onkeyup="if(isNaN(value))execCommand('undo');"></asp:TextBox>&nbsp;邮政编码字符长度不可超过8个字符
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                居住地址：
            </td>
            <td>
                <asp:TextBox ID="txtDwellingPlace" runat="server" CssClass="text wd4" Style="width: 500px" MaxLength="128"></asp:TextBox>&nbsp;长度不可超过128个字符
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                用户备注：
            </td>
            <td>
                <asp:TextBox ID="txtUserNote" runat="server" CssClass="text wd4" Style="width: 500px" MaxLength="256"></asp:TextBox>&nbsp;长度不可超过256个字符
            </td>
        </tr>
    </table>
    <table width="99%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="关闭" class="btn wd1" onclick="window.close();" />
                <asp:Button ID="btnSave1" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

<script type="text/javascript">
    jQuery(document).ready(function() {
        jQuery.metadata.setType("attr", "validate");
        jQuery("#<%=form1.ClientID %>").validate();
    });
</script>


<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ConfineAddressInfo.aspx.cs" Inherits="Game.Web.Module.AccountManager.ConfineAddressInfo" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="../../scripts/common.js"></script>

    <script type="text/javascript" src="../../scripts/My97DatePicker/WdatePicker.js"></script>

    <script type="text/javascript" src="../../scripts/jquery.js"></script>

    <script type="text/javascript" src="../../scripts/jquery.validate.js"></script>

    <script type="text/javascript" src="../../scripts/messages_cn.js"></script>

    <script type="text/javascript" src="../../scripts/jquery.metadata.js"></script>

    <script type="text/javascript">
        /*
            jQuery(document).ready(function() {
            jQuery.metadata.setType("attr", "validate");
            jQuery.validator.addMethod("ip", function(value, element) {
            var ip = /"^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$/;
            return ip.test(value) || this.optional(element);
            }, " IP地址格式有误");
            jQuery("#<%=form1.ClientID %>").validate();
            });
        */
    </script>

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
                你当前位置：用户系统 - 限制IP地址
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="返回" class="btn wd1" onclick="Redirect('ConfineAddressList.aspx')" />
                <input class="btnLine" type="button" />
                <asp:Button ID="btnSave" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                <div class="hg3  pd7">限制地址信息</div>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                限制IP地址：
            </td>
            <td>
                <asp:Literal ID="ltString" runat="server"></asp:Literal>
                <asp:TextBox ID="txtString" runat="server" CssClass="text" MaxLength="15" validate="{required:true,ip:true}"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                选项：
            </td>
            <td>
                <asp:CheckBox ID="ckbEnjoinLogon" runat="server" Text="限制登录" />&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:CheckBox ID="ckbEnjoinRegister" runat="server" Text="限制注册" />
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                失效时间：
            </td>
            <td>
                <asp:TextBox ID="txtEnjoinOverDate" runat="server" CssClass="text wd2" onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd',minDate:'%y-%M-%d'})"></asp:TextBox><img
                    src="../../Images/btn_calendar.gif" onclick="WdatePicker({el:'txtEnjoinOverDate',skin:'whyGreen',dateFmt:'yyyy-MM-dd',minDate:'%y-%M-%d'})"
                    style="cursor: pointer; vertical-align: middle" />
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                警告：
            </td>
            <td>
                <span class="hong">失效时间不填写，则默认为永久限制</span>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                备注：
            </td>
            <td>
                <asp:TextBox ID="txtCollectNote" runat="server" CssClass="text" MaxLength="32" Style="width: 500px;"></asp:TextBox>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="返回" class="btn wd1" onclick="Redirect('ConfineAddressList.aspx')" />
                <input class="btnLine" type="button" />
                <asp:Button ID="btnSave1" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

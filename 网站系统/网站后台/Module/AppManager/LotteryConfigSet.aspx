<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LotteryConfigSet.aspx.cs" Inherits="Game.Web.Module.AppManager.LotteryConfigSet" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="/styles/layout.css" rel="stylesheet" type="text/css" />
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
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="title">
        <tr>
            <td width="19" height="25" valign="top" class="Lpd10">
                <div class="arr">
                </div>
            </td>
            <td width="1232" height="25" valign="top" align="left">
                你当前位置：系统维护 - 转盘管理
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="Tmg7">
        <tr>
            <td height="28">
                <ul>
                    <li class="tab1">转盘配置</li>
                    <li class="tab2" onclick="Redirect('LotteryItemSet.aspx')">奖品配置</li>
                    <li class="tab2" onclick="Redirect('LotteryRecord.aspx')">抽奖明细</li>
                </ul>
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
            <td class="listTdLeft">
                <label class="hong">* </label>每日免费次数：
            </td>
            <td>
                <asp:TextBox ID="txtFreeCount" runat="server" CssClass="text" validate="{required:true,digits:true}" onkeyup="if(isNaN(value))execCommand('undo');"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                <label class="hong">* </label>付费金额：
            </td>
            <td>
                <asp:TextBox ID="txtChargeFee" runat="server" CssClass="text" validate="{required:true,digits:true}" onkeyup="if(isNaN(value))execCommand('undo');" MaxLength="10"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                是否付费抽奖：
            </td>
            <td>
                <asp:CheckBox ID="cbIsCharge" runat="server" Text="允许付费" />
            </td>
        </tr>        
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
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
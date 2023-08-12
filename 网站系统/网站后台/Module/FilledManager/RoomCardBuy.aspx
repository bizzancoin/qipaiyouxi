<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RoomCardBuy.aspx.cs" Inherits="Game.Web.Module.FilledManager.RoomCardBuy" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="../../scripts/common.js"></script>

    <script type="text/javascript" src="../../scripts/comm.js"></script>

    <script type="text/javascript" src="../../scripts/jquery.js"></script>

    <script type="text/javascript" src="../../scripts/jquery.validate.js"></script>

    <script type="text/javascript" src="../../scripts/messages_cn.js"></script>

    <script type="text/javascript" src="../../scripts/jquery.metadata.js"></script>

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
                你当前位置：充值系统 - 充值配置
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="Tmg7">
        <tr>
            <td height="28">
                <ul>
                    <li class="tab2" onclick="Redirect('PayConfigList.aspx')">网站支付</li>
                    <li class="tab2" onclick="Redirect('OrderAppProductList.aspx')">手机支付</li>
                    <li class="tab1">代理房卡购买</li>
                </ul>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input id="btnReturn" type="button" value="返回" class="btn wd1" onclick="Redirect('RoomCardBuyList.aspx')" />
                <asp:Button ID="btnCreate" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                <div class="hg3  pd7">
                    房卡信息</div>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                房卡数：
            </td>
            <td>
                <asp:TextBox ID="txtRoomCard" runat="server" CssClass="text" validate="{required:true}" onkeyup="if(isNaN(value))execCommand('undo');"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                支付游戏豆：
            </td>
            <td>
                <asp:TextBox ID="txtCurrency" runat="server" CssClass="text" validate="{required:true}" onkeyup="if(isNaN(value))execCommand('undo');"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                支付金额：
            </td>
            <td>
                <asp:TextBox ID="txtAmount" runat="server" CssClass="text" validate="{required:true}" onkeyup="if(isNaN(value))execCommand('undo');"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                排序标识：
            </td>
            <td>
                <asp:TextBox ID="txtSortID" runat="server" CssClass="text" validate="{required:true}" onkeyup="if(isNaN(value))execCommand('undo');"></asp:TextBox>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input id="btnReturn2" type="button" value="返回" class="btn wd1" onclick="Redirect('RoomCardBuyList.aspx')" />
                <asp:Button ID="btnSave2" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
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

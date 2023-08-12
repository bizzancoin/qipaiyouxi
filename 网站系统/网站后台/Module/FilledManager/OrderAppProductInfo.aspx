<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OrderAppProductInfo.aspx.cs" Inherits="Game.Web.Module.FilledManager.OrderAppProductInfo" %>

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
                你当前位置：充值系统 - 手机支付
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input id="btnReturn" type="button" value="返回" class="btn wd1" onclick="Redirect('OrderAppProductList.aspx')" />
                <asp:Button ID="btnCreate" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                <div class="hg3  pd7">
                    产品信息</div>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                产品设备：
            </td>
            <td>
                <asp:DropDownList ID="ddlDevice" runat="server" Width="157px" Height="23px" CssClass="text">
                    <asp:ListItem Text="安卓产品" Value="0"></asp:ListItem>
                    <asp:ListItem Text="苹果产品" Value="1"></asp:ListItem>
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                产品编号：
            </td>
            <td>
                <asp:TextBox ID="txtProductID" runat="server" CssClass="text" validate="{required:true}"></asp:TextBox>
                &nbsp;<span class="hong">苹果充值设置为product_id</span>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                产品名称：
            </td>
            <td>
                <asp:TextBox ID="txtProductName" runat="server" CssClass="text" validate="{required:true}"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                产品描述：
            </td>
            <td>
                <asp:TextBox ID="txtDescription" runat="server" CssClass="text" validate="{required:true}"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                产品价格：
            </td>
            <td>
                <asp:TextBox ID="txtPrice" runat="server" CssClass="text" validate="{required:true}" onkeyup="if(isNaN(value))execCommand('undo');"></asp:TextBox>
            </td>
        </tr>      
        <tr>
            <td class="listTdLeft">
                赠送游戏豆：
            </td>
            <td>
                <asp:TextBox ID="txtCurrency" runat="server" CssClass="text" validate="{required:true}" onkeyup="if(isNaN(value))execCommand('undo');"></asp:TextBox>
            </td>
        </tr>  
        <tr>
            <td class="listTdLeft">
                首充奖励：
            </td>
            <td>
                <asp:CheckBox ID="cbFirst" runat="server" />
                <asp:TextBox ID="txtAttachCurrency" runat="server" CssClass="text" onkeyup="if(isNaN(value))execCommand('undo');" Width="124px"></asp:TextBox>
            </td>
        </tr>  
        <tr>
            <td class="listTdLeft">
                排序标识：
            </td>
            <td>
                <asp:TextBox ID="txtSortID" runat="server" CssClass="text" validate="{required:true}"></asp:TextBox>
            </td>
        </tr>   
        <tr id="txtDate" runat="server">
            <td class="listTdLeft">
                创建日期：
            </td>
            <td>
                <asp:Label ID="lblCollectDate" runat="server"></asp:Label>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input id="btnReturn2" type="button" value="返回" class="btn wd1" onclick="Redirect('OrderAppProductList.aspx')" />
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

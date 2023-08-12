<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MemberTypeInfo.aspx.cs" Inherits="Game.Web.Module.FilledManager.MemberTypeInfo" %>

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
    <script type="text/javascript">
        jQuery(document).ready(function() {
            jQuery.metadata.setType("attr", "validate");
            jQuery("#<%=form1.ClientID %>").validate();
        });
    </script>
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
                你当前位置：充值系统 - 会员类型管理
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input id="btnReturn" type="button" value="返回" class="btn wd1" onclick="Redirect('MemberTypeList.aspx')" />
                <asp:Button ID="btnCreate" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                <div class="hg3  pd7">
                    会员卡信息</div>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                会员名称：
            </td>
            <td>
                <asp:Label ID="lbCardName" runat="server" Text=""></asp:Label>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                任务奖励：
            </td>
            <td>
                <asp:TextBox ID="txtTaskRate" runat="server" CssClass="text" MaxLength="9"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="请输入任务奖励" ControlToValidate="txtTaskRate" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="只能为整数"
										ControlToValidate="txtTaskRate" Display="Dynamic" ValidationExpression="[0-9]{1,9}" ForeColor="red"></asp:RegularExpressionValidator>
                <span class="lan">会员完成任务额外奖励（百分比）</span>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                商城折扣：
            </td>
            <td>
                <asp:TextBox ID="txtShopRate" runat="server" CssClass="text" MaxLength="9"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="请输入商城折扣" ControlToValidate="txtShopRate" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ErrorMessage="只能为整数"
										ControlToValidate="txtShopRate" Display="Dynamic" ValidationExpression="[0-9]{1,9}" ForeColor="red"></asp:RegularExpressionValidator>
                <span class="lan">会员购买道具礼物可享有优惠。（百分比）</span>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                转账费率：
            </td>
            <td>
                <asp:TextBox ID="txtInsureRate" runat="server" CssClass="text" MaxLength="9"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="请输入转账费率" ControlToValidate="txtInsureRate" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" ErrorMessage="只能为整数"
										ControlToValidate="txtInsureRate" Display="Dynamic" ValidationExpression="[0-9]{1,9}" ForeColor="red"></asp:RegularExpressionValidator>
                <span class="lan">会员转帐手续费不同。（千分比）</span>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                每日送金：
            </td>
            <td>
                <asp:TextBox ID="txtPresentScore" runat="server" CssClass="text" MaxLength="9"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="请输入每日送金" ControlToValidate="txtPresentScore" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator10" runat="server" ErrorMessage="只能为整数"
										ControlToValidate="txtPresentScore" Display="Dynamic" ValidationExpression="[0-9]{1,9}" ForeColor="red"></asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                登录礼包：
            </td>
            <td>
                <asp:DropDownList ID="ddlDayGiftID" runat="server"></asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                会员权限：
            </td>
            <td>
                <asp:CheckBoxList ID="ckbUserRight" runat="server" RepeatDirection="Horizontal" RepeatColumns="6">
                </asp:CheckBoxList>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
            </td>
            <td class="hong">
                注意：修改成功后游戏中生效的时间为20分钟
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input id="btnReturn2" type="button" value="返回" class="btn wd1" onclick="Redirect('MemberTypeList.aspx')" />
                <asp:Button ID="btnSave2" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

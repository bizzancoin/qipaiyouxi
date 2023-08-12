<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SpreadSet.aspx.cs" Inherits="Game.Web.Module.AppManager.SpreadSet" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
                你当前位置：系统维护 - 推广管理
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="Tmg7">
        <tr>
            <td height="28">
                <ul>
                    <li class="tab1">推广管理</li>
                    <li class="tab2" onclick="Redirect('SpreadManager.aspx')">推广明细</li>
                    <li class="tab2" onclick="Redirect('FinanceInfo.aspx')">财务明细</li>
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
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                <div class="hg3  pd7">
                    注册赠送</div>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                游戏币：
            </td>
            <td>
                <asp:TextBox ID="txtRegGrantScore" runat="server" CssClass="text" onkeyup="if(isNaN(value))execCommand('undo');" MaxLength="10"></asp:TextBox>
                 &nbsp;
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="请填写" ControlToValidate="txtRegGrantScore" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RangeValidator ID="RangeValidator1" runat="server" ErrorMessage="只能填写数字，范围为0-2147483647" ControlToValidate="txtRegGrantScore" MinimumValue="0" MaximumValue="2147483647" Type="Integer" Display="Dynamic" ></asp:RangeValidator>
            </td>
        </tr>
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                <div class="hg3  pd7">
                    游戏时长赠送（属于一次性赠送，推荐设置108000）</div>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                时长（秒）：
            </td>
            <td>
                <asp:TextBox ID="txtPlayTimeCount" runat="server" CssClass="text" onkeyup="if(isNaN(value))execCommand('undo');" MaxLength="10"></asp:TextBox>(单位:秒)
                 &nbsp;
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="请填写" ControlToValidate="txtPlayTimeCount" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RangeValidator ID="RangeValidator2" runat="server" ErrorMessage="只能填写数字，范围为0-2147483647" ControlToValidate="txtPlayTimeCount" MinimumValue="0" MaximumValue="2147483647" Type="Integer" Display="Dynamic" ></asp:RangeValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                游戏币：
            </td>
            <td>
                <asp:TextBox ID="txtPlayTimeGrantScore" runat="server" CssClass="text" onkeyup="if(isNaN(value))execCommand('undo');" MaxLength="10"></asp:TextBox>
                 &nbsp;
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="请填写" ControlToValidate="txtPlayTimeGrantScore" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RangeValidator ID="RangeValidator3" runat="server" ErrorMessage="只能填写数字，范围为0-2147483647" ControlToValidate="txtPlayTimeGrantScore" MinimumValue="0" MaximumValue="2147483647" Type="Integer" Display="Dynamic" ></asp:RangeValidator>
            </td>
        </tr>
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                <div class="hg3  pd7">
                    充值赠送</div>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                比率：
            </td>
            <td>
                <asp:TextBox ID="txtFillGrantRate" runat="server" CssClass="text" onkeyup="if(isNaN(value))execCommand('undo');" MaxLength="3"></asp:TextBox>% 充值金额等价的游戏币数的比率
                 &nbsp;
                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="请填写" ControlToValidate="txtFillGrantRate" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RangeValidator ID="RangeValidator4" runat="server" ErrorMessage="只能填写数字，范围为0-100" ControlToValidate="txtFillGrantRate" MinimumValue="0" MaximumValue="100" Type="Integer" Display="Dynamic" ></asp:RangeValidator>
            </td>
        </tr>
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                <div class="hg3  pd7">
                    结算赠送</div>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                比率：
            </td>
            <td>
                <asp:TextBox ID="txtBalanceRate" runat="server" CssClass="text" onkeyup="if(isNaN(value))execCommand('undo');"  MaxLength="3"></asp:TextBox>%
                &nbsp;
                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="请填写" ControlToValidate="txtBalanceRate" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RangeValidator ID="RangeValidator5" runat="server" ErrorMessage="只能填写数字，范围为0-100" ControlToValidate="txtBalanceRate" MinimumValue="0" MaximumValue="100" Type="Integer" Display="Dynamic" ></asp:RangeValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                最低值：
            </td>
            <td>
                <asp:TextBox ID="txtMinBalanceScore" runat="server" CssClass="text" onkeyup="if(isNaN(value))execCommand('undo');" MaxLength="10"></asp:TextBox>
                 &nbsp;
                <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ErrorMessage="请填写" ControlToValidate="txtMinBalanceScore" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RangeValidator ID="RangeValidator6" runat="server" ErrorMessage="只能填写数字，范围为0-2147483647" ControlToValidate="txtMinBalanceScore" MinimumValue="0" MaximumValue="2147483647" Type="Integer" Display="Dynamic" ></asp:RangeValidator>
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
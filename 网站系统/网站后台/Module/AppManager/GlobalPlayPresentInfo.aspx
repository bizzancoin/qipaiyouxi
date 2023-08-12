<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GlobalPlayPresentInfo.aspx.cs" Inherits="Game.Web.Module.AppManager.GlobalPlayPresentInfo" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="../../scripts/common.js"></script>

    <script type="text/javascript" src="../../scripts/comm.js"></script>

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
                你当前位置：系统维护 - 泡点设置
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="返回" class="btn wd1" onclick="Redirect('GlobalPlayPresentList.aspx');" />
                <asp:Button ID="btnSave" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    <asp:PlaceHolder ID="phMaxPresent" runat="server">
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                <div class="hg3  pd7">
                    泡点封顶设置(设置为0即为取消封顶)</div>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                单日封顶值：
            </td>
            <td>
                <asp:TextBox ID="txtMaxDatePresent" runat="server" CssClass="text" onkeyup="if(isNaN(value))execCommand('undo');" Text="0" MaxLength="10"></asp:TextBox> 游戏币
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                总封顶值：
            </td>
            <td>
                <asp:TextBox ID="txtMaxPresent" runat="server" CssClass="text" onkeyup="if(isNaN(value))execCommand('undo');" Text="0" MaxLength="10"></asp:TextBox> 游戏币
            </td>
        </tr>
    </table>
    </asp:PlaceHolder>
    <asp:PlaceHolder ID="phPresent" runat="server">
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                <div class="hg3  pd7">
                    泡点规则</div>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                房间名称：
            </td>
            <td>
                <asp:DropDownList ID="ddlGameRoom" runat="server">
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                赠送对象：
            </td>
            <td>
                <asp:CheckBoxList ID="ckbMemberOrder" runat="server" RepeatDirection="Horizontal">
                </asp:CheckBoxList>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                游戏泡分单元值：
            </td>
            <td>
                <asp:TextBox ID="txtCellPlayPresnet" runat="server" CssClass="text" onkeyup="if(isNaN(value))execCommand('undo');" Text="0" MaxLength="10"></asp:TextBox> 游戏币
                &nbsp;&nbsp;
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="请填写" ControlToValidate="txtCellPlayPresnet" Display=Dynamic></asp:RequiredFieldValidator>
                <asp:RangeValidator ID="RangeValidator1" runat="server" ErrorMessage="只能填写数字，范围为0-2147483647" ControlToValidate="txtCellPlayPresnet" MinimumValue="0" MaximumValue="2147483647" Type="Integer" Display="Dynamic" ></asp:RangeValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                游戏泡分单元时间（秒）：
            </td>
            <td>
                <asp:TextBox ID="txtCellPlayTime" runat="server" CssClass="text" onkeyup="if(isNaN(value))execCommand('undo');" Text="0" MaxLength="10"></asp:TextBox>
                &nbsp;&nbsp;
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="请填写" ControlToValidate="txtCellPlayTime" Display=Dynamic></asp:RequiredFieldValidator>
                <asp:RangeValidator ID="RangeValidator2" runat="server" ErrorMessage="只能填写数字，范围为0-2147483647" ControlToValidate="txtCellPlayTime" MinimumValue="0" MaximumValue="2147483647" Type="Integer" Display="Dynamic"></asp:RangeValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                游戏泡分启始时间（秒）：
            </td>
            <td>
                <asp:TextBox ID="txtStartPlayTime" runat="server" CssClass="text" onkeyup="if(isNaN(value))execCommand('undo');" Text="0" MaxLength="10"></asp:TextBox>
                &nbsp;&nbsp;
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="请填写" ControlToValidate="txtStartPlayTime" Display=Dynamic></asp:RequiredFieldValidator>
                <asp:RangeValidator ID="RangeValidator3" runat="server" ErrorMessage="只能填写数字，范围为0-2147483647" ControlToValidate="txtStartPlayTime" MinimumValue="0" MaximumValue="2147483647" Type="Integer" Display="Dynamic"></asp:RangeValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                在线泡分单元值：
            </td>
            <td>
                <asp:TextBox ID="txtCellOnlinePresent" runat="server" CssClass="text" onkeyup="if(isNaN(value))execCommand('undo');" Text="0" MaxLength="10"></asp:TextBox> 游戏币
                &nbsp;&nbsp;
                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="请填写" ControlToValidate="txtCellOnlinePresent" Display=Dynamic></asp:RequiredFieldValidator>
                <asp:RangeValidator ID="RangeValidator4" runat="server" ErrorMessage="只能填写数字，范围为0-2147483647" ControlToValidate="txtCellOnlinePresent" MinimumValue="0" MaximumValue="2147483647" Type="Integer" Display="Dynamic"></asp:RangeValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                在线泡分单元时间（秒）：
            </td>
            <td>
                <asp:TextBox ID="txtCellOnlineTime" runat="server" CssClass="text" onkeyup="if(isNaN(value))execCommand('undo');" Text="0" MaxLength="10"></asp:TextBox>
                &nbsp;&nbsp;
                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="请填写" ControlToValidate="txtCellOnlineTime" Display=Dynamic></asp:RequiredFieldValidator>
                <asp:RangeValidator ID="RangeValidator5" runat="server" ErrorMessage="只能填写数字，范围为0-2147483647" ControlToValidate="txtCellOnlineTime" MinimumValue="0" MaximumValue="2147483647" Type="Integer" Display="Dynamic"></asp:RangeValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                在线泡分启始时间（秒）：
            </td>
            <td>
                <asp:TextBox ID="txtStartOnlineTime" runat="server" CssClass="text" onkeyup="if(isNaN(value))execCommand('undo');" Text="0" MaxLength="10"></asp:TextBox>
                 &nbsp;&nbsp;
                <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ErrorMessage="请填写" ControlToValidate="txtStartOnlineTime" Display=Dynamic></asp:RequiredFieldValidator>
                <asp:RangeValidator ID="RangeValidator6" runat="server" ErrorMessage="只能填写数字，范围为0-2147483647" ControlToValidate="txtStartOnlineTime" MinimumValue="0" MaximumValue="2147483647" Type="Integer" Display="Dynamic"></asp:RangeValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                泡分状态：
            </td>
            <td>
                <asp:CheckBox ID="ckbIsPlayPresent" runat="server" Checked="true" Text="开启游戏泡分" />
                <asp:CheckBox ID="ckbIsOnlinePresent" runat="server" Checked="true" Text="开启在线泡分 " />
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                创建时间：
            </td>
            <td>
                <asp:Literal ID="ltCollectDate" runat="server"></asp:Literal>
            </td>
        </tr>
    </table>
    </asp:PlaceHolder>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="返回" class="btn wd1" onclick="Redirect('GlobalPlayPresentList.aspx');" />
                <asp:Button ID="btnSave1" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LivcardCreate.aspx.cs" Inherits="Game.Web.Module.FilledManager.LivcardCreate" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="../../scripts/common.js"></script>

    <script type="text/javascript" src="../../scripts/comm.js"></script>
    <script type="text/javascript" src="../../scripts/My97DatePicker/WdatePicker.js"></script>


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
                你当前位置：充值系统 - 实卡管理
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="Tmg7">
        <tr>
            <td height="28">
                <ul>
                    <li class="tab2" onclick="Redirect('LivcardBuildStreamList.aspx')">会员卡管理</li>
                    <li class="tab1">会员卡生成</li>
                    <li class="tab2" onclick="Redirect('LivcardStat.aspx')">库存统计</li>
                    <li class="tab2" onclick="Redirect('GlobalLivcardList.aspx')">类型管理</li>
                </ul>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <asp:Button ID="btnReset" runat="server" Text="重置" CssClass="btn wd1" OnClick="btnReset_Click" />
                <asp:Button ID="btnCreate" runat="server" Text="生成会员卡" CssClass="btn wd2" OnClick="btnCreate_Click" />
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                <div class="hg3  pd7">
                    基本信息</div>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                会员卡类型：
            </td>
            <td>
                <asp:DropDownList ID="ddlCardType" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlCardType_SelectedIndexChanged">
                </asp:DropDownList>  &nbsp;&nbsp;同一分钟内不能生成同一类型的卡多次，以免会造成卡号重复现象！
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                生成数量：
            </td>
            <td>
                <asp:TextBox ID="txtCount" runat="server" CssClass="text" MaxLength="7" onkeyup="if(isNaN(value))execCommand('undo');"></asp:TextBox> 每次最多10000张
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                价格：
            </td>
            <td>
                <asp:Literal ID="ltCardPrice" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                实卡游戏豆：
            </td>
            <td>
                <asp:Literal ID="ltCurrency" runat="server"></asp:Literal>
                <asp:TextBox ID="txtCurrency" runat="server" MaxLength="8" CssClass="text"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                实卡游戏币：
            </td>
            <td>
                <asp:Literal ID="ltGold" runat="server"></asp:Literal>
                <asp:TextBox ID="txtGold" runat="server" CssClass="text"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                使用范围：
            </td>
            <td>
                <asp:DropDownList ID="ddlUseRange" runat="server">
                    <asp:ListItem Value="0">全部用户</asp:ListItem>
                    <asp:ListItem Value="1">新注册用户</asp:ListItem>
                    <asp:ListItem Value="2">第一次充值用户</asp:ListItem>
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                销售商：
            </td>
            <td>
                <asp:TextBox ID="txtSalesPerson" runat="server" CssClass="text"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                有效日期：
            </td>
            <td>
               <asp:TextBox ID="txtValidDate" runat="server" CssClass="text wd2" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})"></asp:TextBox>
               <img src="../../Images/btn_calendar.gif" onclick="WdatePicker({el:'txtValidDate',dateFmt:'yyyy-MM-dd'})"
                    style="cursor: pointer; vertical-align: middle" />
                
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                备注：
            </td>
            <td>
                <asp:TextBox ID="txtRemark" runat="server" CssClass="text" MaxLength="128" Width="300"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                <div class="hg3  pd7">
                    卡号规则
                 </div>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                开始字符：
            </td>
            <td>
                <asp:TextBox ID="txtInitial" runat="server" Text="P" CssClass="text" MaxLength="2"></asp:TextBox> 开始字符可为空，最大只可为一位
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                卡号长度：
            </td>
            <td>
                <asp:TextBox ID="txtCardNumLen" runat="server" CssClass="text" Text="15" MaxLength="2" onkeyup="if(isNaN(value))execCommand('undo');"></asp:TextBox> 卡号长度必须大于等于15小于32
            </td>
        </tr>
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                <div class="hg3  pd7">
                    卡密规则</div>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                密码字符类型：
            </td>
            <td>
                <asp:CheckBox ID="ckbDigit" runat="server" Text="数字" Checked="true" />
                <asp:CheckBox ID="ckbLower" runat="server" Text="含小写字母" />
                <asp:CheckBox ID="ckbUpper" runat="server" Text="含大写字母" />
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                密码长度：
            </td>
            <td>
                <asp:TextBox ID="txtPassLen" runat="server" Text="8" CssClass="text" MaxLength="2" onkeyup="if(isNaN(value))execCommand('undo');"></asp:TextBox> 密码长度必须大于等于8小于33
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <asp:Button ID="btnReset2" runat="server" Text="重置" CssClass="btn wd1" OnClick="btnReset_Click" />
                <asp:Button ID="btnCreate2" runat="server" Text="生成会员卡" CssClass="btn wd2" OnClick="btnCreate_Click" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

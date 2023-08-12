<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MallOrder.aspx.cs" Inherits="Game.Web.Module.MallManager.MallOrder" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <link href="/styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/scripts/common.js"></script>
    <script type="text/javascript" src="/scripts/jquery.js"></script>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <!-- 头部菜单 Start -->
        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="title">
            <tr>
                <td width="19" height="25" valign="top"  class="Lpd10"><div class="arr"></div></td>
                <td width="1232" height="25" valign="top" align="left">你当前位置：商城系统 - 类型管理</td>
            </tr>
        </table>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td class="titleOpBg Lpd10">
                     <asp:Button ID="btnConfirm2" runat="server" Text="" CssClass="btn wd3" onclick="btnConfirm_Click" />&nbsp;&nbsp;
                     <asp:Button ID="btnRefused2" runat="server" Text="拒绝退货" CssClass="btn wd3" onclick="btnConfirm_Click"/>&nbsp;&nbsp;
                     <input type="button" value="返回" class="btn wd2" onclick="Redirect('MallOrderList.aspx')" />
                </td>
            </tr>
        </table>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
             <tr>
                <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10"><div class="hg3  pd7">
                <asp:Literal ID="litInfo" runat="server"></asp:Literal>订单信息</div></td>
            </tr>
            <tr>
                <td class="listTdLeft">订单号码：</td>
                <td colspan="3">
                    <asp:Label ID="lbOrderID" runat="server" Text=""></asp:Label>  
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">商品名称：</td>
                <td><asp:Label ID="lbAwardID" runat="server" Text=""></asp:Label></td>
            </tr>
            <tr>
                <td class="listTdLeft">购买数量：</td>
                <td><asp:Label ID="lbAwardCount" runat="server" Text=""></asp:Label></td>
            </tr>
            <tr>
                <td class="listTdLeft">商品价格：</td>
                <td><asp:Label ID="lbAwardPrice" runat="server" Text=""></asp:Label></td>
            </tr>
            <tr>
                <td class="listTdLeft">支付金额：</td>
                <td><asp:Label ID="lbTotalAmount" runat="server" Text=""></asp:Label></td>
            </tr>
            <tr>
                <td class="listTdLeft">用户帐号：</td>
                <td><asp:Label ID="lbUserID" runat="server" Text=""></asp:Label></td>
            </tr>
            <tr>
                <td class="listTdLeft">真实姓名：</td>
                <td><asp:Label ID="lbCompellation" runat="server" Text=""></asp:Label></td>
            </tr>
            <tr>
                <td class="listTdLeft">联系电话：</td>
                <td><asp:Label ID="lbMobilePhone" runat="server" Text=""></asp:Label></td>
            </tr>
            <tr>
                <td class="listTdLeft">联系 QQ：</td>
                <td><asp:Label ID="lbQQ" runat="server" Text=""></asp:Label></td>
            </tr>
            <tr>
                <td class="listTdLeft">邮政编码：</td>
                <td><asp:Label ID="lbPostalCode" runat="server" Text=""></asp:Label></td>
            </tr>
            <tr>
                <td class="listTdLeft">详细地址：</td>
                <td><asp:Label ID="lbDwellingPlace" runat="server" Text=""></asp:Label></td>
            </tr>
            <tr>
                <td class="listTdLeft">购买时间：</td>
                <td><asp:Label ID="lbBuyDate" runat="server" Text=""></asp:Label></td>
            </tr>
            <tr>
                <td class="listTdLeft">购买地址：</td>
                <td><asp:Label ID="lbBuyIP" runat="server" Text=""></asp:Label></td>
            </tr>
            <tr>
                <td class="listTdLeft">订单状态：</td>
                <td><asp:Label ID="lbOrderStatus" runat="server" Text="" CssClass="red"></asp:Label></td>
            </tr>
            <tr>
                <td class="listTdLeft">处理时间：</td>
                <td><asp:Label ID="lbSolveDate" runat="server" Text=""></asp:Label></td>
            </tr>
            <tr>
                <td class="listTdLeft">处理日志：</td>
                <td colspan="3"><asp:Label ID="lbSolveNote" runat="server" Text="" CssClass="red"></asp:Label></td>
            </tr>
        </table>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td class="titleOpBg Lpd10">
                     <asp:Button ID="btnConfirm" runat="server" Text="" CssClass="btn wd3" onclick="btnConfirm_Click" />&nbsp;&nbsp;
                     <asp:Button ID="btnRefused" runat="server" Text="拒绝退货" CssClass="btn wd3" onclick="btnConfirm_Click"/>&nbsp;&nbsp;
                     <input type="button" value="返回" class="btn wd2" onclick="Redirect('MallOrderList.aspx')" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>

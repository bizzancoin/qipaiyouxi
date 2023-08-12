<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OnLineOrderInfo.aspx.cs" Inherits="Game.Web.Module.FilledManager.OnLineOrderInfo" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../../scripts/common.js"></script>   
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <!-- 头部菜单 Start -->
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="title">
        <tr>
            <td width="19" height="25" valign="top"  class="Lpd10"><div class="arr"></div></td>
            <td width="1232" height="25" valign="top" align="left">你当前位置：充值系统 - 订单信息</td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="关闭" class="btn wd1" onclick="javascript:window.close()" />                           
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10"><div class="hg3  pd7">基本信息</div></td>
        </tr
        <tr>
            <td class="listTdLeft">订单号码：</td>
            <td>        
                <asp:Literal ID="litOrderID" runat="server"></asp:Literal>             
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">订单日期：</td>
            <td>        
                <asp:Literal ID="litApplyDate" runat="server"></asp:Literal>             
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">帐号：</td>
            <td>        
                <asp:Literal ID="litAccounts" runat="server"></asp:Literal>             
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">订单金额：</td>
            <td>        
                <asp:Literal ID="litOrderAmount" runat="server"></asp:Literal>             
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">实付金额：</td>
            <td>        
                <asp:Literal ID="litPayAmount" runat="server"></asp:Literal>             
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">赠送游戏币：</td>
            <td>        
                <asp:Literal ID="litPresentScore" runat="server"></asp:Literal>             
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">订单状态：</td>
            <td>        
                <asp:Literal ID="litOrderStatus" runat="server"></asp:Literal>             
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">充值地址：</td>
            <td>        
                <asp:Literal ID="litIPAddress" runat="server"></asp:Literal>             
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">操作用户：</td>
            <td>        
                <asp:Literal ID="litOperUserID" runat="server"></asp:Literal>             
            </td>
        </tr>        
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="关闭" class="btn wd1" onclick="javascript:window.close()" />                           
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

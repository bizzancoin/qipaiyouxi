<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AgentStatInfo.aspx.cs" Inherits="Game.Web.Module.AgentManager.AgentStatInfo" %>
<%@ Register Src="~/Themes/TabAgent.ascx" TagPrefix="Fox" TagName="Tab" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link href="/styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/scripts/common.js"></script>
    <script type="text/javascript" src="/scripts/comm.js"></script>    
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
            <td width="1232" height="25" valign="top" align="left" style="width: 1232px; height: 25px; vertical-align: top; text-align: left;">
                目前操作功能：代理信息
            </td>
        </tr>
    </table>
    <!-- 头部菜单 End -->
    <Fox:Tab ID="fab1" runat="server" NavActivated="F"></Fox:Tab>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="关闭" class="btn wd1" onclick="window.close();" />
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10"><div class="hg3  pd7">
                <asp:Literal ID="litInfo" runat="server"></asp:Literal>分成信息</div></td>
        </tr>
        <tr>
            <td class="listTdLeft">代理编号：</td>
            <td>        
                <asp:Label ID="lblAgentID" runat="server" ForeColor="Blue"></asp:Label>   
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">游戏ID：</td>
            <td>               
                <asp:Label ID="lblGameID" runat="server" ForeColor="Blue"></asp:Label>    
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">游戏帐号：</td>
            <td>        
                <asp:Label ID="lblAccounts" runat="server" ForeColor="Blue"></asp:Label>           
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">代理人数：</td>
            <td>        
                <asp:Label ID="lblChildCount" runat="server"></asp:Label>           
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">税收分成：</td>
            <td>        
                <asp:Label ID="lblRevenue" runat="server"></asp:Label>           
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">充值分成：</td>
            <td>        
                <asp:Label ID="lblPay" runat="server"></asp:Label>           
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">返现分成：</td>
            <td>        
                <asp:Label ID="lblPayBack" runat="server"></asp:Label>           
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">收入合计：</td>
            <td>        
                <asp:Label ID="lblIn" runat="server" ForeColor="Blue"></asp:Label>           
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">结算支出：</td>
            <td>        
                <asp:Label ID="lblOut" runat="server" ForeColor="Blue"></asp:Label>           
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">分成余额：</td>
            <td>        
                <asp:Label ID="lblRemain" runat="server" ForeColor="Red"></asp:Label>           
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="关闭" class="btn wd1" onclick="window.close();" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

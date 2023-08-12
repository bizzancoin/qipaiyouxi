<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StatAgentInfo.aspx.cs" Inherits="Game.Web.Module.AgentManager.StatAgentInfo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link href="/styles/layout.css" rel="stylesheet" type="text/css" />
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
                你当前位置：代理系统 - 手工统计
            </td>
        </tr>
    </table>
    <div style="text-align: center;">
        <h3>
            作为紧急处理。统计代理税收，充值返现，只统计到昨天为止的数据。<br /><br />
            描述：在断电或维护时，忘记开启作业执行，导致数据没有及时统计，则需要手工执行。</h3>
        <br />
        <asp:Button ID="btnRevenue" runat="server" Text="税收统计并结算" OnClick="btnRevenue_Click" />
        <asp:Button ID="btnPayBack" runat="server" Text="返现统计并结算" OnClick="btnPayBack_Click" />
    </div>
    </form>
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AgentScaleInfo.aspx.cs" Inherits="Game.Web.Mobile.Agent.AgentScaleInfo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
    <link type="text/css" rel="stylesheet" href="/Mobile/Css/shop/base.css" />
    <link type="text/css" rel="stylesheet" href="/Mobile/Css/Agent/agentscaleinfo.css" />
</head>
<body>  
    <form id="form1" name="form1" runat="server">
    <table>
      <tr>
        <td>代理人数：<span><%=childCount %></span></td>
        <td>税收分成：<span><%=agentRevenue %></span></td>
      </tr>
      <tr>
        <td>充值分成：<span><%=agentPay %></span></td>
        <td>返现分成：<span><%=agentPayBack %></span></td>
      </tr>
      <tr>
        <td>收入合计：<span><%=agentIn %></span></td>
        <td>结算支出：<span><%=agentOut %></span></td>
      </tr>
      <tr>
        <td>分成余额：<span><%=agentRemain %></span></td>
        <td><span></span></td>
      </tr>
      <tr>
        <td colspan="2">请输入结算游戏币：<span><asp:TextBox ID="txtScore" runat="server"></asp:TextBox></span></td>
      </tr>
    </table>
        <asp:Button ID="btnUpdate" runat="server" OnClick="btnUpdate_Click" />
    </form>
</body>
</html>

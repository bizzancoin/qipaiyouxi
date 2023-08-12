<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AgentInfo.aspx.cs" Inherits="Game.Web.Mobile.Agent.AgentInfo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
    <link type="text/css" rel="stylesheet" href="/Mobile/Css/shop/base.css" />
    <link type="text/css" rel="stylesheet" href="/Mobile/Css/Agent/agentinfo.css" />
</head>
<body>
    <table>
      <tr>
        <td>真实姓名：<span><%=compellation %></span></td>
        <td>联系电话：<span><%=mobilePhone %></span></td>
      </tr>
      <tr>
        <td>代理编号：<span><%=agentID %></span></td>
        <td>代理域名：<span><%=domain %></span></td>
      </tr>
      <tr>
        <td>代理比例：<span><%=agentScale %></span></td>
        <td>代理时间：<span><%=collectDate %></span></td>
      </tr>
      <tr>
        <td>分成类型：<span><%=agentType %></span></td>
        <td>电子邮箱：<span><%=eMail %></span></td>
      </tr>
      <tr>
        <td>日累计充值返现：<span><%=payBackScore %></span></td>
        <td>返现比例：<span><%=payBackScale %></span></td>
      </tr>
      <tr>
        <td colspan="2">联系地址：<span><%=dwellingPlace %></span></td>
      </tr>
    </table>
</body>
</html>

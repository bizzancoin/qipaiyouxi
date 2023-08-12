<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AgentRevenueInfo.aspx.cs" Inherits="Game.Web.Mobile.Agent.AgentRevenueInfo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
    <link type="text/css" rel="stylesheet" href="/Mobile/Css/shop/base.css" />
    <link type="text/css" rel="stylesheet" href="/Mobile/Css/Agent/agentrevenueinfo.css" />
    <link type="text/css" rel="stylesheet" href="/Mobile/Js/iscroll/pull-refresh.css">
    <title>税收信息</title>
</head>
<body>
    <div id="wrapper">
        <table>
            <thead>
                <tr>
                  <th>统计日期</th>
                  <th>贡献玩家</th>
                  <th>贡献税收</th>
                  <th>代理分成</th>
                  <th>代理比例</th>
                </tr>
                <tr>
                  <td colspan="5"></td>
                </tr>
            </thead>
            <tbody id="order-list" data-url="/WS/MobileInterface.ashx?action=getagentrevenuelist">
            </tbody>
        </table>
    </div>
    <%--<div style="text-align:center; display: none;">--%>
        <%--<a href="javascript:;" id="load-more" style="display:block;font-size:1.5rem;color:#006A92;border:1px solid #D4D4D4;width:96%;background-color:#EBEBEB;margin:0 2% 1rem 2%;border-radius:3px;">加载更多 <em></em></a>--%>
    <%--</div>--%>
    <script src="/Mobile/Js/mobile/zepto/1.1.6/zepto.min.js" type="text/javascript"></script>
    <script src="/Mobile/Js/iscroll/iscroll.js" type="text/javascript"></script>
    <script src="/Mobile/Js/iscroll/pull-refresh.js" type="text/javascript"></script>
    <script src="/Mobile/Js/agent/agentrevenue.js" type="text/javascript"></script>
</body>
</html>

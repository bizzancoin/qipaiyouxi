<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AgentPayInfo.aspx.cs" Inherits="Game.Web.Mobile.Agent.AgentPayInfo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
    <link type="text/css" rel="stylesheet" href="/Mobile/Css/shop/base.css" />
    <link type="text/css" rel="stylesheet" href="/Mobile/Css/Agent/agentpayinfo.css" />
    <link type="text/css" rel="stylesheet" href="/Mobile/Js/iscroll/pull-refresh.css">
    <title>充值信息</title>
</head>
<body>
    <div id="wrapper">
        <table>
            <thead>
                <tr>
                  <th>充值时间</th>
                  <th>分成金币</th>
                  <th>分成比例</th>
                  <th>贡献帐号</th>
                  <th>充值金币</th>
                  <th>充值地址</th>
                </tr>
                <tr>
                  <td colspan="6"></td>
                </tr>
            </thead>
            <tbody id="order-list" data-url="/WS/MobileInterface.ashx?action=getagentpaylist">
            </tbody>
        </table>
    </div>
    <%--<div style="text-align:center;">--%>
        <%--<a href="javascript:;" id="load-more" style="display:block;font-size:1.5rem;color:#006A92;border:1px solid #D4D4D4;width:96%;background-color:#EBEBEB;margin:0 2% 1rem 2%;border-radius:3px;">加载更多 <em></em></a>--%>
    <%--</div>--%>
    <script src="/Mobile/Js/mobile/zepto/1.1.6/zepto.min.js" type="text/javascript"></script>
    <script src="/Mobile/Js/iscroll/iscroll.js" type="text/javascript"></script>
    <script src="/Mobile/Js/iscroll/pull-refresh.js" type="text/javascript"></script>
    <script src="/Mobile/Js/agent/agentpay.js" type="text/javascript"></script>
</body>
</html>

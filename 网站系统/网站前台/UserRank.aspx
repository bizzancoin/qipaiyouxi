<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserRank.aspx.cs" Inherits="Game.Web.UserRank" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <style>
    html, body { overflow: hidden; }
    body {background: #18142f; width: 196px;}
    .ui-text-left {text-align: left;}
    .ui-text-right {text-align: right;}
    .ui-rank-title {width: 186px; padding: 0 5px; height: 21px; margin-bottom: 2px;}
    .ui-rank-title tr {height: 20px; font-size: 0;}
    .ui-rank-title th {font-size: 12px; line-height: 20px; color: #524b7d; height: 20px; width: 30px; border-bottom: 1px solid #392e5a; display: inline-block; *zoom: 1; *display: inline;}
    .ui-rank-title th.ui-text-left,
     .ui-rank-list td.ui-text-left {width: 66px;}
    .ui-rank-title th.ui-text-right,
     .ui-rank-list td.ui-text-right {width: 90px;}
    .ui-rank-list {text-align: center; width: 186px; padding: 0 5px; height: 205px; overflow: hidden;}
    .ui-rank-list table {width: 100%; height: 200px; margin-bottom: 5px;}
    .ui-rank-list tr {height: 20px; font-size: 0;}
    .ui-rank-list td,
     .ui-rank-list td>span {font-size: 12px; line-height: 20px; width: 30px; color: #ff9900;}
    .ui-rank-list td.ui-text-left span { display: block; width: 66px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;}
    .ui-rank-list td.ui-text-right span { display: block; width: 90px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;}
    .ui-rank-list td.ui-text-right span {color: #ffcc00; }
    .ui-rank-list td.ui-text-left span {color: #9c98b8; }
    tr.ui-bg-color {background: #1d1936;}
    td.b1,
    td.b2,
    td.b3 {font-size: 0;}
    td.b1 {background: url("/images/ranking_1.png") center no-repeat;}
    td.b2 {background: url("/images/ranking_2.png") center no-repeat;}
    td.b3 {background: url("/images/ranking_3.png") center no-repeat;}
</style>
</head>
<body>
    <div class="ui-rank-title">
        <table>
            <thead>
                <tr>
                <th>名次</th>
                <th class="ui-text-left">昵称</th>
                <th class="ui-text-right">财富</th>
                </tr>
            </thead>
        </table>
    </div>
    <div class="ui-rank-list">
        <table id="marquee" cellpadding="0" cellspacing="0">
        <tbody>
            <asp:Repeater ID="rptRank" runat="server">
                <ItemTemplate>
                    <tr>
                        <td <%# (Container.ItemIndex + 1)<4?"class=\"b"+(Container.ItemIndex + 1)+"\"":"" %>><%# Container.ItemIndex + 1%></td>
                        <td class="ui-text-left"><span><%# Game.Utils.TextUtility.CutStringProlongSymbol(Eval("NickName").ToString(), 25)%></span></td>
                        <td class="ui-text-right"><span><%# Convert.ToInt64(Eval("Score")).ToString("N0")%></span></td>
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr class="ui-bg-color">
                        <td <%# (Container.ItemIndex + 1)<4?"class=\"b"+(Container.ItemIndex + 1)+"\"":"" %>><%# Container.ItemIndex + 1%></td>
                        <td class="ui-text-left"><span><%# Game.Utils.TextUtility.CutStringProlongSymbol(Eval("NickName").ToString(), 25)%></span></td>
                        <td class="ui-text-right"><span><%# Convert.ToInt64(Eval("Score")).ToString("N0")%></span></td>
                    </tr>
                </AlternatingItemTemplate>
            </asp:Repeater>                  
        </tbody>
        </table>
    </div>
</body>
</html>

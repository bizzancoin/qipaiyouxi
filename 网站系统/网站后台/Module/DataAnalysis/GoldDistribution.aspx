<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GoldDistribution.aspx.cs"
    Inherits="Game.Web.Admin.Module.Data_Analysis.GoldDistribution" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="/styles/layout.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        #tree
        {
            overflow-y: auto;
            visibility: visible;
            min-height: 400px;
            width: 100%;
            padding-top: 5px;
            text-align: center;
        }
        .tdBgColor
        {
            background-color: White;
            width: 10%;
            height: 26px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="title">
        <tr>
            <td width="19" height="25" valign="top" class="Lpd10">
                <div class="arr">
                </div>
            </td>
            <td width="1232" height="25" valign="top" align="left">
                你当前位置：数据分析 - 游戏币分布
            </td>
        </tr>
    </table>
    <div style="height:30px; width:97%; margin-top:10px;">
        <div style="margin-left:10px;font-size:14px; font-weight:bold; float:left;">游戏币分布图 </div>
        <div class="xuxian"></div>
    </div>
    <div id="tree">
        <asp:Chart ID="Chart1" runat="server">
            <Series>
                <asp:Series Name="Series1">
                </asp:Series>
            </Series>
            <ChartAreas>
                <asp:ChartArea Name="ChartArea1">
                </asp:ChartArea>
            </ChartAreas>
            <Legends>
                <asp:Legend>
                </asp:Legend>
            </Legends>
            <Titles>
            </Titles>
        </asp:Chart>
        <table style="margin: 0 auto; width: 70%; background-color: Black;" border="0" cellpadding="0"
            cellspacing="1">
            <tr>
                <td class="tdBgColor" style="width: 20%;">
                    游戏币区域
                </td>
                <td class="tdBgColor">
                    1万以下
                </td>
                <td class="tdBgColor">
                    1万-10万
                </td>
                <td class="tdBgColor">
                    10万-50万
                </td>
                <td class="tdBgColor">
                    50万-100万
                </td>
                <td class="tdBgColor">
                    100万-500万
                </td>
                <td class="tdBgColor">
                    500万-1000万
                </td>
                <td class="tdBgColor">
                    1000万-3000万
                </td>
                <td class="tdBgColor">
                    3000万以上
                </td>
            </tr>
            <tr>
                <td class="tdBgColor">
                    玩家数量
                </td>
                <td class="tdBgColor">
                    <asp:Label ID="Label1" runat="server" Text="Label"></asp:Label>
                </td>
                <td class="tdBgColor">
                    <asp:Label ID="Label2" runat="server" Text="Label"></asp:Label>
                </td>
                <td class="tdBgColor">
                    <asp:Label ID="Label3" runat="server" Text="Label"></asp:Label>
                </td>
                <td class="tdBgColor">
                    <asp:Label ID="Label4" runat="server" Text="Label"></asp:Label>
                </td>
                <td class="tdBgColor">
                    <asp:Label ID="Label5" runat="server" Text="Label"></asp:Label>
                </td>
                <td class="tdBgColor">
                    <asp:Label ID="Label6" runat="server" Text="Label"></asp:Label>
                </td>
                <td class="tdBgColor">
                    <asp:Label ID="Label7" runat="server" Text="Label"></asp:Label>
                </td>
                <td class="tdBgColor">
                    <asp:Label ID="Label8" runat="server" Text="Label"></asp:Label>
                </td>
            </tr>
        </table>
        <table border="0" cellpadding="0" cellspacing="1" style="margin:5px auto; width:70%;
            height:60; line-height: 30px;" runat="server" id="tbCalc">
            <tr>
                <td align="right" style="width:25%;">
                    总游戏币数：
                </td>
                <td align="left" style="width:25%;">
                    <asp:Label ID="lbGoldTotal" runat="server" Text=""></asp:Label>
                </td>
                <td align="right" style="width:30%;">
                    游戏币市场价值(每<asp:Label ID="lbGoldRate" runat="server" Text=""></asp:Label>游戏币)：
                </td>
                <td align="left" style="width:20%;">
                    <asp:Label ID="lbGoldTrueValue" runat="server" Text=""></asp:Label>
                </td>
            </tr>
            <tr>
                <td align="right">
                    游戏币的市场价值通胀率：
                </td>
                <td align="left">
                    <asp:Label ID="lbExpansionRate" runat="server" Text=""></asp:Label>
                </td>
                <td align="right">
                    预估游戏币市场价值(每<asp:Label ID="lbGoldRate2" runat="server" Text=""></asp:Label>游戏币)：
                </td>
                <td align="left">
                    <asp:Label ID="lbGoldEstimatedValue" runat="server" Text=""></asp:Label>
                </td>
            </tr>
        </table>
        <div runat="server" id="divGoldCount" style="margin-top:10px;">
             总游戏币数：<asp:Label ID="lbGoldTotal2" runat="server" Text=""></asp:Label>
        </div>
    </div>
    <div style="height:30px; width:97%; margin-top:10px;">
        <div style="margin-left:10px; font-weight:bold; float:left;">公式参考：</div>
        <div class="xuxian"></div>
    </div>
    <table style="margin-left: 20px; line-height:20px; width:98%;"  runat="server" id="tbRefer">
        <tr>
            <td>
                游戏币的市场价值 = 充值的RMB总额 * 兑换率 / 系统游戏币总数
            </td>
        </tr>
        <tr>
            <td>
                游戏币的市场价值通胀率 = 1 / 游戏币的市场价值
            </td>
        </tr>
        <tr>
            <td>
                预估实际游戏币价值 = 游戏币的市场价值 * (2.5/通胀率)
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

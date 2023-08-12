<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MatchRankInfo.aspx.cs" Inherits="Game.Web.Module.MatchManager.MatchRankInfo" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link href="/styles/layout.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="/scripts/common.js"></script>
    <script type="text/javascript" src="/scripts/comm.js"></script>
    <title></title>
</head>
<body scroll="no">
    <form id="form1" runat="server">
    <!-- 头部菜单 Start -->
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="title">
        <tr>
            <td width="19" height="25" valign="top" class="Lpd10">
                <div class="arr">
                </div>
            </td>
            <td width="1232" height="25" valign="top" align="left">
                你当前位置：比赛系统 - 比赛排名
            </td>
        </tr>
    </table>
    <!-- 头部菜单 End -->
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="关闭" class="btn wd1" onclick="window.close();" />                
            </td>
        </tr>
    </table>
    <div id="content">
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="box" id="list">
            <tr align="center" class="bold">
                <td class="listTitle2">
                    排名
                </td>
                <td class="listTitle2">
                    用户标识
                </td>
                <td class="listTitle2">
                    玩家帐号
                </td>
                <td class="listTitle2">
                    比赛分数
                </td>
                <td class="listTitle2">
                    奖励游戏币
                </td>
                <td class="listTitle2">
                    奖励元宝
                </td>
                <td class="listTitle2">
                    奖励经验
                </td>
                <td class="listTitle2">
                    赢局
                </td>
                <td class="listTitle2">
                    输局
                </td>
                <td class="listTitle2">
                    平局
                </td>
                <td class="listTitle2">
                    逃跑
                </td>
                <td class="listTitle2">
                    IP
                </td>
            </tr>
            <asp:Repeater ID="rptData" runat="server">
                <ItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td>
                            <%# Eval("RankID")%>
                        </td>
                        <td>
                           <%# Eval("UserID")%>
                        </td>
                        <td>
                           <%# GetAccounts(Convert.ToInt32(Eval("UserID")))%>
                        </td>
                        <td>
                           <%# Eval("MatchScore")%>
                        </td>
                        <td>
                           <%# Eval("RewardGold")%>
                        </td>
                        <td>
                           <%# Eval("RewardIngot")%>
                        </td>
                        <td>
                           <%# Eval("RewardExperience")%>
                        </td>
                        <td>
                            <%# Eval("WinCount")%>
                        </td>
                        <td>
                            <%# Eval("LostCount")%>
                        </td>
                        <td>
                            <%# Eval("DrawCount")%>
                        </td>
                        <td>
                            <%# Eval("FleeCount")%>
                        </td>
                        <td>
                            <%# Eval("ClientIP")%>
                        </td>
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr align="center" class="listBg" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td>
                            <%# Eval("RankID")%>
                        </td>
                        <td>
                           <%# Eval("UserID")%>
                        </td>
                        <td>
                           <%# GetAccounts(Convert.ToInt32(Eval("UserID")))%>
                        </td>
                        <td>
                           <%# Eval("MatchScore")%>
                        </td>
                        <td>
                           <%# Eval("RewardGold")%>
                        </td>
                        <td>
                           <%# Eval("RewardIngot")%>
                        </td>
                        <td>
                           <%# Eval("RewardExperience")%>
                        </td>
                        <td>
                            <%# Eval("WinCount")%>
                        </td>
                        <td>
                            <%# Eval("LostCount")%>
                        </td>
                        <td>
                            <%# Eval("DrawCount")%>
                        </td>
                        <td>
                            <%# Eval("FleeCount")%>
                        </td>
                        <td>
                            <%# Eval("ClientIP")%>
                        </td>
                    </tr>
                </AlternatingItemTemplate>
            </asp:Repeater>
            <asp:Literal runat="server" ID="litNoData" Visible="false" Text="<tr class='tdbg'><td colspan='100' align='center'><br>没有任何信息!<br><br></td></tr>"></asp:Literal>
        </table>
    </div>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="listTitleBg" style="">
            </td>
            <td align="right" class="page">
               &nbsp;
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

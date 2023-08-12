<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MatchRank.aspx.cs" Inherits="Game.Web.Module.MatchManager.MatchRank" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
     <title></title>
    <link href="/styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/scripts/common.js"></script>
    <script type="text/javascript" src="/scripts/comm.js"></script>
    <script type="text/javascript" src="/scripts/jquery.js"></script>
    <script type="text/javascript" src="/scripts/My97DatePicker/WdatePicker.js"></script>

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
                    你当前位置：比赛系统 - 比赛排名
                </td>
            </tr>
        </table>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="titleQueBg Tmg7">
            <tr>
                <td>
                    &nbsp;&nbsp;比赛类型：
                    <asp:DropDownList ID="ddlMatchType" runat="server" Width="150" onselectedindexchanged="ddlMatchTypeSelect" AutoPostBack="true">
                       <asp:ListItem Text="定时赛" Value="0"></asp:ListItem>
                       <asp:ListItem Text="即时赛" Value="1"></asp:ListItem>
                    </asp:DropDownList>
                    &nbsp;比赛名称： 
                    <asp:DropDownList ID="ddlMatchName" runat="server" Width="150">
                    </asp:DropDownList>
                    <asp:Button ID="btnSearch" runat="server" Text="查询" CssClass="btn wd1" onclick="btnSearch_Click"  />    
                </td>
            </tr>
          </table> 
        <div id="content">
            <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="box Tmg7" id="list">
               <tr align="center" class="bold">
                    <td class="listTitle">查看排名</td>
                    <td class="listTitle2">比赛名称</td>
                    <td class="listTitle2">比赛场次</td>
                    <td class="listTitle2">比赛房间</td>
                    <td class="listTitle2">比赛时间</td>
               </tr>
               <asp:Repeater ID="rpData" runat="server">
                    <ItemTemplate>
                       <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                            <td><a href="#" class="l" onclick="openWindowOwn('MatchRankInfo.aspx?matchtype=<%# matchType%>&matchid=<%# Eval("MatchID") %>&serverid=<%# Eval("ServerID") %>&matchno=<%# Eval("MatchNo") %>', 'MatchRankInfo', 800, 500);">查看详细排名</a></td>
                            <td><%# Eval("MatchName")%></td>
                            <td><%# Eval("MatchNo")%></td>
                            <td><%# Eval("ServerName")%></td>
                            <td><%# Eval("MatchStartTime","{0:yyyy-MM-dd HH:mm}").ToString() + " 至 " + Eval("MatchEndTime","{0:yyyy-MM-dd HH:mm}").ToString()%></td>
                        </tr>
                    </ItemTemplate>
                    <AlternatingItemTemplate>
                       <tr align="center" class="listBg" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                            <td><a href="#" class="l" onclick="openWindowOwn('MatchRankInfo.aspx?matchType=<%# matchType%>&matchid=<%# Eval("MatchID") %>&serverid=<%# Eval("ServerID") %>&matchno=<%# Eval("MatchNo") %>', 'MatchRankInfo', 800, 500);">查看详细排名</a></td>
                            <td><%# Eval("MatchName")%></td>
                            <td><%# Eval("MatchNo")%></td>
                            <td><%# Eval("ServerName")%></td>
                            <td><%# Eval("MatchStartTime","{0:yyyy-MM-dd HH:mm}").ToString() + " 至 " + Eval("MatchEndTime","{0:yyyy-MM-dd HH:mm}").ToString()%></td>
                        </tr>
                    </AlternatingItemTemplate>
                </asp:Repeater>
                <asp:Literal runat="server" ID="litNoData" Visible="false" Text="<tr class='tdbg'><td colspan='100' align='center'><br>没有任何信息!<br><br></td></tr>"></asp:Literal>
            </table>
        </div>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td class="listTitleBg">
                    <span>选择：</span>&nbsp;<a class="l1" href="javascript:SelectAll(true);">全部</a>&nbsp;-&nbsp;<a class="l1" href="javascript:SelectAll(false);">无</a>
                </td>
                <td align="right" class="page">
                    <gsp:AspNetPager ID="anpPage" OnPageChanged="anpPage_PageChanged" runat="server" AlwaysShow="true" FirstPageText="首页" LastPageText="末页"
                        PageSize="20" NextPageText="下页" PrevPageText="上页" ShowBoxThreshold="0" ShowCustomInfoSection="Left" LayoutType="Table"
                        NumericButtonCount="5" CustomInfoHTML="总记录：%RecordCount%　页码：%CurrentPageIndex%/%PageCount%　每页：%PageSize%" UrlPaging="false">
                    </gsp:AspNetPager>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>

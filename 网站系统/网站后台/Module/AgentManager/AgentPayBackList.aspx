<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AgentPayBackList.aspx.cs" Inherits="Game.Web.Module.AgentManager.AgentPayBackList" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link href="/styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/scripts/common.js"></script>
    <script type="text/javascript" src="/scripts/comm.js"></script>
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
                你当前位置：代理系统 - 返现信息
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="titleQueBg">
        <tr>
            <td align="center"  style="width: 80px">
                日期查询：
            </td>
            <td>
                <asp:TextBox ID="txtStartDate" runat="server" CssClass="text wd2" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'txtEndDate\')}'})"></asp:TextBox><img
                    src="../../Images/btn_calendar.gif" onclick="WdatePicker({el:'txtStartDate',dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'txtEndDate\')}'})"
                    style="cursor: pointer; vertical-align: middle" />
                至
                <asp:TextBox ID="txtEndDate" runat="server" CssClass="text wd2" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'txtStartDate\')}'})"></asp:TextBox><img
                    src="../../Images/btn_calendar.gif" onclick="WdatePicker({el:'txtEndDate',dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'txtStartDate\')}'})"
                    style="cursor: pointer; vertical-align: middle" />
                <asp:TextBox ID="txtSearch" runat="server" CssClass="text" ToolTip="输入代理编号、游戏帐号、游戏ID或真实姓名"></asp:TextBox>
                <asp:Button ID="btnQuery" runat="server" Text="查询" CssClass="btn wd1" OnClick="btnQuery_Click"/>
                <asp:Button ID="btnRefresh" runat="server" Text="刷新" CssClass="btn wd1" OnClick="btnRefresh_Click" />            
                <asp:Button ID="btnDay" runat="server" Text="本日" CssClass="btn wd1" OnClick="btnQueryTD_Click"/>
                <asp:Button ID="btnWeek" runat="server" Text="本周" CssClass="btn wd1" OnClick="btnQueryTW_Click"/>
                <asp:Button ID="btnMonth" runat="server" Text="本月" CssClass="btn wd1" OnClick="btnQueryTM_Click"/>
                <asp:Button ID="btnYear" runat="server" Text="本年" CssClass="btn wd1" OnClick="btnQueryTY_Click" />      
            </td>
        </tr>
    </table>
    <div id="content" class="Tmg7">
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="box" id="list">
            <tr align="center" class="bold">
                <td class="listTitle2">
                    统计日期
                </td>
                <td class="listTitle2">
                    代理商
                </td>
                <td class="listTitle2">
                    返现游戏币
                </td>  
                <td class="listTitle2">
                    返现比例
                </td> 
                <td class="listTitle2">
                    日累计充值
                </td>
                <td class="listTitle2">
                    统计时间
                </td>                           
            </tr>
            <asp:Repeater ID="rptDataList" runat="server">
                <ItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td>
                            <%# Game.Facade.Fetch.ShowDate( int.Parse( Eval( "DateID" ).ToString( ) ) )%>
                        </td> 
                        <td title="<%# GetAccounts((int)Eval( "UserID" ))%>">
                            <a class="l" href="javascript:void(0);" onclick="openWindowOwn('AgentManager.aspx?param=<%#Eval("UserID").ToString() %>','<%#Eval("UserID").ToString() %>',850,670);">
                                <%#Game.Utils.TextUtility.CutString(GetAccounts((int)Eval( "UserID" )),0,10)%></a>
                        </td> 
                        <td>
                            <%# Eval("Score") %>
                        </td>
                        <td>
                            <%# (int)((decimal)Eval( "PayBackScale" )*1000) %>‰
                        </td>                         
                        <td>
                            <%# Eval("PayScore") %>
                        </td>
                        <td>
                            <%# Eval("CollectDate") %>
                        </td>
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr align="center" class="listBg" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                         <td>
                            <%# Game.Facade.Fetch.ShowDate( int.Parse( Eval( "DateID" ).ToString( ) ) )%>
                        </td> 
                        <td title="<%# GetAccounts((int)Eval( "UserID" ))%>">
                            <a class="l" href="javascript:void(0);" onclick="openWindowOwn('AgentManager.aspx?param=<%#Eval("UserID").ToString() %>','<%#Eval("UserID").ToString() %>',850,670);">
                                <%#Game.Utils.TextUtility.CutString(GetAccounts((int)Eval( "UserID" )),0,10)%></a>
                        </td> 
                        <td>
                            <%# Eval("Score") %>
                        </td>
                        <td>
                            <%# (int)((decimal)Eval( "PayBackScale" )*1000) %>‰
                        </td>                         
                        <td>
                            <%# Eval("PayScore") %>
                        </td>
                        <td>
                            <%# Eval("CollectDate") %>
                        </td>
                    </tr>
                </AlternatingItemTemplate>
            </asp:Repeater>
            <asp:Literal runat="server" ID="litNoData" Visible="false" Text="<tr class='tdbg'><td colspan='100' align='center'><br>没有任何信息!<br><br></td></tr>"></asp:Literal>
        </table>
    </div>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
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

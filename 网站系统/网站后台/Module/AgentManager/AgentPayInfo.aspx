<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AgentPayInfo.aspx.cs" Inherits="Game.Web.Module.AgentManager.AgentPayInfo" %>
<%@ Register Src="~/Themes/TabAgent.ascx" TagPrefix="Fox" TagName="Tab" %>
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
            <td width="1232" height="25" valign="top" align="left" style="width: 1232px; height: 25px; vertical-align: top; text-align: left;">
                目前操作功能：充值信息
            </td>
        </tr>
    </table>
    <!-- 头部菜单 End -->
    <Fox:Tab ID="fab1" runat="server" NavActivated="C"></Fox:Tab>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="titleQueBg">
        <tr>
            <td class="listTdLeft" style="width: 80px">
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
                <asp:Button ID="btnQuery" runat="server" Text="查询" CssClass="btn wd1" OnClick="btnQuery_Click"/>
                <asp:Button ID="btnRefresh" runat="server" Text="刷新" CssClass="btn wd1" OnClick="btnRefresh_Click" />            
                <asp:Button ID="btnDay" runat="server" Text="本日" CssClass="btn wd1" OnClick="btnQueryTD_Click"/>
                <asp:Button ID="btnWeek" runat="server" Text="本周" CssClass="btn wd1" OnClick="btnQueryTW_Click"/>
                <asp:Button ID="btnMonth" runat="server" Text="本月" CssClass="btn wd1" OnClick="btnQueryTM_Click"/>
                <asp:Button ID="btnYear" runat="server" Text="本年" CssClass="btn wd1" OnClick="btnQueryTY_Click" />
            </td>           
        </tr>
    </table>
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
                    充值时间
                </td>
                <td class="listTitle2">
                    分成游戏币
                </td>  
                <td class="listTitle2">
                    分成比例
                </td> 
                <td class="listTitle2">
                    贡献帐号
                </td>
                <td class="listTitle2">
                    充值游戏币
                </td> 
                <td class="listTitle2">
                    充值地址
                </td>
                <td class="listTitle2">
                    备注
                </td>                           
            </tr>
            <asp:Repeater ID="rptDataList" runat="server">
                <ItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td>
                            <%# Eval( "CollectDate" ) %>
                        </td> 
                        <td>
                            <%# Eval("Score") %>
                        </td>
                        <td>
                            <%# (int)((decimal)Eval( "AgentScale" )*1000) %>‰
                        </td> 
                        <td title="<%# GetAccounts((int)Eval( "ChildrenID" ))%>">
                            <a class="l" href="javascript:void(0);" onclick="openWindowOwn('/Module/AccountManager/AccountsInfo.aspx?param=<%#Eval("ChildrenID").ToString() %>','<%#Eval("ChildrenID").ToString() %>',850,670);">
                                <%#Game.Utils.TextUtility.CutString(GetAccounts((int)Eval( "ChildrenID" )),0,10)%></a>
                        </td>  
                        <td>
                            <%# Eval("PayScore") %>
                        </td>
                        <td>
                            <%# Eval("CollectIP") %>
                        </td>
                        <td>
                            <%# Eval("CollectNote") %>
                        </td>
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr align="center" class="listBg" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                         <td>
                            <%# Eval( "CollectDate" ) %>
                        </td> 
                        <td>
                            <%# Eval("Score") %>
                        </td>
                        <td>
                            <%# (int)((decimal)Eval( "AgentScale" )*1000) %>‰
                        </td> 
                        <td title="<%# GetAccounts((int)Eval( "ChildrenID" ))%>">
                            <a class="l" href="javascript:void(0);" onclick="openWindowOwn('/Module/AccountManager/AccountsInfo.aspx?param=<%#Eval("ChildrenID").ToString() %>','<%#Eval("ChildrenID").ToString() %>',850,670);">
                                <%#Game.Utils.TextUtility.CutString(GetAccounts((int)Eval( "ChildrenID" )),0,10)%></a>
                        </td>  
                        <td>
                            <%# Eval("PayScore") %>
                        </td>
                        <td>
                            <%# Eval("CollectIP") %>
                        </td>
                        <td>
                            <%# Eval("CollectNote") %>
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

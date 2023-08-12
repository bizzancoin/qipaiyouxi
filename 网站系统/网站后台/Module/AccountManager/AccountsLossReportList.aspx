<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AccountsLossReportList.aspx.cs" Inherits="Game.Web.Module.AccountManager.AccountsLossReportList" %>
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
                    你当前位置：用户系统 - 申诉管理
                </td>
            </tr>
        </table>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="titleQueBg">
            <tr>
                <td>
                     &nbsp;&nbsp; &nbsp;&nbsp;申诉日期：
                    <asp:TextBox ID="txtStartDate" runat="server" CssClass="text wd2" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'txtEndDate\')}'})"></asp:TextBox><img
                        src="../../Images/btn_calendar.gif" onclick="WdatePicker({el:'txtStartDate',dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'txtEndDate\')}'})"
                        style="cursor: pointer; vertical-align: middle" />
                    至
                    <asp:TextBox ID="txtEndDate" runat="server" CssClass="text wd2" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'txtStartDate\')}'})"></asp:TextBox><img
                        src="../../Images/btn_calendar.gif" onclick="WdatePicker({el:'txtEndDate',dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'txtStartDate\')}'})"
                        style="cursor: pointer; vertical-align: middle" />
                    &nbsp;&nbsp;
                    <asp:Button ID="btnQuery" runat="server" Text="查询" CssClass="btn wd1" OnClick="btnQuery_Click" />
                </td>
            </tr>
        </table>
        <div id="content">
            <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="box Tmg7" id="list">
                <tr align="center" class="bold">
                    <td class="listTitle">进度</td>
                    <td class="listTitle2">申诉单号</td>
                    <td class="listTitle2">申诉游戏帐号</td>
                    <td class="listTitle2">用户 ID</td>
                    <td class="listTitle2">游戏 ID</td>
                    <td class="listTitle2">申诉邮箱</td>
                    <td class="listTitle2">申诉地址</td>
                    <td class="listTitle2">申诉时间</td>
               </tr>
                <asp:Repeater ID="rpData" runat="server">
                    <ItemTemplate>
                       <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                            <td><%# GetProcess( Eval( "ProcessStatus" ).ToString() )%></td>
                            <td><a href="#" class="l" onclick="openWindowOwn('AccountsLossReportInfo.aspx?param=<%#Eval("ReportID").ToString() %>','<%#Eval("ReportID").ToString() %>',1000,600);"><%# Eval("ReportNo") %></a></td>
                            <td><%# Eval("Accounts")%></td>
                            <td><%# Eval( "UserID" )%></td>
                            <td><%# Eval( "GameID" )%></td>
                            <td><%# Eval("ReportEmail")%></td>
                            <td><%# Eval("ReportIP")%></td>
                            <td><%# Eval("ReportDate")%></td>
                        </tr>
                    </ItemTemplate>
                    <AlternatingItemTemplate>
                       <tr align="center" class="listBg" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                            <td><%# GetProcess( Eval( "ProcessStatus" ).ToString() )%></td>
                            <td><a href="#" class="l" onclick="openWindowOwn('AccountsLossReportInfo.aspx?param=<%#Eval("ReportID").ToString() %>','<%#Eval("ReportID").ToString() %>',1000,600);"><%# Eval("ReportNo") %></a></td>
                            <td><%# Eval("Accounts")%></td>
                            <td><%# Eval( "UserID" )%></td>
                            <td><%# Eval("GameID")%></td>
                            <td><%# Eval("ReportEmail")%></td>
                            <td><%# Eval("ReportIP")%></td>
                            <td><%# Eval("ReportDate")%></td>
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


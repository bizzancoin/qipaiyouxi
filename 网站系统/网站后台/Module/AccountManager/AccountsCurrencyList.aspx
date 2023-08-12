<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AccountsCurrencyList.aspx.cs" Inherits="Game.Web.Module.AccountManager.AccountsCurrencyList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
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
                你当前位置：游戏用户 - 游戏豆管理
            </td>
        </tr>
    </table>
     <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="titleQueBg">
        <tr>
            <td>
                &nbsp;&nbsp;用户帐号：<asp:TextBox ID="txtSearch" runat="server" CssClass="text" Text=""></asp:TextBox>
                &nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnQuery" runat="server" Text="查询" CssClass="btn wd1" OnClick="btnQuery_Click" />
                &nbsp;
                <asp:Button ID="btnRefresh" runat="server" Text="刷新" CssClass="btn wd1" OnClick="btnRefresh_Click" />
            </td>
        </tr>
    </table>
    <div id="content">
         <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="box Tmg7" id="list">
            <tr align="center" class="bold">
                <td class="listTitle">用户标识</td>
                <td class="listTitle2">游戏ID</td>
                <td class="listTitle2">用户帐号</td>
                <td class="listTitle2"><a href="Javascript:void(0);" onclick='OrderBy("Currency")' class="l1">游戏豆</a></td>
            </tr>
            <asp:Repeater ID="rpDataList" runat="server">
                <ItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td><%# Eval( "UserID" )%></td>
                        <td>
                            <%# GetGameID( Convert.ToInt32( Eval( "UserID" ) ) ) %>
                        </td>
                        <td title="<%# GetAccounts(int.Parse(Eval( "UserID" ).ToString()))%>">
                            <a class="l" href="javascript:void(0);" onclick="openWindowOwn('AccountsInfo.aspx?param=<%#Eval("UserID").ToString() %>','<%#Eval("UserID").ToString() %>',850,600);">
                                <%# GetAccounts(int.Parse(Eval( "UserID" ).ToString( ))) %></a>
                        </td>
                        <td><%# Eval( "Currency" )%></td>
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr align="center" class="listBg" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td><%# Eval( "UserID" )%></td>
                        <td>
                            <%# GetGameID( Convert.ToInt32( Eval( "UserID" ) ) ) %>
                        </td>
                       <td title="<%# GetAccounts(int.Parse(Eval( "UserID" ).ToString()))%>">
                            <a class="l" href="javascript:void(0);" onclick="openWindowOwn('AccountsInfo.aspx?param=<%#Eval("UserID").ToString() %>','<%#Eval("UserID").ToString() %>',850,600);">
                                <%# GetAccounts(int.Parse(Eval( "UserID" ).ToString( ))) %></a>
                        </td>
                        <td><%# Eval( "Currency" )%></td>
                    </tr>
                </AlternatingItemTemplate>
            </asp:Repeater>
            <asp:Literal runat="server" ID="litNoData" Visible="false" Text="<tr class='tdbg'><td colspan='5' align='center'><br>没有任何信息!<br><br></td></tr>"></asp:Literal>
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
                    NumericButtonCount="5" CustomInfoHTML="总记录：%RecordCount%　页码：%CurrentPageIndex%/%PageCount%　每页：%PageSize%" UrlPaging="true">
                </gsp:AspNetPager>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

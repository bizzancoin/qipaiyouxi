<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AgentChildList.aspx.cs" Inherits="Game.Web.Module.AgentManager.AgentChildList" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link href="/styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/scripts/common.js"></script>
    <script type="text/javascript" src="/scripts/comm.js"></script>
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
                你当前位置：代理系统 - 注册信息
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="titleQueBg">
        <tr>
            <td align="center"  style="width: 80px">
                代理商查询：
            </td>
            <td>
                <asp:TextBox ID="txtSearch" runat="server" CssClass="text" ToolTip="输入代理编号、游戏帐号、游戏ID或真实姓名"></asp:TextBox>
                <asp:CheckBox ID="ckbIsLike" runat="server" Text="模糊查询" />
                <asp:Button ID="btnQuery" runat="server" Text="查询" CssClass="btn wd1" OnClick="btnQuery_Click" />    
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
                    用户帐号
                </td>
                <td class="listTitle2">
                    游戏ID
                </td>
                <td class="listTitle2">
                    推荐时间
                </td>
                <td class="listTitle2">
                    代理商
                </td>
                <td class="listTitle2">
                    税收贡献
                </td>   
                <td class="listTitle2">
                    充值贡献
                </td>                         
            </tr>
            <asp:Repeater ID="rptDataList" runat="server">
                <ItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td title="<%# Eval( "Accounts" ).ToString()%>">
                            <a class="l" href="javascript:void(0);" onclick="openWindowOwn('/Module/AccountManager/AccountsInfo.aspx?param=<%#Eval("UserID").ToString() %>','<%#Eval("UserID").ToString() %>',850,600);">
                                <%#Eval( "Accounts" )%></a>
                        </td>
                        <td>
                            <%# Eval( "GameID" ) %>
                        </td>
                        <td>
                            <%# Eval( "RegisterDate" ) %>
                        </td>  
                        <td title="<%# GetAccounts((int)Eval( "SpreaderID" ))%>">
                            <a class="l" href="javascript:void(0);" onclick="openWindowOwn('AgentManager.aspx?param=<%#Eval("SpreaderID").ToString() %>','<%#Eval("SpreaderID").ToString() %>',850,670);">
                                <%#GetAccounts((int)Eval( "SpreaderID" ))%></a>
                        </td> 
                        <td>                            
                            <a class="l" href="javascript:void(0);" onclick="openWindowOwn('ChildRevenueInfo.aspx?param=<%#Eval("UserID").ToString() %>','ChildRevenue_<%#Eval("UserID").ToString() %>',850,600);">
                                <%# GetChildRevenueProvide((int)Eval("UserID")) %></a>
                        </td>  
                        <td>
                            <a class="l" href="javascript:void(0);" onclick="openWindowOwn('ChildPayInfo.aspx?param=<%#Eval("UserID").ToString() %>','ChildPay_<%#Eval("UserID").ToString() %>',850,600);">
                                <%# GetChildPayProvide((int)Eval("UserID")) %></a>
                        </td>        
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr align="center" class="listBg" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td title="<%# Eval( "Accounts" ).ToString()%>">
                            <a class="l" href="javascript:void(0);" onclick="openWindowOwn('/Module/AccountManager/AccountsInfo.aspx?param=<%#Eval("UserID").ToString() %>','<%#Eval("UserID").ToString() %>',850,600);">
                                <%#Eval( "Accounts" )%></a>
                        </td>
                        <td>
                            <%# Eval( "GameID" ) %>
                        </td>                         
                        <td>
                            <%# Eval( "RegisterDate" ) %>
                        </td>  
                        <td title="<%# GetAccounts((int)Eval( "SpreaderID" ))%>">
                            <a class="l" href="javascript:void(0);" onclick="openWindowOwn('AgentManager.aspx?param=<%#Eval("SpreaderID").ToString() %>','<%#Eval("SpreaderID").ToString() %>',850,670);">
                                <%#GetAccounts((int)Eval( "SpreaderID" ))%></a>
                        </td> 
                        <td>                            
                            <a class="l" href="javascript:void(0);" onclick="openWindowOwn('ChildRevenueInfo.aspx?param=<%#Eval("UserID").ToString() %>','ChildRevenue_<%#Eval("UserID").ToString() %>',850,600);">
                                <%# GetChildRevenueProvide((int)Eval("UserID")) %></a>
                        </td>  
                        <td>
                            <a class="l" href="javascript:void(0);" onclick="openWindowOwn('ChildPayInfo.aspx?param=<%#Eval("UserID").ToString() %>','ChildPay_<%#Eval("UserID").ToString() %>',850,600);">
                                <%# GetChildPayProvide((int)Eval("UserID")) %></a>
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

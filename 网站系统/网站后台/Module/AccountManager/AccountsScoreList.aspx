<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AccountsScoreList.aspx.cs" Inherits="Game.Web.Module.AccountManager.AccountsScoreList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="../../scripts/common.js"></script>

    <script type="text/javascript" src="../../scripts/comm.js"></script>

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
                你当前位置：用户系统 - 积分管理
            </td>
        </tr>
    </table>
    <!-- 头部菜单 End -->
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="titleQueBg">
        <tr>
            <td class="listTdLeft" style="width: 80px">
                普通查询：
            </td>
            <td>
                <asp:TextBox ID="txtSearch" runat="server" CssClass="text"></asp:TextBox>
                 <asp:DropDownList ID="ddlSearchType" runat="server" >
                 <asp:ListItem Value="1">按用户帐号</asp:ListItem>
                 <asp:ListItem Value="2">按游戏ID</asp:ListItem>
                 <asp:ListItem Value="3">按积分大于等于</asp:ListItem>
                 <asp:ListItem Value="4">按积分小于等于</asp:ListItem>
                 </asp:DropDownList>                
                 <asp:DropDownList ID="ddlGame" runat="server" ></asp:DropDownList>
                <asp:Button ID="btnQuery" runat="server" Text="查询" CssClass="btn wd1" OnClick="btnQuery_Click" />
                <asp:Button ID="btnRefresh" runat="server" Text="刷新" CssClass="btn wd1" OnClick="btnRefresh_Click" />
            </td>           
        </tr>
    </table>
    <div id="content">
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="box Tmg7" id="list">
            <tr align="center" class="bold">
                <td class="listTitle2">
                    用户标识
                </td>
                <td class="listTitle2">
                    游戏ID
                </td>
                <td class="listTitle2">
                    用户帐号
                </td>
                <td class="listTitle2">
                    积分
                </td>
                <td class="listTitle2">
                    赢局
                </td>
                <td class="listTitle2">
                    输局
                </td>
                <td class="listTitle2">
                    和局
                </td>
                <td class="listTitle2">
                    逃局
                </td>
                <td class="listTitle2">
                    登录次数
                </td>
                <td class="listTitle2">
                    游戏时长
                </td>
                <td class="listTitle2">
                    在线时长
                </td>
                <td class="listTitle2">
                    最后登录时间
                </td>
                <td class="listTitle2">
                    最后登录地址
                </td>
            </tr>
            <asp:Repeater ID="rptDataList" runat="server">
                <ItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td>
                            <%# Eval( "UserID" ).ToString( )%>
                        </td>
                          <td>
                            <%#GetGameID(int.Parse( Eval( "UserID" ).ToString( )))%>
                        </td>
                        <td title="<%# GetAccounts(int.Parse(Eval( "UserID" ).ToString()))%>">
                            <a class="l" href="javascript:void(0);" onclick="openWindowOwn('AccountsScoreInfo.aspx?param=<%#Eval("UserID").ToString() %>','<%#Eval("UserID").ToString() %>',850,600);">
                                <%# GetAccounts(int.Parse(Eval( "UserID" ).ToString( ))) %></a>
                        </td>
                        <td>
                            <%# Eval( "Score" ).ToString( )%>
                        </td>
                        <td>
                            <%# Eval( "WinCount" ).ToString( )%>
                        </td>
                        <td>
                            <%# Eval( "LostCount" ).ToString( )%>
                        </td>
                        <td>
                            <%# Eval( "DrawCount" ).ToString( )%>
                        </td>
                        <td>
                            <%# Eval( "FleeCount" ).ToString( )%>
                        </td>
                        <td>
                            <%# Eval( "AllLogonTimes" ).ToString( )%>
                        </td>
                        <td>
                            <%# Eval( "PlayTimeCount" ).ToString( )%>
                        </td>
                        <td>
                            <%# Eval( "OnLineTimeCount" ).ToString( )%>
                        </td>
                        <td>
                            <%# Eval( "LastLogonDate" ).ToString()%>
                        </td>
                        <td title="<%# GetAddressWithIP( Eval("LastLogonIP").ToString())%>">
                            <%#Game.Utils.TextUtility.CutString( GetAddressWithIP( Eval( "LastLogonIP" ).ToString( ) ), 0, 6 )%>
                        </td>
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr align="center" class="listBg" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td>
                            <%# Eval( "UserID" ).ToString( )%>
                        </td>
                          <td>
                            <%#GetGameID(int.Parse( Eval( "UserID" ).ToString( )))%>
                        </td>
                        <td title="<%# GetAccounts(int.Parse(Eval( "UserID" ).ToString()))%>">
                            <a class="l" href="javascript:void(0);" onclick="openWindowOwn('AccountsScoreInfo.aspx?param=<%#Eval("UserID").ToString() %>','<%#Eval("UserID").ToString() %>',850,600);">
                                <%# GetAccounts(int.Parse(Eval( "UserID" ).ToString( ))) %></a>
                        </td>
                        <td>
                            <%# Eval( "Score" ).ToString( )%>
                        </td>                       
                        <td>
                            <%# Eval( "WinCount" ).ToString( )%>
                        </td>
                        <td>
                            <%# Eval( "LostCount" ).ToString( )%>
                        </td>
                        <td>
                            <%# Eval( "DrawCount" ).ToString( )%>
                        </td>
                        <td>
                            <%# Eval( "FleeCount" ).ToString( )%>
                        </td>
                        <td>
                            <%# Eval( "AllLogonTimes" ).ToString( )%>
                        </td>
                        <td>
                            <%# Eval( "PlayTimeCount" ).ToString( )%>
                        </td>
                        <td>
                            <%# Eval( "OnLineTimeCount" ).ToString( )%>
                        </td>
                        <td>
                            <%# Eval( "LastLogonDate" ).ToString()%>
                        </td>
                        <td title="<%# GetAddressWithIP( Eval("LastLogonIP").ToString())%>">
                            <%#Game.Utils.TextUtility.CutString( GetAddressWithIP( Eval( "LastLogonIP" ).ToString( ) ), 0, 6 )%>
                        </td>
                    </tr>
                </AlternatingItemTemplate>
            </asp:Repeater>
            <asp:Literal runat="server" ID="litNoData" Visible="false" Text="<tr class='tdbg'><td colspan='100' align='center'><br>没有任何信息!<br><br></td></tr>"></asp:Literal>
            <asp:Literal runat="server" ID="litNoSelect" Visible="false" Text="<tr class='tdbg'><td colspan='100' align='center'><br>默认不显示数据，请选择游戏后查询!<br><br></td></tr>"></asp:Literal>
        </table>
    </div>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="listTitleBg" style="">
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

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AccountsControlList.aspx.cs" Inherits="Game.Web.Module.AccountManager.AccountsControlList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
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
                你当前位置：用户系统 - 黑白名单
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="Tmg7">
        <tr>
            <td height="28">
                <ul>
                    <li class="tab2" onclick="Redirect('AccountsControlConfig.aspx')">控制配置</li>
                    <li class="tab1">黑白名单</li>
                    <li class="tab2" onclick="Redirect('AccountsControlRecord.aspx')">控制记录</li>
                </ul>
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
                   <asp:ListItem Value="2">按用户ID</asp:ListItem>
                </asp:DropDownList>                
                <asp:DropDownList ID="ddlControlStatus" runat="server" >
                   <asp:ListItem Value="0">全部</asp:ListItem>
                   <asp:ListItem Value="1">黑名单</asp:ListItem>
                   <asp:ListItem Value="2">白名单</asp:ListItem>
                </asp:DropDownList>  
                <asp:Button ID="btnQuery" runat="server" Text="查询" CssClass="btn wd1" OnClick="btnQuery_Click" />
                <asp:Button ID="btnRefresh" runat="server" Text="刷新" CssClass="btn wd1" OnClick="btnRefresh_Click" />
            </td>           
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="Tmg7">
        <tr>
            <td height="39" class="titleOpBg">
                <input type="button" value="新增" class="btn wd1" onclick="Redirect('AccountsControlInfo.aspx')" />
                <asp:Button ID="Button1" runat="server" Text="删除" CssClass="btn wd1" OnClick="btnDelete_Click" />
            </td>
        </tr>
    </table>
    <div id="content">
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="box Tmg7" id="list">
            <tr align="center" class="bold">
                <td class="listTitle">
                    <input type="checkbox" name="cbxAll" id="cbxAll" />
                </td>
                <td class="listTitle2">
                    管理
                </td>
                <td class="listTitle2">
                    用户标识
                </td>
                <td class="listTitle2">
                    用户帐号
                </td>
                <td class="listTitle2">
                    控制状态
                </td>
                <td class="listTitle2">
                    控制类型
                </td>
                <td class="listTitle2">
                    激活时间
                </td>
                <td class="listTitle2">
                    退出名单输赢金币配置
                </td>
                <td class="listTitle2">
                    退出名单所需时间配置（秒）
                </td>
                 <td class="listTitle2">
                    已消耗时间
                </td>
                <td class="listTitle2">
                    胜率配置
                </td>
                <td class="listTitle2">
                    赢的金币总数
                </td>
                <td class="listTitle2">
                    输的金币总数
                </td>
            </tr>
            <asp:Repeater ID="rptData" runat="server">
                <ItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td><%# "<input name='cid' type='checkbox' value='" + Eval("UserID") + "'/>"%></td>
                        <td>
                            <a class="l" href="AccountsControlInfo.aspx?param=<%# Eval("UserID").ToString() %>">编辑</a>
                        </td>
                        <td>
                            <%# Eval( "UserID" ).ToString( )%>
                        </td>
                        <td title="<%# GetAccounts(int.Parse(Eval( "UserID" ).ToString()))%>">
                            <a class="l" href="javascript:void(0);" onclick="openWindowOwn('AccountsScoreInfo.aspx?param=<%#Eval("UserID").ToString() %>','<%#Eval("UserID").ToString() %>',850,600);">
                                <%# GetAccounts(int.Parse(Eval("UserID").ToString()))%></a>
                        </td>
                        <td>
                            <%# Convert.ToInt32(Eval("ControlStatus")) == 1 ? "黑名单" : "白名单"%>
                        </td>
                        <td>
                            <%# Convert.ToInt32(Eval("ControlType")) == 1 ? "时间控制" : "金币变更控制"%>
                        </td>
                        <td>
                            <%# Eval("ActiveDateTime").ToString()%>
                        </td>
                        <td>
                            <%# Convert.ToInt64(Eval("ChangeScore")).ToString("N0")%>
                        </td>
                        <td>
                            <%# Eval("SustainedTimeCount").ToString()%>
                        </td>
                        <td>
                            <%# Eval("ConsumeTimeCount").ToString()%>
                        </td>
                        <td>
                            <%# Eval("WinRate").ToString()%> %
                        </td>
                        <td>
                            <%# Convert.ToInt64(Eval("WinScore")).ToString("N0")%>
                        </td>
                        <td>
                            <%# Convert.ToInt64(Eval("LoseScore")).ToString("N0")%>
                        </td>
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr align="center" class="listBg" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td><%# "<input name='cid' type='checkbox' value='" + Eval("UserID") + "'/>"%></td>
                        <td>
                            <a class="l" href="AccountsControlInfo.aspx?param=<%# Eval("UserID").ToString() %>">编辑</a>
                        </td>
                        <td>
                            <%# Eval( "UserID" ).ToString( )%>
                        </td>
                        <td title="<%# GetAccounts(int.Parse(Eval( "UserID" ).ToString()))%>">
                            <a class="l" href="javascript:void(0);" onclick="openWindowOwn('AccountsScoreInfo.aspx?param=<%#Eval("UserID").ToString() %>','<%#Eval("UserID").ToString() %>',850,600);">
                                <%# GetAccounts(int.Parse(Eval("UserID").ToString()))%></a>
                        </td>
                        <td>
                            <%# Convert.ToInt32(Eval("ControlStatus")) == 1 ? "黑名单" : "白名单"%>
                        </td>
                        <td>
                            <%# Convert.ToInt32(Eval("ControlType")) == 1 ? "时间控制" : "金币变更控制"%>
                        </td>
                        <td>
                            <%# Eval("ActiveDateTime").ToString()%>
                        </td>
                        <td>
                            <%# Convert.ToInt64(Eval("ChangeScore")).ToString("N0")%>
                        </td>
                        <td>
                            <%# Eval("SustainedTimeCount").ToString()%>
                        </td>
                        <td>
                            <%# Eval("ConsumeTimeCount").ToString()%>
                        </td>
                        <td>
                            <%# Eval("WinRate").ToString()%> %
                        </td>
                        <td>
                            <%# Convert.ToInt64(Eval("WinScore")).ToString("N0")%>
                        </td>
                        <td>
                            <%# Convert.ToInt64(Eval("LoseScore")).ToString("N0")%>
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

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GameScoreLockerList.aspx.cs" Inherits="Game.Web.Module.AccountManager.GameScoreLockerList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="../../scripts/common.js"></script>

    <title></title>
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
                你当前位置：用户系统 - 正在游戏中玩家
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
                <asp:CheckBox ID="ckbIsLike" runat="server" Text="模糊查询" />
               
                <asp:Button ID="btnQuery" runat="server" Text="查询" CssClass="btn wd1" OnClick="btnQuery_Click" />
                <asp:Button ID="btnRefresh" runat="server" Text="刷新" CssClass="btn wd1" OnClick="btnRefresh_Click" />
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td height="39" class="titleOpBg">
                <asp:Button ID="btnDelete" runat="server" Text="卡线清理" CssClass="btn wd2" OnClick="btnDelete_Click" OnClientClick="return deleteop()" />
            </td>
        </tr>
    </table>
    <div id="content">
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="box" id="list">
            <tr align="center" class="bold">
                <td class="listTitle1">
                    <input type="checkbox" name="chkAll" onclick="SelectAll(this.checked);" />
                </td>
                <td class="listTitle2">
                    序号
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
                    游戏
                </td>
                <td class="listTitle">
                    房间
                </td>
                <td class="listTitle2">
                    登录地址
                </td>
                <td class="listTitle">
                    登录机器
                </td>
                <td class="listTitle2">
                    进入时间
                </td>
                <td class="listTitle">
                    时长
                </td>
            </tr>
            <asp:Repeater ID="rptDataList" runat="server">
                <ItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td style="width: 8px;">
                            <input name='cid' type='checkbox' value='<%# Eval("UserID").ToString()%>' />
                        </td>
                        <td style="width: 8px;">
                            <%# anpPage.PageSize * ( anpPage.CurrentPageIndex - 1 ) + ( Container.ItemIndex + 1 )%>
                        </td>
                        <td>
                            <a class="l" href="GameScoreLockerList.aspx?cmd=del&param=<%#Eval("UserID") %>" onclick="return confirm('确定要删除吗？')">卡线清理</a>
                        </td>
                        <td>
                            <%# Eval( "UserID" ).ToString( )%>
                        </td>
                        <td>
                            <%#GetAccounts(int.Parse( Eval( "UserID" ).ToString( )))%>
                        </td>
                        <td>
                            <%#GetGameKindName(int.Parse( Eval( "KindID" ).ToString( )))%>
                        </td>
                        <td>
                            <%# GetGameRoomName(int.Parse( Eval( "ServerID" ).ToString( )))%>
                        </td>
                        <td title="<%# Eval("EnterIP").ToString()%>">
                           <%# GetAddressWithIP( Eval("EnterIP").ToString())%>
                        </td>                       
                        <td>
                            <%# Eval( "EnterMachine" ).ToString( )%>
                        </td>
                        <td>
                            <%# Eval( "CollectDate", "{0:yyyy-MM-dd HH:mm:ss}" )%>
                        </td>
                        <td>
                            <%# Game.Facade.Fetch.GetTimeSpan(Convert.ToDateTime( Eval( "CollectDate" )),DateTime.Now)%>
                        </td>
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr align="center" class="listBg" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td style="width: 8px;">
                            <input name='cid' type='checkbox' value='<%# Eval("UserID").ToString()%>' />
                        </td>
                        <td style="width: 8px;">
                            <%# anpPage.PageSize * ( anpPage.CurrentPageIndex - 1 ) + ( Container.ItemIndex + 1 )%>
                        </td>
                        <td>
                            <a class="l" href="GameScoreLockerList.aspx?cmd=del&param=<%#Eval("UserID") %>" onclick="return confirm('确定要删除吗？')">卡线清理</a>
                        </td>
                        <td>
                            <%# Eval( "UserID" ).ToString( )%>
                        </td>
                        <td>
                            <%#GetAccounts(int.Parse( Eval( "UserID" ).ToString( )))%>
                        </td>
                        <td>
                            <%#GetGameKindName(int.Parse( Eval( "KindID" ).ToString( )))%>
                        </td>
                        <td>
                            <%# GetGameRoomName(int.Parse( Eval( "ServerID" ).ToString( )))%>
                        </td>
                        <td title="<%# Eval("EnterIP").ToString()%>">
                           <%# GetAddressWithIP( Eval("EnterIP").ToString())%>
                        </td>   
                        <td>
                            <%# Eval( "EnterMachine" ).ToString( )%>
                        </td>
                        <td>
                            <%# Eval( "CollectDate", "{0:yyyy-MM-dd HH:mm:ss}" )%>
                        </td>
                        <td>
                            <%# Game.Facade.Fetch.GetTimeSpan(Convert.ToDateTime( Eval( "CollectDate" )),DateTime.Now)%>
                        </td>
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
                <gsp:AspNetPager  ID="anpPage" onpagechanged="anpPage_PageChanged" runat="server" AlwaysShow="true" FirstPageText="首页" LastPageText="末页" PageSize="20" NextPageText="下页"
                    PrevPageText="上页" ShowBoxThreshold="0" ShowCustomInfoSection="Left" LayoutType="Table" NumericButtonCount="5" CustomInfoHTML="总记录：%RecordCount%　页码：%CurrentPageIndex%/%PageCount%　每页：%PageSize%"
                    UrlPaging="false">
                </gsp:AspNetPager>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" id="OpList">
        <tr>
            <td height="39" class="titleOpBg">
                <asp:Button ID="btnDelete1" runat="server" Text="删除" CssClass="btn wd1" OnClick="btnDelete_Click" OnClientClick="return deleteop()" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

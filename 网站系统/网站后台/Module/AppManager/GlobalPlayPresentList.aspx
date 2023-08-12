<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GlobalPlayPresentList.aspx.cs" Inherits="Game.Web.Module.AppManager.GlobalPlayPresentList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="../../scripts/common.js"></script>

    <script type="text/javascript" src="../../scripts/comm.js"></script>

    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="title">
        <tr>
            <td width="19" height="25" valign="top" class="Lpd10">
                <div class="arr">
                </div>
            </td>
            <td width="1232" height="25" valign="top" align="left">
                你当前位置：系统维护 - 泡点设置
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="Tmg7">
        <tr>
            <td height="39" class="titleOpBg">
                <input type="button" id="btnNew" value="新建" class="btn wd1" onclick="Redirect('GlobalPlayPresentInfo.aspx');" />
                <asp:Button ID="btnDelete" runat="server" Text="删除" CssClass="btn wd1" OnClick="btnDelete_Click" OnClientClick="return deleteop()" />
                <input type="button" id="btnSet" value="封顶设置" class="btn wd2" onclick="Redirect('GlobalPlayPresentInfo.aspx?param=-3');" />
            </td>
        </tr>
    </table>
    <div id="content">
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="box" id="list">
            <tr align="center" class="bold">
                <td class="listTitle">
                    <input type="checkbox" name="chkAll" onclick="SelectAll(this.checked);" />
                </td>
                <td class="listTitle2">
                    管理
                </td>
                <td class="listTitle2">
                    房间名称
                </td>
                <td class="listTitle2">
                    赠送对象
                </td>
                <td class="listTitle2">
                    游戏泡分单元值
                </td>
                <td class="listTitle2">
                    游戏泡分单元时间
                </td>
                <td class="listTitle2">
                    游戏泡分启始时间
                </td>
                <td class="listTitle2">
                    在线泡分单元值
                </td>
                <td class="listTitle2">
                    在线泡分单元时间
                </td>
                <td class="listTitle2">
                    在线泡分启始时间
                </td>
                <td class="listTitle2">
                    游戏泡分状态
                </td>
                <td class="listTitle2">
                    在线泡分状态
                </td>
                <td class="listTitle2">
                    收录时间
                </td>
            </tr>
            <asp:Repeater ID="rptDataList" runat="server">
                <ItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td>
                            <%# "<input name='cid' type='checkbox' value='" + Eval( "ServerID" ) + "'/>" %>
                        </td>
                        <td>
                            <a href="GlobalPlayPresentInfo.aspx?param=<%# Eval("ServerID").ToString()%>" class="l">更新</a>
                        </td>
                        <td>
                            <%#GetRoomName(int.Parse( Eval("ServerID").ToString()))%>
                        </td>
                        <td>
                           <%#GetMemberList( Eval( "PresentMember" ).ToString())%>
                        </td>
                        <td>
                            <%# Eval( "CellPlayPresnet" )%>
                        </td>
                        <td>
                            <%# Eval( "CellPlayTime" )%>
                        </td>
                        <td>
                            <%# Eval( "StartPlayTime" )%>
                        </td>
                        <td>
                            <%# Eval( "CellOnlinePresent" )%>
                        </td>
                        <td>
                            <%# Eval( "CellOnlineTime" )%>
                        </td>
                        <td>
                            <%# Eval( "StartOnlineTime" )%>
                        </td>
                        <td>
                            <%#int.Parse( Eval( "IsPlayPresent" ).ToString( ) ) == 0 ? "关闭" : "启用"%>
                        </td>
                        <td>
                            <%#int.Parse(Eval( "IsOnlinePresent" ).ToString())==0?"关闭":"启用" %>
                        </td>
                        <td>
                            <%# Eval( "CollectDate","{0:yyyy-MM-dd HH:mm:ss}" )%>
                        </td>
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td>
                            <%# "<input name='cid' type='checkbox' value='" + Eval( "ServerID" ) + "'/>" %>
                        </td>
                        <td>
                            <a href="GlobalPlayPresentInfo.aspx?param=<%# Eval("ServerID").ToString()%>" class="l">更新</a>
                        </td>
                        <td>
                            <%#GetRoomName(int.Parse( Eval("ServerID").ToString()))%>
                        </td>
                        <td>
                            <%#GetMemberList( Eval( "PresentMember" ).ToString())%>
                        </td>
                        <td>
                            <%# Eval( "CellPlayPresnet" )%>
                        </td>
                        <td>
                            <%# Eval( "CellPlayTime" )%>
                        </td>
                        <td>
                            <%# Eval( "StartPlayTime" )%>
                        </td>
                        <td>
                            <%# Eval( "CellOnlinePresent" )%>
                        </td>
                        <td>
                            <%# Eval( "CellOnlineTime" )%>
                        </td>
                        <td>
                            <%# Eval( "StartOnlineTime" )%>
                        </td>
                        <td>
                            <%#int.Parse( Eval( "IsPlayPresent" ).ToString( ) ) == 0 ? "关闭" : "启用"%>
                        </td>
                        <td>
                            <%#int.Parse(Eval( "IsOnlinePresent" ).ToString())==0?"关闭":"启用" %>
                        </td>
                        <td>
                            <%# Eval( "CollectDate","{0:yyyy-MM-dd HH:mm:ss}" )%>
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
                <gsp:AspNetPager ID="anpNews" runat="server" OnPageChanged="anpNews_PageChanged" AlwaysShow="true" FirstPageText="首页" LastPageText="末页"
                    PageSize="20" NextPageText="下页" PrevPageText="上页" ShowBoxThreshold="0" ShowCustomInfoSection="Left" LayoutType="Table"
                    NumericButtonCount="5" CustomInfoHTML="总记录：%RecordCount%　页码：%CurrentPageIndex%/%PageCount%　每页：%PageSize%">
                </gsp:AspNetPager>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" id="OpList">
        <tr>
            <td height="39" class="titleOpBg">
                <input type="button" id="btnNew1" value="新建" class="btn wd1" />
                <asp:Button ID="btnDelete2" runat="server" Text="删除" CssClass="btn wd1" OnClick="btnDelete_Click" OnClientClick="return deleteop()" />
                <input type="button" id="btnSet2" value="封顶设置" class="btn wd2" onclick="Redirect('GlobalPlayPresentInfo.aspx?param=-3');"/>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

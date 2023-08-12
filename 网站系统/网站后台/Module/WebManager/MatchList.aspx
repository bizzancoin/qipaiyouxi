<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MatchList.aspx.cs" Inherits="Game.Web.Module.WebManager.MatchList" %>

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
                你当前位置：网站系统 - 比赛管理
            </td>
        </tr>
    </table>
   <!-- 
   <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="Tmg7">
        <tr>
            <td height="28">
                <ul>
                    <li class="tab1">赛事管理</li>
                    <li class="tab2" onclick="Redirect('MatchUserList.aspx')">用户管理</li>
                </ul>
            </td>
        </tr>
    </table>
    -->
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td height="39" class="titleOpBg">
                <input type="button" value="新增" class="btn wd1" onclick="Redirect('MatchInfo.aspx')" />
                <input class="btnLine" type="button" />
                <asp:Button ID="btnDel" runat="server" Text="删除" CssClass="btn wd1" OnClick="btnDel_Click" OnClientClick="return deleteop()" />
                <asp:Button ID="btnDisable" runat="server" Text="冻结" CssClass="btn wd1" OnClick="btnDisable_Click" OnClientClick="return deleteop()" />
                <asp:Button ID="btnEnable" runat="server" Text="解冻" CssClass="btn wd1" OnClick="btnEnable_Click" OnClientClick="return deleteop()" />
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
                    比赛标识
                </td>
                <td class="listTitle2">
                    比赛名称
                </td>
                <td class="listTitle2">
                    比赛时间
                </td>
                <td class="listTitle2">
                    赛事状态
                </td>
                <td class="listTitle2">
                    冻结状态
                </td>
                <td class="listTitle2">
                    新增日期
                </td>
            </tr>
            <asp:Repeater ID="rptDataList" runat="server">
                <ItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td>
                            <input name='cid' type='checkbox' value='<%# Eval("MatchID")%>' />
                        </td>
                        <td>
                            <a href="MatchInfo.aspx?param=<%#  Eval( "MatchID" ).ToString( )%>" class="l">更新</a>
                        </td>
                        <td>
                            <%#  Eval( "MatchID" ).ToString( )%>
                        </td>
                        <td>
                            <%# Eval( "MatchName" )%>
                        </td>
                      
                        <td>
                            <%# Eval( "MatchDate" )%>
                        </td>
                        <td>
                            <%# GetMatchStatus( byte.Parse( Eval( "MatchStatus" ).ToString( ) ) )%>
                        </td>
                        <td>
                            <%# GetNullityStatus(byte.Parse(  Eval( "Nullity" ).ToString( )))%>
                        </td>
                        <td>
                            <%# Eval( "CollectDate", "{0:yyyy-MM-dd HH:mm:ss}" )%>
                        </td>
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td>
                            <input name='cid' type='checkbox' value='<%# Eval("MatchID")%>' />
                        </td>
                        <td>
                            <a href="MatchInfo.aspx?param=<%#  Eval( "MatchID" ).ToString( )%>" class="l">更新</a>
                        </td>
                        <td>
                            <%#  Eval( "MatchID" ).ToString( )%>
                        </td>
                        <td>
                            <%# Eval( "MatchName" )%>
                        </td>
                        <td>
                            <%# Eval( "MatchDate" )%>
                        </td>
                        <td>
                            <%# GetMatchStatus( byte.Parse( Eval( "MatchStatus" ).ToString( ) ) )%>
                        </td>
                        <td>
                            <%# GetNullityStatus(byte.Parse(  Eval( "Nullity" ).ToString( )))%>
                        </td>
                        <td>
                            <%# Eval( "CollectDate", "{0:yyyy-MM-dd HH:mm:ss}" )%>
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
            </td>
            <td align="right" class="page">
                <gsp:AspNetPager ID="anpNews" runat="server" OnPageChanged="anpNews_PageChanged" AlwaysShow="true" FirstPageText="首页" LastPageText="末页"
                    PageSize="20" NextPageText="下页" PrevPageText="上页" ShowBoxThreshold="0" ShowCustomInfoSection="Left" LayoutType="Table"
                    NumericButtonCount="5" CustomInfoHTML="总记录：%RecordCount%　页码：%CurrentPageIndex%/%PageCount%　每页：%PageSize%">
                </gsp:AspNetPager>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td height="39" class="titleOpBg">
                <input type="button" value="新增" class="btn wd1" onclick="Redirect('MatchInfo.aspx')" />
                <input class="btnLine" type="button" />
                <asp:Button ID="btnDel1" runat="server" Text="删除" CssClass="btn wd1" OnClick="btnDel_Click" OnClientClick="return deleteop()" />
                <asp:Button ID="btnDisable1" runat="server" Text="冻结" CssClass="btn wd1" OnClick="btnDisable_Click" OnClientClick="return deleteop()" />
                <asp:Button ID="btnEnable1" runat="server" Text="解冻" CssClass="btn wd1" OnClick="btnEnable_Click" OnClientClick="return deleteop()" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

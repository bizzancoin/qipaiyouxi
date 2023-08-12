<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SpreadInfo.aspx.cs" Inherits="Game.Web.Module.AppManager.SpreadInfo" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id=Head1 runat="server">
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../../scripts/common.js"></script>
    <script type="text/javascript" src="../../scripts/comm.js"></script>
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
                你当前位置：推广管理 - 贡献明细
            </td>
        </tr>
    </table>
    <div id="content">
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="box Tmg7" id="list">
            <tr align="center" class="bold">
            <!-- 收集日期 推广人 游戏币 类型 收集备注  -->
                <td class="listTitle2">
                    收集日期
                </td>
                <td class="listTitle2">
                    推广人
                </td>
                <td class="listTitle2">
                    游戏币
                </td>
                <td class="listTitle2">
                    类型
                </td>
                <td class="listTitle2">
                    收集备注
                </td>
            </tr>
            <asp:Repeater ID="rptDataList" runat="server">
                <ItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td>
                            <%# Eval( "CollectDate" ).ToString()%>
                        </td>
                        <td>
                            <%# GetAccounts( Convert.ToInt32( Eval( "UserID" ) ) )%></a>
                        </td>
                        <td>
                            <%# FormatMoney(Eval( "Score" ).ToString( ))%>
                        </td>
                        <td>
                            <%# Enum.GetName(typeof( Game.Facade.EnumerationList.SpreadTypes) ,Eval( "TypeID" ) )%>
                        </td>
                        <td>
                            <%# Eval( "CollectNote" ).ToString( )%>
                        </td>
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                           <td>
                            <%# Eval( "CollectDate" ).ToString()%>
                        </td>
                        <td>
                            <%# GetAccounts( Convert.ToInt32( Eval( "UserID" ) ) )%></a>
                        </td>
                        <td>
                            <%# FormatMoney(Eval( "Score" ).ToString( ))%>
                        </td>
                        <td>
                            <%# Enum.GetName(typeof( Game.Facade.EnumerationList.SpreadTypes) ,Eval( "TypeID" ) )%>
                        </td>
                        <td>
                            <%# Eval( "CollectNote" ).ToString( )%>
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
    </form>
</body>
</html>
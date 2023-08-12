<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FinanceInfo.aspx.cs" Inherits="Game.Web.Module.AppManager.FinanceInfo" %>

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
                你当前位置：系统维护 - 财务明细
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="Tmg7">
        <tr>
            <td height="28">
                <ul>
                    <li class="tab2" onclick="Redirect('SpreadSet.aspx')">推广管理</li>
                    <li class="tab2" onclick="Redirect('SpreadManager.aspx')">推广明细</li>
                    <li class="tab1">财务明细</li>
                </ul>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="titleQueBg">
        <tr>
            <td class="listTdLeft" style="width: 80px">
                用户查询：
            </td>
            <td>
                <asp:TextBox ID="txtKeyword" runat="server" CssClass="text"></asp:TextBox>
                <asp:DropDownList ID="ddlSearchtype" runat="server">
                    <asp:ListItem Value="0">按用户帐号</asp:ListItem>
                    <asp:ListItem Value="1">按游戏ID</asp:ListItem>
                </asp:DropDownList>
                <asp:Button ID="btnSearch" runat="server" Text="查询" CssClass="btn wd1" OnClick="btnSearch_OnClick" />
                 <asp:Button ID="btnRefresh" runat="server" Text="刷新" CssClass="btn wd1" OnClick="btnRefresh_Click" />
            </td>
        </tr>
    </table>
    <div id="content">
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="box Tmg7" id="list">
            <tr align="center" class="bold">
                <td class="listTitle2">
                    收集日期
                </td>
                <td class="listTitle2">
                    帐号
                </td>
                <td class="listTitle2">
                    收入
                </td>
                <td class="listTitle2">
                    支出
                </td>
                <td class="listTitle2">
                    类型
                </td>
                <td class="listTitle2">
                    被推广人(ID)
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
                            <%# Eval( "CollectDate", "{0:yyyy-MM-dd HH:mm:ss}" )%>
                        </td>
                        <td>
                            <%# GetAccounts(int.Parse( Eval( "UserID" ).ToString()))%>
                        </td>
                        <td>
                            <%#int.Parse( Eval( "Score" ).ToString( ) ) < 0 ? "" : FormatMoney(Eval( "Score" ).ToString( ))%>
                        </td>
                        <td>
                            <%#int.Parse( Eval( "Score" ).ToString( ) ) > 0 ? "" : FormatMoney(( Convert.ToInt32( Eval( "Score" ) ) * ( -1 ) ).ToString( ))%>
                        </td>
                        <td>
                             <%# Enum.GetName(typeof( Game.Facade.EnumerationList.SpreadTypes) ,Eval( "TypeID" ) )%>
                        </td>
                        <td>
                            <%# int.Parse( Eval( "ChildrenID" ).ToString( ) ) > 0 ? GetAccounts( int.Parse( Eval( "ChildrenID" ).ToString( ) ) ): ""%>
                        </td>
                        <td>
                            <%# Eval( "CollectNote" )%>
                        </td>
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td>
                            <%# Eval( "CollectDate", "{0:yyyy-MM-dd HH:mm:ss}" )%>
                        </td>
                        <td>
                            <%# GetAccounts(int.Parse( Eval( "UserID" ).ToString()))%>
                        </td>
                        <td>
                            <%#int.Parse( Eval( "Score" ).ToString( ) ) < 0 ? "" : FormatMoney(Eval( "Score" ).ToString( ))%>
                        </td>
                        <td>
                            <%#int.Parse( Eval( "Score" ).ToString( ) ) > 0 ? "" : FormatMoney(( Convert.ToInt32( Eval( "Score" ) ) * ( -1 ) ).ToString( ))%>
                        </td>
                        <td>
                             <%# Enum.GetName(typeof( Game.Facade.EnumerationList.SpreadTypes) ,Eval( "TypeID" ) )%>
                        </td>
                        <td>
                           <%# int.Parse( Eval( "ChildrenID" ).ToString( ) ) > 0 ? GetAccounts( int.Parse( Eval( "ChildrenID" ).ToString( ) ) ) : ""%>
                        </td>
                        <td>
                            <%# Eval( "CollectNote" )%>
                        </td>
                    </tr>
                </AlternatingItemTemplate>
            </asp:Repeater>
             <asp:Panel ID="plPayStat" runat="server">
                <tr>
                    <td colspan="2" style="height:40px;" class="bold">合计：</td>
                    <td class="bold"><asp:Literal ID="ltGainGold" runat="server"></asp:Literal></td>
                    <td class="bold"><asp:Literal ID="ltExpendGold" runat="server"></asp:Literal></td>    
                    <td colspan="3"></td>
                </tr>
            </asp:Panel>
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
    </form>
</body>
</html>

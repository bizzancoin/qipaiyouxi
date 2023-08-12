<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AccountsInsureList.aspx.cs" Inherits="Game.Web.Module.AccountManager.AccountsInsureList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="../../scripts/common.js"></script>

    <script type="text/javascript" src="../../scripts/comm.js"></script>

    <script type="text/javascript" src="../../scripts/My97DatePicker/WdatePicker.js"></script>

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
                你当前位置：用户系统 - 银行记录
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="titleQueBg">
        <tr>
            <td class="listTdLeft" style="width: 80px">
                普通查询：
            </td>
            <td>
                <asp:TextBox ID="txtSearch" runat="server" CssClass="text"></asp:TextBox>
                <asp:DropDownList ID="ddlSearchType" runat="server">
                    <asp:ListItem Value="1">按汇款用户帐号</asp:ListItem>
                    <asp:ListItem Value="2">按汇款游戏ID</asp:ListItem>
                    <asp:ListItem Value="3">按收款用户帐号</asp:ListItem>
                    <asp:ListItem Value="4">按收款游戏ID</asp:ListItem>
                    <asp:ListItem Value="5">游戏ID</asp:ListItem>
                    <asp:ListItem Value="6">房间ID</asp:ListItem>
                </asp:DropDownList>
                日期：
                <asp:TextBox ID="txtStartDate" runat="server" CssClass="text wd2" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'txtEndDate\')}'})"></asp:TextBox><img
                    src="../../Images/btn_calendar.gif" onclick="WdatePicker({el:'txtStartDate',dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'txtEndDate\')}'})"
                    style="cursor: pointer; vertical-align: middle" />
                至
                <asp:TextBox ID="txtEndDate" runat="server" CssClass="text wd2" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'txtStartDate\')}'})"></asp:TextBox><img
                    src="../../Images/btn_calendar.gif" onclick="WdatePicker({el:'txtEndDate',dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'txtStartDate\')}'})"
                    style="cursor: pointer; vertical-align: middle" />
                <asp:DropDownList ID="ddlTradeType" runat="server">
                    <asp:ListItem Value="0" Text="全部"></asp:ListItem>
                    <asp:ListItem Value="1" Text="存款"></asp:ListItem>
                    <asp:ListItem Value="2" Text="取款"></asp:ListItem>
                    <asp:ListItem Value="3" Text="转账"></asp:ListItem>
                </asp:DropDownList>
                <asp:Button ID="btnQuery" runat="server" Text="查询" CssClass="btn wd1" OnClick="btnQuery_Click" />
                <asp:Button ID="btnQueryTD" runat="server" Text="今天" CssClass="btn wd1" OnClick="btnQueryTD_Click" />
                <asp:Button ID="btnQueryYD" runat="server" Text="昨天" CssClass="btn wd1" OnClick="btnQueryYD_Click" />
                <asp:Button ID="btnQueryTW" runat="server" Text="本周" CssClass="btn wd1" OnClick="btnQueryTW_Click" />
                <asp:Button ID="btnQueryYW" runat="server" Text="上周" CssClass="btn wd1" OnClick="btnQueryYW_Click" />
                <input type="button" value="转账税收TOP100" class="btn" style="width:120px;" onclick="javascript:openWindowOwn('AccountsInsureTop.aspx', 'AccountsInsureTop', 700, 500);" />
            </td>
        </tr>
    </table>
    <div id="content">
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="box Tmg7" id="list">
            <tr align="center" class="bold">
                <td class="listTitle">
                    时间
                </td>
                <td class="listTitle2">
                    汇款人
                </td>
                <td class="listTitle2">
                    收款人
                </td>
                <td class="listTitle2">
                    交易类型
                </td>
                <td class="listTitle2">
                    汇款人现金
                </td>
                <td class="listTitle2">
                    汇款人银行
                </td>
                <td class="listTitle2">
                    收款人现金
                </td>
                <td class="listTitle2">
                    收款人银行
                </td>
                <td class="listTitle2">
                    交易游戏币
                </td>
                <td class="listTitle2">
                    服务费
                </td>
                <td class="listTitle2">
                    操作场所
                </td>
                <td class="listTitle2">
                    操作地址
                </td>
                <td class="listTitle2">
                    游戏
                </td>
                <td class="listTitle2">
                    房间
                </td>
                <td class="listTitle1">
                    备注
                </td>
            </tr>
            <asp:Repeater ID="rptInsure" runat="server" OnItemDataBound="rptInsure_ItemDataBound">
                <ItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td>
                            <%# Eval("CollectDate")%>
                        </td>
                        <td>
                            <a class="l" href="javascript:void(0);" onclick="openWindowOwn('AccountsInfo.aspx?param=<%#Eval("SourceUserID").ToString() %>','<%#Eval("SourceUserID").ToString() %>',850,600);">
                            <%# GetAccounts((int)Eval("SourceUserID"))%>
                            </a>
                        </td>
                        <td>
                            <a class="l" href="javascript:void(0);" onclick="openWindowOwn('AccountsInfo.aspx?param=<%#Eval("TargetUserID").ToString() %>','<%#Eval("TargetUserID").ToString() %>',850,600);">
                            <%# (byte)Eval("TradeType") == 3 ? GetAccounts((int)Eval("TargetUserID")) : ""%>
                            </a>
                        </td>
                        <td>
                            <asp:Label ID="lblTradeType" runat="server"></asp:Label>
                        </td>
                        <td>
                            <%# Convert.ToInt64( Eval( "SourceGold" ) ).ToString( "N0" )%>
                        </td>
                        <td>
                            <%# Convert.ToInt64( Eval( "SourceBank" ) ).ToString( "N0" )%>
                        </td>
                        <td>
                            <%# (byte)Eval( "TradeType" ) == 3 ? Convert.ToInt64( Eval( "TargetGold" ) ).ToString( "N0" ) : ""%>
                        </td>
                        <td>
                            <%# (byte)Eval( "TradeType" ) == 3 ? Convert.ToInt64( Eval( "TargetBank" ) ).ToString( "N0" ) : ""%>
                        </td>
                        <td>
                            <%# Convert.ToInt64( Eval( "SwapScore" ) ).ToString( "N0" )%>
                        </td>
                        <td>
                            <%# Convert.ToInt64( Eval( "Revenue" ) ).ToString( "N0" )%>
                        </td>
                        <td>
                            <%# (byte)Eval("IsGamePlaza") == 0 ? "大厅" : "网页"%>
                        </td>
                        <td title=" <%# Eval( "ClientIP" ).ToString( )%>">
                            <%# GetAddressWithIP( Eval( "ClientIP" ).ToString( ) )%>
                        </td>
                        <td>
                            <%# GetGameKindName((int)Eval("KindID"))%>
                        </td>
                        <td>
                            <%# GetGameRoomName((int)Eval("ServerID"))%>
                        </td>
                        <td>
                            <%# Eval("CollectNote")%>
                        </td>
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr align="center" class="listBg" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td>
                            <%# Eval("CollectDate")%>
                        </td>
                        <td>
                            <a class="l" href="javascript:void(0);" onclick="openWindowOwn('AccountsInfo.aspx?param=<%#Eval("SourceUserID").ToString() %>','<%#Eval("SourceUserID").ToString() %>',850,600);">
                            <%# GetAccounts((int)Eval("SourceUserID"))%>
                            </a>
                        </td>
                        <td>
                            <a class="l" href="javascript:void(0);" onclick="openWindowOwn('AccountsInfo.aspx?param=<%#Eval("TargetUserID").ToString() %>','<%#Eval("TargetUserID").ToString() %>',850,600);">
                            <%# (byte)Eval("TradeType") == 3 ? GetAccounts((int)Eval("TargetUserID")) : ""%>
                            </a>
                        </td>
                        <td>
                            <asp:Label ID="lblTradeType" runat="server"></asp:Label>
                        </td>
                        <td>
                            <%# Convert.ToInt64( Eval( "SourceGold" ) ).ToString( "N0" )%>
                        </td>
                        <td>
                            <%# Convert.ToInt64( Eval( "SourceBank" ) ).ToString( "N0" )%>
                        </td>
                        <td>
                            <%# (byte)Eval( "TradeType" ) == 3 ? Convert.ToInt64( Eval( "TargetGold" ) ).ToString( "N0" ) : ""%>
                        </td>
                        <td>
                            <%# (byte)Eval( "TradeType" ) == 3 ? Convert.ToInt64( Eval( "TargetBank" ) ).ToString( "N0" ) : ""%>
                        </td>
                        <td>
                            <%# Convert.ToInt64( Eval( "SwapScore" ) ).ToString( "N0" )%>
                        </td>
                        <td>
                            <%# Convert.ToInt64( Eval( "Revenue" ) ).ToString( "N0" )%>
                        </td>
                        <td>
                            <%# (byte)Eval("IsGamePlaza") == 0 ? "大厅" : "网页"%>
                        </td>
                        <td title=" <%# Eval( "ClientIP" ).ToString( )%>">
                             <%# GetAddressWithIP( Eval( "ClientIP" ).ToString( ) )%>
                        </td>
                        <td>
                            <%# GetGameKindName((int)Eval("KindID"))%>
                        </td>
                        <td>
                            <%# GetGameRoomName((int)Eval("ServerID"))%>
                        </td>
                        <td>
                            <%# Eval("CollectNote")%>
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

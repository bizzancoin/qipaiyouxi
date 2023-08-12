<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RecordConvertPresentList.aspx.cs" Inherits="Game.Web.Module.AccountManager.RecordConvertPresentList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="../../scripts/common.js"></script>

    <script type="text/javascript" src="../../scripts/My97DatePicker/WdatePicker.js"></script>

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
                你当前位置：用户系统 - 魅力兑换记录
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="titleQueBg">
        <tr>
            <td class="listTdLeft" style="width: 80px">
                日期查询：
            </td>
            <td>
                <asp:TextBox ID="txtStartDate" runat="server" CssClass="text wd2" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'txtEndDate\')}'})"></asp:TextBox><img
                    src="../../Images/btn_calendar.gif" onclick="WdatePicker({el:'txtStartDate',dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'txtEndDate\')}'})"
                    style="cursor: pointer; vertical-align: middle" />
                至
                <asp:TextBox ID="txtEndDate" runat="server" CssClass="text wd2" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'txtStartDate\')}'})"></asp:TextBox><img
                    src="../../Images/btn_calendar.gif" onclick="WdatePicker({el:'txtEndDate',dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'txtStartDate\')}'})"
                    style="cursor: pointer; vertical-align: middle" />
                <asp:Button ID="btnQuery" runat="server" Text="查询" CssClass="btn wd1" OnClick="btnQuery_Click" />
                <asp:Button ID="btnRefresh" runat="server" Text="刷新" CssClass="btn wd1" OnClick="btnRefresh_Click" />
                <asp:Button ID="btnQueryTD" runat="server" Text="今天" CssClass="btn wd1" OnClick="btnQueryTD_Click" />
                <asp:Button ID="btnQueryYD" runat="server" Text="昨天" CssClass="btn wd1" OnClick="btnQueryYD_Click" />
                <asp:Button ID="btnQueryTW" runat="server" Text="本周" CssClass="btn wd1" OnClick="btnQueryTW_Click" />
                <asp:Button ID="btnQueryYW" runat="server" Text="上周" CssClass="btn wd1" OnClick="btnQueryYW_Click" />
            </td>
        </tr>
    </table>
    <div id="content">
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="box Tmg7" id="list">
            <tr align="center" class="bold">
                <td class="listTitle2">
                    序号
                </td>               
                <td class="listTitle2">
                    游戏
                </td>
                <td class="listTitle2">
                    房间
                </td>
                <td class="listTitle2">
                    兑换前保险柜游戏币
                </td>
                <td class="listTitle2">
                    兑换后保险柜游戏币
                </td>
                <td class="listTitle2">
                    兑换前魅力点
                </td>
                <td class="listTitle2">
                    兑换点数
                </td>
                <td class="listTitle2">
                    兑换比例
                </td>
                <td class="listTitle2">
                    兑换场所
                </td>
                <td class="listTitle2">
                    地址
                </td>
                <td class="listTitle">
                    兑换日期
                </td>
            </tr>
            <asp:Repeater ID="rptDataList" runat="server">
                <ItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td>
                            <%# anpNews.PageSize * ( anpNews.CurrentPageIndex - 1 ) + ( Container.ItemIndex + 1 )%>
                        </td>                      
                        <td>
                            <%#GetGameKindName(int.Parse( Eval( "KindID" ).ToString( )))%>
                        </td>
                        <td>
                            <%#GetGameRoomName(int.Parse( Eval( "ServerID" ).ToString()) )%>
                        </td>
                       <td>
                            <%# Convert.ToInt64( Eval( "CurInsureScore" ) ).ToString( "N0" )%>
                        </td>
                        <td>
                            <%# ( Convert.ToInt64( Eval( "CurInsureScore" ) ) + Convert.ToInt64( Eval( "ConvertPresent" ) ) * Convert.ToInt64( Eval( "ConvertRate" ) ) ).ToString( "N0" )%>
                        </td>
                        <td>
                            <%# Convert.ToInt64( Eval( "CurPresent" ) ).ToString( "N0" )%>
                        </td>
                        <td>
                            <%# Convert.ToInt64( Eval( "ConvertPresent" ) ).ToString( "N0" )%>
                        </td>
                        <td>
                            <%# Eval( "ConvertRate" ).ToString( )%>
                        </td>
                        <td>
                            <%#GetExchangePlace(int.Parse( Eval( "IsGamePlaza" ).ToString()) )%>
                        </td>
                        <td>
                            <%# GetAddressWithIP( Eval( "ClientIP" ).ToString( ) )%>
                        </td>
                        <td>
                            <%# Eval( "CollectDate", "{0:yyyy-MM-dd HH:mm:ss}" )%>
                        </td>
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr align="center" class="listBg" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td>
                            <%# anpNews.PageSize * ( anpNews.CurrentPageIndex - 1 ) + ( Container.ItemIndex + 1 )%>
                        </td>                       
                        <td>
                            <%#GetGameKindName(int.Parse( Eval( "KindID" ).ToString( )))%>
                        </td>
                        <td>
                            <%#GetGameRoomName(int.Parse( Eval( "ServerID" ).ToString()) )%>
                        </td>
                        <td>
                            <%# Convert.ToInt64( Eval( "CurInsureScore" ) ).ToString( "N0" )%>
                        </td>
                        <td>
                            <%# ( Convert.ToInt64( Eval( "CurInsureScore" ) ) + Convert.ToInt64( Eval( "ConvertPresent" ) ) * Convert.ToInt64( Eval( "ConvertRate" ) ) ).ToString( "N0" )%>
                        </td>
                        <td>
                            <%# Convert.ToInt64( Eval( "CurPresent" ) ).ToString( "N0" )%>
                        </td>
                        <td>
                            <%# Convert.ToInt64( Eval( "ConvertPresent" ) ).ToString( "N0" )%>
                        </td>
                        <td>
                            <%# Eval( "ConvertRate" ).ToString( )%>
                        </td>
                        <td>
                            <%#GetExchangePlace( int.Parse( Eval( "IsGamePlaza" ).ToString() ) )%>
                        </td>
                        <td>
                            <%# GetAddressWithIP( Eval( "ClientIP" ).ToString( ) )%>
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
            <td align="right" class="page">
                <gsp:AspNetPager ID="anpNews" runat="server" AlwaysShow="true" FirstPageText="首页" LastPageText="末页" PageSize="20" NextPageText="下页"
                    PrevPageText="上页" ShowBoxThreshold="0" ShowCustomInfoSection="Left" LayoutType="Table" NumericButtonCount="5" CustomInfoHTML="总记录：%RecordCount%　页码：%CurrentPageIndex%/%PageCount%　每页：%PageSize%"
                    UrlPaging="True">
                </gsp:AspNetPager>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

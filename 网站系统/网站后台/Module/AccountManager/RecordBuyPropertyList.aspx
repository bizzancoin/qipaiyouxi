<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RecordBuyPropertyList.aspx.cs" Inherits="Game.Web.Module.AccountManager.RecordBuyPropertyList" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/scripts/common.js"></script>
    <script type="text/javascript" src="/scripts/comm.js"></script>
    <script type="text/javascript" src="/scripts/My97DatePicker/WdatePicker.js"></script>
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
                你当前位置：用户系统 - 道具使用记录
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="Tmg7">
        <tr>
            <td height="28">
                <ul>
                    <li class="tab2" onclick="Redirect('RecordUsePropertyList.aspx')">使用记录</li>
                    <li class="tab1">购买记录</li>
                </ul>
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
                    src="/Images/btn_calendar.gif" onclick="WdatePicker({el:'txtStartDate',dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'txtEndDate\')}'})"
                    style="cursor: pointer; vertical-align: middle" />
                至
                <asp:TextBox ID="txtEndDate" runat="server" CssClass="text wd2" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'txtStartDate\')}'})"></asp:TextBox><img
                    src="/Images/btn_calendar.gif" onclick="WdatePicker({el:'txtEndDate',dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'txtStartDate\')}'})"
                    style="cursor: pointer; vertical-align: middle" />
                <asp:Button ID="btnQuery" runat="server" Text="查询" CssClass="btn wd1" OnClick="btnQuery_Click" />

                用户查询：
                <asp:TextBox ID="txtSearch" runat="server" CssClass="text"></asp:TextBox>
                <asp:Button ID="Button1" runat="server" Text="查询" CssClass="btn wd1" OnClick="btnQuery1_Click" />
                <asp:Button ID="btnRefresh" runat="server" Text="刷新" CssClass="btn wd1" OnClick="btnRefresh_Click" />
            </td>
        </tr>
    </table>
    <div id="content">
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="box Tmg7" id="list">
            <tr align="center" class="bold">
                <td class="listTitle2">
                    序号
                </td>
                <td class="listTitle">
                    道具名称
                </td>
                <td class="listTitle">
                    购买帐号
                </td>
                <td class="listTitle">
                    游戏豆价格
                </td>
                <td class="listTitle2">
                    游戏币价格
                </td>
                <td class="listTitle2">
                    元宝价格
                </td>
                <td class="listTitle2">
                    魅力值价格
                </td>
                <td class="listTitle2">
                    购买数量
                </td>
                <td class="listTitle2">
                    会员折扣
                </td>
                 <td class="listTitle2">
                    花费游戏豆
                </td>
                <td class="listTitle2">
                    花费游戏币
                </td>
                <td class="listTitle2">
                    花费元宝
                </td>
                <td class="listTitle2">
                    花费魅力值
                </td>
                <td class="listTitle2">
                    地址
                </td>
                <td class="listTitle2">
                    时间
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
                            <%# Eval("PropertyName")%>
                        </td>
                        <td title="<%# GetAccounts(int.Parse(Eval( "UserID" ).ToString()))%>">
                            <a class="l" href="javascript:void(0);" onclick="openWindowOwn('AccountsInfo.aspx?param=<%#Eval("UserID").ToString() %>','<%#Eval("UserID").ToString() %>',850,600);">
                                <%# GetAccounts(int.Parse(Eval("UserID").ToString()))%></a>
                        </td>                        
                        <td>
                            <%# Eval("Cash").ToString()%>
                        </td>
                        <td>
                            <%# Eval("Gold").ToString()%>
                        </td>
                        <td>
                            <%# Eval("UserMedal").ToString()%>
                        </td>
                        <td>
                            <%# Eval("LoveLiness").ToString()%>
                        </td>
                        <td>
                            <%# Eval("PropertyCount").ToString()%>
                        </td>
                        <td>
                            <%# Convert.ToInt32(Eval("MemberDiscount"))%>%
                        </td>
                        <td>
                            <%# Eval("BuyCash").ToString()%>
                        </td>
                        <td>
                            <%# Eval("BuyGold").ToString()%>
                        </td>
                        <td>
                            <%# Eval("BuyUserMedal").ToString()%>
                        </td>
                        <td>
                            <%# Eval("BuyLoveLiness").ToString()%>
                        </td>                        
                        <td title="<%# Eval( "ClinetIP" ).ToString( )%>">
                           <%# GetAddressWithIP( Eval( "ClinetIP" ).ToString( ) )%>
                        </td>
                        <td>
                            <%# Eval("CollectDate").ToString()%>
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
                            <%# Eval("PropertyName")%>
                        </td>
                        <td title="<%# GetAccounts(int.Parse(Eval( "UserID" ).ToString()))%>">
                            <a class="l" href="javascript:void(0);" onclick="openWindowOwn('AccountsInfo.aspx?param=<%#Eval("UserID").ToString() %>','<%#Eval("UserID").ToString() %>',850,600);">
                                <%# GetAccounts(int.Parse(Eval("UserID").ToString()))%></a>
                        </td>                        
                        <td>
                            <%# Eval("Cash").ToString()%>
                        </td>
                        <td>
                            <%# Eval("Gold").ToString()%>
                        </td>
                        <td>
                            <%# Eval("UserMedal").ToString()%>
                        </td>
                        <td>
                            <%# Eval("LoveLiness").ToString()%>
                        </td>
                        <td>
                            <%# Eval("PropertyCount").ToString()%>
                        </td>
                        <td>
                            <%# Convert.ToInt32(Eval("MemberDiscount"))%>%
                        </td>
                        <td>
                            <%# Eval("BuyCash").ToString()%>
                        </td>
                        <td>
                            <%# Eval("BuyGold").ToString()%>
                        </td>
                        <td>
                            <%# Eval("BuyUserMedal").ToString()%>
                        </td>
                        <td>
                            <%# Eval("BuyLoveLiness").ToString()%>
                        </td>                        
                        <td title="<%# Eval( "ClinetIP" ).ToString( )%>">
                           <%# GetAddressWithIP( Eval( "ClinetIP" ).ToString( ) )%>
                        </td>
                        <td>
                            <%# Eval("CollectDate").ToString()%>
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

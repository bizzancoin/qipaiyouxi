<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LivcardBuildStreamList.aspx.cs" Inherits="Game.Web.Module.FilledManager.LivcardBuildStreamList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="../../scripts/common.js"></script>

    <script type="text/javascript" src="../../scripts/comm.js"></script>

    <script type="text/javascript" src="../../scripts/jquery.js"></script>

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
                你当前位置：充值系统 - 实卡管理
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="Tmg7">
        <tr>
            <td height="28">
                <ul>
                    <li class="tab1">会员卡管理</li>
                    <li class="tab2" onclick="Redirect('LivcardCreate.aspx')">会员卡生成</li>
                    <li class="tab2" onclick="Redirect('LivcardStat.aspx')">库存统计</li>
                    <li class="tab2" onclick="Redirect('GlobalLivcardList.aspx')">类型管理</li>
                </ul>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="titleQueBg">
        <tr>
            <td class="listTdLeft" style="width: 80px">
                批次查询：
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
                <input type="button" onclick='openWindowOwn("LivcardAssociatorList.aspx?param=0","1",900,580)' value="全部实卡信息" class="btn wd1" style="width:100px;"/>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="titleQueBg Tmg7">
        <tr>
            <td class="listTdLeft" style="width: 80px">
                卡号查询：
            </td>
            <td>
                <input id="txtSearch" class="text" />
                <input id="btnShow" type="button" class="btn wd1" value="查询" />
                销售商查询：
                <asp:TextBox ID="txtsalesperson" runat="server" CssClass="text"></asp:TextBox>
                <asp:Button ID="btnQuery2" runat="server" Text="查询" CssClass="btn wd1" OnClick="btnQuery2_Click" />
            </td>
        </tr>
    </table>
    <div id="content">
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="box Tmg7" id="list">
            <tr align="center" class="bold">
                <td class="listTitle2">
                    生产批次
                </td>
                <td class="listTitle2">
                    生成日期
                </td>
                <td class="listTitle2">
                    管理员
                </td>
                <td class="listTitle2">
                    销售商
                </td>
                <td class="listTitle2">
                    实卡名称
                </td>
                <td class="listTitle2">
                    实卡数量
                </td>
                <td class="listTitle2">
                    实卡价格
                </td>
                <td class="listTitle1">
                    总金额
                </td>
                <td class="listTitle2">
                    赠送游戏豆
                </td>
                <td class="listTitle2">
                    赠送游戏币
                </td>
                <td class="listTitle2">
                    地址
                </td>
                <td class="listTitle2">
                    导出次数
                </td>
                <td class="listTitle2">
                    备注
                </td>
                <td class="listTitle1">
                    管理
                </td>
            </tr>
            <asp:Repeater ID="rptDataList" runat="server">
                <ItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td>
                            <%# Eval( "BuildID" ).ToString()%>
                        </td>
                        <td>
                            <%# Eval( "BuildDate","{0:yyyy-MM-dd HH:mm:ss}" )%>
                        </td>
                        <td>
                            <%# Eval( "AdminName" ).ToString( )%>
                        </td>
                        <td>
                            <%# GetSalesperson(int.Parse(Eval( "BuildID" ).ToString( )))%>
                        </td>
                        <td>
                            <%# GetCardTypeName(int.Parse(Eval( "CardTypeID" ).ToString()))%>
                        </td>
                        <td>
                            <%# Eval( "BuildCount" ).ToString( )%>
                        </td>
                        <td>
                            <%# Eval( "CardPrice" ).ToString( )%>
                        </td>
                        <td>
                            <%# int.Parse( Eval( "BuildCount" ).ToString( ) ) * double.Parse( Eval( "CardPrice" ).ToString( ) )%>
                        </td>
                        <td>
                            <%# Eval( "Currency" ).ToString( )%>
                        </td>
                        <td>
                            <%# Eval( "Gold" ).ToString()%>
                        </td>
                        <td>
                            <%# Eval( "BuildAddr" ).ToString( )%>
                        </td>
                        <td>
                            <%# Eval( "DownLoadCount" ).ToString( )%>
                        </td>
                        <td>
                            <%# Eval( "NoteInfo" ).ToString( )%>
                        </td>
                        <td>
                            <a href="?cmd=export&param=<%# Eval( "BuildID" ).ToString()%>" class="l">实卡导出</a>
                            <a href="javascript:void(0)" onclick="openWindowOwn('LivcardAssociatorList.aspx?param=<%# Eval( "BuildID" ).ToString()%>', <%# Eval( "BuildID" ).ToString()%>,800,580)"
                                class="l">实卡信息</a>
                        </td>
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td>
                            <%# Eval( "BuildID" ).ToString()%>
                        </td>
                        <td>
                            <%# Eval( "BuildDate","{0:yyyy-MM-dd HH:mm:ss}" )%>
                        </td>
                        <td>
                            <%# Eval( "AdminName" ).ToString( )%>
                        </td>
                        <td>
                            <%# GetSalesperson(int.Parse(Eval( "BuildID" ).ToString( )))%>
                        </td>
                        <td>
                            <%# GetCardTypeName(int.Parse(Eval( "CardTypeID" ).ToString()) )%>
                        </td>
                        <td>
                            <%# Eval( "BuildCount" ).ToString( )%>
                        </td>
                        <td>
                            <%# Eval( "CardPrice" ).ToString( )%>
                        </td>
                        <td>
                            <%# int.Parse( Eval( "BuildCount" ).ToString( ) ) * double.Parse( Eval( "CardPrice" ).ToString( ) )%>
                        </td>
                        <td>
                             <%# Eval( "Currency" ).ToString()%>
                        </td>
                        <td>
                            <%# Eval( "Gold" ).ToString()%>
                        </td>
                        <td>
                            <%# Eval( "BuildAddr" ).ToString( )%>
                        </td>
                        <td>
                            <%# Eval( "DownLoadCount" ).ToString( )%>
                        </td>
                        <td>
                            <%# Eval( "NoteInfo" ).ToString( )%>
                        </td>
                        <td>
                            <a href="?cmd=export&param=<%# Eval( "BuildID" ).ToString()%>" class="l">实卡导出</a>
                            <a href="javascript:void(0)" onclick="openWindowOwn('LivcardAssociatorList.aspx?param=<%# Eval( "BuildID" ).ToString()%>', <%# Eval( "BuildID" ).ToString()%>,800,580)"
                                class="l">实卡信息</a>
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

    <script>
        $(document).ready(function() {
            $("#btnShow").click(function() {
                var txtkey = $("#txtSearch").val();
                if (txtkey == '') {
                    showError("请输入要查询的卡号");
                    return;
                }
                openWindow('LivcardAssociatorInfo.aspx?param=' + txtkey, 700, 500);
            });
        });
    </script>

    </form>
</body>
</html>

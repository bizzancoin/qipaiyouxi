<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LivcardAssociatorList.aspx.cs"
    Inherits="Game.Web.Module.FilledManager.LivcardAssociatorList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="../../scripts/common.js"></script>

    <script type="text/javascript" src="../../scripts/comm.js"></script>

    <script type="text/javascript">
        function selectitem() {
            var cid = "";
            var cids = GelTags("input");
            for (var i = 0; i < cids.length; i++) {
                if (cids[i].checked)
                    cid += cids[i].value + ",";
            }
            if (cid == "") {
                alert("未选中任何数据");
                return false;
            }
            else
                return confirm('确认要批量操作选中记录吗？');
        }

        function EditManager() {
            var cid = "";
            var cids = GelTags("input");
            for (var i = 0; i < cids.length; i++) {
                if (cids[i].checked)
                    cid += cids[i].value + ",";
            }
            if (cid == "") {
                alert("未选中任何数据");
                return false;
            }
            //操作处理
            cid = cid.substring(0, cid.length - 1);
            openWindowOwn('LivcardEdit.aspx?buildid=<%= IntParam%>&param=' + cid, '_LivcardEdit', 600, 300);
        }
    </script>

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
                你当前位置：充值系统 - 实卡列表
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="titleQueBg">
        <tr>
            <td class="listTdLeft" style="width: 80px">
                快速查询：
            </td>
            <td>
                <a href="javascript:void(0);" onclick="Redirect('LivcardAssociatorList.aspx?param='+GetRequest('param',0)+'&cmd=1')"
                    class="l">已使用</a> | <a href="javascript:void(0);" onclick="Redirect('LivcardAssociatorList.aspx?param='+GetRequest('param',0)+'&cmd=2')"
                        class="l">未使用</a> | <a href="javascript:void(0);" onclick="Redirect('LivcardAssociatorList.aspx?param='+GetRequest('param',0)+'&cmd=3')"
                            class="l">已禁用</a> | <a href="javascript:void(0);" onclick="Redirect('LivcardAssociatorList.aspx?param='+GetRequest('param',0)+'&cmd=4')"
                                class="l">未禁用</a> | <a href="javascript:void(0);" onclick="Redirect('LivcardAssociatorList.aspx?param='+GetRequest('param',0)+'&cmd=0')"
                                    class="l">全部</a>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="Tmg7">
        <tr>
            <td height="39" class="titleOpBg">
                <input type="button" value="关闭" class="btn wd1" onclick="window.close()" />
                <input class="btnLine" type="button" />
                <asp:Button ID="btnDisable" runat="server" Text="禁用" CssClass="btn wd1" OnClick="btnDisable_Click"
                    OnClientClick="return selectitem()" />
                <asp:Button ID="btnEnable" runat="server" Text="启用" CssClass="btn wd1" OnClick="btnEnable_Click"
                    OnClientClick="return selectitem()" />
                <input type="button" value="批量修改" class="btn wd2" onclick="EditManager()" runat="server"
                    id="btBatch" />
            </td>
        </tr>
    </table>
    <div id="content">
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="box Tmg7"
            id="list">
            <tr align="center" class="bold">
                <td class="listTitle">
                    <input type="checkbox" name="chkAll" onclick="SelectAll(this.checked);" />
                </td>
                <td class="listTitle2">
                    卡号
                </td>
                <td class="listTitle2">
                    实卡名称
                </td>
                <td class="listTitle2">
                    实卡价格
                </td>
                <td class="listTitle2">
                    赠送游戏豆
                </td>
                <td class="listTitle2">
                    赠送游戏币
                </td>
                <td class="listTitle2">
                    有效期限
                </td>
                <td class="listTitle1">
                    充值日期
                </td>
                <td class="listTitle1">
                    使用范围
                </td>
                <td class="listTitle1">
                    销售商
                </td>
                <td class="listTitle1">
                    禁用状态
                </td>
            </tr>
            <asp:Repeater ID="rptDataList" runat="server">
                <ItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td>
                            <%# "<input name='cid' type='checkbox' value='" + Eval( "CardID" ) + "'/>"%>
                        </td>
                        <td>
                            <a href="javascript:void(0)" onclick="javascript:openWindow('LivcardAssociatorInfo.aspx?param=<%# Eval( "SerialID" ).ToString( )%>',700,500)"
                                class="l">
                                <%# Eval( "SerialID" ).ToString( )%></a>
                        </td>
                        <td>
                            <%# GetCardTypeName(int.Parse(Eval( "CardTypeID" ).ToString( )))%>
                        </td>
                        <td>
                            <%# Eval( "CardPrice" ).ToString( )%>
                        </td>
                        <td>
                            <%# Eval( "Currency" ).ToString( )%>
                        </td>
                        <td>
                            <%# Eval( "Gold" ).ToString()%>
                        </td>
                        <td>
                            <%# Eval( "ValidDate", "{0:yyyy-MM-dd HH:mm:ss}" )%>
                        </td>
                        <td>
                            <%# Eval( "ApplyDate", "{0:yyyy-MM-dd HH:mm:ss}" )%>
                        </td>
                        <td>
                            <%# GetUserRange((int)Eval( "UseRange" ))%>
                        </td>
                        <td>
                            <%# Eval( "SalesPerson" ).ToString( )%>
                        </td>
                        <td>
                            <%# GetNullityStatus((byte)Eval( "Nullity" ))%>
                        </td>
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td>
                            <%# "<input name='cid' type='checkbox' value='" + Eval( "CardID" ) + "'/>"%>
                        </td>
                        <td>
                            <a href="javascript:void(0)" onclick="javascript:openWindow('LivcardAssociatorInfo.aspx?param=<%# Eval( "SerialID" ).ToString( )%>',700,500)"
                                class="l">
                                <%# Eval( "SerialID" ).ToString( )%></a>
                        </td>
                        <td>
                            <%# GetCardTypeName(int.Parse(Eval( "CardTypeID" ).ToString( )))%>
                        </td>
                        <td>
                            <%# Eval( "CardPrice" ).ToString( )%>
                        </td>
                        <td>
                            <%# Eval( "Currency" ).ToString()%>
                        </td>
                        <td>
                            <%# Eval( "Gold" ).ToString()%>
                        </td>
                        <td>
                            <%# Eval( "ValidDate", "{0:yyyy-MM-dd HH:mm:ss}" )%>
                        </td>
                        <td>
                            <%# Eval( "ApplyDate", "{0:yyyy-MM-dd HH:mm:ss}" )%>
                        </td>
                        <td>
                            <%# GetUserRange((int)Eval( "UseRange" ))%>
                        </td>
                        <td>
                            <%# Eval( "SalesPerson" ).ToString( )%>
                        </td>
                        <td>
                            <%# GetNullityStatus((byte)Eval( "Nullity" ))%>
                        </td>
                    </tr>
                </AlternatingItemTemplate>
            </asp:Repeater>
            <asp:Literal runat="server" ID="litNoData" Visible="false" Text="<tr class='tdbg'><td colspan='100' align='center'><br>没有任何信息!<br><br></td></tr>"></asp:Literal>
            <tr>
                <td colspan="12" style="height: 30px; font-size: 12px" align="left">
                    <asp:Literal ID="ltStat" runat="server"></asp:Literal>
                </td>
            </tr>
        </table>
    </div>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="listTitleBg">
                <span>选择：</span>&nbsp;<a class="l1" href="javascript:SelectAll(true);">全部</a>&nbsp;-&nbsp;<a
                    class="l1" href="javascript:SelectAll(false);">无</a>
            </td>
            <td align="right" class="page">
                <gsp:AspNetPager ID="anpNews" runat="server" OnPageChanged="anpNews_PageChanged"
                    AlwaysShow="true" FirstPageText="首页" LastPageText="末页" PageSize="20" NextPageText="下页"
                    PrevPageText="上页" ShowBoxThreshold="0" ShowCustomInfoSection="Left" LayoutType="Table"
                    NumericButtonCount="5" CustomInfoHTML="总记录：%RecordCount%　页码：%CurrentPageIndex%/%PageCount%　每页：%PageSize%">
                </gsp:AspNetPager>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

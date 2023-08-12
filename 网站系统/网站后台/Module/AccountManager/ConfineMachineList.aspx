<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ConfineMachineList.aspx.cs" Inherits="Game.Web.Module.AccountManager.ConfineMachineList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="/scripts/common.js"></script>
    <script type="text/javascript" src="/scripts/comm.js"></script>
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
                你当前位置：用户系统 - 限制机器码
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
                <asp:TextBox ID="txtSearch" runat="server" CssClass="text" ToolTip="输入机器码"></asp:TextBox>
                <asp:CheckBox ID="ckbIsLike" runat="server" Text="模糊查询" />
                <asp:Button ID="btnQuery" runat="server" Text="查询" CssClass="btn wd1" OnClick="btnQuery_Click" />
                <asp:Button ID="btnRefresh" runat="server" Text="刷新" CssClass="btn wd1" OnClick="btnRefresh_Click" />
                <input type="button" value="机器码注册数TOP100" class="btn" style="width:120px;" onclick="javascript:openWindowOwn('ConfineMachineTop.aspx', 'ConfineMachiineTop', 700, 500);" />
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="Tmg7">
        <tr>
            <td height="39" class="titleOpBg">
                <input type="button" value="新增" class="btn wd1" onclick="Redirect('ConfineMachineInfo.aspx')" />
                <input class="btnLine" type="button" />
                <asp:Button ID="btnDelete" runat="server" Text="删除" CssClass="btn wd1" OnClick="btnDelete_Click" OnClientClick="return deleteop()" />
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
                    限制机器
                </td>
                  <td class="listTitle2">
                    限制登录
                </td>
                <td class="listTitle2">
                    限制注册
                </td>
                <td class="listTitle2">
                    失效时间
                </td>
                <td class="listTitle">
                    录入时间
                </td>
                   <td class="listTitle2">
                    备注
                </td>
            </tr>
            <asp:Repeater ID="rptDataList" runat="server">
                <ItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td style="width: 30px;">
                            <input name='cid' type='checkbox' value='<%# Eval("MachineSerial").ToString()%>' />
                        </td>
                        <td>
                            <%# anpNews.PageSize * ( anpNews.CurrentPageIndex - 1 ) + ( Container.ItemIndex + 1 )%>
                        </td>
                        <td style="width: 100px;">
                            <a class="l" href="<%#"ConfineMachineInfo.aspx?param="+Eval("MachineSerial").ToString()+"&reurl="+ Game.Utils.Utility.CurrentUrl %>">
                                更新</a>
                            <a class="l" href="ConfineMachineList.aspx?cmd=del&param=<%#Eval("MachineSerial") %>" onclick="return confirm('确定要删除吗？')">删除</a>
                        </td>
                        <td>
                            <%# Eval( "MachineSerial" ).ToString( )%>
                        </td>
                        <td>
                            <%# ( ( bool ) Eval( "EnjoinLogon" ) ) ? "<span class='hong'>禁止</span>" : "正常"%>
                        </td>
                        <td>
                            <%# ( ( bool ) Eval( "EnjoinRegister" ) ) ? "<span class='hong'>禁止</span>" : "正常"%>
                        </td>
                        <td>
                             <%# string.IsNullOrEmpty( Eval( "EnjoinOverDate" ).ToString() ) ? "永久限制" : Eval( "EnjoinOverDate", "{0:yyyy-MM-dd HH:mm:ss}" )%>
                        </td>
                        <td>
                            <%# Eval( "CollectDate", "{0:yyyy-MM-dd HH:mm:ss}" )%>
                        </td>
                        <td>
                            <%# Eval( "CollectNote" ).ToString( )%>
                        </td>
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr align="center" class="listBg" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td style="width: 30px;">
                            <input name='cid' type='checkbox' value='<%# Eval("MachineSerial").ToString()%>' />
                        </td>
                        <td>
                            <%# anpNews.PageSize * ( anpNews.CurrentPageIndex - 1 ) + ( Container.ItemIndex + 1 )%>
                        </td>
                        <td style="width: 100px;">
                            <a class="l" href="<%#"ConfineMachineInfo.aspx?param="+Eval("MachineSerial").ToString()+"&reurl="+ Game.Utils.Utility.CurrentUrl %>">
                                更新</a>
                            <a class="l" href="ConfineMachineList.aspx?cmd=del&param=<%#Eval("MachineSerial") %>" onclick="return confirm('确定要删除吗？')">删除</a>
                        </td>
                        <td>
                            <%# Eval( "MachineSerial" ).ToString( )%>
                        </td>
                        <td>
                            <%# ( ( bool ) Eval( "EnjoinLogon" ) ) ? "<span class='hong'>禁止</span>" : "正常"%>
                        </td>
                        <td>
                            <%# ( ( bool ) Eval( "EnjoinRegister" ) ) ? "<span class='hong'>禁止</span>" : "正常"%>
                        </td>
                        <td>
                             <%# string.IsNullOrEmpty( Eval( "EnjoinOverDate" ).ToString() ) ? "永久限制" : Eval( "EnjoinOverDate", "{0:yyyy-MM-dd HH:mm:ss}" )%>
                        </td>
                        <td>
                            <%# Eval( "CollectDate", "{0:yyyy-MM-dd HH:mm:ss}" )%>
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
                <gsp:AspNetPager ID="anpNews" runat="server" AlwaysShow="true" FirstPageText="首页" LastPageText="末页" PageSize="20" NextPageText="下页"
                    PrevPageText="上页" ShowBoxThreshold="0" ShowCustomInfoSection="Left" LayoutType="Table" NumericButtonCount="5" CustomInfoHTML="总记录：%RecordCount%　页码：%CurrentPageIndex%/%PageCount%　每页：%PageSize%"
                    UrlPaging="True">
                </gsp:AspNetPager>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" id="OpList">
        <tr>
            <td height="39" class="titleOpBg">
                <input type="button" value="新增" class="btn wd1" onclick="Redirect('ConfineContenInfo.aspx')" />
                <input class="btnLine" type="button" />
                <asp:Button ID="btnDelete1" runat="server" Text="删除" CssClass="btn wd1" OnClick="btnDelete_Click" OnClientClick="return deleteop()" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

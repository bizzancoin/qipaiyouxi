<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AgentList.aspx.cs" Inherits="Game.Web.Module.AgentManager.AgentList" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="../../scripts/common.js"></script>

    <script type="text/javascript" src="../../scripts/comm.js"></script>
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
                你当前位置：代理系统 - 代理用户
            </td>
        </tr>
    </table>
    <!-- 头部菜单 End -->
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="titleQueBg">
        <tr>
            <td align="center"  style="width: 80px">
                普通查询：
            </td>
            <td>
                <asp:TextBox ID="txtSearch" runat="server" CssClass="text" ToolTip="输入代理编号、游戏帐号、游戏ID或真实姓名"></asp:TextBox>
                <asp:CheckBox ID="ckbIsLike" runat="server" Text="模糊查询" />
                <asp:Button ID="btnQuery" runat="server" Text="查询" CssClass="btn wd1" OnClick="btnQuery_Click" />    
                <asp:Button ID="btnRefresh" runat="server" Text="刷新" CssClass="btn wd1" OnClick="btnRefresh_Click" />            
                <asp:Button ID="btnDay" runat="server" Text="本日" CssClass="btn wd1" OnClick="btnQueryTD_Click"/>
                <asp:Button ID="btnWeek" runat="server" Text="本周" CssClass="btn wd1" OnClick="btnQueryTW_Click"/>
                <asp:Button ID="btnMonth" runat="server" Text="本月" CssClass="btn wd1" OnClick="btnQueryTM_Click"/>
                <asp:Button ID="btnYear" runat="server" Text="本年" CssClass="btn wd1" OnClick="btnQueryTY_Click" />
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="Tmg7">
        <tr>
            <td height="39" class="titleOpBg">
                <input type="button" value="新增" class="btn wd1" onclick="openWindowOwn('AgentInfo.aspx', 'addagent', 700, 600)" />
                <input class="btnLine" type="button" />
                <asp:Button ID="btnDongjie" runat="server" Text="冻结" CssClass="btn wd1" OnClick="btnDongjie_Click" OnClientClick="return deleteop()" />
                <asp:Button ID="btnJiedong" runat="server" Text="解冻" CssClass="btn wd1" OnClick="btnJiedong_Click" OnClientClick="return deleteop()" />        
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
                    代理编号
                </td>
                <td class="listTitle2">
                    游戏ID
                </td>
                <td class="listTitle2">
                    用户帐号
                </td>
                <td class="listTitle2">
                    真实姓名
                </td>
                <td class="listTitle2">
                    代理域名
                </td>
                <td class="listTitle2">
                    分成类型
                </td>
                <td class="listTitle2">
                    分成比例
                </td>                
                <td class="listTitle2">
                    代理时间
                </td>
                <td class="listTitle2">
                    状态
                </td>   
                <td class="listTitle2">
                    备注
                </td>   
                <td class="listTitle2">
                    
                </td>              
            </tr>
            <asp:Repeater ID="rptDataList" runat="server">
                <ItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td style="width: 30px;">
                            <input name='cid' type='checkbox' value='<%# Eval("AgentID").ToString()%>' />
                        </td>
                        <td>
                            <%# Eval( "AgentID" ).ToString( ) %>
                        </td>
                        <td>
                            <%# GetGameID((int)Eval( "UserID" )) %>
                        </td>
                        <td title="<%# GetAccounts((int)Eval( "UserID" ))%>">
                            <a class="l" href="javascript:void(0);" onclick="openWindowOwn('AgentManager.aspx?param=<%#Eval("UserID").ToString() %>','<%#Eval("UserID").ToString() %>',850,670);">
                                <%#Game.Utils.TextUtility.CutString(GetAccounts((int)Eval( "UserID" )),0,10)%></a>
                        </td>  
                        <td>
                            <%# Eval( "Compellation" ) %>
                        </td> 
                        <td>
                            <%# Eval( "Domain" ) %>
                        </td>  
                        <td>
                            <%# (int)Eval( "AgentType" )==1?"充值分成":"税收分成" %>
                        </td>   
                        <td>
                            <%# (int)((decimal)Eval( "AgentScale" )*1000) %>‰
                        </td>                         
                        <td>
                            <%# Eval( "CollectDate" ) %>
                        </td>   
                        <td>
                            <%# GetNullityStatus((byte)Eval("Nullity"))%>
                        </td>
                        <td>
                            <%# Eval( "AgentNote" ) %>
                        </td>    
                        <td>
                            <a class="l" href="javascript:void(0)" onclick="javascript:openWindowOwn('PcGameList.aspx?param=<%#Eval("AgentID").ToString() %>','_PcGameList',800,600);">PC游戏列表</a>
                            <a class="l" href="javascript:void(0)" onclick="javascript:openWindowOwn('MobileGameList.aspx?param=<%#Eval("AgentID").ToString() %>','_MobileGameList',800,600);">手机游戏列表</a>
                        </td>          
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr align="center" class="listBg" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td style="width: 30px;">
                            <input name='cid' type='checkbox' value='<%# Eval("AgentID").ToString()%>' />
                        </td>
                        <td>
                            <%# Eval( "AgentID" ).ToString( ) %>
                        </td>
                        <td>
                            <%# GetGameID((int)Eval( "UserID" )) %>
                        </td>
                        <td title="<%# GetAccounts((int)Eval( "UserID" ))%>">
                            <a class="l" href="javascript:void(0);" onclick="openWindowOwn('AgentManager.aspx?param=<%#Eval("UserID").ToString() %>','<%#Eval("UserID").ToString() %>',850,670);">
                                <%#Game.Utils.TextUtility.CutString(GetAccounts((int)Eval( "UserID" )),0,10)%></a>
                        </td>  
                        <td>
                            <%# Eval( "Compellation" ) %>
                        </td> 
                        <td>
                            <%# Eval( "Domain" ) %>
                        </td>  
                        <td>
                            <%# (int)Eval( "AgentType" )==1?"充值分成":"税收分成" %>
                        </td>   
                        <td>
                            <%# (int)((decimal)Eval( "AgentScale" )*1000) %>‰
                        </td> 
                        <td>
                            <%# Eval( "CollectDate" ) %>
                        </td>   
                        <td>
                            <%# GetNullityStatus((byte)Eval("Nullity"))%>
                        </td>
                        <td>
                            <%# Eval( "AgentNote" ) %>
                        </td>    
                        <td>
                            <a class="l" href="javascript:void(0)" onclick="javascript:openWindowOwn('PcGameList.aspx?param=<%#Eval("AgentID").ToString() %>','_PcGameList',800,600);">PC游戏列表</a>
                            <a class="l" href="javascript:void(0)" onclick="javascript:openWindowOwn('MobileGameList.aspx?param=<%#Eval("AgentID").ToString() %>','_MobileGameList',800,600);">手机游戏列表</a>
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
                <gsp:AspNetPager ID="anpPage" OnPageChanged="anpPage_PageChanged" runat="server" AlwaysShow="true" FirstPageText="首页" LastPageText="末页"
                    PageSize="20" NextPageText="下页" PrevPageText="上页" ShowBoxThreshold="0" ShowCustomInfoSection="Left" LayoutType="Table"
                    NumericButtonCount="5" CustomInfoHTML="总记录：%RecordCount%　页码：%CurrentPageIndex%/%PageCount%　每页：%PageSize%" UrlPaging="false">
                </gsp:AspNetPager>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" id="OpList">
        <tr>
            <td height="39" class="titleOpBg">
                <input type="button" value="新增" class="btn wd1" onclick="openWindowOwn('AgentInfo.aspx', '', 700, 600)" />
                <input class="btnLine" type="button" />
                <asp:Button ID="btnDongjie2" runat="server" Text="冻结" CssClass="btn wd1" OnClick="btnDongjie_Click" OnClientClick="return deleteop()" />
                <asp:Button ID="btnJiedong2" runat="server" Text="解冻" CssClass="btn wd1" OnClick="btnJiedong_Click" OnClientClick="return deleteop()" />              
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

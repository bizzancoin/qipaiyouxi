<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GameGiftSubList.aspx.cs" Inherits="Game.Web.Module.AppManager.GameGiftSubList" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
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
                你当前位置：系统维护 - 礼包管理
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="Tmg7">
        <tr>
            <td height="28">
                <ul>
                    <li class="tab2" onclick="Redirect('GamePropertyManager.aspx')">道具管理</li>
                    <li class="tab2" onclick="Redirect('GamePropertyTypeList.aspx')">类型管理</li>
                    <li class="tab2" onclick="Redirect('GamePropertyRelatList.aspx')">道具关联</li>
                    <li class="tab2" onclick="Redirect('GameGiftList.aspx')">礼包管理</li>
                    <li class="tab1">礼包明细</li>
                </ul>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td height="39" class="titleOpBg">
                <input type="button" value="新增" class="btn wd1" onclick="Redirect('GameGiftSubInfo.aspx?cmd=add&OwnerID=<%=IntParam %>')" />
                <asp:Button ID="btnDelete" runat="server" Text="删除" CssClass="btn wd1" OnClick="btnDelete_Click" OnClientClick="return deleteop()" />                
                <input type="button" value="返回" class="btn wd1" onclick="Redirect('GameGiftList.aspx')" />
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
                    道具名称
                </td>                
                <td class="listTitle2">
                    数量
                </td>                
                <td class="listTitle2">
                    排序
                </td>                
            </tr>
            <asp:Repeater ID="rptDataList" runat="server">
                <ItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td>
                            <%# "<input name='cid' type='checkbox' value='" + Eval( "ID" ) + "'/>" %>
                        </td>
                        <td>
                            <a href="GameGiftSubInfo.aspx?param=<%# Eval("ID").ToString()%>&OwnerID=<%#Eval("OwnerID") %>" class="l">更新</a>
                        </td>
                        <td>
                            <%# GetGamePropertyName((int)Eval( "ID" ))%>
                        </td>                        
                        <td>
                            <%# Eval( "Count" ).ToString( )%>
                        </td>                        
                        <td>
                            <%# Eval( "SortID" )%>
                        </td>                        
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td>
                            <%# "<input name='cid' type='checkbox' value='" + Eval( "ID" ) + "'/>" %>
                        </td>
                        <td>
                            <a href="GameGiftSubInfo.aspx?param=<%# Eval("ID").ToString()%>&OwnerID=<%#Eval("OwnerID") %>" class="l">更新</a>
                        </td>
                        <td>
                            <%# GetGamePropertyName((int)Eval( "ID" ))%>
                        </td>                        
                        <td>
                            <%# Eval( "Count" ).ToString( )%>
                        </td>                        
                        <td>
                            <%# Eval( "SortID" )%>
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
                    PageSize="40" NextPageText="下页" PrevPageText="上页" ShowBoxThreshold="0" ShowCustomInfoSection="Left" LayoutType="Table"
                    NumericButtonCount="5" CustomInfoHTML="总记录：%RecordCount%　页码：%CurrentPageIndex%/%PageCount%　每页：%PageSize%">
                </gsp:AspNetPager>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" id="OpList">
        <tr>
            <td height="39" class="titleOpBg">
                <input type="button" value="新增" class="btn wd1" onclick="Redirect('GameGiftSubInfo.aspx?cmd=add&OwnerID=<%=IntParam %>')" />
                <asp:Button ID="btnDelete2" runat="server" Text="删除" CssClass="btn wd1" OnClick="btnDelete_Click" OnClientClick="return deleteop()" />                
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GameRoomInfoList.aspx.cs" Inherits="Game.Web.Module.AppManager.GameRoomInfoList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../../scripts/common.js"></script>
</head>
<body>
    <form id="form1" runat="server">
    <!-- 头部菜单 Start -->
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="title">
        <tr>
            <td width="19" height="25" valign="top"  class="Lpd10"><div class="arr"></div></td>
            <td width="1232" height="25" valign="top" align="left">你当前位置：游戏系统 - 房间管理</td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="titleQueBg">
        <tr>
            <td class="listTdLeft" style="width: 80px">
                 房间名称：
            </td>
            <td>
                <asp:TextBox ID="txtSearch" runat="server" CssClass="text"></asp:TextBox>                    
                <asp:Button ID="btnQuery" runat="server" Text="查询" CssClass="btn wd1" 
                    onclick="btnQuery_Click" />      
            </td>
        </tr>
    </table>     
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="Tmg7">
        <tr>
            <td height="39" class="titleOpBg">
                <!--<input type="button" value="新增" class="btn wd1" onclick="Redirect('GameRoomInfoInfo.aspx?cmd=add')" />
                <input class="btnLine" type="button" /> -->
                <asp:Button ID="btnDelete" runat="server" Text="删除" CssClass="btn wd1" 
                    onclick="btnDelete_Click" OnClientClick="return deleteop()"/>                
            </td>
        </tr>
    </table>  
    <div id="content">
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="box" id="list">
            <tr align="center" class="bold">
                <td style="width:30px;" class="listTitle"><input type="checkbox" name="chkAll" onclick="SelectAll(this.checked);" /></td>
                <td class="listTitle2">管理</td>
                <td class="listTitle2">房间标识</td>
                <td class="listTitle2">房间名称</td>
                <td class="listTitle2">游戏名称</td>
                 <td class="listTitle2">节点名称</td>
                <td class="listTitle2">排序</td>   
                <td class="listTitle2">模块名称</td>   
                <td class="listTitle2">桌子数量</td>   
                <td class="listTitle2">房间类型</td>                
                <td class="listTitle2">服务端口</td>                
                <td class="listTitle2">数据库名称</td>                
                <td class="listTitle2">数据库地址</td>   
                <td class="listTitle2">单位积分</td>   
                <td class="listTitle2">税收比例</td>
                <td class="listTitle2">限制积分</td>
                <td class="listTitle2">最低积分</td>
                <td class="listTitle2">最小进入积分</td>
                <td class="listTitle2">最大进入积分</td>
                <td class="listTitle2">最小进入等级</td>
                <td class="listTitle2">最大进入等级</td>
                <td class="listTitle2">最大人数</td>
                <td class="listTitle2">房间规则</td>
                <td class="listTitle2">运行机器</td>
                <td class="listTitle2">冻结状态</td>
                <td class="listTitle2">创建时间</td>
                <td class="listTitle1">修改时间</td>                                
            </tr>
            <asp:Repeater ID="rptGameRoomInfo" runat="server">
                <ItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                    onmouseout="this.style.backgroundColor=currentcolor">
                        <td><input name='cid' type='checkbox' value='<%# Eval("ServerID")%>'/></td>      
                        <td>                             
                            <a class="l" href="GameRoomInfoInfo.aspx?cmd=edit&param=<%#Eval("ServerID") %>">更新</a>              
                        </td>                
                        <td><%# Eval("ServerID")%></td>
                        <td><%# Eval("ServerName")%></td>
                        <td><%# GetGameKindName(int.Parse(Eval("KindID").ToString()))%></td>
                         <td><%#GetGameNodeName(int.Parse( Eval( "NodeID" ).ToString()))%></td>
                        <td><%# Eval("SortID")%></td>
                       <td><%# GetGameGameName(int.Parse( Eval("GameID").ToString()))%></td>
                        <td><%# Eval("TableCount")%></td>
                             <td><%#GetSupporTypeName( Eval( "ServerType" ) )%></td>
                        <td><%# Eval("ServerPort")%></td>
                        <td><%# Eval("DataBaseName")%></td>
                        <td><%# Eval("DataBaseAddr")%></td>
                        <td><%# Eval("CellScore")%></td>
                        <td><%# Eval("RevenueRatio")%></td>
                        <td><%# Eval("RestrictScore")%></td>
                        <td><%# Eval("MinTableScore")%></td>
                        <td><%# Eval("MinEnterScore")%></td>
                        <td><%# Eval("MaxEnterScore")%></td>
                        <td><%# Eval("MinEnterMember")%></td>
                        <td><%# Eval("MaxEnterMember")%></td>
                        <td><%# Eval("MaxPlayer")%></td>
                        <td><%# Eval("ServerRule")%></td>
                        <td><%# Eval("ServiceMachine")%></td>
                       <td><%# GetNullityStatus((byte)Eval("Nullity"))%></td>
                        <td><%# Eval("CreateDateTime")%></td>
                        <td><%# Eval("ModifyDateTime")%></td>
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr align="center" class="listBg" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                    onmouseout="this.style.backgroundColor=currentcolor">                        
                        <td><input name='cid' type='checkbox' value='<%# Eval("ServerID")%>'/></td>      
                        <td>                             
                            <a class="l" href="GameRoomInfoInfo.aspx?cmd=edit&param=<%#Eval("ServerID") %>">更新</a>              
                        </td>                
                        <td><%# Eval("ServerID")%></td>
                        <td><%# Eval("ServerName")%></td>
                       <td><%# GetGameKindName(int.Parse(Eval("KindID").ToString()))%></td>
                        <td><%#GetGameNodeName(int.Parse( Eval( "NodeID" ).ToString()))%></td>
                        <td><%# Eval("SortID")%></td>
                        <td><%# GetGameGameName(int.Parse( Eval("GameID").ToString()))%></td>
                        <td><%# Eval("TableCount")%></td>
                         <td><%#GetSupporTypeName( Eval( "ServerType" ) )%></td>
                        <td><%# Eval( "ServerPort" )%></td> 
                        <td><%# Eval("DataBaseName")%></td>
                        <td><%# Eval("DataBaseAddr")%></td>
                        <td><%# Eval("CellScore")%></td>
                        <td><%# Eval("RevenueRatio")%></td>
                        <td><%# Eval("RestrictScore")%></td>
                        <td><%# Eval("MinTableScore")%></td>
                        <td><%# Eval("MinEnterScore")%></td>
                        <td><%# Eval("MaxEnterScore")%></td>
                        <td><%# Eval("MinEnterMember")%></td>
                        <td><%# Eval("MaxEnterMember")%></td>
                        <td><%# Eval("MaxPlayer")%></td>
                        <td><%# Eval("ServerRule")%></td>
                        <td><%# Eval("ServiceMachine")%></td>
                        <td><%# GetNullityStatus((byte)Eval("Nullity"))%></td>
                        <td><%# Eval("CreateDateTime")%></td>
                        <td><%# Eval("ModifyDateTime")%></td>
                    </tr>
                </AlternatingItemTemplate>
            </asp:Repeater>
            <asp:Literal runat="server" ID="litNoData" Visible="false" Text="<tr class='tdbg'><td colspan='100' align='center'><br>没有任何信息!<br><br></td></tr>"></asp:Literal>
        </table>
    </div>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="listTitleBg"><span>选择：</span>&nbsp;<a class="l1" href="javascript:SelectAll(true);">全部</a>&nbsp;-&nbsp;<a class="l1" href="javascript:SelectAll(false);">无</a></td>                
            <td align="right" class="page">                
                <gsp:AspNetPager ID="anpNews" runat="server" onpagechanged="anpNews_PageChanged" AlwaysShow="true" FirstPageText="首页" LastPageText="末页" PageSize="20" 
                    NextPageText="下页" PrevPageText="上页" ShowBoxThreshold="0" ShowCustomInfoSection="Left" LayoutType="Table" NumericButtonCount="5"
                    CustomInfoHTML="总记录：%RecordCount%　页码：%CurrentPageIndex%/%PageCount%　每页：%PageSize%">
                </gsp:AspNetPager>
            </td>
        </tr>
    </table>  
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" id="OpList">
        <tr>
            <td height="39" class="titleOpBg">
                <!--<input type="button" value="新增" class="btn wd1" onclick="Redirect('GameRoomInfoInfo.aspx?cmd=add')" />
                <input class="btnLine" type="button" />-->
                <asp:Button ID="btnDelete2" runat="server" Text="删除" CssClass="btn wd1" 
                    onclick="btnDelete_Click" OnClientClick="return deleteop()"/>                    
            </td>
        </tr>
    </table>  
    </form>
</body>
</html>

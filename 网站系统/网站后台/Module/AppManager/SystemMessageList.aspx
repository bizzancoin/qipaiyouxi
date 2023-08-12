<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SystemMessageList.aspx.cs" Inherits="Game.Web.Module.AppManager.SystemMessageList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../../scripts/common.js"></script>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <!-- 头部菜单 Start -->
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="title">
        <tr>
            <td width="19" height="25" valign="top"  class="Lpd10"><div class="arr"></div></td>
            <td width="1232" height="25" valign="top" align="left">你当前位置：游戏系统 - 系统消息</td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td height="39" class="titleOpBg">
                <input type="button" value="新增" class="btn wd1" onclick="Redirect('SystemMessageInfo.aspx?cmd=add')" />
                <input class="btnLine" type="button" /> 
                <asp:Button ID="btnDelete" runat="server" Text="删除" CssClass="btn wd1" 
                    onclick="btnDelete_Click" OnClientClick="return deleteop()" /> 
                 <input class="btnLine" type="button" /> 
               <asp:Button ID="btnNoEnable" runat="server" Text="冻结" CssClass="btn wd1" 
                    onclick="btnNoEnable_Click" OnClientClick="return deleteop()" /> 
                 <input class="btnLine" type="button" />    
                       <asp:Button ID="btnEnable" runat="server" Text="解冻" CssClass="btn wd1" 
                    onclick="btnEnable_Click" OnClientClick="return deleteop()" />             
            </td>
        </tr>
    </table>  
    <div id="content">
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="box" id="list">
            <tr align="center" class="bold">
                <td style="width:30px;" class="listTitle"><input type="checkbox" name="chkAll" onclick="SelectAll(this.checked);" /></td>
                <td style="width:100px;" class="listTitle2">管理</td>
                <td class="listTitle2">开始时间</td>
                <td class="listTitle2">结束时间</td>
                <td class="listTitle2">消息范围</td>
                <td class="listTitle2">消息内容</td>       
                <td class="listTitle2">频率(秒)</td>       
                <td class="listTitle1">禁止标志</td>                
            </tr>
            <asp:Repeater ID="rptSystemMessage" runat="server">
                <ItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                    onmouseout="this.style.backgroundColor=currentcolor">
                        <td><input name='cid' type='checkbox' value='<%# Eval("ID")%>'/></td>      
                        <td>                             
                            <a class="l" href="SystemMessageInfo.aspx?cmd=edit&id=<%#Eval("ID") %>">更新</a>              
                        </td>                
                        <td><%# Eval("StartTime")%></td>
                        <td><%# Eval("ConcludeTime")%></td>
                        <td><%# GetMessageTypeName((int)Eval("MessageType"))%></td>
                        <td title="<%# Eval("MessageString")%>"><div><%# Eval("MessageString")%></div></td>
                        <td><%# Eval("TimeRate")%></td>
                        <td><%# GetNullityStatus((byte)Eval("Nullity"))%></td>
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr align="center" class="listBg" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                    onmouseout="this.style.backgroundColor=currentcolor">                        
                        <td><input name='cid' type='checkbox' value='<%# Eval("ID")%>'/></td>      
                        <td>                             
                            <a class="l" href="SystemMessageInfo.aspx?cmd=edit&id=<%#Eval("ID") %>">更新</a>              
                        </td>                
                        <td><%# Eval("StartTime")%></td>
                        <td><%# Eval("ConcludeTime")%></td>
                        <td><%# GetMessageTypeName((int)Eval("MessageType"))%></td>
                        <td title="<%# Eval("MessageString")%>"><div><%# Eval("MessageString")%></div></td>
                        <td><%# Eval("TimeRate")%></td>
                        <td><%# GetNullityStatus((byte)Eval("Nullity"))%></td>
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
                <input type="button" value="新增" class="btn wd1" onclick="Redirect('SystemMessageInfo.aspx?cmd=add')" />
                <input class="btnLine" type="button" /> 
                <asp:Button ID="Button1" runat="server" Text="删除" CssClass="btn wd1" 
                    onclick="btnDelete_Click" OnClientClick="return deleteop()" />                
            </td>
        </tr>
    </table>  
    </form>
</body>
</html>

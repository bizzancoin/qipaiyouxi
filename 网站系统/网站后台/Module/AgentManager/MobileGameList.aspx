<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MobileGameList.aspx.cs" Inherits="Game.Web.Module.AgentManager.MobileGameList" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link href="/styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/scripts/common.js"></script>
    <script type="text/javascript" src="/scripts/comm.js"></script>  
    <script type="text/javascript">
        //批量控制操作
        function deleteopAll(){
            var checkok = false;
            var e = document.getElementsByTagName("input", document.getElementById("list"));
            for (var i = 0; i < e.length; i++) {
                if (e[i].type == "checkbox") {
                    if (e[i].checked == true) {
                        checkok = true;
                        break;
                    }
                }
            }
            if (checkok)
                return confirm('确认要操作选中记录吗？');
            else {
                alert("请选择要操作的记录!");
                return false;
            }
        }
    </script>  
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
                你当前位置：代理系统 - 代理用户 - 手机游戏列表
            </td>
        </tr>
    </table>
    <!-- 头部菜单 End -->    
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="Tmg7">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="新增" class="btn wd1" onclick="openWindowOwn('MobileGameInfo.aspx?cmd=add&AgentID=<%=IntParam %>    ', 'addMobileGame', 600, 300)" />
                <input class="btnLine" type="button" />
                <asp:Button ID="btnDelete" runat="server" Text="删除" CssClass="btn wd1" 
                    onclick="btnDelete_Click" OnClientClick="return deleteopAll()" />           
                <input type="button" value="关闭" class="btn wd1" onclick="window.close();" />
            </td>
        </tr>
    </table>
    <div id="content">
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="box" id="list">
            <tr align="center" class="bold">
                <td style="width:30px;" class="listTitle"><input type="checkbox" name="chkAll" onclick="SelectAll(this.checked);" /></td>
                <td style="width:100px;" class="listTitle2">管理</td>
                <td class="listTitle2">游戏标识</td>
                <td class="listTitle2">游戏名称</td>
                <td class="listTitle2">排序</td>                
                <td class="listTitle1">创建时间</td>

            </tr>
            <asp:Repeater ID="rptGameList" runat="server">
                <ItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td><input name='cid' type='checkbox' value='<%# Eval("ID")%>'/></td>      
                        <td>                             
                            <a class="l" href="javascript:void(0);" onclick="openWindowOwn('MobileGameInfo.aspx?param=<%#Eval("ID").ToString() %>','<%#Eval("ID").ToString() %>_MobileGame',600,300);">更新</a>              
                        </td>   
                        <td><%# Eval("KindID")%></td>
                        <td><%# GetMobileGameName((int)Eval("KindID"))%></td>
                        <td><%# Eval("SortID")%></td>
                        <td><%# Eval("CollectDate")%></td>
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td><input name='cid' type='checkbox' value='<%# Eval("ID")%>'/></td>      
                        <td>                             
                            <a class="l" href="javascript:void(0);" onclick="openWindowOwn('MobileGameInfo.aspx?param=<%#Eval("ID").ToString() %>','<%#Eval("ID").ToString() %>_MobileGame',600,300);">更新</a>                      
                        </td> 
                        <td><%# Eval("KindID")%></td>
                        <td><%# GetMobileGameName((int)Eval("KindID"))%></td>
                        <td><%# Eval("SortID")%></td>
                        <td><%# Eval("CollectDate")%></td>
                    </tr>
                </AlternatingItemTemplate>
            </asp:Repeater>
            <asp:Literal runat="server" ID="litNoData" Visible="false" Text="<tr class='tdbg'><td colspan='100' align='center'><br>没有任何信息!<br><br></td></tr>"></asp:Literal>
        </table>
    </div>
    </form>
</body>
</html>

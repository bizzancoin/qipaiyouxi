<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TaskList.aspx.cs" Inherits="Game.Web.Module.TaskManager.TaskList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
     <title></title>
    <link href="/styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/scripts/common.js"></script>
    <script type="text/javascript" src="/scripts/comm.js"></script>
    <script type="text/javascript" src="/scripts/jquery.js"></script>
    <script type="text/javascript" src="/scripts/My97DatePicker/WdatePicker.js"></script>
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
                    你当前位置：任务系统 - 任务管理
                </td>
            </tr>
        </table>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td height="39" class="titleOpBg">
                    &nbsp;&nbsp;<input type="button" value="新增" onclick="Redirect('TaskInfo.aspx')"  class="btn wd1" />
                    <input type="button" class="btnLine" />
                    <asp:Button ID="btnDelete" runat="server" Text="删除" CssClass="btn wd1" onclick="btnDelete_Click" OnClientClick="return deleteop()" />     
              </td>
            </tr>
        </table>
        <div id="content">
            <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="box" id="list">
                <tr align="center" class="bold">
                    <td class="listTitle">
                       <input type="checkbox" name="chkAll" onclick="SelectAll(this.checked);" />
                    </td>
                    <td class="listTitle2">管理</td>
                    <td class="listTitle2">任务标识</td>
                    <td class="listTitle2">任务名称</td>
                    <td class="listTitle2">任务类型</td>
                    <td class="listTitle2">所属游戏</td>
                    <td class="listTitle2">时间限制(单位：秒)</td>
                    <td class="listTitle2">录入日期</td>
               </tr>
                <asp:Repeater ID="rpData" runat="server">
                    <ItemTemplate>
                       <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                            <td><%# "<input name='cid' type='checkbox' value='" + Eval("TaskID") + "'/>"%></td>
                            <td><a class="l" href="TaskInfo.aspx?param=<%# Eval("TaskID").ToString() %>">编辑</a></td>
                            <td><%# Eval( "TaskID" )%></td>
                            <td><%# Eval( "TaskName" )%></td>
                            <td><%# Enum.GetName( typeof( Game.Facade.EnumerationList.TaskType ), Eval( "TaskType" ) )%></td>
                            <td><%# GetGameKindName( Convert.ToInt32( Eval( "KindID" ) ) )%></td>
                            <td><%# Eval( "TimeLimit" )%></td>
                            <td><%# Eval( "InputDate" )%></td>
                        </tr>
                    </ItemTemplate>
                    <AlternatingItemTemplate>
                       <tr align="center" class="listBg" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                            <td><%# "<input name='cid' type='checkbox' value='" + Eval("TaskID") + "'/>"%></td>
                            <td><a class="l" href="TaskInfo.aspx?param=<%# Eval("TaskID").ToString() %>">编辑</a></td>
                            <td><%# Eval( "TaskID" )%></td>
                            <td><%# Eval( "TaskName" )%></td>
                            <td><%# Enum.GetName( typeof( Game.Facade.EnumerationList.TaskType ), Eval( "TaskType" ) )%></td>
                            <td><%# GetGameKindName( Convert.ToInt32( Eval( "KindID" ) ) )%></td>
                            <td><%# Eval( "TimeLimit" )%></td>
                            <td><%# Eval( "InputDate" )%></td>
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
                    &nbsp;&nbsp;<input type="button" value="新增" onclick="Redirect('TaskInfo.aspx')"  class="btn wd1" />
                    <input type="button" class="btnLine" />
                      <asp:Button ID="Button1" runat="server" Text="删除" CssClass="btn wd1" 
                    onclick="btnDelete_Click" OnClientClick="return deleteop()" />     
              </td>
            </tr>
        </table>
    </form>
</body>
</html>

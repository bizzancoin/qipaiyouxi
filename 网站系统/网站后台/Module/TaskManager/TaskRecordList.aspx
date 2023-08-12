<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TaskRecordList.aspx.cs" Inherits="Game.Web.Module.TaskManager.TaskRecordList" %>

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
                    你当前位置：任务系统 - 玩家完成任务记录
                </td>
            </tr>
        </table>
         <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="titleQueBg">
            <tr>
                 <td class="listTdLeft" style="width: 80px">
                    查询用户：
                </td>
                <td>
                <asp:TextBox ID="txtUser" runat="server" Width="100px" CssClass="text"></asp:TextBox>
                <asp:DropDownList ID="ddlType" runat="server">
                    <asp:ListItem Text="用户帐号" Value="0"></asp:ListItem>
                    <asp:ListItem Text="游戏 ID" Value="1"></asp:ListItem>
                    <asp:ListItem Text="用户标识" Value="2"></asp:ListItem>
                </asp:DropDownList>
                日期：<asp:TextBox ID="txtDate" runat="server" CssClass="text wd2" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})"></asp:TextBox><img 
                src="/Images/btn_calendar.gif" onclick="WdatePicker({el:'txtStartDate',dateFmt:'yyyy-MM-dd'})" style="cursor: pointer; vertical-align: middle" />
                <asp:Button ID="btnUseSearch" runat="server" Text="查询" CssClass="btn wd1"  onclick="btnUseSearch_Click"  />
                &nbsp;<input id="btnRefresh" type="button" value="刷新" class="btn wd1" onclick="Redirect('TaskRecordList.aspx')" />
                </td>
            </tr>
        </table>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="Tmg7">
            <tr>
                <td height="39" class="titleOpBg">
                    <asp:Button ID="btnDelete" runat="server" Text="删除" CssClass="btn wd1" onclick="btnDelete_Click" OnClientClick="return deleteop()" />   
                    <input type="button" class="btnLine" />
                    <asp:Button ID="Button2" runat="server" Text="清除一个月前的记录" CssClass="btn" Width="120" onclick="btnClear_Click" />    
              </td>
            </tr>
        </table>
        <div id="content">
            <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="box" id="list">
                <tr align="center" class="bold">
                    <td class="listTitle">
                         <input type="checkbox" name="chkAll" onclick="SelectAll(this.checked);" />
                    </td>
                    <td class="listTitle2">日志标识</td>
                    <td class="listTitle2">用户标识</td>
                    <td class="listTitle2">用户帐号</td>
                    <td class="listTitle2">任务名称</td>
                    <td class="listTitle2">奖励游戏币</td>
                    <td class="listTitle2">奖励元宝</td>
                    <td class="listTitle2">完成时间</td>
               </tr>
                <asp:Repeater ID="rpData" runat="server">
                    <ItemTemplate>
                       <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                            <td><%# "<input name='cid' type='checkbox' value='" + Eval("RecordID") + "'/>"%></td>
                            <td><%# Eval( "RecordID" )%></td>
                            <td><%# Eval( "UserID" )%></td>
                            <td><%# GetAccounts( Convert.ToInt32( Eval( "UserID" ) ) )%></td>
                            <td><%# GetTaskName( Convert.ToInt32( Eval( "TaskID" ) ) )%></td>
                            <td><%# Eval( "AwardGold" )%></td>
                            <td><%# Eval( "AwardMedal" )%></td>
                            <td><%# Eval( "InputDate" )%></td>
                        </tr>
                    </ItemTemplate>
                    <AlternatingItemTemplate>
                       <tr align="center" class="listBg" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                            <td><%# "<input name='cid' type='checkbox' value='" + Eval("RecordID") + "'/>"%></td>
                            <td><%# Eval( "RecordID" )%></td>
                            <td><%# Eval( "UserID" )%></td>
                            <td><%# GetAccounts( Convert.ToInt32( Eval( "UserID" ) ) )%></td>
                            <td><%# GetTaskName( Convert.ToInt32( Eval( "TaskID" ) ) )%></td>
                            <td><%# Eval( "AwardGold" )%></td>
                            <td><%# Eval( "AwardMedal" )%></td>
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
                   <asp:Button ID="Button1" runat="server" Text="删除" CssClass="btn wd1" onclick="btnDelete_Click" OnClientClick="return deleteop()" />    
                   <input type="button" class="btnLine" />
                   <asp:Button ID="Button3" runat="server" Text="清除一个月前的记录" CssClass="btn" Width="120" onclick="btnClear_Click"/>     
              </td>
            </tr>
        </table>
    </form>
</body>
</html>

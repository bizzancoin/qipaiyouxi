<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdsGameList.aspx.cs" Inherits="Game.Web.Module.WebManager.AdsGameList" %>

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
                    你当前位置：网站系统 - 其它广告管理
                </td>
            </tr>
        </table>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td height="39" class="titleOpBg">
                   
              </td>
            </tr>
        </table>
        <div id="content">
            <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="box" id="list">
                <tr align="center" class="bold">
                    <td class="listTitle2">管理</td>
                    <td class="listTitle2">广告资源</td>
                    <td class="listTitle2">备注</td>
               </tr>
                <asp:Repeater ID="rpData" runat="server">
                    <ItemTemplate>
                       <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                            <td><a class="l" href="AdsGameInfo.aspx?param=<%# Eval("ID").ToString() %>">编辑</a></td>
                            <td style="padding:2px;"><img src="<%# Eval( "ResourceURL" )%>" title="<%# Eval( "Title" )%>" width="176" height="58"/></td>
                            <td><%# Eval( "Remark" )%></td>
                        </tr>
                    </ItemTemplate>
                    <AlternatingItemTemplate>
                       <tr align="center" class="listBg" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                            <td><a class="l" href="AdsGameInfo.aspx?param=<%# Eval("ID").ToString() %>">编辑</a></td>
                            <td style="padding:2px;"><img src="<%# Eval( "ResourceURL" )%>" title="<%# Eval( "Title" )%>" width="176" height="58"/></td>
                            <td><%# Eval( "Remark" )%></td>
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
            </tr>
        </table>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" id="OpList">
            <tr>
                <td height="39" class="titleOpBg">
                  
              </td>
            </tr>
        </table>
    </form>
</body>
</html>

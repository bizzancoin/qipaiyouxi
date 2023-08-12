<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdsWebHomeList.aspx.cs" Inherits="Game.Web.Module.WebManager.AdsWebHomeList" %>

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
                    你当前位置：网站系统 - 网站首页广告
                </td>
            </tr>
        </table>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td height="39" class="titleOpBg">
                    &nbsp;&nbsp;<input type="button" value="新增" onclick="Redirect('AdsWebHomeListInfo.aspx')"  class="btn wd1" />
                    <input type="button" class="btnLine" />
                    <asp:Button ID="btnDelete" runat="server" Text="删除" CssClass="btn wd1" onclick="btnDelete_Click" OnClientClick="return deleteop()" />     
              </td>
            </tr>
        </table>
        <div id="content">
            <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="box" id="list">
                <tr align="center" class="bold">
                    <td class="listTitle">
                        <input type="checkbox" name="cbxAll" id="cbxAll" />
                    </td>
                    <td class="listTitle2">管理</td>
                    <td class="listTitle2">排序号</td>
                    <td class="listTitle2">广告标题</td>
                    <td class="listTitle2">广告图片</td>
               </tr>
                <asp:Repeater ID="rpData" runat="server">
                    <ItemTemplate>
                       <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                            <td><%# "<input name='cid' type='checkbox' value='" + Eval("ID") + "'/>"%></td>
                            <td><a class="l" href="AdsWebHomeListInfo.aspx?param=<%# Eval("ID").ToString() %>">编辑</a></td>
                            <td><%# Eval( "SortID" )%></td>
                            <td><%# Eval( "Title" )%></td>
                            <td style="padding:2px;"><img src="<%# Eval( "ResourceURL" )%>" title="<%# Eval( "Title" )%>" width="176" height="58"/></td>
                        </tr>
                    </ItemTemplate>
                    <AlternatingItemTemplate>
                       <tr align="center" class="listBg" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                            <td style="height:60;"><%# "<input name='cid' type='checkbox' value='" + Eval("ID") + "'/>"%></td>
                            <td><a class="l" href="AdsWebHomeListInfo.aspx?param=<%# Eval("ID").ToString() %>">编辑</a></td>
                            <td><%# Eval( "SortID" )%></td>
                            <td><%# Eval( "Title" )%></td>
                            <td style="padding:2px;"><img src="<%# Eval( "ResourceURL" )%>" title="<%# Eval( "Title" )%>" width="176" height="58"/></td>
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
                    &nbsp;&nbsp;<input type="button" value="新增" onclick="Redirect('AdsWebHomeListInfo.aspx')"  class="btn wd1" />
                    <input type="button" class="btnLine" />
                      <asp:Button ID="Button1" runat="server" Text="删除" CssClass="btn wd1" 
                    onclick="btnDelete_Click" OnClientClick="return deleteop()" />     
              </td>
            </tr>
        </table>
    </form>
</body>
</html>

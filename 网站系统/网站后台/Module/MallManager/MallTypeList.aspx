<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MallTypeList.aspx.cs" Inherits="Game.Web.Module.MallManager.MallTypeList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
     <title></title>
    <link href="/styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/scripts/common.js"></script>
    <script type="text/javascript" src="/scripts/comm.js"></script>
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
                    你当前位置：商城系统 - 类型管理
                </td>
            </tr>
        </table>
       <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td height="39" class="titleOpBg">
                    &nbsp;&nbsp;  <input type="button" class="btn wd1" value="新增" onclick="Redirect('MallTypeInfo.aspx')" />
                    <input type="button" class="btnLine" />
                    <asp:Button ID="btnNulityTrue" runat="server" Text="启用" CssClass="btn wd1" OnClientClick="return deleteop()"
                        onclick="btnNulityTrue_Click" />&nbsp;
                    <asp:Button ID="btnNulityFalse" runat="server" Text="禁用" CssClass="btn wd1" OnClientClick="return deleteop()"
                        onclick="btnNulityFalse_Click" />
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
                        类型标识
                    </td>
                    <td class="listTitle2">
                        类型名称
                    </td>
                    <td class="listTitle2">
                        类型排序
                    </td>
                    <td class="listTitle2">
                        禁用状态
                    </td>
                    <td class="listTitle2">
                        创建时间
                    </td>
                </tr>
                <asp:Repeater ID="rpData" runat="server">
                    <ItemTemplate>
                        <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                            <td><%# "<input name='cbxData' type='checkbox' value='" + Eval("TypeID") + "/" + Eval("ParentID") + "'/>"%></td>
                            <td><a class="l" href="MallTypeInfo.aspx?param=<%# Eval("TypeID").ToString() %>">编辑</a>&nbsp;
                            <asp:LinkButton ID="lbDelete" CssClass="l" runat="server" oncommand="lbDelete_Command" OnClientClick="return confirm('您确定要删除您选中的数据吗？\r\n注意：此操作不可恢复！')" CommandArgument='<%# Eval("TypeID") %>'>删除</asp:LinkButton></td>
                            <td><%# Eval("TypeID")%></td>
                            <td><%# Eval("TypeName")%></td>
                            <td><%# Eval("SortID")%></td>
                            <td><%# Eval("Nullity").ToString() == "1" ? "<span style='color:red;'>禁用</span>" : "启用"%></td>
                            <td><%# Eval("CollectDate")%></td>
                        </tr>
                      </ItemTemplate>
                      <AlternatingItemTemplate>
                         <tr align="center" class="listBg" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                            <td><%# "<input name='cbxData' type='checkbox' value='" + Eval("TypeID") + "/" + Eval("ParentID") + "'/>"%></td>
                            <td><a class="l" href="MallTypeInfo.aspx?param=<%# Eval("TypeID").ToString() %>">编辑</a>&nbsp;
                            <asp:LinkButton ID="LinkButton1" CssClass="l" runat="server" oncommand="lbDelete_Command" OnClientClick="return confirm('您确定要删除您选中的数据吗？\r\n注意：此操作不可恢复！')" CommandArgument='<%# Eval("TypeID") %>'>删除</asp:LinkButton></td>
                            <td><%# Eval("TypeID")%></td>
                            <td><%# Eval("TypeName")%></td>
                            <td><%# Eval("SortID")%></td>
                            <td><%# Eval("Nullity").ToString() == "1" ? "<span style='color:red;'>禁用</span>" : "启用"%></td>
                            <td><%# Eval("CollectDate")%></td>
                        </tr>
                    </AlternatingItemTemplate>
                </asp:Repeater>
                <asp:Literal runat="server" ID="litNoData" Visible="false" Text="<tr class='tdbg'><td colspan='100'><br>没有任何信息!<br><br></td></tr>"></asp:Literal>
            </table>
        </div>
       <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td class="listTitleBg">
                    <span>选择：</span>&nbsp;<a class="l1" href="javascript:SelectAll(true);">全部</a>&nbsp;-&nbsp;<a class="l1" href="javascript:SelectAll(false);">无</a>
                </td>
                <td align="right" class="page">
                    <gsp:AspNetPager ID="anpPage" runat="server" AlwaysShow="true" FirstPageText="首页" LastPageText="末页"
                        PageSize="20" NextPageText="下页" PrevPageText="上页" ShowBoxThreshold="0" ShowCustomInfoSection="Left" LayoutType="Table"
                        NumericButtonCount="5" CustomInfoHTML="总记录：%RecordCount%　页码：%CurrentPageIndex%/%PageCount%　每页：%PageSize%" UrlPaging="true">
                    </gsp:AspNetPager>
                </td>
            </tr>
        </table>
       <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" id="OpList">
            <tr>
                <td height="39" class="titleOpBg">
                    &nbsp;&nbsp; <input id="Button3" type="button" class="btn wd1" value="添加" onclick="Redirect('MallTypeInfo.aspx')" />
                    <input type="button" class="btnLine" />
                    <asp:Button ID="Button1" runat="server" Text="启用" CssClass="btn wd1" OnClientClick="return deleteop()"
                        onclick="btnNulityTrue_Click" />&nbsp;
                    <asp:Button ID="Button2" runat="server" Text="禁用" CssClass="btn wd1" OnClientClick="return deleteop()"
                        onclick="btnNulityFalse_Click" />
               </td>
            </tr>
        </table>
    </form>
</body>
</html>

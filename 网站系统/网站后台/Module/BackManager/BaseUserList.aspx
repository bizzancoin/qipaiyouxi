<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BaseUserList.aspx.cs" Inherits="Game.Web.Module.BackManager.BaseUserList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
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
            <td width="19" height="25" valign="top" class="Lpd10">
                <div class="arr">
                </div>
            </td>
            <td width="1232" height="25" valign="top" align="left">
                你当前位置：后台系统 - 管理员管理
            </td>
        </tr>
    </table>
    <!-- 头部菜单 End -->
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="Tmg7">
        <tr>
            <td height="28">
                <ul>
                    <li class="tab2" onclick="Redirect('BaseRoleList.aspx')">角色管理</li>
                    <li class="tab1">用户管理</li>
                </ul>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td height="39" class="titleOpBg">
                <input type="button" value="新增" class="btn wd1" onclick="Redirect('BaseUserInfo.aspx?cmd=add')" />
                <input class="btnLine" type="button" />
                <asp:Button ID="btnDongjie" runat="server" Text="冻结" CssClass="btn wd1" OnClick="btnDongjie_Click" OnClientClick="return deleteop()" />
                <asp:Button ID="btnJiedong" runat="server" Text="解冻" CssClass="btn wd1" OnClick="btnJiedong_Click" OnClientClick="return deleteop()" />
                <asp:Button ID="btnDelete" runat="server" Text="删除" CssClass="btn wd1" OnClick="btnDelete_Click" OnClientClick="return deleteop()" />
            </td>
        </tr>
    </table>
    <div id="content">
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="box" id="list">
            <tr align="center" class="bold">
                <td style="width: 30px;" class="listTitle">
                    <input type="checkbox" name="chkAll" onclick="SelectAll(this.checked);" />
                </td>
                <td style="width: 100px;" class="listTitle2">
                    管理
                </td>
                <td class="listTitle2">
                    用户帐号
                </td>
                <td class="listTitle2">
                    用户角色
                </td>
                <td class="listTitle2">
                    状态
                </td>
                <td class="listTitle2">
                    登录次数
                </td>
                <td class="listTitle2">
                    上次登录地址
                </td>
                <td class="listTitle1">
                    上次登录时间
                </td>
                <td class="listTitle2">
                    最后登录地址
                </td>
                <td class="listTitle1">
                    最后登录时间
                </td>
            </tr>
            <asp:Repeater ID="rptUser" runat="server">
                <ItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td>
                            <%# (int)Eval("UserID") == 1 ? "&nbsp;" : "<input name='cid' type='checkbox' value='" + Eval("UserID") + "'/>"%>
                        </td>
                        <td>
                            <%# (int)Eval("RoleID") == 1 ? "&nbsp;" : "<a class='l' href='BaseUserInfo.aspx?cmd=edit&param=" + Eval("UserID") + "'>更新</a> "%>
                        </td>
                        <td>
                            <%# Eval("UserName")%>
                        </td>
                        <td>
                            <%# GetRoleName((int)Eval("RoleID"))%>
                        </td>
                         <td>
                            <%# GetNullityStatus( Convert.ToByte( Eval("Nullity") ))%>
                        </td>
                        <td>
                            <%# Eval("LoginTimes")%>
                        </td>
                        <td>
                            <%# Eval( "PreLoginIP" )%>
                        </td>
                        <td>
                            <%# Eval( "PreLogintime" )%>
                        </td>
                        <td>
                            <%# Eval("LastLoginIP")%>
                        </td>
                        <td>
                            <%# Eval( "LastLoginTime" )%>
                        </td>
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr align="center" class="listBg" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td>
                            <%# (int)Eval("UserID") == 1 ? "&nbsp;" : "<input name='cid' type='checkbox' value='" + Eval("UserID") + "'/>"%>
                        </td>
                        <td>
                            <%# ( int ) Eval( "RoleID" ) == 1 ? "&nbsp;" : "<a class='l' href='BaseUserInfo.aspx?cmd=edit&param=" + Eval( "UserID" ) + "'>更新</a> "%>
                        </td>
                        <td>
                            <%# Eval( "UserName" )%>
                        </td>
                        <td>
                            <%# GetRoleName((int)Eval("RoleID"))%>
                        </td>
                        <td>
                            <%# GetNullityStatus( Convert.ToByte( Eval( "Nullity" ) ) )%>
                        </td>
                        <td>
                            <%# Eval("LoginTimes")%>
                        </td>
                        <td>
                            <%# Eval( "PreLoginIP" )%>
                        </td>
                        <td>
                            <%# Eval( "PreLogintime" )%>
                        </td>
                        <td>
                            <%# Eval("LastLoginIP")%>
                        </td>
                        <td>
                            <%# Eval("LastLoginTime")%>
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
                    PageSize="20" NextPageText="下页" PrevPageText="上页" ShowBoxThreshold="0" ShowCustomInfoSection="Left" LayoutType="Table"
                    NumericButtonCount="5" CustomInfoHTML="总记录：%RecordCount%　页码：%CurrentPageIndex%/%PageCount%　每页：%PageSize%">
                </gsp:AspNetPager>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" id="OpList">
        <tr>
            <td height="39" class="titleOpBg">
                <input type="button" value="新增" class="btn wd1" onclick="Redirect('BaseUserInfo.aspx?cmd=add')" />
                <input class="btnLine" type="button" />
                <asp:Button ID="btnDongjie1" runat="server" Text="冻结" CssClass="btn wd1" OnClick="btnDongjie_Click" OnClientClick="return deleteop()" />
                <asp:Button ID="btnJiedong1" runat="server" Text="解冻" CssClass="btn wd1" OnClick="btnJiedong_Click" OnClientClick="return deleteop()" />
                <asp:Button ID="Button1" runat="server" Text="删除" CssClass="btn wd1" OnClick="btnDelete_Click" OnClientClick="return deleteop()" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

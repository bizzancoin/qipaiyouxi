<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FeedbackList.aspx.cs" Inherits="Game.Web.Module.WebManager.FeedbackList" %>

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
                你当前位置：网站系统 - 反馈管理
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="titleQueBg">
        <tr>
            <td class="listTdLeft" style="width: 80px">
                用户查询：
            </td>
            <td>
                <asp:TextBox ID="txtSearch" runat="server" CssClass="text"></asp:TextBox>
                <asp:DropDownList ID="ddlRevertStatus" runat="server">
                    <asp:ListItem Value="0" Text="全部"></asp:ListItem>
                    <asp:ListItem Value="1" Text="已回复"></asp:ListItem>
                    <asp:ListItem Value="2" Text="未回复"></asp:ListItem>
                </asp:DropDownList>
                <asp:Button ID="btnQuery" runat="server" Text="查询" CssClass="btn wd1" OnClick="btnQuery_Click" />
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="Tmg7">
        <tr>
            <td height="39" class="titleOpBg">
                <asp:Button ID="btnDelete" runat="server" Text="删除" CssClass="btn wd1" OnClick="btnDelete_Click" OnClientClick="return deleteop()" />
                <asp:Button ID="btnDisable" runat="server" Text="冻结" CssClass="btn wd1" OnClick="btnDisable_Click" OnClientClick="return deleteop()" />
                <asp:Button ID="btnEnable" runat="server" Text="解冻" CssClass="btn wd1" OnClick="btnEnable_Click" OnClientClick="return deleteop()" />
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
                    反馈内容
                </td>
                <td class="listTitle2">
                    用户帐号
                </td>
                <td class="listTitle2">
                    提交时间
                </td>
                <td class="listTitle1">
                    回复时间
                </td>
                <td class="listTitle1">
                    回复人
                </td>
                <td class="listTitle1">
                    显示状态
                </td>
                <td class="listTitle1">
                    处理状态
                </td>
            </tr>
            <asp:Repeater ID="rptFeedback" runat="server">
                <ItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td>
                            <input name='cid' type='checkbox' value='<%# Eval("FeedbackID")%>' />
                        </td>
                        <td>
                            <a class="l" href="FeedbackInfo.aspx?cmd=edit&param=<%#Eval("FeedbackID") %>">处理</a>
                        </td>
                        <td title="<%#Eval("FeedbackContent") %>">
                            <div>
                                <%# Eval( "FeedbackContent" )%></div>
                        </td>
                        <td>
                            <%# Convert.ToInt32(Eval("UserID")) == 0 ? "匿名提问" : GetAccounts(Convert.ToInt32(Eval("UserID")))%>
                        </td>
                        <td>
                            <%# Eval("FeedbackDate")%>
                        </td>
                        <td>
                            <%# Eval("RevertDate")%>
                        </td>
                        <td>
                            <%# (int)Eval("RevertUserID") == 0 ? "" : GetMasterName((int)Eval("RevertUserID"))%>
                        </td>
                        <td>
                            <%# GetNullityStatus((byte)Eval("Nullity"))%>
                        </td>
                        <td>
                            <%# Convert.ToByte( Eval("IsProcessed") )==0?"<span style=\"color:red;\">未处理</span>":"已处理"%>
                        </td>
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr align="center" class="listBg" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td>
                            <input name='cid' type='checkbox' value='<%# Eval("FeedbackID")%>' />
                        </td>
                        <td>
                            <a class="l" href="FeedbackInfo.aspx?cmd=edit&param=<%#Eval("FeedbackID") %>">处理</a>
                        </td>
                        <td title="<%#Eval("FeedbackContent") %>">
                            <div>
                                <%# Eval( "FeedbackContent" )%></div>
                        </td>
                        <td>
                             <%# Convert.ToInt32(Eval("UserID")) == 0 ? "匿名提问" : GetAccounts(Convert.ToInt32(Eval("UserID")))%>
                        </td>
                        <td>
                            <%# Eval("FeedbackDate")%>
                        </td>
                        <td>
                            <%# Eval("RevertDate")%>
                        </td>
                        <td>
                            <%# (int)Eval("RevertUserID") == 0 ? "" : GetMasterName((int)Eval("RevertUserID"))%>
                        </td>
                        <td>
                            <%# GetNullityStatus((byte)Eval("Nullity"))%>
                        </td>
                        <td>
                            <%# Convert.ToByte( Eval( "IsProcessed" ) ) == 0 ? "<span style=\"color:red;\">未处理</span>" : "已处理"%>
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
                <asp:Button ID="Button1" runat="server" Text="删除" CssClass="btn wd1" OnClick="btnDelete_Click" OnClientClick="return deleteop()" />
                <asp:Button ID="btnDisable1" runat="server" Text="冻结" CssClass="btn wd1" OnClick="btnDisable_Click" OnClientClick="return deleteop()" />
                <asp:Button ID="btnEnable1" runat="server" Text="解冻" CssClass="btn wd1" OnClick="btnEnable_Click" OnClientClick="return deleteop()" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

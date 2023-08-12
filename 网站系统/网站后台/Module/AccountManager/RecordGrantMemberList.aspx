<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RecordGrantMemberList.aspx.cs" Inherits="Game.Web.Module.AccountManager.RecordGrantMemberList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
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
                你当前位置：用户系统 - 赠送会员记录
            </td>
        </tr>
    </table>
    <!-- 头部菜单 End -->
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="关闭" class="btn wd1" onclick="window.close();" />
            </td>
        </tr>
    </table>
    <div id="content">
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="box" id="list">
            <tr align="center" class="bold">
                <td class="listTitle2">
                    赠送日期
                </td>
                <td class="listTitle2">
                    地址
                </td>
                <td class="listTitle2">
                    会员类型
                </td>
                <td class="listTitle2">
                    赠送天数
                </td>
                <td class="listTitle2">
                    操作网管
                </td>
                <td class="listTitle">
                    赠送原因
                </td>
            </tr>
            <asp:Repeater ID="rptDataList" runat="server">
                <ItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td>
                            <%# Eval( "CollectDate", "{0:yyyy-MM-dd HH:mm:ss}" )%>
                        </td>
                        <td>
                            <%# GetAddressWithIP( Eval( "ClientIP" ).ToString( ) )%>
                        </td>
                        <td>
                            <%# GetMemberName( byte.Parse( Eval( "GrantCardType" ).ToString( ) ) )%>
                        </td>
                        <td>
                            <%# Eval( "MemberDays" ).ToString( )%>
                        </td>
                        <td>
                            <%#GetMasterName( int.Parse( Eval( "MasterID" ).ToString( ) ) )%>
                        </td>
                        <td>
                            <%# Eval( "Reason" ).ToString( )%>
                        </td>
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr align="center" class="listBg" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td>
                            <%# Eval( "CollectDate", "{0:yyyy-MM-dd HH:mm:ss}" )%>
                        </td>
                        <td>
                            <%# GetAddressWithIP( Eval( "ClientIP" ).ToString( ) )%>
                        </td>
                        <td>
                            <%# GetMemberName( byte.Parse( Eval( "GrantCardType" ).ToString( ) ) )%>
                        </td>
                        <td>
                            <%# Eval( "MemberDays" ).ToString( )%>
                        </td>
                        <td>
                            <%#GetMasterName( int.Parse( Eval( "MasterID" ).ToString( ) ) )%>
                        </td>
                        <td>
                            <%# Eval( "Reason" ).ToString( )%>
                        </td>
                    </tr>
                </AlternatingItemTemplate>
            </asp:Repeater>
            <asp:Literal runat="server" ID="litNoData" Visible="false" Text="<tr class='tdbg'><td colspan='100' align='center'><br>没有任何信息!<br><br></td></tr>"></asp:Literal>
        </table>
    </div>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td align="right" class="page">
                <gsp:AspNetPager ID="anpNews" runat="server" AlwaysShow="true" FirstPageText="首页" LastPageText="末页" PageSize="20" NextPageText="下页"
                    PrevPageText="上页" ShowBoxThreshold="0" ShowCustomInfoSection="Left" LayoutType="Table" NumericButtonCount="5" CustomInfoHTML="总记录：%RecordCount%　页码：%CurrentPageIndex%/%PageCount%　每页：%PageSize%"
                    UrlPaging="True">
                </gsp:AspNetPager>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

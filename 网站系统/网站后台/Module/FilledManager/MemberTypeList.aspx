<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MemberTypeList.aspx.cs" Inherits="Game.Web.Module.FilledManager.MemberTypeList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link href="/styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/scripts/common.js"></script>
    <script type="text/javascript" src="/scripts/comm.js"></script>
    <script type="text/javascript" src="/scripts/My97DatePicker/WdatePicker.js"></script>
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
                你当前位置：充值系统 - 会员类型管理
            </td>
        </tr>
    </table>
    <div id="content">
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="box Tmg7" id="list">
            <tr align="center" class="bold">
                <td class="listTitle1">
                    管理
                </td>
                <td class="listTitle2">
                    会员名称
                </td>
                <td class="listTitle2">
                    任务奖励
                </td>
                <td class="listTitle2">
                    商城折扣
                </td>
                <td class="listTitle2">
                    转账费率
                </td>
                <td class="listTitle2">
                    每日送金
                </td>
                <td class="listTitle2">
                    登录礼包
                </td>
            </tr>
            <asp:Repeater ID="rptDataList" runat="server">
                <ItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td>
                           <a href="MemberTypeInfo.aspx?param=<%# Eval( "MemberOrder" ).ToString( )%>" class="l">更新</a>
                        </td>
                        <td>
                            <%# Eval( "MemberName" ).ToString()%>
                        </td>
                        <td>
                            <%# Eval( "TaskRate" )%>%   
                        </td>
                        <td>
                            <%# Eval( "ShopRate" )%>% 
                        </td>
                        <td>
                            <%# Eval( "InsureRate" )%>‰   
                        </td>
                        <td>
                            <%# Eval( "DayPresent" ).ToString()%>
                        </td>
                        <td>
                            <%# Eval( "DayGiftID" ).ToString()%>
                        </td>
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr align="center" class="listBg" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td>
                           <a href="MemberTypeInfo.aspx?param=<%# Eval( "MemberOrder" ).ToString( )%>" class="l">更新</a>
                        </td>
                        <td>
                            <%# Eval( "MemberName" ).ToString()%>
                        </td>
                        <td>
                            <%# Eval( "TaskRate" )%>% 
                        </td>
                        <td>
                            <%# Eval( "ShopRate" )%>%   
                        </td>
                        <td>
                            <%# Eval( "InsureRate" )%>‰  
                        </td>
                        <td>
                            <%# Eval( "DayPresent" ).ToString()%>
                        </td>
                        <td>
                            <%# Eval( "DayGiftID" ).ToString()%>
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
                
            </td>
            <td align="right" class="page">
         
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

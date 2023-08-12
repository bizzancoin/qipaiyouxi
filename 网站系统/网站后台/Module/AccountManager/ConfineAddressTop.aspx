<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ConfineAddressTop.aspx.cs" Inherits="Game.Web.Module.AccountManager.ConfineAddressTop" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="/scripts/common.js"></script>
    <script type="text/javascript" src="/scripts/comm.js"></script>
    <title></title>
</head>
<body scroll="no">
    <form id="form1" runat="server">
    <!-- 头部菜单 Start -->
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="title">
        <tr>
            <td width="19" height="25" valign="top" class="Lpd10">
                <div class="arr">
                </div>
            </td>
            <td width="1232" height="25" valign="top" align="left">
                你当前位置：用户系统 - IP地址注册数【TOP100】
            </td>
        </tr>
    </table>
    <!-- 头部菜单 End -->
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <asp:Button ID="btnQuery" runat="server" Text="永久限制注册/登录" CssClass="btn wd4" OnClick="DisableIP" OnClientClick="return WindowDeleteOp()"/>   
                <input type="button" value="关闭" class="btn wd1" onclick="window.close();" />     
            </td>
        </tr>
    </table>
    <div id="content">
        <table border="0" align="center" cellpadding="0" cellspacing="0" class="box" id="list">
            <tr align="center" class="bold">
                <td class="listTitle1">
                    <input type="checkbox" name="chkAll" onclick="SelectAll(this.checked);" />
                </td>
                <td class="listTitle2">
                    排名
                </td>
                <td class="listTitle2">
                    IP地址
                </td>
                <td class="listTitle2">
                    注册人数
                </td>
                <td class="listTitle2">
                    限制登录
                </td>
                <td class="listTitle2">
                    限制注册
                </td>
                <td class="listTitle2">
                    限制的失效时间
                </td>
            </tr>
            <asp:Repeater ID="rptDataList" runat="server">
                <ItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td style="width: 30px;">
                            <input name='cid' type='checkbox' value='<%# Eval("RegisterIP").ToString()%>' />
                        </td>
                        <td style="width: 30px;">
                           <%# Container.ItemIndex + 1%>
                        </td>
                        <td>
                           <%# Eval( "RegisterIP" )%>
                        </td>
                        <td>
                           <%# Eval( "Counts" )%>
                        </td>  
                         <td>
                            <%# ( ( bool ) Eval( "EnjoinLogon" ) ) ? "<span class='hong'>禁止</span>" : "正常"%>
                        </td>
                        <td>
                            <%# ( ( bool ) Eval( "EnjoinRegister" ) ) ? "<span class='hong'>禁止</span>" : "正常"%>
                        </td>
                        <td>
                            <%# ( (bool)Eval( "EnjoinLogon" ) ) || ( (bool)Eval( "EnjoinRegister" ) ) ? string.IsNullOrEmpty( Eval( "EnjoinOverDate" ).ToString() ) ? "永久限制" : Eval( "EnjoinOverDate", "{0:yyyy-MM-dd HH:mm:ss}" ) : ""%>
                        </td>
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr align="center" class="listBg" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td style="width: 30px;">
                            <input name='cid' type='checkbox' value='<%# Eval("RegisterIP").ToString()%>' />
                        </td>
                        <td style="width: 30px;">
                           <%# Container.ItemIndex + 1%>
                        </td>
                        <td>
                           <%# Eval( "RegisterIP" )%>
                        </td>
                        <td>
                           <%# Eval( "Counts" )%>
                        </td>  
                        <td>
                            <%# ( ( bool ) Eval( "EnjoinLogon" ) ) ? "<span class='hong'>禁止</span>" : "正常"%>
                        </td>
                        <td>
                            <%# ( ( bool ) Eval( "EnjoinRegister" ) ) ? "<span class='hong'>禁止</span>" : "正常"%>
                        </td>
                         <td>
                            <%# ( (bool)Eval( "EnjoinLogon" ) ) || ( (bool)Eval( "EnjoinRegister" ) ) ? string.IsNullOrEmpty( Eval( "EnjoinOverDate" ).ToString() ) ? "永久限制" : Eval( "EnjoinOverDate", "{0:yyyy-MM-dd HH:mm:ss}" ) : ""%>
                        </td>
                    </tr>
                </AlternatingItemTemplate>
            </asp:Repeater>
            <asp:Literal runat="server" ID="litNoData" Visible="false" Text="<tr class='tdbg'><td colspan='100' align='center'><br>没有任何信息!<br><br></td></tr>"></asp:Literal>
        </table>
    </div>
     <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="listTitleBg" style="">
            </td>
            <td align="right" class="page">
               
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AccountPasswordCard.aspx.cs" Inherits="Game.Web.Module.AccountManager.AccountPasswordCard" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="../../scripts/common.js"></script>

    <script type="text/javascript" src="../../scripts/comm.js"></script>

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
                你当前位置：用户系统 - 赠送游戏币记录
            </td>
        </tr>
    </table>
    <!-- 头部菜单 End -->
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="关闭" class="btn wd1" onclick="window.close();" />
                <input type="button" class="btnLine" />
                <asp:Button ID=Button1 runat="server" Text="取消绑定" CssClass="btn wd2" OnClick="btn_ClearPasswordCard"/>
            </td>
        </tr>
    </table>

        <table width="100%" style="height:100%;" border="0" align="center" cellpadding="0" cellspacing="0" class="box" id="list">
            <tr class="list">
             <td colspan="5" style="font-weight:bold;height:25px;" align="left">
                   序列号：<asp:Label ID="lbSerialNumber" runat="server" Text=""></asp:Label>
                </td>
            </tr>
            <tr align="center" class="bold" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                <td class="listTitle2">&nbsp;</td>
                <td class="listTitle2">1</td>
                <td class="listTitle2">2</td>
                <td class="listTitle2">3</td>
                <td class="listTitle2">4</td>                        
            </tr> 
            <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                <td>A</td>
                <td><asp:Label ID="lbA1" runat="server" Text=""></asp:Label></td>
                <td><asp:Label ID="lbA2" runat="server" Text=""></asp:Label></td>
                <td><asp:Label ID="lbA3" runat="server" Text=""></asp:Label></td>
                <td><asp:Label ID="lbA4" runat="server" Text=""></asp:Label></td>                        
            </tr>
            <tr align="center" class="listBg" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                <td style="font-weight:bold;height:20px;">B</td>
                <td><asp:Label ID="lbB1" runat="server" Text=""></asp:Label></td>
                <td><asp:Label ID="lbB2" runat="server" Text=""></asp:Label></td>
                <td><asp:Label ID="lbB3" runat="server" Text=""></asp:Label></td>
                <td><asp:Label ID="lbB4" runat="server" Text=""></asp:Label></td>                        
            </tr>
            <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                <td style="font-weight:bold;height:20px;">C</td>
                <td><asp:Label ID="lbC1" runat="server" Text=""></asp:Label></td>
                <td><asp:Label ID="lbC2" runat="server" Text=""></asp:Label></td>
                <td><asp:Label ID="lbC3" runat="server" Text=""></asp:Label></td>
                <td><asp:Label ID="lbC4" runat="server" Text=""></asp:Label></td>                        
            </tr>
            <tr align="center" class="listBg" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                <td style="font-weight:bold;height:20px;">D</td>
                <td><asp:Label ID="lbD1" runat="server" Text=""></asp:Label></td>
                <td><asp:Label ID="lbD2" runat="server" Text=""></asp:Label></td>
                <td><asp:Label ID="lbD3" runat="server" Text=""></asp:Label></td>
                <td><asp:Label ID="lbD4" runat="server" Text=""></asp:Label></td>                        
            </tr>
            <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                <td style="font-weight:bold;height:20px;">E</td>
                <td><asp:Label ID="lbE1" runat="server" Text=""></asp:Label></td>
                <td><asp:Label ID="lbE2" runat="server" Text=""></asp:Label></td>
                <td><asp:Label ID="lbE3" runat="server" Text=""></asp:Label></td>
                <td><asp:Label ID="lbE4" runat="server" Text=""></asp:Label></td>                        
            </tr>
            <tr align="center" class="listBg" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                <td style="font-weight:bold;height:20px;">F</td>
                <td><asp:Label ID="lbF1" runat="server" Text=""></asp:Label></td>
                <td><asp:Label ID="lbF2" runat="server" Text=""></asp:Label></td>
                <td><asp:Label ID="lbF3" runat="server" Text=""></asp:Label></td>
                <td><asp:Label ID="lbF4" runat="server" Text=""></asp:Label></td>                        
            </tr>
            <asp:Literal runat="server" ID="litNoData" Visible="false" Text="<tr class='tdbg'><td colspan='100' align='center'><br>没有任何信息!<br><br></td></tr>"></asp:Literal>
        </table>
    </form>
</body>
</html>

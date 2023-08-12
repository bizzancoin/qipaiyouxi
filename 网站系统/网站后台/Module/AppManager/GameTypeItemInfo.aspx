<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GameTypeItemInfo.aspx.cs" Inherits="Game.Web.Module.AppManager.GameTypeItemInfo" %>
<%@ Register Src="~/Themes/TabGame.ascx" TagPrefix="Fox" TagName="Tab" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
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
            <td width="19" height="25" valign="top"  class="Lpd10"><div class="arr"></div></td>
            <td width="1232" height="25" valign="top" align="left">你当前位置：游戏系统 - 游戏管理</td>
        </tr>
    </table>
    <Fox:Tab ID="fab1" runat="server" NavActivated="B"></Fox:Tab>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="返回" class="btn wd1" onclick="Redirect('GameTypeItemList.aspx')" />                           
                <input class="btnLine" type="button" />  
                <asp:Button ID="btnSave" runat="server" Text="保存" CssClass="btn wd1" 
                    onclick="btnSave_Click" />
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10"><div class="hg3  pd7">
                <asp:Literal ID="litInfo" runat="server"></asp:Literal>类型信息</div></td>
        </tr>
        <tr>
            <td class="listTdLeft">类型标识：</td>
            <td>        
                <asp:TextBox ID="txtTypeID" runat="server" CssClass="text" onkeyup="if(isNaN(value))execCommand('undo')" MaxLength="9"></asp:TextBox>               
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">类型名称：</td>
            <td>        
                <asp:TextBox ID="txtTypeName" runat="server" CssClass="text" MaxLength="6"></asp:TextBox>               
            </td>
        </tr>
        <!--
         <tr>
            <td class="listTdLeft">
                挂接：
            </td>
            <td>
                <asp:DropDownList ID="ddlJoin" runat="server" Width="158px">
                
                </asp:DropDownList>
            </td>
        </tr>
        -->
        <tr>
            <td class="listTdLeft">排序：</td>
            <td>        
                <asp:TextBox ID="txtSortID" runat="server" CssClass="text" onkeyup="if(isNaN(value))execCommand('undo')" MaxLength="9" Text="0"></asp:TextBox> 
            </td>
        </tr>        
        <tr>
            <td class="listTdLeft">禁用状态：</td>
            <td>        
                <asp:RadioButtonList ID="rbtnNullity" runat="server" RepeatDirection="Horizontal">
                    <asp:ListItem Value="0" Text="正常" Selected="True"></asp:ListItem>
                    <asp:ListItem Value="1" Text="禁用"></asp:ListItem>
                </asp:RadioButtonList>             
            </td>
        </tr>    
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="返回" class="btn wd1" onclick="Redirect('GameTypeItemList.aspx')" />                           
                <input class="btnLine" type="button" />  
                <asp:Button ID="Button1" runat="server" Text="保存" CssClass="btn wd1" 
                    onclick="btnSave_Click" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

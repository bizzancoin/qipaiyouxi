<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NewsInfo.aspx.cs" Inherits="Game.Web.Module.WebManager.NewsInfo" ValidateRequest="false"%>

<%@ Register Src="~/Themes/TopMobileNotice.ascx" TagPrefix="Fox" TagName="Notice" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title></title>
    <link href="/styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/scripts/common.js"></script>
    <script type="text/javascript" src="/scripts/kindEditor/kindeditor.js"></script>
    <script type="text/javascript">
        KE.show({
            id: 'txtBody',
            imageUploadJson: '/Tools/KindEditorUpload.ashx?type=news',
            fileManagerJson: '/Tools/KindEditorFileManager.ashx?type=news',
            allowFileManager: true
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <!-- 头部菜单 Start -->
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="title">
        <tr>
            <td width="19" height="25" valign="top"  class="Lpd10"><div class="arr"></div></td>
            <td width="1232" height="25" valign="top" align="left">你当前位置：网站系统 - 新闻管理</td>
        </tr>
    </table>  
    <Fox:Notice ID="Notice1" runat="server" NewsPageID="1"></Fox:Notice>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="返回" class="btn wd1" onclick="Redirect('NewsList.aspx')" />                           
                <input class="btnLine" type="button" />  
                <asp:Button ID="btnSave" runat="server" Text="保存" CssClass="btn wd1" onclick="btnSave_Click" />
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10"><div class="hg3  pd7">
                <asp:Literal ID="litInfo" runat="server"></asp:Literal>新闻</div></td>
        </tr>
        <tr>
            <td class="listTdLeft">标题：</td>
            <td>        
                <asp:DropDownList ID="ddlClassID" runat="server" Width="80px">
                    <asp:ListItem Value="1" Text="新闻"></asp:ListItem>
                    <asp:ListItem Value="2" Text="公告"></asp:ListItem>
                </asp:DropDownList>      
                <asp:TextBox ID="txtSubject" runat="server" CssClass="text" Width="465px"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rf4" runat="server" ForeColor="Red" Display="Dynamic" ControlToValidate="txtSubject" ErrorMessage="请输入标题内容"></asp:RequiredFieldValidator>         
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">属性：</td>
            <td>        
                <asp:CheckBox ID="chkOnTop" runat="server" Text="置顶" />     
                <asp:CheckBox ID="chkOnTopAll" runat="server" Text="总置顶" />     
                <asp:CheckBox ID="chkIsElite" runat="server" Text="推荐" />     
                <asp:CheckBox ID="chkIsHot" runat="server" Text="热门" />     
                <asp:CheckBox ID="chkIsLock" runat="server" Text="立即发布" Checked="true" />     
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">引用：</td>
            <td>        
                <asp:TextBox ID="txtLinkUrl" runat="server" CssClass="text" Text="http://" Width="550px"></asp:TextBox> 
                <asp:CheckBox ID="chkIsLinks" runat="server" Text="链接地址" />     
            </td>
        </tr>        
        <tr>
            <td class="listTdLeft">内容：</td>
            <td>        
                <asp:TextBox ID="txtBody" runat="server" CssClass="text" Width="650px" Height="350px" TextMode="MultiLine"></asp:TextBox>  
            </td>
        </tr>    
    </table>
    
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="返回" class="btn wd1" onclick="Redirect('NewsList.aspx')" />                           
                <input class="btnLine" type="button" />  
                <asp:Button ID="Button1" runat="server" Text="保存" CssClass="btn wd1" 
                    onclick="btnSave_Click" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

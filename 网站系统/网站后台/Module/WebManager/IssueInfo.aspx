<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="IssueInfo.aspx.cs" Inherits="Game.Web.Module.WebManager.IssueInfo" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../../scripts/common.js"></script>
    <script type="text/javascript" src="../../scripts/kindEditor/kindeditor.js"></script>
    <title></title>
    <script type="text/javascript">
        KE.show({
            id: 'txtIssueContent',
            imageUploadJson: '/Tools/KindEditorUpload.ashx?type=issue',
            fileManagerJson: '/Tools/KindEditorFileManager.ashx?type=issue',
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
            <td width="1232" height="25" valign="top" align="left">你当前位置：网站系统 - 规则管理</td>
        </tr>
    </table>  
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="返回" class="btn wd1" onclick="Redirect('IssueList.aspx')" />                           
                <input class="btnLine" type="button" />  
                <asp:Button ID="btnSave" runat="server" Text="保存" CssClass="btn wd1" 
                    onclick="btnSave_Click" />
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10"><div class="hg3  pd7">
                <asp:Literal ID="litInfo" runat="server"></asp:Literal>问题</div></td>
        </tr>
        <tr>
            <td class="listTdLeft">标题：</td>
            <td>            
                <asp:TextBox ID="txtIssueTitle" runat="server" CssClass="text" Width="465px"></asp:TextBox>     
                <asp:RequiredFieldValidator ID="rf4" runat="server" ForeColor="Red" Display="Dynamic" ControlToValidate="txtIssueTitle" ErrorMessage="请输入标题"></asp:RequiredFieldValidator>                
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">问题类型：</td>
            <td>            
                <asp:DropDownList ID="ddlTypeID" runat="server">
                    <asp:ListItem Value="1" Text="常见问题"></asp:ListItem>
                    <asp:ListItem Value="2" Text="充值问题"></asp:ListItem>
                    <asp:ListItem Value="3" Text="高级教程"></asp:ListItem>
                    <asp:ListItem Value="4" Text="功能说明"></asp:ListItem>
                </asp:DropDownList>                
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
        <tr>
            <td class="listTdLeft">内容：</td>
            <td>        
                <asp:TextBox ID="txtIssueContent" runat="server" CssClass="text" Width="650px" Height="350px" TextMode="MultiLine"></asp:TextBox>      
            </td>
        </tr>    
    </table>
    
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="返回" class="btn wd1" onclick="Redirect('IssueList.aspx')" />                           
                <input class="btnLine" type="button" />  
                <asp:Button ID="Button1" runat="server" Text="保存" CssClass="btn wd1" 
                    onclick="btnSave_Click" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

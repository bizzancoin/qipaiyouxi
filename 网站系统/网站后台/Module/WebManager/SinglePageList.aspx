<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SinglePageList.aspx.cs" Inherits="Game.Web.Module.WebManager.SinglePageList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link href="/styles/layout.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="/scripts/common.js"></script>
    <script type="text/javascript" src="/scripts/jquery.js"></script>
    <script type="text/javascript" src="/scripts/kindEditor/kindeditor.js"></script>
    <script type="text/javascript">
        KE.show({
            id: 'txtContents',
            imageUploadJson: '/Tools/KindEditorUpload.ashx?type=Config',
            fileManagerJson: '/Tools/KindEditorFileManager.ashx?type=config',
            allowFileManager: true
        });
    </script> 
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="title">
        <tr>
            <td width="19" height="25" valign="top" class="Lpd10">
                <div class="arr"></div>
            </td>
            <td width="1232" height="25" valign="top" align="left">
                你当前位置：网站系统 - 独立页管理
            </td>
        </tr>
    </table>
   <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td height="35" colspan="2" class="Lpd10 Rpd10">
                <div class="liebiao">
                    <ul>
                        <asp:Repeater ID="rptDataList" runat="server">
                            <ItemTemplate>
                               <li <%# Convert.ToInt32( Eval("PageID") )==IntParam || ( IntParam==0 && Container.ItemIndex==0 )?"class=\"current\"":""%>><a href="?param=<%#Eval("PageID").ToString() %>">
                                    <%#Eval( "PageName" ).ToString()%></a></li> 
                            </ItemTemplate>
                        </asp:Repeater>
                    </ul>
                </div>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td class="listTdLeft">
                名称：
            </td>
            <td>
                <asp:Label ID="lbPageName" runat="server" Text="Label"></asp:Label>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                页关键字：
            </td>
            <td>
                <asp:TextBox ID="txtKeyWords" runat="server" CssClass="text" Width="250"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                页描述：
            </td>
            <td>
                <asp:TextBox ID="txtDescription" runat="server" CssClass="text" Width="250"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                页内容：
            </td>
            <td>
                <asp:TextBox ID="txtContents" runat="server" CssClass="text" Width="650px" Height="450px" TextMode="MultiLine"></asp:TextBox>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <asp:Button ID="Button1" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

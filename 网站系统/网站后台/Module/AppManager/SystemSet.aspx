<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SystemSet.aspx.cs" Inherits="Game.Web.Module.AppManager.SystemSet" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="../../scripts/common.js"></script>

    <script type="text/javascript" src="../../scripts/kindEditor/kindeditor.js"></script>

    <script type="text/javascript" src="../../scripts/jquery.js"></script>

    <script type="text/javascript" src="../../scripts/jquery.validate.js"></script>

    <script type="text/javascript" src="../../scripts/messages_cn.js"></script>

    <script type="text/javascript" src="../../scripts/jquery.metadata.js"></script>

    <script type="text/javascript">
        jQuery(document).ready(function() {
            jQuery.metadata.setType("attr", "validate");
            jQuery("#<%=form1.ClientID %>").validate();
        });
    </script>

    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="title">
        <tr>
            <td width="19" height="25" valign="top" class="Lpd10">
                <div class="arr">
                </div>
            </td>
            <td width="1232" height="25" valign="top" align="left">
                你当前位置：系统维护 - 系统设置
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
                               <li <%# Eval("StatusName").ToString()==StrParam || ( string.IsNullOrEmpty( StrParam ) && Container.ItemIndex==0 )?"class=\"current\"":""%>><a href="SystemSet.aspx?param=<%#Eval("StatusName").ToString() %>">
                                    <%#Eval( "StatusTip" ).ToString( )%></a></li> 
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
                键名：
            </td>
            <td>
                <asp:TextBox ID="txtStatusName" runat="server" CssClass="text" Width="120px" MaxLength="50" Enabled="false"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                键值：
            </td>
            <td>
                <asp:TextBox ID="txtStatusValue" runat="server" CssClass="text" Width="120px" MaxLength="50" validate="{digits:true}"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                名称：
            </td>
            <td>
                <asp:TextBox ID="txtStatusTip" runat="server" CssClass="text" Width="250px" MaxLength="50" validate="{required:true}"></asp:TextBox>&nbsp;&nbsp;&nbsp;
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                备注：
            </td>
            <td>
                <asp:TextBox ID="txtStatusString" runat="server" CssClass="text" Width="450px" MaxLength="80"></asp:TextBox>&nbsp;&nbsp;&nbsp;
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                描述：
            </td>
            <td>
                <asp:TextBox ID="txtStatusDescription" runat="server" CssClass="text" TextMode="MultiLine" Width="450px" Height="150px"></asp:TextBox>
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

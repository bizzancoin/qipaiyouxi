<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BaseRolePermission.aspx.cs" Inherits="Game.Web.Module.BackManager.BaseRolePermission" %>

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
            <td width="1232" height="25" valign="top" align="left">你当前位置：后台系统 - 管理员管理</td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td height="28">
                <ul>
	                <li class="tab1">角色管理</li>
	                <li class="tab2" onclick="Redirect('BaseUserList.aspx')">用户管理</li>
                </ul>
            </td>
        </tr>
    </table>  
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="返回" class="btn wd1" onclick="Redirect('BaseRoleList.aspx')" />                           
                <input class="btnLine" type="button" />  
                <asp:Button ID="btnSave" runat="server" Text="保存" CssClass="btn wd1" 
                    onclick="btnSave_Click" />
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10"><div class="hg3  pd7">
                <asp:Literal ID="litInfo" runat="server"></asp:Literal>权限信息列表<asp:Literal ID="litSuper" runat="server"></asp:Literal></div></td>
        </tr>
        <tr>
            <td>
                <asp:Repeater ID="rptRolePermission" runat="server" onitemdatabound="rptRolePermission_ItemDataBound">
                    <ItemTemplate>
                        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
                            <tr>
                                <td height="35" class="f14 bold Lpd10 Rpd10"><div class="hg3  pd7">
                                    <asp:Label ID="lblParentName" runat="server" ></asp:Label>（全选：<asp:CheckBox  runat="server" id="chkAll" name="chkAll"  />）</div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:GridView ID="gvRolePermission" runat="server" Width="100%" AutoGenerateColumns="false" CellPadding="0" CellSpacing="0" GridLines="None" 
                                        ShowHeader="false" OnRowDataBound="gvRolePermission_RowDataBound">
                                        <Columns>
                                            <asp:TemplateField ItemStyle-CssClass="listTdLeft">
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ID="lblTitle"></asp:Label><asp:TextBox runat="server" ID="txtModuleID" style="display:none"></asp:TextBox>
                                                </ItemTemplate>
                                                <ItemStyle CssClass="listTdLeft" />
                                            </asp:TemplateField>
                                            <asp:TemplateField>
                                                <ItemTemplate>
                                                    <asp:CheckBoxList runat="server" ID="cblModulePermission" RepeatDirection="Horizontal"></asp:CheckBoxList>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </td>
                            </tr>
                        </table>
                    </ItemTemplate>
                </asp:Repeater>
            </td>
        </tr>            
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="返回" class="btn wd1" onclick="Redirect('BaseRoleList.aspx')" />                           
                <input class="btnLine" type="button" />  
                <asp:Button ID="Button1" runat="server" Text="保存" CssClass="btn wd1" 
                    onclick="btnSave_Click" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>
<script type="text/javascript">
    function SelectAllTable(flag, tableID) {
        var m_list_table = document.getElementById(tableID);

        var m_list_checkbox = GelTags("input", m_list_table);
        for (var i = m_list_checkbox.length - 1; i >= 0; i--) {
            m_list_checkbox[i].checked = flag;
        }
    }
</script>
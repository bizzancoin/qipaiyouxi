<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MallTypeInfo.aspx.cs" Inherits="Game.Web.Module.MallManager.MallTypeInfo" %>

<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="/scripts/common.js"></script>

    <script type="text/javascript" src="../../scripts/comm.js"></script>

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
            <td width="19" height="25" valign="top" class="Lpd10">
                <div class="arr">
                </div>
            </td>
            <td width="1232" height="25" valign="top" align="left">
                你当前位置：商城系统 - 类型管理
            </td>
        </tr>
        </table>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td class="titleOpBg Lpd10">
                    <input id="btnReturn" type="button" value="返回" class="btn wd1" onclick="Redirect('MallTypeList.aspx')" />
                    <asp:Button ID="btnCreate" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
                </td>
            </tr>
        </table>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
            <tr>
                <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                    <div class="hg3  pd7">
                        类型信息</div>
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">类型名称：</td>
                <td>
                    <asp:TextBox ID="txtTypeName" runat="server" CssClass="text wd7"></asp:TextBox>
                    &nbsp;<span class="hong">*</span>
                    <asp:RequiredFieldValidator ID="rvt" runat="server" ForeColor="Red" ControlToValidate="txtTypeName" Display="Dynamic" ErrorMessage="类型名称不能为空"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">排列序号：</td>
                <td>
                    <asp:TextBox ID="txtSortID" runat="server" CssClass="text wd7"></asp:TextBox>
                    &nbsp;<span class="hong">*</span>
                    <asp:RequiredFieldValidator ID="rv" runat="server" ForeColor="Red" ControlToValidate="txtSortID" Display="Dynamic" ErrorMessage="排列序号不能为空"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="re" ForeColor="Red" ControlToValidate="txtSortID" Display="Dynamic" ValidationExpression="^[0-9]\d*$" runat="server" ErrorMessage="输入格式不正确"></asp:RegularExpressionValidator>
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">禁用状态：</td>
                <td>
                    <asp:RadioButtonList ID="rbNullity" runat="server" RepeatDirection="Horizontal" 
                        RepeatLayout="Flow">
                        <asp:ListItem Text="启用" Value="0" Selected="True"></asp:ListItem>
                        <asp:ListItem Text="禁用" Value="1"></asp:ListItem>
                    </asp:RadioButtonList>
                </td>
            </tr>
        </table>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td class="titleOpBg Lpd10">
                    <input id="btnReturn2" type="button" value="返回" class="btn wd1" onclick="Redirect('MallTypeList.aspx')" />
                    <asp:Button ID="btnSave2" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>

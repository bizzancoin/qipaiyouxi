<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GameGiftSubInfo.aspx.cs" Inherits="Game.Web.Module.AppManager.GameGiftSubInfo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="/scripts/common.js"></script>
    <script type="text/javascript" src="/scripts/comm.js"></script>
    <script type="text/javascript" src="/scripts/jquery.js"></script>
    <script type="text/javascript" src="/scripts/jquery.validate.js"></script>
    <script type="text/javascript" src="/scripts/messages_cn.js"></script>
    <script type="text/javascript" src="/scripts/jquery.metadata.js"></script>
    <script type="text/javascript">
        jQuery(document).ready(function() {
            jQuery.metadata.setType("attr", "validate");
            jQuery.validator.addMethod("decmal1", function(value, element) {
                var decmal = /^\d+(\.\d+)?$/;
                return decmal.test(value) || this.optional(element);
            });
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
                你当前位置：系统维护 - 礼包管理
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="Tmg7">
        <tr>
            <td height="28">
                <ul>
                    <li class="tab2" onclick="Redirect('GamePropertyManager.aspx')">道具管理</li>
                    <li class="tab2" onclick="Redirect('GamePropertyTypeList.aspx')">类型管理</li>
                    <li class="tab2" onclick="Redirect('GamePropertyRelatList.aspx')">道具关联</li>
                    <li class="tab2" onclick="Redirect('GameGiftList.aspx')">礼包管理</li>
                    <li class="tab1">礼包明细</li>
                </ul>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="返回" class="btn wd1" onclick="Redirect('GameGiftSubList.aspx?param=<% =ownerID %>');" />
                <asp:Button ID="btnSave" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                <div class="hg3  pd7">
                    <asp:Literal ID="litInfo" runat="server"></asp:Literal>礼包明细信息</div>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                道具名称：
            </td>
            <td>
                <asp:DropDownList ID="ddlGameProperty" runat="server"></asp:DropDownList>
            </td>
        </tr>              
        <tr>
            <td class="listTdLeft">
                数量：
            </td>
            <td>
                <asp:TextBox ID="txtCount" runat="server" CssClass="text" validate="{digits:true}" Text="1"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                排序：
            </td>
            <td>
                <asp:TextBox ID="txtSortID" runat="server" CssClass="text" validate="{digits:true}" Text="0"></asp:TextBox>
            </td>
        </tr>        
        <tr>
            <td class="listTdLeft">
            </td>
            <td class="hong">
                注意：修改成功后需重启游戏服务端才可生效
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="返回" class="btn wd1" onclick="Redirect('GameGiftSubList.aspx?param=<% =ownerID %>');" />
                <asp:Button ID="btnSave1" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

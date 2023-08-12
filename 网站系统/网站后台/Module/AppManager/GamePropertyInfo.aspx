<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GamePropertyInfo.aspx.cs" Inherits="Game.Web.Module.AppManager.GamePropertyInfo" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
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
    <!-- 头部菜单 Start -->
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="title">
        <tr>
            <td width="19" height="25" valign="top" class="Lpd10">
                <div class="arr">
                </div>
            </td>
            <td width="1232" height="25" valign="top" align="left">
                你当前位置：系统维护 - 道具管理
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="Tmg7">
        <tr>
            <td height="28">
                <ul>
                    <li class="tab1">道具管理</li>
                    <li class="tab2" onclick="Redirect('GamePropertyTypeList.aspx')">类型管理</li>
                    <li class="tab2" onclick="Redirect('GamePropertyRelatList.aspx')">道具关联</li>
                    <li class="tab2" onclick="Redirect('GameGiftList.aspx')">礼包管理</li>
                </ul>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="返回" class="btn wd1" onclick="Redirect('GamePropertyManager.aspx');" />
                <asp:Button ID="btnSave" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                <div class="hg3  pd7">
                    道具信息</div>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                道具名称：
            </td>
            <td>
                <asp:TextBox ID="txtName" runat="server" CssClass="text" validate="{required:true}"></asp:TextBox>
            </td>
        </tr>        
        <tr>
            <td class="listTdLeft">
                游戏豆价格：
            </td>
            <td>
                <asp:TextBox ID="txtCash" runat="server" CssClass="text" validate="{number:true}" Text="0"></asp:TextBox>
            </td>
        </tr>        
        <tr>
            <td class="listTdLeft">
                游戏币价格：
            </td>
            <td>
                <asp:TextBox ID="txtGold" runat="server" CssClass="text" validate="{digits:true}" onkeyup="if(isNaN(value))execCommand('undo');"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                元宝价格：
            </td>
            <td>
                <asp:TextBox ID="txtUserMedal" runat="server" CssClass="text" validate="{digits:true}" onkeyup="if(isNaN(value))execCommand('undo');"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                魅力值价格：
            </td>
            <td>
                <asp:TextBox ID="txtLoveLiness" runat="server" CssClass="text" validate="{digits:true}" onkeyup="if(isNaN(value))execCommand('undo');"></asp:TextBox>
            </td>
        </tr>
        <%--<tr>
            <td class="listTdLeft">
                使用范围：
            </td>
            <td>
                <asp:CheckBoxList ID="ckbIssueArea" runat="server" RepeatDirection="Horizontal">
                </asp:CheckBoxList>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                作用范围：
            </td>
            <td>
                <asp:CheckBoxList ID="ckbServiceArea" runat="server" RepeatDirection="Horizontal">
                </asp:CheckBoxList>
            </td>
        </tr>--%>
        <tr>
            <td class="listTdLeft">
                赠送魅力值：
            </td>
            <td>
                <asp:TextBox ID="txtSendLoveLiness" runat="server" CssClass="text" validate="{number:true}"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                购买赠送游戏币：
            </td>
            <td>
                <asp:TextBox ID="txtBuyResultsGold" runat="server" CssClass="text" validate="{digits:true}"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                接收魅力值：
            </td>
            <td>
                <asp:TextBox ID="txtRecvLoveLiness" runat="server" CssClass="text" validate="{number:true}"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                <asp:Label ID="lbGoldText" runat="server" Text="增加金币"></asp:Label>：
            </td>
            <td>
                <asp:TextBox ID="txtUseResultsGold" runat="server" CssClass="text" validate="{digits:true}"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                持续时间：
            </td>
            <td>
                <asp:TextBox ID="txtUseResultsValidTime" runat="server" CssClass="text" validate="{digits:true}"></asp:TextBox>&nbsp;秒
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                积分倍率：
            </td>
            <td>
                <asp:TextBox ID="txtUseResultsValidTimeScoreMultiple" runat="server" CssClass="text" validate="{digits:true}"></asp:TextBox>
            </td>
        </tr>  
        <tr>
            <td class="listTdLeft">
                道具排序：
            </td>
            <td>
                <asp:TextBox ID="txtSortID" runat="server" CssClass="text" validate="{number:true}"></asp:TextBox>
            </td>
        </tr>      
        <tr>
            <td class="listTdLeft">
                使用说明：
            </td>
            <td>
                <asp:TextBox ID="txtRegulationsInfo" runat="server" CssClass="text" Width="300" MaxLength="256"></asp:TextBox>&nbsp;使用说明字符长度不可超过128个字符
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                是否推荐：
            </td>
            <td>
                <asp:CheckBox ID="ckbRecommend" runat="server" Text="推荐" />
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                是否启用：
            </td>
            <td>
                <asp:CheckBox ID="ckbNullity" runat="server" Text="启用" />
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
                <input type="button" value="返回" class="btn wd1" onclick="Redirect('GamePropertyManager.aspx');" />
                <asp:Button ID="btnSave1" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

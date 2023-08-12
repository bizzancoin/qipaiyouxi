<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PayConfigInfo.aspx.cs" Inherits="Game.Web.Module.FilledManager.PayConfigInfo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="../../scripts/common.js"></script>

    <script type="text/javascript" src="../../scripts/comm.js"></script>

    <script type="text/javascript" src="../../scripts/jquery.js"></script>

    <script type="text/javascript" src="../../scripts/jquery.validate.js"></script>

    <script type="text/javascript" src="../../scripts/messages_cn.js"></script>

    <script type="text/javascript" src="../../scripts/jquery.metadata.js"></script>

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
                你当前位置：充值系统 - 网站支付
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input id="btnReturn" type="button" value="返回" class="btn wd1" onclick="Redirect('PayConfigList.aspx')" />
                <asp:Button ID="btnCreate" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    
     <asp:ScriptManager ID="ScriptManager1" runat="server">
     </asp:ScriptManager>
     <asp:UpdatePanel ID="UpdatePanel1" runat="server" ChildrenAsTriggers="True">
         <ContentTemplate>
             <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                <div class="hg3  pd7">
                    产品信息</div>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                产品类别：
            </td>
            <td>
                <asp:DropDownList ID="ddlProductType" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlProductType_SelectedIndexChanged">
                    <asp:ListItem Text="网银充值" Value="800"></asp:ListItem>
                    <asp:ListItem Text="支付宝充值" Value="801"></asp:ListItem>
                    <asp:ListItem Text="微信充值" Value="802"></asp:ListItem>
                    <asp:ListItem Text="易宝支付" Value="803"></asp:ListItem>
                    <asp:ListItem Text="支付宝官方充值" Value="804"></asp:ListItem>
                    <asp:ListItem Text="微信官方充值" Value="805"></asp:ListItem>
                    <asp:ListItem Text="骏网一卡通" Value="101"></asp:ListItem>
                    <asp:ListItem Text="盛大充值卡" Value="102"></asp:ListItem>
                    <asp:ListItem Text="神州行充值卡" Value="103"></asp:ListItem>
                    <asp:ListItem Text="征途充值卡" Value="104"></asp:ListItem>
                    <asp:ListItem Text="Q币充值卡" Value="105"></asp:ListItem>
                    <asp:ListItem Text="联通充值卡" Value="106"></asp:ListItem>
                    <asp:ListItem Text="久游充值卡" Value="107"></asp:ListItem>
                    <asp:ListItem Text="易宝e卡通" Value="108"></asp:ListItem>
                    <asp:ListItem Text="网易充值卡" Value="109"></asp:ListItem>
                    <asp:ListItem Text="完美充值卡" Value="110"></asp:ListItem>
                    <asp:ListItem Text="搜狐充值卡" Value="111"></asp:ListItem>
                    <asp:ListItem Text="电信充值卡" Value="112"></asp:ListItem>
                    <asp:ListItem Text="纵游一卡通" Value="113"></asp:ListItem>
                    <asp:ListItem Text="天下一卡通" Value="114"></asp:ListItem>
                    <asp:ListItem Text="天宏一卡通" Value="115"></asp:ListItem>
                    <asp:ListItem Text="全国电话手机充值" Value="200"></asp:ListItem>
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                产品名称：
            </td>
            <td>
                <asp:TextBox ID="txtProductName" Enabled="false" runat="server" CssClass="text" Text="网银充值" validate="{required:true}"></asp:TextBox>
            </td>
        </tr> 
        <tr>
            <td class="listTdLeft">
                产品价格：
            </td>
            <td>
                <asp:TextBox ID="txtPrice" runat="server" CssClass="text" validate="{required:true}" onkeyup="if(isNaN(value))execCommand('undo');"></asp:TextBox>
                <asp:DropDownList ID="ddlPrice" runat="server" Visible="false">
                </asp:DropDownList>

            </td>
        </tr> 
        <tr>
            <td class="listTdLeft">
                赠送游戏豆：
            </td>
            <td>
                <asp:TextBox ID="txtCurrency" runat="server" CssClass="text" validate="{required:true}" onkeyup="if(isNaN(value))execCommand('undo');"></asp:TextBox>
            </td>
        </tr>  
        <%--<tr>
            <td class="listTdLeft">
                首充奖励游戏豆：
            </td>
            <td>
                <asp:TextBox ID="txtAttachCurrency" runat="server" CssClass="text" validate="{required:true}" onkeyup="if(isNaN(value))execCommand('undo');"></asp:TextBox>
                &nbsp;<span class="hong">设置为0不支持首充</span>
            </td>
        </tr>  --%>
        <tr>
            <td class="listTdLeft">
                排序标识：
            </td>
            <td>
                <asp:TextBox ID="txtSortID" runat="server" CssClass="text" validate="{required:true}" onkeyup="if(isNaN(value))execCommand('undo');"></asp:TextBox>
            </td>
        </tr>   
    </table>
         </ContentTemplate>
     </asp:UpdatePanel>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input id="btnReturn2" type="button" value="返回" class="btn wd1" onclick="Redirect('PayConfigList.aspx')" />
                <asp:Button ID="btnSave2" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

<script type="text/javascript">
    jQuery(document).ready(function() {
        jQuery.metadata.setType("attr", "validate");
        jQuery("#<%=form1.ClientID %>").validate();
    });
</script>

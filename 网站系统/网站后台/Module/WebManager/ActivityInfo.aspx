<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ActivityInfo.aspx.cs" Inherits="Game.Web.Module.WebManager.ActivityInfo" %>

<%@ Register Src="/Tools/ImageUploader.ascx" TagName="ImageUploader" TagPrefix="GameImg" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link href="/styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/scripts/common.js"></script>
    <script type="text/javascript" src="/scripts/comm.js"></script>
    <script type="text/javascript" src="/scripts/jquery.js"></script>
    <script type="text/javascript" src="/scripts/messages_cn.js"></script>
    <script type="text/javascript" src="/scripts/kindEditor/kindeditor.js"></script>
    <script type="text/javascript">
        KE.show({
            id: 'txtBody',
            imageUploadJson: '/Tools/KindEditorUpload.ashx?type=activity',
            fileManagerJson: '/Tools/KindEditorFileManager.ashx?type=activity',
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
                    你当前位置：网站系统 - 活动管理
                </td>
            </tr>
        </table>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td class="titleOpBg Lpd10">
                    <input id="btnReturn" type="button" value="返回" class="btn wd1" onclick="Redirect('ActivityList.aspx')" />
                    <asp:Button ID="btnCreate" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
                </td>
            </tr>
        </table>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
            <tr>
                <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                    <div class="hg3  pd7">
                        活动管理</div>
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">活动名称：</td>
                <td>
                   <asp:TextBox ID="txtActivityTitle" runat="server" CssClass="text wd7" MaxLength="50"></asp:TextBox>
                   &nbsp;<span class="hong">*</span>
                   <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ForeColor="Red" ControlToValidate="txtActivityTitle" Display="Dynamic" ErrorMessage="请输入任务名称"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">图片地址：</td>
                <td>
                    <GameImg:ImageUploader ID="upImage" runat="server" DeleteButtonClass="l2" DeleteButtonText="删除" Folder="/Upload/Activity" ViewButtonClass="l2" ViewButtonText="查看" TextBoxClass="text"/> <span>[尺寸：680*170 体积：不大于1M]</span>
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">排序：</td>
                <td>
                    <asp:TextBox ID="txtSortID" runat="server" CssClass="text wd7" Text="0" MaxLength="8"></asp:TextBox>&nbsp;数字越大排名越靠后
                    &nbsp;<span class="hong">*</span>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ForeColor="Red" ControlToValidate="txtSortID" Display="Dynamic" ErrorMessage="请输入排序"></asp:RequiredFieldValidator>  
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator5" ForeColor="Red" ControlToValidate="txtSortID" Display="Dynamic" ValidationExpression="^[0-9]\d*$" runat="server" ErrorMessage="输入格式不正确"></asp:RegularExpressionValidator>
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">
                    是否推荐至首页：
                </td>
                <td>
                    <asp:RadioButtonList ID="rblIsRecommend" runat="server" RepeatDirection="Horizontal">
                        <asp:ListItem Value="1" Text="推荐" Selected="True"></asp:ListItem>
                        <asp:ListItem Value="0" Text="不推荐"></asp:ListItem>
                    </asp:RadioButtonList>
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">活动描述：</td>
                <td>
                   <asp:TextBox ID="txtBody" runat="server" CssClass="text" Width="650px" Height="350px" TextMode="MultiLine"></asp:TextBox>  
                </td>
            </tr>
        </table>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td class="titleOpBg Lpd10">
                    <input id="btnReturn2" type="button" value="返回" class="btn wd1" onclick="Redirect('ActivityList.aspx')" />
                    <asp:Button ID="btnSave2" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
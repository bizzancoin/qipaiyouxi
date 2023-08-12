<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MatchInfo.aspx.cs" Inherits="Game.Web.Module.WebManager.MatchInfo" %>

<%@ Register Src="/Tools/ImageUploader.ascx" TagName="ImageUploader" TagPrefix="GameImg" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../../scripts/common.js"></script>
    <script type="text/javascript" src="../../scripts/kindEditor/kindeditor.js"></script>
 <script type="text/javascript" src="../../scripts/My97DatePicker/WdatePicker.js"></script>
    <title></title>
    <script type="text/javascript">
        KE.show({
            id: 'txtContent',
            urlType: 'domain',
            imageUploadJson: '/Tools/KindEditorUpload.ashx?type=match',
            fileManagerJson: '/Tools/KindEditorFileManager.ashx?type=match',
            allowFileManager: true
        });
    </script>
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
                你当前位置：网站系统 - 比赛管理
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="返回" class="btn wd1" onclick="Redirect('MatchList.aspx')" />
                <input class="btnLine" type="button" />
                <asp:Button ID="btnSave" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                <div class="hg3  pd7">
                    <asp:Literal ID="litInfo" runat="server"></asp:Literal>比赛信息</div>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                比赛名称：
            </td>
            <td>
                <asp:TextBox ID="txtMatchTitle" runat="server" CssClass="text" Width="465px" MaxLength="100"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rf4" runat="server" ForeColor="Red" Display="Dynamic" ControlToValidate="txtMatchTitle" ErrorMessage="请输入比赛名称"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                比赛描述：
            </td>
            <td>
                <asp:TextBox ID="txtMatchSummary" runat="server" CssClass="text" Width="465px" MaxLength="300"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                缩率图：
            </td>
            <td style="line-height:35px;">
                <GameImg:ImageUploader ID="upThumbnail" runat="server" DeleteButtonClass="l2" DeleteButtonText="删除" Folder="/Upload/Match" ViewButtonClass="l2" ViewButtonText="查看" TextBoxClass="text"/> <span>[尺寸：230*160 体积：不大于1M]</span>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                展示图：
            </td>
            <td style="line-height:35px;">
                <GameImg:ImageUploader ID="upShowPicture" runat="server" DeleteButtonClass="l2" DeleteButtonText="删除" Folder="/Upload/Match" ViewButtonClass="l2" ViewButtonText="查看" TextBoxClass="text"/> <span>[体积：不大于1M]</span>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                比赛时间：
            </td>
            <td>
                <asp:TextBox ID="txtMatchDate" runat="server" CssClass="text" Width="465px" MaxLength="300"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ForeColor="Red" Display="Dynamic" ControlToValidate="txtMatchDate" ErrorMessage="请输入比赛时间"></asp:RequiredFieldValidator>
            </td>
        </tr>
         <tr>
            <td class="listTdLeft">
                比赛状态：
            </td>
            <td>
                <asp:RadioButtonList ID="rblMatchStatus" runat="server" RepeatDirection="Horizontal">
                    <asp:ListItem Value="0" Text="未开始" Selected="True"></asp:ListItem>
                    <asp:ListItem Value="1" Text="进行中"></asp:ListItem>
                    <asp:ListItem Value="2" Text="已结束"></asp:ListItem>
                </asp:RadioButtonList>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                冻结状态：
            </td>
            <td>
                <asp:RadioButtonList ID="rbtnNullity" runat="server" RepeatDirection="Horizontal">
                    <asp:ListItem Value="0" Text="正常" Selected="True"></asp:ListItem>
                    <asp:ListItem Value="1" Text="冻结"></asp:ListItem>
                </asp:RadioButtonList>
            </td>
        </tr>      
        <tr>
            <td class="listTdLeft">
                是否推荐：
            </td>
            <td>
                <asp:RadioButtonList ID="rblIsRecommend" runat="server" RepeatDirection="Horizontal">
                    <asp:ListItem Value="1" Text="推荐" Selected="True"></asp:ListItem>
                    <asp:ListItem Value="0" Text="不推荐"></asp:ListItem>
                </asp:RadioButtonList>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                内容：
            </td>
            <td>
                <asp:TextBox ID="txtContent" runat="server" CssClass="text" Width="650px" Height="350px" TextMode="MultiLine"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ForeColor="Red" Display="Dynamic" ControlToValidate="txtContent" ErrorMessage="请输入比赛内容"></asp:RequiredFieldValidator>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="返回" class="btn wd1" onclick="Redirect('MatchList.aspx')" />
                <input class="btnLine" type="button" />
                <asp:Button ID="Button1" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MatchConfigInfo.aspx.cs" Inherits="Game.Web.Module.MatchManager.MatchConfigInfo" %>
<%@ Register Src="/Tools/ImageUploader.ascx" TagName="ImageUploader" TagPrefix="GameImg" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="/styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/scripts/JQuery.js"></script>
    <script type="text/javascript" src="/scripts/common.js"></script>
    <script type="text/javascript" src="/scripts/kindEditor/kindeditor.js"></script>
    <script type="text/javascript" src="/scripts/My97DatePicker/WdatePicker.js"></script>
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
    <form id="form1" runat="server" method="post">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="title">
            <tr>
                <td width="19" height="25" valign="top" class="Lpd10">
                    <div class="arr">
                    </div>
                </td>
                <td width="1232" height="25" valign="top" align="left">
                    你当前位置：比赛系统 - 比赛配置
                </td>
            </tr>
        </table>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td class="titleOpBg Lpd10">
                    <input id="btnReturn" type="button" value="返回" class="btn wd1" onclick="Redirect('MatchConfigList.aspx')" />
                    <asp:Button ID="btnCreate" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
                </td>
            </tr>
        </table>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
            <tr>
                <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                    <div class="hg3  pd7">配置信息</div>
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">比赛名称：</td>
                <td>
                   <asp:Label ID="lblMatchName" runat="server"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">比赛类型：</td>
                <td>
                    <asp:Label ID="lblMatchTypeName" runat="server"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">比赛状态：</td>
                <td>
                    <asp:Label ID="lblMatchStatusName" runat="server"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">
                    所属游戏：
                </td>
                <td>
                    <asp:Label ID="lblKindName" runat="server"></asp:Label>
                </td>
            </tr>            
        </table>        
        <table id="Table1" width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2" runat="server">
            <tr>
                <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                    <div class="hg3 pd7">奖励配置</div>
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">
                    &nbsp;
                </td>
                <td>
                    <%= strReward%>
                </td>
            </tr>
        </table>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2" runat="server">
            <tr>
                <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                    <div class="hg3 pd7">网站展示</div>
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">
                    比赛摘要：
                </td>
                <td>
                    <asp:TextBox ID="txtMatchSummary" runat="server" CssClass="text" Width="650px" MaxLength="300"></asp:TextBox>
                    &nbsp;<span class="hong">*</span>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator18" runat="server" ForeColor="Red" ControlToValidate="txtMatchSummary" Display="Dynamic" ErrorMessage="请输入比赛摘要"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">
                    比赛日期：
                </td>
                <td>
                    <asp:Label ID="lblMatchDate" runat="server"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">
                    排序：
                </td>
                <td>
                    <asp:TextBox ID="txtSortID" runat="server" CssClass="text" Width="200px" Text="0"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">
                    展示图：
                </td>
                <td style="line-height:35px;">
                    <GameImg:ImageUploader ID="upSmallImage" runat="server" DeleteButtonClass="l2" DeleteButtonText="删除" Folder="/Upload/Match" ViewButtonClass="l2" ViewButtonText="查看" TextBoxClass="text"/>  &nbsp;<span class="hong">*</span> <span>[尺寸：680*170 体积：不大于1M]</span>
                </td>
            </tr>          
            <tr>
                <td class="listTdLeft">
                    比赛描述：(<span class="hong">*</span>)：
                </td>
                <td>
                    <asp:TextBox ID="txtContent" runat="server" CssClass="text" Width="650px" Height="350px" TextMode="MultiLine"></asp:TextBox>
                </td>
            </tr>
        </table>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td class="titleOpBg Lpd10">
                    <input id="btnReturn2" type="button" value="返回" class="btn wd1" onclick="Redirect('MatchConfigList.aspx')" />
                    <asp:Button ID="btnSave2" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
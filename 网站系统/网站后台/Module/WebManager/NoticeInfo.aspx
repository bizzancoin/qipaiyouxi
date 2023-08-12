<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NoticeInfo.aspx.cs" Inherits="Game.Web.Module.WebManager.NoticeInfo" %>

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
            id: 'txtBody',
            urlType: 'domain',
            imageUploadJson: '/Tools/KindEditorUpload.ashx?type=news',
            fileManagerJson: '/Tools/KindEditorFileManager.ashx?type=news',
            allowFileManager: true
        });
    </script>

</head>
<body>
    <form id="form1" runat="server" onsubmit="return checkForm()">
    <!-- 头部菜单 Start -->
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="title">
        <tr>
            <td width="19" height="25" valign="top" class="Lpd10">
                <div class="arr">
                </div>
            </td>
            <td width="1232" height="25" valign="top" align="left">
                你当前位置：网站系统 - 弹出页面
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="返回" class="btn wd1" onclick="Redirect('NoticeList.aspx')" />
                <input class="btnLine" type="button" />
                <asp:Button ID="btnSave" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                <div class="hg3  pd7">
                    <asp:Literal ID="litInfo" runat="server"></asp:Literal>弹出页面</div>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                标题：
            </td>
            <td>
                <asp:TextBox ID="txtSubject" runat="server" CssClass="text" Width="465px" MaxLength="64"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="请填写标题" ControlToValidate="txtSubject" Display="Dynamic"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                引用：
            </td>
            <td>
                <asp:TextBox ID="txtLinkUrl" runat="server" CssClass="text" Text="http://" Width="550px" MaxLength="256"></asp:TextBox>
                <asp:CheckBox ID="chkIsLinks" runat="server" Text="链接地址" />
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                内容：
            </td>
            <td>
                <asp:TextBox ID="txtBody" runat="server" CssClass="text" Width="650px" Height="350px" TextMode="MultiLine"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                宽度：
            </td>
            <td>
                <asp:TextBox ID="txtWidth" runat="server" CssClass="text" Text="0"></asp:TextBox>
                  &nbsp;&nbsp;
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="请填写" ControlToValidate="txtWidth" Display=Dynamic></asp:RequiredFieldValidator>
                <asp:RangeValidator ID="RangeValidator1" runat="server" ErrorMessage="只能填写数字，范围为0-2000" ControlToValidate="txtWidth" MinimumValue="0" MaximumValue="2000" Type="Integer" Display="Dynamic"></asp:RangeValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                高度：
            </td>
            <td>
                <asp:TextBox ID="txtHeight" runat="server" CssClass="text" Text="0"></asp:TextBox>
                  <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="请填写" ControlToValidate="txtHeight" Display=Dynamic></asp:RequiredFieldValidator>
                <asp:RangeValidator ID="RangeValidator2" runat="server" ErrorMessage="只能填写数字，范围为0-2000" ControlToValidate="txtHeight" MinimumValue="0" MaximumValue="2000" Type="Integer" Display="Dynamic"></asp:RangeValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                开始时间：
            </td>
            <td>
                <asp:TextBox ID="txtStartDate" runat="server" CssClass="text"  onFocus="WdatePicker({el:'txtStartDate',skin:'whyGreen',dateFmt:'yyyy-MM-dd HH:mm:ss',maxDate:'#F{$dp.$D(\'txtOverDate\')}'})"></asp:TextBox><img src="../../Images/btn_calendar.gif" onclick="WdatePicker({el:'txtStartDate',skin:'whyGreen',dateFmt:'yyyy-MM-dd HH:mm:ss'})"
                    style="cursor: pointer; vertical-align: middle" />
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="请填写开始日期" ControlToValidate="txtStartDate" Display="Dynamic"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                结束时间：
            </td>
            <td>
                <asp:TextBox ID="txtOverDate" runat="server" CssClass="text" onFocus="WdatePicker({el:'txtOverDate',skin:'whyGreen',dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'txtStartDate\')}'})"></asp:TextBox><img src="../../Images/btn_calendar.gif" onclick="WdatePicker({el:'txtOverDate',skin:'whyGreen',dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'txtStartDate\')}'})"
                    style="cursor: pointer; vertical-align: middle" />
                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="请填写结束日期" ControlToValidate="txtOverDate" Display="Dynamic"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                禁用状态：
            </td>
            <td>
                <asp:RadioButtonList ID="rbtnNullity" runat="server" RepeatDirection="Horizontal">
                    <asp:ListItem Value="0" Text="正常" Selected="True"></asp:ListItem>
                    <asp:ListItem Value="1" Text="禁用"></asp:ListItem>
                </asp:RadioButtonList>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                公告范围：
            </td>
            <td>
                <asp:CheckBoxList ID="ckbLocation" runat="server" RepeatDirection="Horizontal">                   
                </asp:CheckBoxList>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="返回" class="btn wd1" onclick="Redirect('NoticeList.aspx')" />
                <input class="btnLine" type="button" />
                <asp:Button ID="Button1" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

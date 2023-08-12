<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MobileNoticeInfo.aspx.cs" Inherits="Game.Web.Module.WebManager.MobileNoticeInfo" %>

<%@ Register Src="~/Themes/TopMobileNotice.ascx" TagPrefix="Fox" TagName="Notice" %>
<%@ Register Src="/Tools/ImageUploader.ascx" TagName="ImageUploader" TagPrefix="GameImg" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title></title>
    <link href="/styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/scripts/common.js"></script>
    <script type="text/javascript" src="/scripts/jquery.js"></script>
    <script type="text/javascript">
        //$(function () {
        //    $("#gameRangeAll").change(function () {
        //        if ($(this).prop("checked")) {
        //            $('#gameList input[type="checkbox"]').not("#gameRangeAll").prop("checked", true);
        //        }
        //        else {
        //            $('#gameList input[type="checkbox"]').not("#gameRangeAll").prop("checked", false);
        //        }
        //    });

        //    $('#gameList input[type="checkbox"]').change(function () {
        //        var all=$("#gameRangeAll");
        //        if (all.prop("checked")) {
        //            if (!$(this).prop("checked")) {
        //                all.prop("checked", false)
        //            }
        //        }
        //    })
        //});
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <!-- 头部菜单 Start -->
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="title">
        <tr>
            <td width="19" height="25" valign="top"  class="Lpd10"><div class="arr"></div></td>
            <td width="1232" height="25" valign="top" align="left">你当前位置：网站系统 - 新闻管理</td>
        </tr>
    </table>  
    <Fox:Notice ID="Notice1" runat="server" NewsPageID="2"></Fox:Notice>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="返回" class="btn wd1" onclick="Redirect('MobileNoticeList.aspx')" />                           
                <input class="btnLine" type="button" />  
                <asp:Button ID="btnSave" runat="server" Text="保存" CssClass="btn wd1" 
                    onclick="btnSave_Click" />
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10"><div class="hg3  pd7">
                <asp:Literal ID="litInfo" runat="server"></asp:Literal>新闻</div></td>
        </tr>
        <tr>
            <td class="listTdLeft">标题：</td>
            <td>        
                <asp:TextBox ID="txtSubject" runat="server" CssClass="text" Width="465px"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rf4" runat="server" ForeColor="Red" Display="Dynamic" ControlToValidate="txtSubject" ErrorMessage="请输入标题内容"></asp:RequiredFieldValidator>         
            </td>
        </tr>
        <%--<tr>
            <td class="listTdLeft">
                广告图片：
            </td>
            <td style="line-height:35px;">
                <GameImg:ImageUploader ID="upImageUrl" runat="server" DeleteButtonClass="l2" DeleteButtonText="删除" Folder="/Upload/News" ViewButtonClass="l2" ViewButtonText="查看" TextBoxClass="text"/> <span>[尺寸：73*73 体积：不大于1M]</span>
            </td>
        </tr>--%>
        <tr>
            <td class="listTdLeft">是否置顶：</td>
            <td>        
                <asp:CheckBox ID="chkOnTop" runat="server" Text="是" />
            </td>
        </tr>
        <tr>
            <td class="listTdLeft" style="margin-top:10px;">内容：</td>
            <td>        
                <asp:TextBox ID="txtBody" runat="server" CssClass="text" Width="650px" Height="350px" TextMode="MultiLine"></asp:TextBox>  
            </td>
        </tr>    
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="返回" class="btn wd1" onclick="Redirect('MobileNoticeList.aspx')" />                           
                <input class="btnLine" type="button" />  
                <asp:Button ID="Button1" runat="server" Text="保存" CssClass="btn wd1" onclick="btnSave_Click" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>
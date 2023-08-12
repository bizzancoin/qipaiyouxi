<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RulesInfo.aspx.cs" Inherits="Game.Web.Module.WebManager.RulesInfo" %>

<%@ Register Src="/Tools/ImageUploader.ascx" TagName="ImageUploader" TagPrefix="GameImg" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../../scripts/common.js"></script>
    <script type="text/javascript" src="../../scripts/kindEditor/kindeditor.js"></script>
    <script type="text/javascript" src="../../scripts/My97DatePicker/WdatePicker.js"></script>
    <title></title>
    <script type="text/javascript">
        /*
        * 设置图片文件
        */
        function setImgFilePath(frID, uploadPath) {
            document.getElementById(frID).contentWindow.setUploadFileView(uploadPath);
        }
        
        KE.show({
            id: 'txtHelpRule',
            imageUploadJson: '/Tools/KindEditorUpload.ashx?type=rules',
            fileManagerJson: '/Tools/KindEditorFileManager.ashx?type=rules',
            allowFileManager: true
        });

        KE.show({
            id: 'txtHelpGrade',
            imageUploadJson: '/Tools/KindEditorUpload.ashx?type=rules',
            fileManagerJson: '/Tools/KindEditorFileManager.ashx?type=rules',
            allowFileManager: true
        });

        KE.show({
            id: 'txtMobileIntro',
            imageUploadJson: '/Tools/KindEditorUpload.ashx?type=rules',
            fileManagerJson: '/Tools/KindEditorFileManager.ashx?type=rules',
            allowFileManager: true
        });

        KE.show({
            id: 'txtRoomCardIntro',
            imageUploadJson: '/Tools/KindEditorUpload.ashx?type=rules',
            fileManagerJson: '/Tools/KindEditorFileManager.ashx?type=rules',
            allowFileManager: true
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <!-- 头部菜单 Start -->
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="title">
        <tr>
            <td width="19" height="25" valign="top"  class="Lpd10"><div class="arr"></div></td>
            <td width="1232" height="25" valign="top" align="left">你当前位置：网站系统 - 规则管理</td>
        </tr>
    </table>  
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="返回" class="btn wd1" onclick="Redirect('RulesList.aspx')" />                           
                <input class="btnLine" type="button" />  
                <asp:Button ID="btnSave" runat="server" Text="保存" CssClass="btn wd1" 
                    onclick="btnSave_Click" />
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10"><div class="hg3  pd7">
                <asp:Literal ID="litInfo" runat="server"></asp:Literal>规则</div></td>
        </tr>
        <tr>
            <td class="listTdLeft">游戏名称：</td>
            <td>             
                <asp:DropDownList ID="ddlKind" runat="server" Width="150px">
                </asp:DropDownList>      
            </td>
        </tr>     
        <tr>
            <td class="listTdLeft">
                游戏ICO图标：
            </td>
            <td style="line-height:35px;">
                <GameImg:ImageUploader ID="upThumbnail" runat="server" DeleteButtonClass="l2" DeleteButtonText="删除" Folder="/Upload/Rules" ViewButtonClass="l2" ViewButtonText="查看" TextBoxClass="text"/> <span>[尺寸：73*73 体积：不大于1M]</span>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                PC网站效果图：
            </td>
            <td style="line-height:35px;">
                <GameImg:ImageUploader ID="upShowPicture" runat="server" DeleteButtonClass="l2" DeleteButtonText="删除" Folder="/Upload/Rules" ViewButtonClass="l2" ViewButtonText="查看" TextBoxClass="text"/> <span>[体积：不大于1M]</span>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                移动端网站效果图：
            </td>
            <td style="line-height:35px;">
                <GameImg:ImageUploader ID="upMobilePicture" runat="server" DeleteButtonClass="l2" DeleteButtonText="删除" Folder="/Upload/Rules" ViewButtonClass="l2" ViewButtonText="查看" TextBoxClass="text"/> <span>[体积：不大于1M]</span>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">移动版设置：</td>
            <td>
                <asp:CheckBoxList ID="cblMoblieGameType" runat="server" RepeatDirection="Horizontal">
                    <asp:ListItem Text="是否有Android版" Value="1"></asp:ListItem>
                    <asp:ListItem Text="是否有IOS版" Value="2"></asp:ListItem>
                </asp:CheckBoxList>
            </td>
        </tr> 
        <%--<tr>
            <td class="listTdLeft">Android版下载地址：</td>
            <td>
                 <asp:TextBox ID="txtAndroidDownloadUrl" runat="server" CssClass="text" MaxLength="512" Width="200"></asp:TextBox>&nbsp;无Android版不填写
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">IOS版下载地址：</td>
            <td>             
               <asp:TextBox ID="txtIOSDownloadUrl" runat="server" CssClass="text" MaxLength="512" Width="200"></asp:TextBox>&nbsp;无IOS版不填写
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">移动端大小：</td>
            <td>             
               <asp:TextBox ID="txtMoileSize" runat="server" CssClass="text" MaxLength="512" Width="200"></asp:TextBox>&nbsp;无IOS版不填写
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">移动端更新时间：</td>
            <td>             
               <asp:TextBox ID="txtMobileDate" runat="server" CssClass="text" MaxLength="512" Width="175" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})"></asp:TextBox><img
                    src="../../Images/btn_calendar.gif" onclick="WdatePicker({el:'txtMobileDate',dateFmt:'yyyy-MM-dd'})"
                    style="cursor: pointer; vertical-align: middle" />&nbsp;无IOS版不填写
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">移动端版本号：</td>
            <td>             
               <asp:TextBox ID="txtMobileVersion" runat="server" CssClass="text" MaxLength="512" Width="200"></asp:TextBox>&nbsp;无IOS版不填写
            </td>
        </tr>--%>
        <tr runat="server" id="trGameImage" visible="false">
            <td class="listTdLeft"></td>
            <td>             
                <asp:Image ID="imgGame" runat="server" Width="450" Height="300"/>
            </td>
        </tr>  
        <tr>
            <td class="listTdLeft">游戏介绍：</td>
            <td style="padding:5px 0 5px 0;">             
                <asp:TextBox ID="txtHelpIntro" runat="server" TextMode="MultiLine" Width="650px" Height="150px"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">规则介绍：</td>
            <td style="padding:5px 0 5px 0;">             
                <asp:TextBox ID="txtHelpRule" runat="server" TextMode="MultiLine" Width="650px" Height="250px"></asp:TextBox>  
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">等级介绍：</td>
            <td style="padding:5px 0 5px 0;">             
                <asp:TextBox ID="txtHelpGrade" runat="server" TextMode="MultiLine" Width="650px" Height="250px"></asp:TextBox>       
            </td>
        </tr>   
        <tr>
            <td class="listTdLeft">手机玩法介绍：</td>
            <td style="padding:5px 0 5px 0;">             
                <asp:TextBox ID="txtMobileIntro" runat="server" TextMode="MultiLine" Width="650px" Height="250px"></asp:TextBox>       
            </td>
        </tr>   
        <tr>
            <td class="listTdLeft">手机房卡介绍：</td>
            <td style="padding:5px 0 5px 0;">             
                <asp:TextBox ID="txtRoomCardIntro" runat="server" TextMode="MultiLine" Width="650px" Height="250px"></asp:TextBox>       
            </td>
        </tr>       
        <tr>
            <td class="listTdLeft">禁用状态：</td>
            <td>        
                <asp:RadioButtonList ID="rbtnNullity" runat="server" RepeatDirection="Horizontal">
                    <asp:ListItem Value="0" Text="正常" Selected="True"></asp:ListItem>
                    <asp:ListItem Value="1" Text="禁用"></asp:ListItem>
                </asp:RadioButtonList>             
            </td>
        </tr>
        <!--
        <tr>
            <td class="listTdLeft">推荐显示：</td>
            <td>        
                <asp:RadioButtonList ID="rbtnIsJoin" runat="server" RepeatDirection="Horizontal">
                    <asp:ListItem Value="0" Text="否" Selected="True"></asp:ListItem>
                    <asp:ListItem Value="1" Text="是"></asp:ListItem>
                </asp:RadioButtonList>             
            </td>
        </tr>    
        -->
        <tr>
            <td class="listTdLeft">创建时间：</td>
            <td>             
                <asp:Label ID="lblCollectDate" runat="server"></asp:Label>         
            </td>
        </tr>   
        <tr>
            <td class="listTdLeft">修改时间：</td>
            <td>             
                <asp:Label ID="lblModifyDate" runat="server"></asp:Label>         
            </td>
        </tr>   
    </table>
    
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="返回" class="btn wd1" onclick="Redirect('RulesList.aspx')" />                           
                <input class="btnLine" type="button" />  
                <asp:Button ID="Button1" runat="server" Text="保存" CssClass="btn wd1" onclick="btnSave_Click" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

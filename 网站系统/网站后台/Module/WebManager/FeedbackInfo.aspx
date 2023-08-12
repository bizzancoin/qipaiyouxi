<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FeedbackInfo.aspx.cs" Inherits="Game.Web.Module.WebManager.FeedbackInfo" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <link href="/styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/scripts/common.js"></script>
    <title></title>
    <script type="text/javascript">
        //top.GetNewMessageAndNewOrder();
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <!-- 头部菜单 Start -->
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="title">
        <tr>
            <td width="19" height="25" valign="top"  class="Lpd10"><div class="arr"></div></td>
            <td width="1232" height="25" valign="top" align="left">你当前位置：网站系统 - 反馈管理</td>
        </tr>
    </table>  
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="返回" class="btn wd1" onclick="Redirect('FeedbackList.aspx')" />                           
                <input class="btnLine" type="button" />  
                <asp:Button ID="btnSave" runat="server" Text="保存" CssClass="btn wd1" 
                    onclick="btnSave_Click" />
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10"><div class="hg3  pd7">
                <asp:Literal ID="litInfo" runat="server"></asp:Literal>反馈</div></td>
        </tr>
        <tr>
            <td class="listTdLeft">处理状态：</td>
            <td>        
                <asp:Label ID="lbIsProcessed" runat="server"></asp:Label>     
            </td>
        </tr>    
        <!--
        <tr>
            <td class="listTdLeft">反馈标题：</td>
            <td>             
                <asp:Label ID="lblFeedbackTitle" runat="server"></asp:Label>         
            </td>
        </tr>   
        -->
        <tr>
            <td class="listTdLeft">反馈内容：</td>
            <td>             
                <asp:Label ID="lblFeedbackContent" runat="server" Width="600px"></asp:Label>                  
            </td>
        </tr>    
        <tr>
            <td class="listTdLeft">反馈帐号：</td>
            <td>             
                <asp:Label ID="lblAccounts" runat="server"></asp:Label>                  
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">反馈日期：</td>
            <td>             
                <asp:Label ID="lblFeedbackDate" runat="server"></asp:Label>                  
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">反馈地址：</td>
            <td>             
                <asp:Label ID="lblClientIP" runat="server"></asp:Label>                  
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">回复内容：</td>
            <td>             
                <asp:TextBox ID="txtRevertContent" runat="server" TextMode="MultiLine" Width="600px" Height="150px"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">回复人：</td>
            <td>             
                <asp:Label ID="lblRevertUserID" runat="server"></asp:Label>                  
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">回复日期：</td>
            <td>             
                <asp:Label ID="lblRevertDate" runat="server"></asp:Label>                  
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">显示状态：</td>
            <td>      
                <table>
                    <tr>
                        <td>
                            <asp:RadioButtonList ID="rbtnNullity" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="0" Text="启用" Selected="True"></asp:ListItem>
                                <asp:ListItem Value="1" Text="禁用"></asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                        <td style="padding-left:20px;">
                            注：启用时所有玩家可见，禁用时仅限留言人自己可见
                        </td>
                    </tr>
                </table>  
               
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="返回" class="btn wd1" onclick="Redirect('FeedbackList.aspx')" />                           
                <input class="btnLine" type="button" />  
                <asp:Button ID="Button1" runat="server" Text="保存" CssClass="btn wd1" 
                    onclick="btnSave_Click" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

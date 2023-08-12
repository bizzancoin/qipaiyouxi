<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OrderVBInfo.aspx.cs" Inherits="Game.Web.Module.FilledManager.OrderVBInfo" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id=Head1 runat="server">
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../../scripts/common.js"></script>   
    <script type="text/javascript" src="../../scripts/comm.js"></script>   
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <!-- 头部菜单 Start -->
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="title">
        <tr>
            <td width="19" height="25" valign="top"  class="Lpd10"><div class="arr"></div></td>
            <td width="1232" height="25" valign="top" align="left">你当前位置：充值系统 - 声讯记录</td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="关闭" class="btn wd1" onclick="javascript:window.close()" />                           
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10"><div class="hg3  pd7">基本信息</div></td>
        </tr>
        <tr>
            <td class="listTdLeft">订单号码：</td>
            <td>        
                <asp:Literal ID="litOrderID" runat="server"></asp:Literal>             
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">订单日期：</td>
            <td>            
                <asp:Literal ID="litOrderTime" runat="server"></asp:Literal>                      
            </td>
        </tr> 
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10"><div class="hg3  pd7">交易信息</div></td>
        </tr>
        <tr>
            <td class="listTdLeft">V币交易号：</td>
            <td>        
                <asp:Literal ID="litRtoID" runat="server"></asp:Literal>                                          
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">面值：</td>
            <td>        
                <asp:Literal ID="litRtmz" runat="server"></asp:Literal>                                
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">卡的类型：</td>
            <td>        
                <asp:Literal ID="litRtlx" runat="server"></asp:Literal>                                
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">V币号码：</td>
            <td>        
                <asp:Literal ID="litRtka" runat="server"></asp:Literal>                                
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">V币密码：</td>
            <td>        
                <asp:Literal ID="LitRtmi" runat="server"></asp:Literal>                                
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">返回状态：</td>
            <td>        
                <asp:Literal ID="litRtflag" runat="server"></asp:Literal>                                         
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">操作站点：</td>
            <td>        
                <asp:Literal ID="litOperStationID" runat="server"></asp:Literal>                                    
            </td>
        </tr>
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10"><div class="hg3  pd7">签名信息</div></td>
        </tr>
        <tr>
            <td class="listTdLeft">签名字符串：</td>
            <td>        
                <asp:Literal ID="litSignMsg" runat="server"></asp:Literal>                                     
            </td>
        </tr>
        <tr>
            <td class="listTdLeft"> V币服务器MD5：</td>
            <td>        
                <asp:Literal ID="litRtmd5" runat="server"></asp:Literal>                                
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="关闭" class="btn wd1" onclick="javascript:window.close()" />                           
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

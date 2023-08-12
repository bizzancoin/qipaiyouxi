<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OrderKQInfo.aspx.cs" Inherits="Game.Web.Module.FilledManager.OrderKQInfo" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
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
            <td width="1232" height="25" valign="top" align="left">你当前位置：充值系统 - 快钱记录</td>
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
            <td class="listTdLeft">订单金额：</td>
            <td>         
                <asp:Literal ID="litOrderAmount" runat="server"></asp:Literal>                                
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">实付金额：</td>
            <td>        
                <asp:Literal ID="litPayAmount" runat="server"></asp:Literal>                                
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">手续费：</td>
            <td>        
                <asp:Literal ID="litFee" runat="server"></asp:Literal>                                
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">实收金额：</td>
            <td>        
                <asp:Literal ID="litRevenue" runat="server"></asp:Literal>                                
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">订单状态：</td>
            <td>        
                <asp:Literal ID="litPayResult" runat="server"></asp:Literal>                                     
            </td>
        </tr>
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10"><div class="hg3  pd7">交易信息</div></td>
        </tr>
        <tr>
            <td class="listTdLeft">快钱交易号：</td>
            <td>        
                <asp:Literal ID="litDealID" runat="server"></asp:Literal>                                          
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">交易日期：</td>
            <td>        
                <asp:Literal ID="litDealTime" runat="server"></asp:Literal>                                
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">银行交易号：</td>
            <td>        
                <asp:Literal ID="litBankDealID" runat="server"></asp:Literal>                                
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">支付方式：</td>
            <td>        
                <asp:Literal ID="litPayType" runat="server"></asp:Literal>                                    
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">支付银行：</td>
            <td>        
                <asp:Literal ID="litBankID" runat="server"></asp:Literal>                                
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">支付错误描述：</td>
            <td>        
                <asp:Literal ID="litErrCode" runat="server"></asp:Literal>                                
            </td>
        </tr>
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10"><div class="hg3  pd7">其它信息</div></td>
        </tr>
        <tr>
            <td class="listTdLeft">快钱网关版本：</td>
            <td>        
                <asp:Literal ID="litVersion" runat="server"></asp:Literal>                                
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">网页语言：</td>
            <td>        
                <asp:Literal ID="litLanguage" runat="server"></asp:Literal>                                
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">扩展字段1：</td>
            <td>        
                <asp:Literal ID="litExt1" runat="server"></asp:Literal>                                
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">扩展字段2：</td>
            <td>        
                <asp:Literal ID="litExt2" runat="server"></asp:Literal>                                         
            </td>
        </tr>
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10"><div class="hg3  pd7">签名信息</div></td>
        </tr>
        <tr>
            <td class="listTdLeft">签名类型：</td>
            <td>        
                <asp:Literal ID="litSignType" runat="server"></asp:Literal>                                     
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">MD5 签名后的字符串：</td>
            <td>        
                <asp:Literal ID="litSignMsg" runat="server"></asp:Literal>                                
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

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OrderYPInfo.aspx.cs" Inherits="Game.Web.Module.FilledManager.OrderYPInfo" %>

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
            <td width="1232" height="25" valign="top" align="left">你当前位置：充值系统 - 易宝记录</td>
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
                <asp:Literal ID="litR6_Order" runat="server"></asp:Literal>             
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">支付状态：</td>
            <td>            
                <asp:Literal ID="litR1_Code" runat="server"></asp:Literal>                      
            </td>
        </tr>        
        <tr>
            <td class="listTdLeft">订单金额：</td>
            <td>         
                <asp:Literal ID="litR3_Amt" runat="server"></asp:Literal>                                
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">商品名称：</td>
            <td>         
                <asp:Literal ID="litR5_Pid" runat="server"></asp:Literal>                                
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">充值用户：</td>
            <td>         
                <asp:Literal ID="litR8_MP" runat="server"></asp:Literal>                                
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">充值时间：</td>
            <td>         
                <asp:Literal ID="litCollectDate" runat="server"></asp:Literal>                                
            </td>
        </tr>
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10"><div class="hg3  pd7">交易信息</div></td>
        </tr>
        <tr>
            <td class="listTdLeft">易宝交易号：</td>
            <td>            
                <asp:Literal ID="litR2_TrxId" runat="server"></asp:Literal>                      
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">交易结果返回类型：</td>
            <td>            
                <asp:Literal ID="litR9_BType" runat="server"></asp:Literal>                      
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">银行名称：</td>
            <td>            
                <asp:Literal ID="litRb_BankId" runat="server"></asp:Literal>                      
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">银行订单号：</td>
            <td>            
                <asp:Literal ID="litRo_BankOrderId" runat="server"></asp:Literal>                      
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">支付成功时间：</td>
            <td>        
                <asp:Literal ID="litRp_PayDate" runat="server"></asp:Literal>                                
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">神州行充值卡号：</td>
            <td>        
                <asp:Literal ID="litRq_CardNo" runat="server"></asp:Literal>                                
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">交易结果通知时间：</td>
            <td>        
                <asp:Literal ID="litRu_Trxtime" runat="server"></asp:Literal>                                
            </td>
        </tr>        
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10"><div class="hg3  pd7">其它信息</div></td>
        </tr>
        <tr>
            <td class="listTdLeft">签名数据：</td>
            <td>        
                <asp:Literal ID="litHmac" runat="server"></asp:Literal>                                
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

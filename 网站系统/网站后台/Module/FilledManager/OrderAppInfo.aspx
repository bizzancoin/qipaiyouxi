<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OrderAppInfo.aspx.cs" Inherits="Game.Web.Module.FilledManager.OrderAppInfo" %>

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
            <td width="1232" height="25" valign="top" align="left">你当前位置：充值系统 - 苹果记录</td>
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
            <td class="listTdLeft">订单金额：</td>
            <td>         
                <asp:Literal ID="litPayAmount" runat="server"></asp:Literal>                                
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">商品名称：</td>
            <td>         
                <asp:Literal ID="litproduct_id" runat="server"></asp:Literal>                                
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">充值用户：</td>
            <td>         
                <asp:Literal ID="litUserID" runat="server"></asp:Literal>                                
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">购买数量：</td>
            <td>         
                <asp:Literal ID="litquantity" runat="server"></asp:Literal>                                
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">订单状态：</td>
            <td>         
                <asp:Literal ID="litStatus" runat="server"></asp:Literal>                                
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
            <td class="listTdLeft">交易号：</td>
            <td>            
                <asp:Literal ID="littransaction_id" runat="server"></asp:Literal>                      
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">交易时间：</td>
            <td>            
                <asp:Literal ID="litpurchase_date" runat="server"></asp:Literal>                      
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">原始交易号：</td>
            <td>            
                <asp:Literal ID="litoriginal_transaction_id" runat="server"></asp:Literal>                      
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">原始交易时间：</td>
            <td>            
                <asp:Literal ID="litoriginal_purchase_date" runat="server"></asp:Literal>                      
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">交易的iOS应用：</td>
            <td>        
                <asp:Literal ID="litapp_item_id" runat="server"></asp:Literal>                                
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">应用修订版本值：</td>
            <td>        
                <asp:Literal ID="litversion_external_identifier" runat="server"></asp:Literal>                                
            </td>
        </tr>        
        <tr>
            <td class="listTdLeft">应用标识符：</td>
            <td>        
                <asp:Literal ID="litbid" runat="server"></asp:Literal>                                
            </td>
        </tr>   
        <tr>
            <td class="listTdLeft">应用版本号：</td>
            <td>        
                <asp:Literal ID="litbvrs" runat="server"></asp:Literal>                                
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

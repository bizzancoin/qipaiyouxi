<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MallOrderList.aspx.cs" Inherits="Game.Web.Module.MallManager.MallOrderList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
     <title></title>
    <link href="/styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/scripts/common.js"></script>
    <script type="text/javascript" src="/scripts/comm.js"></script>
    <script type="text/javascript" src="/scripts/My97DatePicker/WdatePicker.js"></script>
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
                    你当前位置：商城系统 - 订单管理
                </td>
            </tr>
        </table>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="titleQueBg">
            <tr>
                <td class="listTdLeft" style="width: 80px">
                    订单查询：
                </td>
                <td>
                    <asp:TextBox ID="txtOrderID" runat="server" CssClass="text wd7"></asp:TextBox>
                    &nbsp;&nbsp;下单时间：<asp:TextBox ID="txtStartDate" runat="server" CssClass="text wd2" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'txtEndDate\')}'})"></asp:TextBox><img
                        src="/Images/btn_calendar.gif" onclick="WdatePicker({el:'txtStartDate',dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'txtEndDate\')}'})"
                        style="cursor: pointer; vertical-align: middle" />
                    至
                    <asp:TextBox ID="txtEndDate" runat="server" CssClass="text wd2" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'txtStartDate\')}'})"></asp:TextBox><img
                        src="/Images/btn_calendar.gif" onclick="WdatePicker({el:'txtEndDate',dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'txtStartDate\')}'})"
                        style="cursor: pointer; vertical-align: middle" />&nbsp;&nbsp;
                    <asp:Button ID="btnSearch" runat="server" Text="查询" CssClass="btn wd1" 
                        onclick="btnSearch_Click" />
                        &nbsp;&nbsp;<asp:Button ID="btnRefresh" runat="server" CssClass="btn wd1" Text="刷新" OnClick="btnRefresh_Click" />
                   </td>
            </tr>
          </table> 
          <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="titleQueBg Tmg7">
            <tr>
                 <td class="listTdLeft" style="width: 80px">
                    用户查询：
                </td>
                <td>
                <asp:TextBox ID="txtUser" runat="server" Width="100px" CssClass="text"></asp:TextBox>
                <asp:DropDownList ID="ddlType" runat="server">
                    <asp:ListItem Text="用户帐号" Value="0"></asp:ListItem>
                    <asp:ListItem Text="游戏 ID" Value="1"></asp:ListItem>
                </asp:DropDownList>
                <asp:Button ID="btnUseSearch" runat="server" Text="查询" CssClass="btn wd1" 
                    onclick="btnUseSearch_Click"  />
                    &nbsp;&nbsp;<asp:Button ID="Button4" runat="server" CssClass="btn wd1" Text="刷新" OnClick="btnRefresh_Click" />
                </td>
            </tr>
        </table>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="Tmg7">
            <tr>
                <td height="39" class="titleOpBg">
                &nbsp;&nbsp;<asp:Button ID="btnNewOrder" runat="server" CommandArgument="0"
                    Text="新订单" CssClass="btn wd1" oncommand="btnNewOrder_Command" />&nbsp;&nbsp;
                <asp:Button ID="btnSend" runat="server" Text="已发货订单" CssClass="btn wd3" CommandArgument="1"
                    oncommand="btnNewOrder_Command" />&nbsp;&nbsp;
                <asp:Button ID="btnBackOrder" runat="server" Text="申请退货订单" CssClass="btn wd3" CommandArgument="3"
                    oncommand="btnNewOrder_Command" />
                <asp:Button ID="Button1" runat="server" Text="同意退货等待客户发货订单" CssClass="btn" Width="150" CommandArgument="4"
                    oncommand="btnNewOrder_Command" />
                <asp:Button ID="Button2" runat="server" Text="拒绝退货订单" CssClass="btn wd3" CommandArgument="5"
                    oncommand="btnNewOrder_Command" />
                 <asp:Button ID="Button3" runat="server" Text="退货成功订单" CssClass="btn wd3" CommandArgument="6"
                    oncommand="btnNewOrder_Command" />
                    &nbsp;&nbsp;<asp:Button ID="Button5" runat="server" CssClass="btn wd1" Text="刷新" OnClick="btnRefresh_Click" />
              </td>
            </tr>
        </table>
        <div id="content">
            <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="box" id="list">
                <tr align="center" class="bold"> 
                    <td class="listTitle">管理</td>
                    <td class="listTitle2">订单状态</td>
                    <td class="listTitle2">订单号码</td>
                    <td class="listTitle2">用户帐号</td>
                    <td class="listTitle2">商品名称</td>
                    <td class="listTitle2">商品价格（元宝）</td>
                    <td class="listTitle2">购买数量</td>
                    <td class="listTitle2">花费金额（元宝）</td>
                    <td class="listTitle2">购买时间</td>
                    <td class="listTitle2">购买地址</td>
                    <td class="listTitle2">处理时间</td>
                    <td class="listTitle2">真实姓名</td>
                    <td class="listTitle2">联系电话</td>
                    <td class="listTitle2">邮政编码</td>
                    <td class="listTitle2">详细地址</td>
                </tr>
                <asp:Repeater ID="rpData" runat="server">
                    <ItemTemplate>
                        <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                            <td><a class="l" href="MallOrder.aspx?param=<%# Eval("OrderID").ToString() %>">订单处理</a></td>
                            <td><%# GetOrderState(Convert.ToInt32(Eval("OrderStatus"))) %></td>
                            <td><%# Eval("OrderID")%></td>
                            <td><%# GetAccounts(Convert.ToInt32(Eval("UserID")))%></td>
                            <td><%# GetAwardInfoName(Convert.ToInt32(Eval("AwardID")))%></td>
                            <td><%# Eval("AwardPrice")%></td>
                            <td><%# Eval("AwardCount")%></td>
                            <td><%# Eval("TotalAmount")%></td>
                            <td><%# Eval("BuyDate")%></td>
                            <td><%# Eval("BuyIP")%></td>
                            <td><%# Eval("SolveDate")%></td>
                            <td><%# Eval("Compellation")%></td>
                            <td><%# Eval("MobilePhone")%></td>
                            <td><%# Eval("PostalCode")%></td>
                            <td><%# Eval("DwellingPlace")%></td>
                        </tr>
                    </ItemTemplate>
                    <AlternatingItemTemplate>
                        <tr align="center" class="listBg" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                            <td><a class="l" href="MallOrder.aspx?param=<%# Eval("OrderID").ToString() %>">订单处理</a></td>
                            <td><%# GetOrderState(Convert.ToInt32(Eval("OrderStatus"))) %></td>
                            <td><%# Eval("OrderID")%></td>
                            <td><%# GetAccounts(Convert.ToInt32(Eval("UserID"))) %></td>
                            <td><%# GetAwardInfoName(Convert.ToInt32(Eval("AwardID")))%></td>
                            <td><%# Eval("AwardPrice")%></td>
                            <td><%# Eval("AwardCount")%></td>
                            <td><%# Eval("TotalAmount")%></td>
                            <td><%# Eval("BuyDate")%></td>
                            <td><%# Eval("BuyIP")%></td>
                            <td><%# Eval("SolveDate")%></td>
                            <td><%# Eval("Compellation")%></td>
                            <td><%# Eval("MobilePhone")%></td>
                            <td><%# Eval("PostalCode")%></td>
                            <td><%# Eval("DwellingPlace")%></td>
                        </tr>
                    </AlternatingItemTemplate>
                </asp:Repeater>
                <asp:Literal runat="server" ID="litNoData" Visible="false" Text="<tr class='tdbg'><td colspan='100' align='center'><br>没有任何信息!<br><br></td></tr>"></asp:Literal>
            </table>
        </div>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td class="listTitleBg">
                </td>
                <td align="right" class="page">
                    <gsp:AspNetPager ID="anpPage" OnPageChanged="anpPage_PageChanged" runat="server" AlwaysShow="true" FirstPageText="首页" LastPageText="末页"
                        PageSize="20" NextPageText="下页" PrevPageText="上页" ShowBoxThreshold="0" ShowCustomInfoSection="Left" LayoutType="Table"
                        NumericButtonCount="5" CustomInfoHTML="总记录：%RecordCount%　页码：%CurrentPageIndex%/%PageCount%　每页：%PageSize%" UrlPaging="false">
                    </gsp:AspNetPager>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PayConfigList.aspx.cs" Inherits="Game.Web.Module.FilledManager.PayConfigList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="../../scripts/common.js"></script>

    <script type="text/javascript" src="../../scripts/comm.js"></script>

    <script type="text/javascript" src="../../scripts/jquery.js"></script>

    <script type="text/javascript" src="../../scripts/My97DatePicker/WdatePicker.js"></script>

    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="title">
        <tr>
            <td width="19" height="25" valign="top" class="Lpd10">
                <div class="arr">
                </div>
            </td>
            <td width="1232" height="25" valign="top" align="left">
                你当前位置：充值系统 - 充值配置
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="Tmg7">
        <tr>
            <td height="28">
                <ul>
                    <li class="tab1">网站支付</li>
                    <li class="tab2" onclick="Redirect('OrderAppProductList.aspx')">手机支付</li>
                    <% if(AllowRoomCard == "1")
                    { %>
                    <li class="tab2" onclick="Redirect('RoomCardBuyList.aspx')">代理房卡购买</li>
                    <% } %>
                </ul>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input id="btnNew1" type="button" class="btn wd1" value="新建" onclick="Redirect('PayConfigInfo.aspx')" />
                 <input class="btnLine" type="button" /> 
                <asp:Button ID="btnDelete" runat="server" Text="删除" CssClass="btn wd1" onclick="btnDelete_Click" OnClientClick="return deleteop()" />  
                <input class="btnLine" type="button" /> 
                <input id="btnSetScale" type="button" class="btn wd5" value="统一设置比例" onclick="Redirect('PaySetScale.aspx')" />
            </td>
        </tr>
    </table>
    <div id="content">
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="box" id="list">
            <tr align="center" class="bold">
                <td style="width:30px;" class="listTitle"><input type="checkbox" name="chkAll" onclick="SelectAll(this.checked);" /></td>
                <td class="listTitle1">
                    管理
                </td>
                <td class="listTitle2">
                    充值名称
                </td>
                <td class="listTitle2">
                    充值金额
                </td>
                <td class="listTitle2">
                    赠送游戏豆
                </td>
                <%--<td class="listTitle2">
                    首冲奖励游戏豆
                </td>--%>
                <td class="listTitle2">
                    排序
                </td>
                <td class="listTitle2">
                    添加时间
                </td>
            </tr>
            <asp:Repeater ID="rptDataList" runat="server">
                <ItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td>
                             <%# "<input name='cid' type='checkbox' value='" + Eval("WebID").ToString() + "'/>" %>
                        </td>
                        <td>
                           <a href="PayConfigInfo.aspx?param=<%# Eval( "WebID" ).ToString( )%>" class="l">更新</a>
                        </td>
                        <td>
                            <%# Eval("ProductName").ToString() %>
                        </td>
                        <td>
                            <%# Eval("Price").ToString()%>
                        </td>
                        <td>
                            <%# Eval("PresentCurrency").ToString()%>
                        </td>
                        <%--<td>
                            <%# Eval("AttachCurrency").ToString()%>
                        </td>--%>
                        <td>
                            <%# Eval("SortID").ToString()%>
                        </td>
                        <td>
                            <%# Eval("CollectDate").ToString()%>
                        </td>
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td>
                             <%# "<input name='cid' type='checkbox' value='" + Eval("WebID").ToString() + "'/>" %>
                        </td>
                        <td>
                           <a href="PayConfigInfo.aspx?param=<%# Eval( "WebID" ).ToString( )%>" class="l">更新</a>
                        </td>
                        <td>
                            <%# Eval("ProductName").ToString() %>
                        </td>
                        <td>
                            <%# Eval("Price").ToString()%>
                        </td>
                        <td>
                            <%# Eval("PresentCurrency").ToString()%>
                        </td>
                        <%--<td>
                            <%# Eval("AttachCurrency").ToString()%>
                        </td>--%>
                        <td>
                            <%# Eval("SortID").ToString()%>
                        </td>
                        <td>
                            <%# Eval("CollectDate").ToString()%>
                        </td>
                    </tr>
                </AlternatingItemTemplate>
            </asp:Repeater>
            <asp:Literal runat="server" ID="litNoData" Visible="false" Text="<tr class='tdbg'><td colspan='100' align='center'><br>没有任何信息!<br><br></td></tr>"></asp:Literal>
        </table>
    </div>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="listTitleBg">
                <span>选择：</span>&nbsp;<a class="l1" href="javascript:SelectAll(true);">全部</a>&nbsp;-&nbsp;<a class="l1" href="javascript:SelectAll(false);">无</a>
            </td>
            <td align="right" class="page">
                <gsp:AspNetPager ID="anpNews" runat="server" OnPageChanged="anpNews_PageChanged" AlwaysShow="true" FirstPageText="首页" LastPageText="末页"
                    PageSize="20" NextPageText="下页" PrevPageText="上页" ShowBoxThreshold="0" ShowCustomInfoSection="Left" LayoutType="Table"
                    NumericButtonCount="5" CustomInfoHTML="总记录：%RecordCount%　页码：%CurrentPageIndex%/%PageCount%　每页：%PageSize%">
                </gsp:AspNetPager>
            </td>
        </tr>
    </table>
      <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" id="OpList">
        <tr>
            <td class="titleOpBg Lpd10">
                <input id="btnNew2" type="button" class="btn wd1" value="新建" onclick="Redirect('PayConfigInfo.aspx')" />
                 <input class="btnLine" type="button" /> 
                <asp:Button ID="btnDelete2" runat="server" Text="删除" CssClass="btn wd1" onclick="btnDelete_Click" OnClientClick="return deleteop()" />  
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

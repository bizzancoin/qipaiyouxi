<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MallInfoList.aspx.cs" Inherits="Game.Web.Module.MallManager.MallInfoList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
     <title></title>
    <link href="/styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/scripts/common.js"></script>
    <script type="text/javascript" src="/scripts/comm.js"></script>
    <script type="text/javascript" src="/scripts/jquery.js"></script>
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
                    你当前位置：商城系统 - 商品管理
                </td>
            </tr>
        </table>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="titleQueBg">
            <tr>
                <td>
                    &nbsp;&nbsp;商品名称：<asp:TextBox ID="txtName" runat="server" CssClass="text"></asp:TextBox>&nbsp;&nbsp;
                    商品类型：<asp:DropDownList ID="ddlType" runat="server" width="120px">
                    </asp:DropDownList>&nbsp;&nbsp;
                    商品价格：<asp:TextBox ID="txtPriceStart" runat="server" CssClass="text" width="50px"></asp:TextBox>&nbsp;
                    到&nbsp;<asp:TextBox ID="txtPriceEnd" runat="server" CssClass="text" width="50px"></asp:TextBox>&nbsp;&nbsp;&nbsp;
                    <asp:Button ID="btnSearch" runat="server" Text="查询" CssClass="btn wd1" 
                        onclick="btnSearch_Click" />
                    <asp:Button ID="btnRefresh" runat="server" CssClass="btn wd1" Text="刷新" OnClick="btnRefresh_Click" />
                 </td>
            </tr>
        </table>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="Tmg7">
            <tr>
                <td height="39" class="titleOpBg">
                    &nbsp;&nbsp;<input type="button" value="新增" onclick="Redirect('MallInfo.aspx')"  class="btn wd1" />
                    <input type="button" class="btnLine" />
                    <asp:Button ID="btnNulityTrue" runat="server" Text="商品上架" CssClass="btn wd2" 
                        OnClientClick="return deleteop()" onclick="btnNulityTrue_Click" />&nbsp;&nbsp;
                    <asp:Button ID="btnNulityFalse" runat="server" Text="商品下架" CssClass="btn wd2" 
                        OnClientClick="return deleteop()" onclick="btnNulityFalse_Click" />
              </td>
            </tr>
        </table>
        <div id="content">
            <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="box" id="list">
                <tr align="center" class="bold">
                    <td class="listTitle">
                        <input type="checkbox" name="chkAll" onclick="SelectAll(this.checked);" />
                    </td>
                    <td class="listTitle2">管理</td>
                    <td class="listTitle2">商品标识</td>
                    <td class="listTitle2">商品名称</td>
                    <td class="listTitle2">商品类型</td>
                    <td class="listTitle2">商品价格（元宝）</td>
                    <td class="listTitle2">商品库存</td>
                    <td class="listTitle2">已售数量</td>
                    <td class="listTitle2">排列序号</td>
                    <td class="listTitle2">商品状态</td>
                    <td class="listTitle2">填写信息</td>
                    <td class="listTitle2">允许退货</td>
                    <td class="listTitle2">创建时间</td>
               </tr>
                <asp:Repeater ID="rpData" runat="server">
                    <ItemTemplate>
                       <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                            <td><%# "<input name='cid' type='checkbox' value='" + Eval("AwardID") + "'/>"%></td>
                            <td><a class="l" href="MallInfo.aspx?param=<%# Eval("AwardID").ToString() %>">编辑</a></td>
                            <td><%# Eval("AwardID")%></td>
                            <td><%# Eval("AwardName")%></td>
                            <td><%# Game.Facade.FacadeManage.aideNativeWebFacade.GetAwardTypeByID( Convert.ToInt32( Eval( "TypeID" ) ) ).TypeName%></td>
                            <td><%# Eval("Price")%></td>
                            <td><%# Eval("Inventory")%></td>
                            <td><%# Eval("BuyCount")%></td>
                            <td><%# Eval("SortID")%></td>
                            <td><%# Eval("Nullity").ToString() == "1" ? "<span style='color:red;'>已下架</span>" : "已上架"%></td>
                            <td><%# GetNeedInfo(Convert.ToInt32(Eval("NeedInfo"))) %></td>
                            <td><%# Eval("IsReturn").ToString()=="True"?"允许":"不允许" %></td>
                            <td><%# Eval("CollectDate")%></td>
                        </tr>
                    </ItemTemplate>
                    <AlternatingItemTemplate>
                       <tr align="center" class="listBg" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                            <td><%# "<input name='cid' type='checkbox' value='" + Eval("AwardID") + "'/>"%></td>
                            <td><a class="l" href="MallInfo.aspx?param=<%# Eval("AwardID").ToString() %>">编辑</a></td>
                            <td><%# Eval("AwardID")%></td>
                            <td><%# Eval("AwardName")%></td>
                            <td><%# Game.Facade.FacadeManage.aideNativeWebFacade.GetAwardTypeByID( Convert.ToInt32( Eval( "TypeID" ) ) ).TypeName%></td>
                            <td><%# Eval("Price")%></td>
                            <td><%# Eval("Inventory")%></td>
                            <td><%# Eval("BuyCount")%></td>
                            <td><%# Eval("SortID")%></td>
                            <td><%# Eval("Nullity").ToString() == "1" ? "<span style='color:red;'>已下架</span>" : "已上架"%></td>
                            <td><%# GetNeedInfo(Convert.ToInt32(Eval("NeedInfo"))) %></td>
                            <td><%# Eval("IsReturn").ToString()=="True"?"允许":"不允许" %></td>
                            <td><%# Eval("CollectDate")%></td>
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
                    <gsp:AspNetPager ID="anpPage" OnPageChanged="anpPage_PageChanged" runat="server" AlwaysShow="true" FirstPageText="首页" LastPageText="末页"
                        PageSize="20" NextPageText="下页" PrevPageText="上页" ShowBoxThreshold="0" ShowCustomInfoSection="Left" LayoutType="Table"
                        NumericButtonCount="5" CustomInfoHTML="总记录：%RecordCount%　页码：%CurrentPageIndex%/%PageCount%　每页：%PageSize%" UrlPaging="false">
                    </gsp:AspNetPager>
                </td>
            </tr>
        </table>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" id="OpList">
            <tr>
                <td height="39" class="titleOpBg">
                    &nbsp;&nbsp;<input type="button" value="新增" onclick="Redirect('MallInfo.aspx')"  class="btn wd1" />
                    <input type="button" class="btnLine" />
                    <asp:Button ID="Button1" runat="server" Text="商品上架" CssClass="btn wd2" 
                        OnClientClick="return deleteop()" onclick="btnNulityTrue_Click" />&nbsp;&nbsp;
                    <asp:Button ID="Button2" runat="server" Text="商品下架" CssClass="btn wd2" 
                        OnClientClick="return deleteop()" onclick="btnNulityFalse_Click" />
              </td>
            </tr>
        </table>
    </form>
</body>
</html>

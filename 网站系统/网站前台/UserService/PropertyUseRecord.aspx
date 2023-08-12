<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PropertyUseRecord.aspx.cs" Inherits="Game.Web.UserService.PropertyUseRecord" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <title></title>
    <style>
      html{width: 676px; height: 400px; overflow:hidden;}
      body {width: 676px; height: 400px; background: #251b14 url("/images/popup/property_bg.png") no-repeat;}
      .ui-bank-record {width: 100%;}
      .ui-bank-record tbody {max-height: 676px; overflow: hidden;}
      .ui-bank-record th, .ui-bank-record td {text-align: center; font-size: 12px;}
      .ui-bank-record th {line-height: 31px; font-weight: bold;}
      .ui-bank-record td {height: 28px; line-height: 20px; border: 1px solid #c6ab7c; background: #FFEAC2;}
      td.ui-border-top {border-top-color: transparent;}
      td.ui-border-left {border-left: none;}
      td.ui-border-right {border-right: none;}
      td.ui-font-weight {font-weight: bold;}
      td.ui-color-red {color: #f00;}
      td.ui-color-green {color: #390;}
      td.ui-record-tfoot {border: none; background: none; text-align: center; line-height: 37px; height: 37px;}
      .ui-record-tfoot a,
      .ui-record-tfoot span {font-size: 12px; line-height: 37px; color: #753700; margin: 0 4px;
        display: inline-block; *zoom: 1; *display: inline;}
      .ui-record-tfoot a:hover {text-decoration: none;}
      .ui-record-tfoot a.ui-active,
      .ui-record-tfoot span {color: #c30; font-size: 14px;}
      a.ui-prev, a.ui-next {font-size: 12px; line-height: 24px; width: 62px; height: 24px;
      background: url("/images/popup/record_page.png") no-repeat;}
      a.ui-prev:hover,
      a.ui-next:hover {background-position: 0 -24px;}
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <table class="ui-bank-record">
    <thead>
        <tr>
        <th style="width:200px; overflow-x:hidden;">消耗日期</th>
        <th style="width:150px; overflow-x:hidden;">道具名</th>
        <th style="width:50px; overflow-x:hidden;">消耗数量</th>
        <th style="width:100px; overflow-x:hidden;">消耗类型</th>
        <th style="width:176px; overflow-x:hidden;">使用对象（ID）</th>           
        </tr>
    </thead>
    <tbody>
        <asp:Repeater ID="rptInsureList" runat="server">
            <ItemTemplate>
                <tr>
                    <td>
                        <%# Eval("RecordDate")%>
                    </td>
                    <td>
                        <%# GetPropertyName(Convert.ToInt32(Eval("PropertyID")))%>
                    </td>
                    <td>
                        <%# Eval("PropertyCount")%>
                    </td>
                    <td>
                        <%# Eval("RecordType")%>
                    </td>
                    <td>
                        <%# GetGameIDByUserID(Convert.ToInt32(Eval("TargetUserID")))%>
                    </td>
                </tr>
            </ItemTemplate>
        </asp:Repeater>
        <asp:Literal runat="server" ID="litNoData" Text="<tr><td colspan='100'><br>没有任何信息<br><br></td></tr>"></asp:Literal>                                     
    </tbody>
    <tfoot>
        <tr>
            <td colspan="6" class="ui-record-tfoot">
                <webdiyer:AspNetPager ID="anpPage" runat="server" AlwaysShow="true" FirstPageText="首页" FirstLastButtonClass="ui-prev" NextPrevButtonClass="ui-prev"  
                    LastPageText="末页" PageSize="11" NextPageText="下一页" PrevPageText="上一页" ShowBoxThreshold="0"
                    LayoutType="Table" NumericButtonCount="5" CustomInfoHTML="共 %PageCount% 页" ShowPageIndexBox="Never"
                    UrlPaging="true" ShowCustomInfoSection="Never" CurrentPageButtonClass="ui-active">
                </webdiyer:AspNetPager>
            </td>
        </tr>
    </tfoot>
    </table>
    </form>
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ClearTableData.aspx.cs" Inherits="Game.Web.Module.DataAnalysis.ClearTableData" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
     <title></title>
    <link href="/styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/scripts/common.js"></script>
    <script type="text/javascript" src="/scripts/comm.js"></script>
    <script type="text/javascript" src="/scripts/jquery.js"></script>
    <script type="text/javascript" src="/scripts/My97DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
        function submitForm(obj) {
            $.ajax({
                url: '/Tools/Operating.ashx?action=ClearTableData',
                type: 'post',
                data: serializeInput(obj),
                dataType: 'json',
                success: function(result) {
                    if (result.data.valid) {
                        alert(result.msg);
                        location.href = "ClearTableData.aspx";
                    } else {
                        alert(result.msg);
                    }
                },
                complete: function() {

                }
            });
        }
    </script>
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
                    你当前位置：数据分析 - 清理数据
                </td>
            </tr>
        </table>
         <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td height="39" class="titleOpBg">
                      
              </td>
            </tr>
        </table>
        <div id="content">
            <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="box" id="list">
                <tr align="center" class="bold">
                    <td class="listTitle2">管理</td>
                    <td class="listTitle2">清理记录截止时间</td>
                    <td class="listTitle2">数据表名称</td>
                    <td class="listTitle2">记录总数</td>
                    <td class="listTitle2">记录最小时间</td>
                    <td class="listTitle2">记录最大时间</td>
               </tr>
                <asp:Repeater ID="rpData" runat="server">
                    <ItemTemplate>
                       <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                            <td><input type="button" onclick="submitForm(this)" value="确定清除"/><input name="id" value="<%# Eval("ID").ToString() %>" type="hidden"/></td>
                            <td><input value="" name="time" class="text wd2" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'%y-%M-#{%d-1}'})"/></td>
                            <td><%# Enum.GetName( typeof( Game.Facade.EnumerationList.ClearTableTypes ), Eval( "ID" ) )%></td>
                            <td><%# Eval("Counts") %></td>
                            <td><%# Eval("MinTime","{0:yyyy-MM-dd}") %></td>
                            <td><%# Eval( "MaxTime","{0:yyyy-MM-dd}" )%></td>
                       </tr>
                    </ItemTemplate>
                    <AlternatingItemTemplate>
                       <tr align="center" class="listBg" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                            <td><input type="button" onclick="submitForm(this)" value="确定清除"/><input name="id" value="<%# Eval("ID").ToString() %>" type="hidden"/></td>
                            <td><input value="" name="time" class="text wd2" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'%y-%M-#{%d-1}'})"/></td>
                           <td><%# Enum.GetName(typeof( Game.Facade.EnumerationList.ClearTableTypes ), Eval( "ID" ))%></td>
                            <td><%# Eval("Counts") %></td>
                            <td><%# Eval("MinTime","{0:yyyy-MM-dd}") %></td>
                            <td><%# Eval( "MaxTime","{0:yyyy-MM-dd}" )%></td>
                       </tr>
                    </AlternatingItemTemplate>
                </asp:Repeater>
            </table>
        </div>
         <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td class="listTitleBg">
                   
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
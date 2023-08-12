<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TransferReturnConfigList.aspx.cs" Inherits="Game.Web.Module.AppManager.TransferReturnConfigList" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="/styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/scripts/common.js"></script>
    <script type="text/javascript" src="/scripts/comm.js"></script>
    <script type="text/javascript" src="/scripts/jquery.js"></script>
    <title></title>
    <script type="text/javascript">
        function submitForm(obj) {
            $.ajax({
                url: '/Tools/Operating.ashx?action=UpdateTransferReturnConfig',
                type: 'post',
                data: serializeInput(obj),
                dataType: 'json',
                success: function (result) {
                    if (result.data.valid) {
                        alert(result.msg);
                    } else {
                        alert(result.msg);
                    }
                },
                complete: function () {

                }
            });
        }
    </script>
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
                你当前位置：系统维护 - 转账返利
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="Tmg7">
        <tr>
            <td height="28">
                <ul>
                    <li class="tab1">返利配置</li>
                    <li class="tab2" onclick="Redirect('TransferReturnDetailInfo.aspx')">返利明细</li>
                </ul>
            </td>
        </tr>
    </table>
    <div id="content">
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="box" id="list">
            <tr align="center" class="bold">
                <td class="listTitle2">管理</td>
                <td class="listTitle2">配置说明</td>
                <td class="listTitle2">返利类型(0:元宝 1:魅力值)</td>
                <td class="listTitle2">返利比例(%)</td>
            </tr>
            <asp:Repeater ID="rpData" runat="server">
                <ItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                    onmouseout="this.style.backgroundColor=currentcolor">
                        <td><input type="button" onclick="submitForm(this)" value="保存修改"/><input name="id" value="<%# Eval("ConfigID").ToString() %>" type="hidden"/></td>
                        <td><%# Eval( "ConfigDescribe" )%></td>
                        <td><input type="text" value="<%# Eval( "ReturnType" )%>" name="ReturnType" class="text wd1"/></td>
                        <td><input type="text" value="<%# Eval( "ReturnPercent" )%>" name="ReturnPercent" class="text wd1"/></td>
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr align="center" class="listBg" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                    onmouseout="this.style.backgroundColor=currentcolor">
                        <td><input type="button" onclick="submitForm(this)" value="保存修改"/><input name="id" value="<%# Eval("ConfigID").ToString() %>" type="hidden"/></td>
                        <td><%# Eval( "ConfigDescribe" )%></td>
                        <td><input type="text" value="<%# Eval( "ReturnType" )%>" name="ReturnType" class="text wd1"/></td>
                        <td><input type="text" value="<%# Eval( "ReturnPercent" )%>" name="ReturnPercent" class="text wd1"/></td>
                    </tr>
                </AlternatingItemTemplate>
            </asp:Repeater>
            <asp:Literal runat="server" ID="litNoData" Visible="false" Text="<tr class='tdbg'><td colspan='100' align='center'><br>没有任何信息!<br><br></td></tr>"></asp:Literal>
        </table>
    </div>        
    </form>
</body>
</html>

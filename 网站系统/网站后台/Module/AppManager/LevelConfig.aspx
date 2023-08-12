<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LevelConfig.aspx.cs" Inherits="Game.Web.Module.AppManager.LevelAwardConfig" %>

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
                url: '/Tools/Operating.ashx?action=UpdateLevelConfig',
                type: 'post',
                data: serializeInput(obj),
                dataType:'json',
                success: function(result) {
                    if (result.data.valid) {
                       alert(result.msg);
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
                    你当前位置：系统维护 - 等级配置
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
                    <td class="listTitle2">等级</td>
                    <td class="listTitle2">经验值</td>
                    <td class="listTitle2">奖励游戏币</td>
                    <td class="listTitle2">奖励元宝</td>
                    <td class="listTitle2">备注</td>
               </tr>
                <asp:Repeater ID="rpData" runat="server">
                    <ItemTemplate>
                       <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                            <td><input type="button" onclick="submitForm(this)" value="保存修改"/><input name="id" value="<%# Eval("LevelID").ToString() %>" type="hidden"/></td>
                            <td><%# Eval( "LevelID" )%></td>
                            <td><input value="<%# Eval( "Experience" )%>" name="experience" class="text wd1"/></td>
                            <td><input value="<%# Eval( "RewardGold" )%>" name="gold" class="text wd1"/></td>
                            <td><input value="<%# Eval( "RewardMedal" )%>" name="medal" class="text wd1"/></td>
                            <td><input value="<%# Eval( "LevelRemark" )%>" name="remark" class="text"/></td>
                       </tr>
                    </ItemTemplate>
                    <AlternatingItemTemplate>
                       <tr align="center" class="listBg" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                            <td><input type="button" onclick="submitForm(this)" value="保存修改" /><input name="id" value="<%# Eval("LevelID").ToString() %>" type="hidden"/></td>
                            <td><%# Eval( "LevelID" )%></td>
                            <td><input value="<%# Eval( "Experience" )%>" name="experience" class="text wd1"/></td>
                            <td><input value="<%# Eval( "RewardGold" )%>" name="gold" class="text wd1"/></td>
                            <td><input value="<%# Eval( "RewardMedal" )%>" name="medal" class="text wd1"/></td>
                            <td><input value="<%# Eval( "LevelRemark" )%>" name="remark" class="text"/></td>
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
            </tr>
        </table>
    </form>
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AndroidInfo.aspx.cs" Inherits="Game.Web.Module.AccountManager.AndroidInfo" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../../scripts/common.js"></script>
    <script type="text/javascript" src="../../scripts/jquery.js"></script>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <!-- 头部菜单 Start -->
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="title">
        <tr>
            <td width="19" height="25" valign="top"  class="Lpd10"><div class="arr"></div></td>
            <td width="1232" height="25" valign="top" align="left">你当前位置：用户系统 - 机器人管理</td>
        </tr>
    </table>
    <!-- 头部菜单 End -->   
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="关闭" class="btn wd1" onclick="window.close();" />                           
                <input class="btnLine" type="button" />  
                <asp:Button ID="btnSave" runat="server" Text="保存" CssClass="btn wd1" 
                    onclick="btnSave_Click" />
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10"><div class="hg3  pd7">
                <asp:Literal ID="litInfo" runat="server"></asp:Literal>配置机器人</div></td>
        </tr>
        <tr>
            <td class="listTdLeft">房间名称：</td>
            <td>        
                <asp:DropDownList ID="ddlServerID" runat="server" Width="157px">
                </asp:DropDownList>     
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">最少局数：</td>
            <td>        
                <asp:TextBox ID="txtMinPlayDraw" runat="server" CssClass="text"></asp:TextBox> 
            </td>
        </tr>      
        <tr>
            <td class="listTdLeft">最大局数：</td>
            <td>        
                <asp:TextBox ID="txtMaxPlayDraw" runat="server" CssClass="text"></asp:TextBox> 
            </td>
        </tr>  
        <tr>
            <td class="listTdLeft">最少分数：</td>
            <td>        
                <asp:TextBox ID="txtMinTakeScore" runat="server" CssClass="text"></asp:TextBox> 
            </td>
        </tr>  
        <tr>
            <td class="listTdLeft">最高分数：</td>
            <td>        
                <asp:TextBox ID="txtMaxTakeScore" runat="server" CssClass="text"></asp:TextBox> 
            </td>
        </tr>  
        <tr>
            <td class="listTdLeft">最少游戏时间：</td>
            <td>        
                <asp:TextBox ID="txtMinReposeTime" runat="server" CssClass="text"></asp:TextBox> 
            </td>
        </tr>  
        <tr>
            <td class="listTdLeft">最大游戏时间：</td>
            <td>        
                <asp:TextBox ID="txtMaxReposeTime" runat="server" CssClass="text"></asp:TextBox> 
            </td>
        </tr>  
        <tr>
            <td class="listTdLeft">机器人类型：</td>
            <td>        
                <asp:CheckBoxList ID="chkServiceGender" runat="server" RepeatDirection="Horizontal">
                    <asp:ListItem Value="1" Text="相互模拟型"></asp:ListItem>
                    <asp:ListItem Value="2" Text="被动陪打"></asp:ListItem>
                    <asp:ListItem Value="4" Text="主动陪打"></asp:ListItem>
                </asp:CheckBoxList>
            </td>
        </tr>  
        <tr>
            <td class="listTdLeft">
             <input id="chkAll" type="checkbox" /><label for="chkAll">全选</label>&nbsp;&nbsp;<br />
            服务时间：</td>
            <td>    <div id="divservice" >         
                <asp:CheckBoxList ID="chkServiceTime" runat="server" RepeatDirection="Horizontal" RepeatColumns="6">
                    <asp:ListItem Value="1" Text="0:00-1:00"></asp:ListItem>
                    <asp:ListItem Value="2" Text="1:00-2:00"></asp:ListItem>
                    <asp:ListItem Value="4" Text="2:00-3:00"></asp:ListItem>
                    <asp:ListItem Value="8" Text="3:00-4:00"></asp:ListItem>
                    <asp:ListItem Value="16" Text="4:00-5:00"></asp:ListItem>
                    <asp:ListItem Value="32" Text="5:00-6:00"></asp:ListItem>
                    <asp:ListItem Value="64" Text="6:00-7:00"></asp:ListItem>
                    <asp:ListItem Value="128" Text="7:00-8:00"></asp:ListItem>
                    <asp:ListItem Value="256" Text="8:00-9:00"></asp:ListItem>
                    <asp:ListItem Value="512" Text="9:00-10:00"></asp:ListItem>
                    <asp:ListItem Value="1024" Text="10:00-11:00"></asp:ListItem>
                    <asp:ListItem Value="2048" Text="11:00-12:00"></asp:ListItem>
                    <asp:ListItem Value="4096" Text="12:00-13:00"></asp:ListItem>
                    <asp:ListItem Value="8192" Text="13:00-14:00"></asp:ListItem>
                    <asp:ListItem Value="16384" Text="14:00-15:00"></asp:ListItem>
                    <asp:ListItem Value="32768" Text="15:00-16:00"></asp:ListItem>
                    <asp:ListItem Value="65536" Text="16:00-17:00"></asp:ListItem>
                    <asp:ListItem Value="131072" Text="17:00-18:00"></asp:ListItem>
                    <asp:ListItem Value="262144" Text="18:00-19:00"></asp:ListItem>
                    <asp:ListItem Value="524288" Text="19:00-20:00"></asp:ListItem>
                    <asp:ListItem Value="1048576" Text="20:00-21:00"></asp:ListItem>
                    <asp:ListItem Value="2097152" Text="21:00-22:00"></asp:ListItem>
                    <asp:ListItem Value="4194304" Text="22:00-23:00"></asp:ListItem>
                    <asp:ListItem Value="8388608" Text="23:00-24:00"></asp:ListItem>
                </asp:CheckBoxList></div>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">备注信息：</td>
            <td>        
                <asp:TextBox ID="txtAndroidNote" runat="server" CssClass="text"></asp:TextBox> 
            </td>
        </tr>           
        <tr>
            <td class="listTdLeft">禁用状态：</td>
            <td>        
                <asp:RadioButtonList ID="rbtnNullity" runat="server" RepeatDirection="Horizontal">
                    <asp:ListItem Value="0" Text="正常" Selected="True"></asp:ListItem>
                    <asp:ListItem Value="1" Text="禁用"></asp:ListItem>
                </asp:RadioButtonList>             
            </td>
        </tr>    
        <tr>
            <td class="listTdLeft">创建时间：</td>
            <td>        
                <asp:Label ID="lblCreateDate" runat="server"></asp:Label>
            </td>
        </tr>  
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="关闭" class="btn wd1" onclick="window.close();" />                           
                <input class="btnLine" type="button" />  
                <asp:Button ID="Button1" runat="server" Text="保存" CssClass="btn wd1" 
                    onclick="btnSave_Click" />
            </td>
        </tr>
    </table>
    </form>
     <script type="text/javascript">
        $(document).ready(function() {
            $("#chkAll").click(function() {
                if (this.checked) {                  
                    $("#divservice :checkbox").each(
						function() {
						    this.checked = true;
						}
					);
                }
                else {
                    $("#divservice :checkbox").each(
						function() {
						    this.checked = false;
						}
					);
                }
            });
        });
        
        
    </script>
</body>
</html>

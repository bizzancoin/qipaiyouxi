<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GameKindItemInfo.aspx.cs" Inherits="Game.Web.Module.AppManager.GameKindItemInfo" %>
<%@ Register Src="~/Themes/TabGame.ascx" TagPrefix="Fox" TagName="Tab" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../../scripts/common.js"></script>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <!-- 头部菜单 Start -->
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="title">
        <tr>
            <td width="19" height="25" valign="top"  class="Lpd10"><div class="arr"></div></td>
            <td width="1232" height="25" valign="top" align="left">你当前位置：游戏系统 - 游戏管理</td>
        </tr>
    </table>
    <Fox:Tab ID="fab1" runat="server" NavActivated="C"></Fox:Tab>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="返回" class="btn wd1" onclick="Redirect('GameKindItemList.aspx')" />                           
                <input class="btnLine" type="button" />  
                <asp:Button ID="btnSave" runat="server" Text="保存" CssClass="btn wd1" onclick="btnSave_Click" />
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10"><div class="hg3  pd7">
                <asp:Literal ID="litInfo" runat="server"></asp:Literal>游戏信息</div></td>
        </tr>
        <tr>
            <td class="listTdLeft">游戏标识：</td>
            <td>        
                <asp:TextBox ID="txtKindID" runat="server" CssClass="text" onkeyup="if(isNaN(value))execCommand('undo')" MaxLength="9"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="请输入游戏标识" ControlToValidate="txtKindID" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="请输入正确的游戏标识，必须为整数" Display="Dynamic" ControlToValidate="txtKindID" ValidationExpression="^([0-9]){1,9}?$" ForeColor="Red"></asp:RegularExpressionValidator>               
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">游戏名称：</td>
            <td>        
                <asp:TextBox ID="txtKindName" runat="server" CssClass="text" MaxLength="32"></asp:TextBox> 
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="请输入游戏名称" ControlToValidate="txtKindName" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>             
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">游戏类型：</td>
            <td>           
                <asp:DropDownList ID="ddlTypeID" runat="server" Width="158px">
                </asp:DropDownList>         
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                挂接：
            </td>
            <td>
                <asp:DropDownList ID="ddlJoin" runat="server" Width="158px">
                
                </asp:DropDownList>
            </td>
        </tr> 
        <tr>
            <td class="listTdLeft">排序：</td>
            <td>        
                <asp:TextBox ID="txtSortID" runat="server" CssClass="text" onkeyup="if(isNaN(value))execCommand('undo')" MaxLength="9" Text="0"></asp:TextBox> 
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="请输入排序" ControlToValidate="txtSortID" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ErrorMessage="请输入正确的排序，必须为整数" Display="Dynamic" ControlToValidate="txtSortID" ValidationExpression="^([0-9]){1,9}?$" ForeColor="Red"></asp:RegularExpressionValidator>               
            </td>
        </tr>     
        <tr>
            <td class="listTdLeft">模块名称：</td>
            <td>        
                <asp:DropDownList ID="ddlGameID" runat="server" Width="158px">
                </asp:DropDownList>       
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">进程名字：</td>
            <td>        
                <asp:TextBox ID="txtProcessName" runat="server" CssClass="text" MaxLength="32"></asp:TextBox> 
                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="请输入排序" ControlToValidate="txtSortID" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
            </td>
        </tr>    
        <tr>
            <td class="listTdLeft">规则路径：</td>
            <td>        
                <asp:TextBox ID="txtGameRuleUrl" runat="server" CssClass="text" MaxLength="256"></asp:TextBox> 
            </td>
        </tr>  
        <tr>
            <td class="listTdLeft">下载路径：</td>
            <td>        
                <asp:TextBox ID="txtDownLoadUrl" runat="server" CssClass="text" MaxLength="256"></asp:TextBox> 
            </td>
        </tr>
        <!--
        <tr>
            <td class="listTdLeft">显示公告的输赢金额：</td>
            <td>        
                <asp:TextBox ID="txtNoticeChangeGolds" runat="server" CssClass="text" MaxLength="9" Text="0"></asp:TextBox> 某个玩家在该游戏中一局输赢超过该金额则在公告中显示这条输赢信息，为0时表示不显示公告。
                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="请输入金额" ControlToValidate="txtNoticeChangeGolds" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" ErrorMessage="请输入正确的金额，必须为整数" Display="Dynamic" ControlToValidate="txtNoticeChangeGolds" ValidationExpression="^([0-9]){1,9}?$" ForeColor="Red"></asp:RegularExpressionValidator>  
            </td>
        </tr>
        -->
        <tr>
            <td class="listTdLeft">赢一局经验：</td>
            <td>        
                <asp:TextBox ID="txtWinExperience" runat="server" CssClass="text" MaxLength="9" Text="0"></asp:TextBox> 在该游戏中赢一局奖励的经验。
                <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ErrorMessage="请输入金额" ControlToValidate="txtWinExperience" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator4" runat="server" ErrorMessage="请输入正确的金额，必须为整数" Display="Dynamic" ControlToValidate="txtWinExperience" ValidationExpression="^([0-9]){1,9}?$" ForeColor="Red"></asp:RegularExpressionValidator>  
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">游戏属性：</td>
            <td>            
                <asp:CheckBoxList ID="cblGameFlag" runat="server" RepeatDirection="Horizontal">
                    <asp:ListItem Value="1" Text="新"></asp:ListItem>
                    <asp:ListItem Value="2" Text="荐"></asp:ListItem>
                    <asp:ListItem Value="4" Text="热"></asp:ListItem>
                    <asp:ListItem Value="8" Text="赛"></asp:ListItem>
                </asp:CheckBoxList>       
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
            <td class="listTdLeft">
                是否存在移动版：
            </td>
            <td>
                <asp:CheckBox ID="ckbRecommend" runat="server" Text="是否存在移动版" />
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="返回" class="btn wd1" onclick="Redirect('GameKindItemList.aspx')" />                           
                <input class="btnLine" type="button" />  
                <asp:Button ID="Button1" runat="server" Text="保存" CssClass="btn wd1" onclick="btnSave_Click" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

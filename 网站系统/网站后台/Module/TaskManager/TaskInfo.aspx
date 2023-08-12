<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TaskInfo.aspx.cs" Inherits="Game.Web.Module.TaskManager.TaskInfo" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link href="/styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/scripts/common.js"></script>
    <script type="text/javascript" src="/scripts/comm.js"></script>
    <script type="text/javascript" src="/scripts/jquery.js"></script>
    <script type="text/javascript" src="/scripts/messages_cn.js"></script>
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
                    你当前位置：任务系统 - 任务管理
                </td>
            </tr>
        </table>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td class="titleOpBg Lpd10">
                    <input id="btnReturn" type="button" value="返回" class="btn wd1" onclick="Redirect('TaskList.aspx')" />
                    <asp:Button ID="btnCreate" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
                </td>
            </tr>
        </table>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
            <tr>
                <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                    <div class="hg3  pd7">
                        任务信息</div>
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">任务名称：</td>
                <td>
                   <asp:TextBox ID="txtTaskName" runat="server" CssClass="text wd7"></asp:TextBox>
                    &nbsp;<span class="hong">*</span>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ForeColor="Red" ControlToValidate="txtTaskName" Display="Dynamic" ErrorMessage="请输入任务名称"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">任务类型：</td>
                <td>
                    <asp:DropDownList ID="ddlTaskType" runat="server" Width="150"  AutoPostBack="true" onselectedindexchanged="ddlTaskType_SelectedIndexChanged">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">可领取任务用户类型：</td>
                <td>                    
                    <asp:RadioButtonList ID="rblUserType" runat="server" RepeatDirection="Horizontal" >
                        <asp:ListItem Text="所有玩家" Value="3" Selected="True"></asp:ListItem>
                        <asp:ListItem Text="会员玩家" Value="2"></asp:ListItem>
                    </asp:RadioButtonList>
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">所属游戏：</td>
                <td>
                     <asp:DropDownList ID="ddlGameKind" runat="server" Width="150">
                    </asp:DropDownList>
                </td>
            </tr>
            <!--
            <tr runat="server" id="trMatchID">
                <td class="listTdLeft">所属比赛：</td>
                <td>
                     <asp:DropDownList ID="ddlMatchID" runat="server" Width="150">
                    </asp:DropDownList>
                </td>
            </tr>
            -->
            <tr>
                <td class="listTdLeft">普通玩家奖励金币：</td>
                <td>
                   <asp:TextBox ID="txtStandardAwardGold" runat="server" CssClass="text wd7" Text="0"></asp:TextBox>
                    &nbsp;<span class="hong">*</span>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ForeColor="Red" ControlToValidate="txtStandardAwardGold" Display="Dynamic" ErrorMessage="请输入奖励金币数"></asp:RequiredFieldValidator>  
                    <asp:RegularExpressionValidator ID="re" ForeColor="Red" ControlToValidate="txtStandardAwardGold" Display="Dynamic" ValidationExpression="^[0-9]\d*$" runat="server" ErrorMessage="输入格式不正确"></asp:RegularExpressionValidator>
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">普通玩家奖励元宝：</td>
                <td>
                   <asp:TextBox ID="txtStandardAwardMedal" runat="server" CssClass="text wd7" Text="0"></asp:TextBox>
                    &nbsp;<span class="hong">*</span>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ForeColor="Red" ControlToValidate="txtStandardAwardMedal" Display="Dynamic" ErrorMessage="请输入奖励元宝数"></asp:RequiredFieldValidator>  
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" ForeColor="Red" ControlToValidate="txtStandardAwardMedal" Display="Dynamic" ValidationExpression="^[0-9]\d*$" runat="server" ErrorMessage="输入格式不正确"></asp:RegularExpressionValidator>
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">会员玩家奖励金币：</td>
                <td>
                   <asp:TextBox ID="txtMemberAwardGold" runat="server" CssClass="text wd7" Text="0"></asp:TextBox>
                    &nbsp;<span class="hong">*</span>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ForeColor="Red" ControlToValidate="txtMemberAwardGold" Display="Dynamic" ErrorMessage="请输入奖励金币数"></asp:RequiredFieldValidator>  
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator2" ForeColor="Red" ControlToValidate="txtMemberAwardGold" Display="Dynamic" ValidationExpression="^[0-9]\d*$" runat="server" ErrorMessage="输入格式不正确"></asp:RegularExpressionValidator>
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">会员玩家奖励元宝：</td>
                <td>
                   <asp:TextBox ID="txtMemberAwardMedal" runat="server" CssClass="text wd7" Text="0"></asp:TextBox>
                    &nbsp;<span class="hong">*</span>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ForeColor="Red" ControlToValidate="txtMemberAwardMedal" Display="Dynamic" ErrorMessage="请输入奖励元宝数"></asp:RequiredFieldValidator>  
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator3" ForeColor="Red" ControlToValidate="txtMemberAwardMedal" Display="Dynamic" ValidationExpression="^[0-9]\d*$" runat="server" ErrorMessage="输入格式不正确"></asp:RegularExpressionValidator>
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">时间限制：</td>
                <td>
                   <asp:TextBox ID="txtTimeLimit" runat="server" CssClass="text wd7"></asp:TextBox>&nbsp;秒
                    &nbsp;<span class="hong">*</span>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ForeColor="Red" ControlToValidate="txtTimeLimit" Display="Dynamic" ErrorMessage="请输入时间限制"></asp:RequiredFieldValidator>  
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator4" ForeColor="Red" ControlToValidate="txtTimeLimit" Display="Dynamic" ValidationExpression="^[0-9]\d*$" runat="server" ErrorMessage="输入格式不正确"></asp:RegularExpressionValidator>
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">完成任务所需局数：</td>
                <td>
                   <asp:TextBox ID="txtInnings" runat="server" CssClass="text wd7"></asp:TextBox>&nbsp;局
                    &nbsp;<span class="hong">*</span>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ForeColor="Red" ControlToValidate="txtInnings" Display="Dynamic" ErrorMessage="请输入时间限制"></asp:RequiredFieldValidator>  
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator5" ForeColor="Red" ControlToValidate="txtInnings" Display="Dynamic" ValidationExpression="^[0-9]\d*$" runat="server" ErrorMessage="输入格式不正确"></asp:RegularExpressionValidator>
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">任务描述：</td>
                <td>
                   <asp:TextBox ID="txtTaskDescription" runat="server" CssClass="text" Width="280" TextMode="MultiLine" Height="120"></asp:TextBox>
                   不允许超过500个字。
                </td>
            </tr>
            <tr>
            <td class="listTdLeft">
               
            </td>
            <td class="hong">
                注意：修改成功后游戏中生效的时间为20分钟
            </td>
        </tr>
        </table>
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td class="titleOpBg Lpd10">
                    <input id="btnReturn2" type="button" value="返回" class="btn wd1" onclick="Redirect('TaskList.aspx')" />
                    <asp:Button ID="btnSave2" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>

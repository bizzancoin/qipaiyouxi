<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AccountsInfo.aspx.cs" Inherits="Game.Web.Module.AccountManager.AccountInfo" %>

<%@ Register Src="~/Themes/TabUser.ascx" TagPrefix="Fox" TagName="Tab" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="/styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/scripts/common.js"></script>
    <script type="text/javascript" src="/scripts/comm.js"></script>
    <script type="text/javascript" src="/scripts/jquery.js"></script>
   <script src="/scripts/lhgdialog/lhgdialog.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function() {
            //弹出页面
            $('#btnSwitchFace').dialog({
                id: 'winUserfaceList',
                title: '更换头像',
                width: 540,
                height: 385,
                content: 'url:/Tools/UserFaceList.aspx?param='+<%= IntParam %>,
                min: false,
                max: false,
                fixed: true,
                drag: false,
                resize: false
            });
        })		        
    </script>

</head>
<body>
    <!-- 头部菜单 Start -->
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="title">
        <tr>
            <td width="19" height="25" valign="top" class="Lpd10">
                <div class="arr">
                </div>
            </td>
            <td width="1232" height="25" valign="top" align="left" style="width: 1232px; height: 25px; vertical-align: top; text-align: left;">
                目前操作功能：用户信息
            </td>
        </tr>
    </table>
    <!-- 头部菜单 End -->
    <Fox:Tab ID="fab1" runat="server" NavActivated="A"></Fox:Tab>

    <script type="text/javascript">
        function CheckForm() {
            var re = /^(-?[1-9][0-9]*|0)$/;
            var userName = document.form1.in_Accounts.value;
            var experience = document.form1.in_Experience.value;
            var loveLiness = document.form1.in_LoveLiness.value;
            var present = document.form1.in_Present.value;
            var nickname = document.form1.in_Nickname.value;
            var underWrite = document.form1.in_UnderWrite.value;
            if (userName.trim() == "") {
                alert("帐号不能为空！");
                document.form1.in_Accounts.focus();
                return false;
            }
            else if (len(userName.trim()) > 31) {
                alert("帐号字符长度不可超过31个字符！");
                document.form1.in_Accounts.focus();
                return false;
            }
            if (len(nickname.trim()) > 31) {
                alert("用户昵称字符长度不可超过31个字符！");
                document.form1.in_Nickname.focus();
                return false;
            }
            if (len(underWrite.trim()) > 63) {
                alert("个性签名字符长度不可超过63个字符！");
                document.form1.in_UnderWrite.focus();
                return false;
            }
            if (!re.test(experience)) {
                alert("经验值必须为整数！");
                document.form1.in_Experience.focus();
                return false;
            }
            if (!re.test(present)) {
                alert("礼物必须为整数！");
                document.form1.in_Present.focus();
                return false;
            }
            if (!re.test(loveLiness)) {
                alert("魅力值必须为整数！");
                document.form1.in_LoveLiness.focus();
                return false;
            }
        }
        function ShowTable() {
            $("#passwordCardDiv").slideToggle("slow");
        }
    </script>

    <form runat="server" id="form1">
    <table width="99%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="关闭" class="btn wd1" onclick="window.close();" />
                <asp:Button ID="btnSave" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    <table width="99%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                <div class="hg3  pd7">
                    基本信息</div>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                ID号码(GameID)：
            </td>
            <td>
                <span class="Rpd20 lan bold">
                    <asp:Literal ID="ltGameID" runat="server"></asp:Literal>
                </span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                    原帐号：
                <span class="Rpd20 lan bold">
                    <asp:Literal ID="ltRegAccounts" runat="server"></asp:Literal>
                </span>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                    <asp:Literal ID="litSName" runat="server" Text="推广人"></asp:Literal>：
                <span class="Rpd20 lan bold">
                    <asp:Literal ID="ltSpreader" runat="server" Text="无推广人"></asp:Literal>
                </span>
            </td>
        </tr>
        <tr style="display: none;">
            <td class="listTdLeft">
                真实姓名：
            </td>
            <td>
                <asp:Literal ID="litCompellation" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                帐号：
            </td>
            <td>
                <asp:TextBox ID="txtAccount" runat="server" CssClass="text wd4" MaxLength="31"></asp:TextBox>&nbsp;帐号字符长度不可超过31个字符
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                用户昵称：
            </td>
            <td>
                <asp:TextBox ID="txtNickName" runat="server" CssClass="text wd4" MaxLength="31"></asp:TextBox>&nbsp;用户昵称字符长度不可超过31个字符
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                登录密码：
            </td>
            <td>
                <asp:TextBox ID="txtLogonPass" TextMode="Password" runat="server" CssClass="text wd4" MaxLength="20"></asp:TextBox>&nbsp;留空不修改
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                保险柜密码：
            </td>
            <td>
                <asp:TextBox ID="txtInsurePass" TextMode="Password" runat="server" CssClass="text wd4" MaxLength="20"></asp:TextBox>&nbsp;留空不修改
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                个性签名：
            </td>
            <td>
                <asp:TextBox ID="txtUnderWrite" runat="server" CssClass="text" Style="width: 450px;" MaxLength="63"></asp:TextBox>&nbsp;个性签名字符长度不可超过63个字符
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                性别：
            </td>
            <td>
                <asp:DropDownList ID="ddlGender" runat="server">
                    <asp:ListItem Value="1" Selected="True">男</asp:ListItem>
                    <asp:ListItem Value="0">女</asp:ListItem>
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                头像：
            </td>
            <td>
                 <!--类型：自定义头像 or 系统头像 -->
                <input id="faceType" name="faceType" type="hidden" value="<%= faceType%>" />
                <!--标识：自定义头像标识 or 系统头像标识 -->
                <input id="inFaceID" name="inFaceID" type="hidden" value="<%= faceId%>" />
                <img id="picFace" alt="头像" title="头像" src="<%= faceUrl %>" />&nbsp;
                <a href="javascript:void(0)" id="btnSwitchFace" class="l">查看更多头像</a>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                密码保护：
            </td>
            <td>
                <asp:Literal ID="ltProtectID" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                密保卡：
            </td>
            <td>
                <asp:Literal ID="LiteralPasswordCard" runat="server" Text="未申请"></asp:Literal>
                 <span ID=spanPasswordCard runat="server" Visible="false">
                  <a href="javascript:void(0)"  class="l1" onclick="javascript:openWindowOwn('AccountPasswordCard.aspx?param=<%= IntParam %>','AccountsPasswordCard',500,330);">点击查看</a> 
                 </span>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                选项：
            </td>
            <td>
                <asp:CheckBox ID="ckbNullity" runat="server" Text="冻结帐号" />
                <asp:CheckBox ID="ckbStunDown" runat="server" Text="安全关闭" />
                <asp:CheckBox ID="chkIsAndroid" runat="server" Text="设为机器人" />
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                锁定机器：
            </td>
            <td>
                <asp:RadioButtonList ID="rdoMoorMachine" runat="server" RepeatDirection="Horizontal">
                    <asp:ListItem Value="0" Selected="True">未锁定</asp:ListItem>
                    <asp:ListItem Value="1">客户端锁定</asp:ListItem>
                </asp:RadioButtonList>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                经验值：
            </td>
            <td>
                <asp:TextBox ID="txtExperience" runat="server" CssClass="text wd4" MaxLength="20" onkeyup="if(isNaN(value))execCommand('undo');" Enabled="false"></asp:TextBox>
            </td>
        </tr>
       
        <tr>
            <td class="listTdLeft">
                魅力值：
            </td>
            <td>
                <asp:TextBox ID="txtLoveLiness" runat="server" CssClass="text wd4" MaxLength="20" onkeyup="if(isNaN(value))execCommand('undo');" Enabled="false"></asp:TextBox>
            </td>
        </tr>
         <tr>
            <td class="listTdLeft">
                已兑魅力：
            </td>
            <td>
                <asp:TextBox ID="txtPresent" runat="server" CssClass="text wd4" MaxLength="20" Enabled="false"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                会员级别：
            </td>
            <td>
                <asp:Literal ID="ltMemberInfo" runat="server"></asp:Literal> 
                <span ID=plMemberList runat="server" Visible="false">
                    &nbsp;<a href="javascript:void(0)" onclick="javascript:openWindowOwn('AccountsMemberList.aspx?param=<%= IntParam %>','_AccountsMemberList',800,500);" class="l">点击查看详情</a>
                </span>
            </td>
        </tr>
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                <div class="hg3  pd7">
                    登录信息</div>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                网站登录次数：
            </td>
            <td>
                <asp:Literal ID="ltWebLogonTimes" runat="server"></asp:Literal>次
                <span style="padding-left: 100px;">大厅登录次数：</span>
                <asp:Literal ID="ltGameLogonTimes" runat="server"></asp:Literal>次
                <span style="padding-left: 10px;"></span>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                在线时长共计：
            </td>
            <td>
                <asp:Literal ID="ltOnLineTimeCount" runat="server"></asp:Literal>
                <span style="padding-left: 100px;">游戏时长共计：</span>
                <asp:Literal ID="ltPlayTimeCount" runat="server"></asp:Literal>
                <span style="padding-left: 10px;"></span>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                最后登录时间：
            </td>
            <td>
                <asp:Literal ID="ltLastLogonDate" runat="server"></asp:Literal>&nbsp;&nbsp;
                <asp:Literal ID="ltLogonSpacingTime" runat="server"></asp:Literal>前
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                最后登录地址：
            </td>
            <td>
                <asp:Literal ID="ltLastLogonIP" runat="server"></asp:Literal>&nbsp;&nbsp;
                <asp:Literal ID="ltLogonIPInfo" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                登录机器：
            </td>
            <td>
                <asp:Literal ID="ltLastLogonMachine" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                注册时间：
            </td>
            <td>
                <asp:Literal ID="ltRegisterDate" runat="server"></asp:Literal>&nbsp;&nbsp;
                <asp:Literal ID="ltRegSpacingTime" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                注册地址：
            </td>
            <td>
                <asp:Literal ID="ltRegisterIP" runat="server"></asp:Literal>&nbsp;&nbsp;
                <asp:Literal ID="ltRegIPInfo" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                注册机器：
            </td>
            <td>
               <asp:Literal ID="ltRegisterMachine" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                注册来源：
            </td>
            <td>
               <asp:Literal ID="ltRegisterOrigin" runat="server"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                <div class="hg3  pd7">
                    权限信息
                </div>
            </td>
        </tr>
         <tr>
            <td colspan="2">
                &nbsp;
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                用户权限：
            </td>
            <td>
                <span style="margin-left:2px;"><input type="checkbox" onclick="SelectAllTable(this.checked,'ckbUserRight')" id="ckbUserAll"/> 全选</span>
                <asp:CheckBoxList ID="ckbUserRight" runat="server" RepeatDirection="Horizontal" RepeatColumns="6">
                </asp:CheckBoxList>
            </td>
        </tr>
         <tr>
            <td colspan="2">
                &nbsp;
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                用户身份：
            </td>
            <td>
                &nbsp;
                <asp:DropDownList ID="ddlMasterOrder" runat="server">
                    <asp:ListItem Value="0" Text="普通玩家"></asp:ListItem>
                    <asp:ListItem Value="1" Text="管理员"></asp:ListItem>
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                &nbsp;
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                管理权限：
            </td>
            <td>
                <span style="margin-left:2px;"><input type="checkbox" onclick="SelectAllTable(this.checked,'ckbMasterRight')" id="ckbMasterAll"/> 全选</span>
                <asp:CheckBoxList ID="ckbMasterRight" runat="server" RepeatDirection="Horizontal" RepeatColumns="6">
                </asp:CheckBoxList>
            </td>
        </tr>
    </table>
    <table width="99%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="关闭" class="btn wd1" onclick="window.close();" />
                <asp:Button ID="btnSave1" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    </form>
<script type="text/javascript">

    //全选函数
    function SelectAllTable(flag, tableID) 
    {
        var m_list_table = document.getElementById(tableID);
        var m_list_checkbox = GelTags("input", m_list_table);
        for (var i = m_list_checkbox.length - 1; i >= 0; i--) 
        {
            m_list_checkbox[i].checked = flag;
        }
    }
    
    //设置全选checkbox是否选中
    $(document).ready(
        function() {
            var results = true;
            if ($("#ckbMasterRight input").length != $("#ckbMasterRight input:checked").length) {
                results = false;
            }
            $("#ckbMasterAll").attr("checked", results);

            results = true;
            if ($("#ckbUserRight input").length != $("#ckbUserRight input:checked").length) {
                results = false;
            }
            $("#ckbUserAll").attr("checked", results);
        }
    );
</script>
</body>
</html>

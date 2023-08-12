<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddAccount.aspx.cs" Inherits="Game.Web.Module.AccountManager.AddAccount" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link type="text/css" href="/styles/layout.css" rel="stylesheet"/>
    <link type="text/css" href="/scripts/lhgdialog/lhgdialog.css" rel="stylesheet"/>
    <script type="text/javascript" src="/scripts/common.js"></script>
    <script type="text/javascript" src="/scripts/comm.js"></script>
    <script type="text/javascript" src="/scripts/jquery.js"></script>
    <script type="text/javascript" src="/scripts/My97DatePicker/WdatePicker.js"></script>
    <script src="/scripts/lhgdialog/lhgdialog.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function() {
            //弹出页面
            $('#btnSwitchFace').dialog({
                id: 'winUserfaceList',
                title: '更换头像',
                width: 540,
                height: 385,
                content: 'url:/Tools/UserfacesList.aspx',
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
            <td width="1232" height="25" valign="top" align="left">
                目前操作功能：添加用户信息
            </td>
        </tr>
    </table>
    <!-- 头部菜单 End -->
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
                帐号：
            </td>
            <td>
                <asp:TextBox ID="txtAccount" runat="server" CssClass="text wd4" MaxLength="31"></asp:TextBox><span class="hong">*</span>&nbsp;
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="请输入帐号" Display="Dynamic" ControlToValidate="txtAccount" ForeColor="Red"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" ErrorMessage="由字母、数字、下划线和汉字组成！" ValidationExpression="^[a-zA-Z0-9_\u4e00-\u9fa5]+$" ControlToValidate="txtAccount" ForeColor="Red"></asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                用户昵称：
            </td>
            <td>
                <asp:TextBox ID="txtNickName" runat="server" CssClass="text wd4" MaxLength="31"></asp:TextBox>&nbsp;不填则与帐号相同
                <asp:RegularExpressionValidator ID="RegularExpressionValidator4" runat="server" ErrorMessage="由字母、数字、下划线和汉字组成！" ValidationExpression="^[a-zA-Z0-9_\u4e00-\u9fa5]+$" ControlToValidate="txtNickName" ForeColor="Red"></asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                登录密码：
            </td>
            <td>
                <asp:TextBox ID="txtLogonPass" TextMode="Password" runat="server" CssClass="text wd4" MaxLength="32"></asp:TextBox><span
                    class="hong">*</span>&nbsp;
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="请输入登录密码" Display="Dynamic" ControlToValidate="txtLogonPass" ForeColor="Red"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ErrorMessage="密码长度为6-32位" ValidationExpression="^.{6,32}$" ControlToValidate="txtLogonPass" ForeColor="Red"></asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                确认登录密码：
            </td>
            <td>
                <asp:TextBox ID="txtLogonPass2" TextMode="Password" runat="server" CssClass="text wd4" MaxLength="32"></asp:TextBox><span
                    class="hong">*</span>&nbsp;
                 <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="请输入确认登录密码" Display="Dynamic" ControlToValidate="txtLogonPass" ForeColor="Red"></asp:RequiredFieldValidator>
                 <asp:CompareValidator ID="CompareValidator2" runat="server" ErrorMessage="两次输入的登录密码不一致" ControlToValidate="txtLogonPass2" ControlToCompare="txtLogonPass"></asp:CompareValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                保险柜密码：
            </td>
            <td>
                <asp:TextBox ID="txtInsurePass" TextMode="Password" runat="server" CssClass="text wd4" MaxLength="32"></asp:TextBox>&nbsp;不填则与登录密码相同
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                确认保险柜密码：
            </td>
            <td>
                <asp:TextBox ID="txtInsurePass2" TextMode="Password" runat="server" CssClass="text wd4" MaxLength="32"></asp:TextBox>&nbsp;
                <asp:CompareValidator ID="CompareValidator1" runat="server" ErrorMessage="两次输入的保险柜密码不一致" ControlToValidate="txtInsurePass2" ControlToCompare="txtInsurePass"></asp:CompareValidator>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                个性签名：
            </td>
            <td>
                <asp:TextBox ID="txtUnderWrite" runat="server" CssClass="text" Style="width: 500px" MaxLength="63"></asp:TextBox>&nbsp;
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                性别：
            </td>
            <td>
                <asp:DropDownList ID="ddlGender" runat="server">
                    <asp:ListItem Value="1" Selected="True">男</asp:ListItem>
                    <asp:ListItem Value="2">女</asp:ListItem>
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                头像：
            </td>
            <td>
                <input id="inFaceID" name="inFaceID" type="hidden" value="" />
                <img id="picFace" alt="头像" title="头像" src="/gamepic/Avatar0.png" />&nbsp;&nbsp;
                <a href="javascript:void(0)" id="btnSwitchFace">查看更多头像</a>
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
                    <asp:ListItem Value="2">网页锁定</asp:ListItem>
                </asp:RadioButtonList>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                经验值：
            </td>
            <td>
                <asp:TextBox ID="txtExperience" runat="server" CssClass="text wd4" MaxLength="8" onkeyup="if(isNaN(value))execCommand('undo');"></asp:TextBox>
            </td>
        </tr>
        <tr style="display:none;">
            <td class="listTdLeft">
                礼 物：
            </td>
            <td>
                <asp:TextBox ID="txtPresent" runat="server" CssClass="text wd4" MaxLength="8" onkeyup="if(isNaN(value))execCommand('undo');"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                魅力值：
            </td>
            <td>
                <asp:TextBox ID="txtLoveLiness" runat="server" CssClass="text wd4" MaxLength="8" onkeyup="if(isNaN(value))execCommand('undo');"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                会员级别：
            </td>
            <td>
                <asp:DropDownList ID="ddlMemberOrder" runat="server">
                   
                </asp:DropDownList>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <span id="spanMember" style="display: none;">会员到期时间：
                    <asp:TextBox ID="txtMemberOverDate" runat="server" CssClass="text wd2"></asp:TextBox><img src="../../Images/btn_calendar.gif"
                        onclick="WdatePicker({el:'txtMemberOverDate',skin:'whyGreen',dateFmt:'yyyy-MM-dd'})" style="cursor: pointer; vertical-align: middle" />
                </span>
            </td>
        </tr>
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                <div class="hg3  pd7">
                    详细信息</div>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                真实姓名：
            </td>
            <td>
                <asp:TextBox ID="txtCompellation" runat="server" CssClass="text wd4" MaxLength="16"></asp:TextBox>&nbsp;
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                QQ号码：
            </td>
            <td>
                <asp:TextBox ID="txtQQ" runat="server" CssClass="text wd4" MaxLength="16" onkeyup="if(isNaN(value))execCommand('undo');"></asp:TextBox>&nbsp;
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                电子邮箱：
            </td>
            <td>
                <asp:TextBox ID="txtEMail" runat="server" CssClass="text wd4" MaxLength="32" validate="email:true"></asp:TextBox>&nbsp;
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                固定电话：
            </td>
            <td>
                <asp:TextBox ID="txtSeatPhone" runat="server" CssClass="text wd4" MaxLength="32"></asp:TextBox>&nbsp;
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                手机号码：
            </td>
            <td>
                <asp:TextBox ID="txtMobilePhone" runat="server" CssClass="text wd4" MaxLength="16" onkeyup="if(isNaN(value))execCommand('undo');"></asp:TextBox>&nbsp;
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                邮政编码：
            </td>
            <td>
                <asp:TextBox ID="txtPostalCode" runat="server" CssClass="text wd4" MaxLength="8" onkeyup="if(isNaN(value))execCommand('undo');"></asp:TextBox>&nbsp;
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                居住地址：
            </td>
            <td>
                <asp:TextBox ID="txtDwellingPlace" runat="server" CssClass="text wd4" Style="width: 500px" MaxLength="128"></asp:TextBox>&nbsp;
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                用户备注：
            </td>
            <td>
                <asp:TextBox ID="txtUserNote" runat="server" CssClass="text wd4" Style="width: 500px" MaxLength="256"></asp:TextBox>&nbsp;
            </td>
        </tr>
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                <div class="hg3  pd7">
                    权限信息</div>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                用户权限：
            </td>
            <td>
                <span style="margin-left:2px;"><input type="checkbox" onclick="SelectAllTable(this.checked,'ckbUserRight')" id="ckbUserAll"/>全选</span>
                <asp:CheckBoxList ID="ckbUserRight" runat="server" RepeatDirection="Horizontal" RepeatColumns="6">
                </asp:CheckBoxList>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                用户身份：
            </td>
            <td>
                &nbsp;<asp:DropDownList ID="ddlMasterOrder" runat="server">
                    <asp:ListItem Value="0" Text="玩家"></asp:ListItem>
                    <asp:ListItem Value="1" Text="管理员"></asp:ListItem>
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">
                管理权限：
            </td>
            <td id="tdMasterOrder">
                <span style="margin-left:2px;"><input type="checkbox" onclick="SelectAllTable(this.checked,'ckbMasterRight')" id="ckbMasterAll" disabled="true" data-test="158"/>全选</span>
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
</body>
</html>

<script type="text/javascript">

    //全选函数
    function SelectAllTable(flag, tableID) {
        var m_list_table = document.getElementById(tableID);
        var m_list_checkbox = GelTags("input", m_list_table);
        for (var i = m_list_checkbox.length - 1; i >= 0; i--) {
            m_list_checkbox[i].checked = flag;
        }
    }

    $(document).ready(function() {
        MasterSet();
        
        $("#ddlMasterOrder").change(function() {
            MasterSet();
        });

        function MasterSet() {
            var ele = $("#tdMasterOrder").find('span,input');
            var obj = $("#ddlMasterOrder");
            if (obj.val() == "0") {
                ele.prop("checked", false);
                ele.attr("disabled", "disabled");
                $("#ckbMasterAll").prop("checked", false);
                $("#ckbMasterAll").attr("disabled", "disabled");
            }
            else {
                $("#ckbMasterRight").removeAttr("disabled");
                $("#tdMasterOrder").find('span').removeAttr('disabled');
                ele.removeAttr("disabled");
                $("#ckbMasterAll").removeAttr("disabled");
            }
        }
    });
</script>


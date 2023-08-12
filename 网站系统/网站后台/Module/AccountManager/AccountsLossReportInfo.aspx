<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AccountsLossReportInfo.aspx.cs" Inherits="Game.Web.Module.AccountManager.AccountsLossReportInfo" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link href="/styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/scripts/common.js"></script>
    <script type="text/javascript" src="/scripts/comm.js"></script>
    <script type="text/javascript" src="/scripts/My97DatePicker/WdatePicker.js"></script>
    <title></title>
</head>
<body>
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="title">
        <tr>
            <td width="19" height="25" valign="top" class="Lpd10">
                <div class="arr">
                </div>
            </td>
            <td width="1232" height="25" valign="top" align="left">
                目前操作功能：用户系统 - 申诉资料
            </td>
        </tr>
    </table>
    <form id="form1" runat="server">
        <div style="width:500px; height:540px; clear:both; float:left; overflow:scroll; overflow-x:hidden;">
           <table width="480px" border="0" cellpadding="0" cellspacing="0" style="clear:both;" class="listtable">
            <tr>
              <td height="30px" colspan="2" class="bold Lpd10 Rpd10">
                <div>申诉资料</div>
                <div class="xuxian2" style="margin-top:0px;"></div>
              </td>
            </tr>
            <tr>
                <td class="listTdLeft">申诉单号：</td>
                <td><asp:Label ID="lblReportNo" runat="server" Text=""></asp:Label></td>
            </tr>
            <tr>
                <td class="listTdLeft">帐号：</td>
                <td><asp:Label ID="lblAccounts" runat="server" Text=""></asp:Label></td>
            </tr>
            <tr>
                <td class="listTdLeft">真实姓名：</td>
                <td><asp:Label ID="lblCompellation" runat="server" Text=""></asp:Label></td>
            </tr>
            <tr>
                <td class="listTdLeft">身份证号：</td>
                <td><asp:Label ID="lblPassportID" runat="server" Text=""></asp:Label></td>
            </tr>
            <tr>
                <td class="listTdLeft">移动电话：</td>
                <td><asp:Label ID="lblLinkPhone" runat="server" Text=""></asp:Label></td>
            </tr>
            <tr>
                <td class="listTdLeft">注册时间：</td>
                <td><asp:Label ID="lblRegisterTime" runat="server" Text=""></asp:Label></td>
            </tr>
            <tr>
                <td class="listTdLeft">历史昵称1：</td>
                <td><asp:Label ID="lblOldNickName1" runat="server" Text=""></asp:Label></td>
            </tr>
            <tr>
                <td class="listTdLeft">历史昵称2：</td>
                <td><asp:Label ID="lblOldNickName2" runat="server" Text=""></asp:Label></td>
            </tr>
            <tr>
                <td class="listTdLeft">历史昵称3：</td>
                <td><asp:Label ID="lblOldNickName3" runat="server" Text=""></asp:Label></td>
            </tr>
            <tr>
                <td class="listTdLeft">历史登录密码1：</td>
                <td><asp:Label ID="lblOldLogonPass1" runat="server" Text=""></asp:Label></td>
            </tr>
            <tr>
                <td class="listTdLeft">历史登录密码2：</td>
                <td><asp:Label ID="lblOldLogonPass2" runat="server" Text=""></asp:Label></td>
            </tr>
            <tr>
                <td class="listTdLeft">历史登录密码3：</td>
                <td><asp:Label ID="lblOldLogonPass3" runat="server" Text=""></asp:Label></td>
            </tr>
            <tr>
                <td class="listTdLeft">密保1：</td>
                <td><asp:Label ID="lblOldProtect1" runat="server" Text=""></asp:Label></td>
            </tr>
            <tr>
                <td class="listTdLeft">密保2：</td>
                <td><asp:Label ID="lblOldProtect2" runat="server" Text=""></asp:Label></td>
            </tr>
            <tr>
                <td class="listTdLeft">密保3：</td>
                <td><asp:Label ID="lblOldProtect3" runat="server" Text=""></asp:Label></td>
            </tr>
            <tr>
                <td class="listTdLeft">申诉时间：</td>
                <td><asp:Label ID="lblReportDate" runat="server" Text=""></asp:Label></td>
            </tr>
            <tr>
                <td class="listTdLeft">申诉地址：</td>
                <td><asp:Label ID="lblReportIP" runat="server" Text=""></asp:Label></td>
            </tr>
            <tr>
                <td class="listTdLeft">处理时间：</td>
                <td><asp:Label ID="lblOverDate" runat="server" Text=""></asp:Label></td>
            </tr>
            <tr>
                <td class="listTdLeft">其他证明：</td>
                <td><asp:Label ID="lblSuppInfo" runat="server" Text=""></asp:Label></td>
            </tr>
           </table>
        </div>
        
        <div style="width:400px; height:500px; float:left; margin-left:20px;">
            <table width="100%">
                <tr>
                    <td height="30px" colspan="2" class="bold Lpd10 Rpd10">
                    <div>资料审核</div>
                    <div class="xuxian2" style="margin-top:0px;"></div></td>
                </tr>
                <tr style="height:300px; vertical-align:top;">
                    <td colspan="2" id="CheckInfo" runat="server"></td>
                </tr>
                <tr>
                    <td height="30px" colspan="2" class="bold Lpd10 Rpd10">
                    <div>密保资料</div>
                    <div class="xuxian2" style="margin-top:0px;"></div></td>
                </tr>
                <tr style="height:30px; vertical-align:middle;">
                    <td colspan="2" id="PassProtect" runat="server" class="retd"></td>
                </tr>
                <tr>
                    <td height="30px" colspan="2" class="bold Lpd10 Rpd10">
                    <div>相关操作</div>
                    <div class="xuxian2" style="margin-top:0px;"></div></td>
                </tr>
                <tr style="height:80px; vertical-align:top;">
                    <td colspan="2" class="retd">
                        <a href="#" class="l" onclick='javascript:openWindowOwn("AccountsInfo.aspx?param="+<%=userID %>,"查看帐号详情",850,600);'>查看帐号详情</a>&nbsp;&nbsp;|&nbsp;&nbsp;
                        <a href="#" class="l" onclick='javascript:openWindowOwn("AccountsUpdatePass.aspx?param="+<%=userID %>,"修改密码",500,260);'>修改密码</a> <br/>
                        <a href="#" class="l" onclick='javascript:openWindowOwn("RecordAccountsExpendList.aspx?type=1&param="+<%=userID %>,"修改昵称记录",800,500);'>修改昵称记录</a>&nbsp;&nbsp;|&nbsp;&nbsp;
                        <a href="#" class="l" onclick='javascript:openWindowOwn("RecordPasswdExpendList.aspx?param="+<%=userID %>,"修改密码记录",800,500);'>修改密码记录</a> (历史)<br/>
                        <asp:LinkButton ID="lblsend" CssClass="l" runat="server" OnClientClick="return confirm('确定发送申诉成功邮件吗？');" onclick="LinkButton1_Click">申诉成功邮件</asp:LinkButton>&nbsp;&nbsp;|&nbsp;&nbsp;
                        <a href="#" class="l" onclick='javascript:openWindowOwn("SendLossReportInfo.aspx?param="+GetRequest("param",0),GetRequest("param",0)+"发送失败邮件",750,550);'>申诉失败邮件</a> (发送)<br/>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>

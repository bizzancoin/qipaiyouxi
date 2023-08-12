<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AgentManager.aspx.cs" Inherits="Game.Web.Module.AgentManager.AgentManager" %>
<%@ Register Src="~/Themes/TabAgent.ascx" TagPrefix="Fox" TagName="Tab" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link href="/styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/scripts/common.js"></script>
    <script type="text/javascript" src="/scripts/comm.js"></script>    
    <script type="text/javascript" src="/scripts/jquery.js"></script>
    <script type="text/javascript" src="../../scripts/jquery.validate.js"></script>

    <script type="text/javascript" src="../../scripts/messages_cn.js"></script>

    <script type="text/javascript" src="../../scripts/jquery.metadata.js"></script>
    <script type="text/javascript">
        $(function () {
            var table = $('#table');

            table.on('change', '[data-section-ref]', function () {
                var radio = $(this);
                var section = radio.attr('data-section-ref');

                table
                  .find('input[data-section]')
                  .each(function () {
                      var target = $(this);
                      var sections = target
                        .attr('data-section')
                        .split(/\s*,\s*/);

                      if (section === '*' || sections.indexOf(section) !== -1) {
                          target.prop('disabled', true).val('0');
                      } else {
                          target.prop('disabled', false).val('0');
                      }
                  });
            });
        });
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
            <td width="1232" height="25" valign="top" align="left" style="width: 1232px; height: 25px; vertical-align: top; text-align: left;">
                目前操作功能：代理信息
            </td>
        </tr>
    </table>
    <!-- 头部菜单 End -->
    <Fox:Tab ID="fab1" runat="server" NavActivated="A"></Fox:Tab>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="titleOpBg Lpd10">
                <input type="button" value="关闭" class="btn wd1" onclick="window.close();" />
                <asp:Button ID="btnSave" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
            </td>
        </tr>
    </table>
    <table id="table" width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10"><div class="hg3  pd7">
                <asp:Literal ID="litInfo" runat="server"></asp:Literal>代理信息</div></td>
        </tr>
        <tr>
            <td class="listTdLeft">代理编号：</td>
            <td>        
                <asp:Label ID="lblAgentID" runat="server" ForeColor="Blue"></asp:Label>   
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">游戏ID：</td>
            <td>               
                <asp:Label ID="lblGameID" runat="server" ForeColor="Blue"></asp:Label>    
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">游戏帐号：</td>
            <td>        
                <asp:Label ID="lblAccounts" runat="server" ForeColor="Blue"></asp:Label>           
            </td>
        </tr>
        <tr>
            <td class="listTdLeft"><label class="hong">* </label>真实姓名：</td>
            <td>        
                <asp:TextBox ID="txtCompellation" runat="server" CssClass="text" validate="{required:true}"></asp:TextBox>               
            </td>
        </tr>
        <tr>
            <td class="listTdLeft"><label class="hong">* </label>代理域名：</td>
            <td>        
                <asp:TextBox ID="txtDomain" runat="server" CssClass="text" validate="{required:true}"></asp:TextBox>        
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">分成类型：</td>
            <td>        
                <asp:RadioButtonList ID="rblAgentType" runat="server" RepeatDirection="Horizontal">
                    <asp:ListItem Value="1" data-section-ref="type-1" Text="充值分成" Selected="True"></asp:ListItem>
                    <asp:ListItem Value="2" data-section-ref="type-2" Text="税收分成"></asp:ListItem>
                </asp:RadioButtonList>   
            </td>
        </tr>
        <tr>
            <td class="listTdLeft"><label class="hong">* </label>分成比例：</td>
            <td>        
                <asp:TextBox ID="txtAgentScale" runat="server" CssClass="text" validate="{required:true,digits:true,min:0,max:1000}" Text="0"></asp:TextBox>‰               
            </td>
        </tr>
        <tr>
            <td class="listTdLeft"><label class="hong">* </label>日累计充值返现：</td>
            <td>        
                <asp:TextBox ID="txtDayBackAllPay" data-section="type-2" runat="server" CssClass="text" validate="{required:true,digits:true}" Text="0"></asp:TextBox>           
            </td>
        </tr>
        <tr>
            <td class="listTdLeft"><label class="hong">* </label>返现比例：</td>
            <td>        
                <asp:TextBox ID="txtDayBackScale" data-section="type-2" runat="server" CssClass="text" validate="{required:true,digits:true,min:0,max:1000}" Text="0"></asp:TextBox>‰               
            </td>
        </tr>
        <tr>
            <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10"><div class="hg3  pd7">
                联系信息</div></td>
        </tr>
        <tr>
            <td class="listTdLeft"><label class="hong">* </label>联系电话：</td>
            <td>        
                <asp:TextBox ID="txtMobilePhone" runat="server" CssClass="text" validate="{required:true,number:true,maxlength:16}"></asp:TextBox>            
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">电子邮箱：</td>
            <td>        
                <asp:TextBox ID="txtEMail" runat="server" CssClass="text"></asp:TextBox>            
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">联系地址：</td>
            <td>        
                <asp:TextBox ID="txtDwellingPlace" runat="server" CssClass="text" Width="300px"></asp:TextBox>            
            </td>
        </tr>
        <tr>
            <td class="listTdLeft">备注：</td>
            <td>        
                <asp:TextBox ID="txtAgentNote" runat="server" CssClass="text" Width="300px"></asp:TextBox>            
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
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
    jQuery(document).ready(function () {
        jQuery.metadata.setType("attr", "validate");
        jQuery("#<%=form1.ClientID %>").validate();
    });
</script>

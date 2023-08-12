<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AccountsList.aspx.cs" Inherits="Game.Web.Module.AccountManager.AccountsList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../styles/layout.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="../../scripts/common.js"></script>

    <script type="text/javascript" src="../../scripts/comm.js"></script>

    <script type="text/javascript" src="../../scripts/My97DatePicker/WdatePicker.js"></script>

    <script type="text/javascript">
        function GrantManager(opType) {
            if (deleteop()) {
                var cid = "";
                var cids = GelTags("input");

                for (var i = 0; i < cids.length; i++) {
                    if (cids[i].checked) {
                        if (cids[i].name == "cid")
                            cid += cids[i].value + ",";
                    }
                }

                if (cid == "") {
                    showError("未选中任何数据");
                    return;
                }

                //操作处理
                cid = cid.substring(0, cid.length - 1);
                switch (opType) {
                    case "GrantMember":
                        openWindowOwn('GrantMember.aspx?param=' + cid, '_GrantMember', 600, 240);
                        break;
                    case "GrantTreasure":
                        openWindowOwn('GrantTreasure.aspx?param=' + cid, '_GrantTreasure', 600, 240);
                        break;
                    case "GrantExperience":
                        openWindowOwn('GrantExperience.aspx?param=' + cid, '_GrantExperience', 600, 240);
                        break;
                    case "GrantScore":
                        openWindowOwn('GrantScore.aspx?param=' + cid, '_GrantScore', 600, 240);
                        break;
                    case "GrantClearScore":
                        openWindowOwn('GrantClearScore.aspx?param=' + cid, '_GrantClearScore', 600, 240);
                        break;
                    case "GrantFlee":
                        openWindowOwn('GrantFlee.aspx?param=' + cid, '_GrantFlee', 600, 240);
                        break;
                    case "GrantRoomCard":
                        openWindowOwn('GrantRoomCard.aspx?param=' + cid, '_GrantRoomCard', 600, 240);
                        break;
                }
            }
        }
        function ShowDiv() {
            document.getElementById('divQuery').style.display = "block";
        }
        function HideDiv() {
            document.getElementById('divQuery').style.display = "none";
        }
    </script>

    <style type="text/css">
        .querybox
        {
            width: 500px;
            background: #caebfc;
            font-size: 12px;
            line-height: 18px;
            text-align: left;
            border-left: 1px solid #066ba4;
            border-right: 1px solid #066ba4;
            border-bottom: 1px solid #066ba4;
            border-top:1px solid #066ba4;
            z-index: 999;
            display: none;
            position: absolute;
            top: 150px;
            left: 200px; /*filter:progid:DXImageTransform.Microsoft.DropShadow(color=#9a8559,offX=1,offY=1,positives=true); */
        }
    </style>
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
                你当前位置：用户系统 - 用户管理
            </td>
        </tr>
    </table>
    <!-- 头部菜单 End -->
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="titleQueBg">
        <tr>
            <td align="center"  style="width: 80px">
                普通查询：
            </td>
            <td>
                <asp:TextBox ID="txtSearch" runat="server" CssClass="text" ToolTip="输入帐号、昵称、用户标识或游戏ID"></asp:TextBox>
                <asp:CheckBox ID="ckbIsLike" runat="server" Text="模糊查询" />
                <asp:Button ID="btnQuery" runat="server" Text="查询" CssClass="btn wd1" OnClick="btnQuery_Click" />
                <input type="button" value="高级查询" class="btn wd2" onclick="ShowDiv()" />
                <asp:Button ID="btnRefresh" runat="server" Text="刷新" CssClass="btn wd1" OnClick="btnRefresh_Click" />
            </td>
        </tr>
    </table>
    <div id="divQuery" class="querybox">
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
            <tr>
                <td height="40" colspan="2" class="f14 bold Lpd10 Rpd10">
                    <div class="hg3  pd7">
                        基本查询</div>
                </td>
            </tr>
            <tr>
                <td align="right" style="width:20%; height:30px;">
                    用户状态：
                </td>
                <td align="left">
                    <asp:CheckBox ID="ckbProtect" runat="server" Text="申请密保" />
                    <asp:CheckBox ID="ckbMember" runat="server" Text="会员" />
                    <asp:CheckBox ID="ckbNullity" runat="server" Text="冻结" />
                    <asp:CheckBox ID="ckbIsAndroid" runat="server" Text="机器人" />
                    <asp:CheckBox ID="ckbIsUser" runat="server" Text="真实玩家" />
                    <asp:CheckBox ID="ckbIsManager" runat="server" Text="管理员" />
                </td>
            </tr>
            <tr>
                <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                    <div class="hg3  pd7">
                        时间查询</div>
                </td>
            </tr>
            <tr>
                <td align="right" style="width:20%;height:35px;">
                    注册日期：
                </td>
                <td align="left">
                    <asp:TextBox ID="txtStartDate" runat="server" CssClass="text wd2" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'txtEndDate\')}'})"></asp:TextBox><img
                        src="../../Images/btn_calendar.gif" onclick="WdatePicker({el:'txtStartDate',dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'txtEndDate\')}'})"
                        style="cursor: pointer; vertical-align: middle" />
                    至
                    <asp:TextBox ID="txtEndDate" runat="server" CssClass="text wd2" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'txtStartDate\')}'})"></asp:TextBox><img
                        src="../../Images/btn_calendar.gif" onclick="WdatePicker({el:'txtEndDate',dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'txtStartDate\')}'})"
                        style="cursor: pointer; vertical-align: middle" />
                </td>
            </tr>
            <tr>
                <td align="right" style="width:20%;height:30px;">
                    登录日期：
                </td>
                <td  align="left">
                    <asp:TextBox ID="txtLoStartDate" runat="server" CssClass="text wd2" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'txtLoEndDate\')}'})"></asp:TextBox><img
                        src="../../Images/btn_calendar.gif" onclick="WdatePicker({el:'txtLoStartDate',dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'txtLoEndDate\')}'})"
                        style="cursor: pointer; vertical-align: middle" />
                    至
                    <asp:TextBox ID="txtLoEndDate" runat="server" CssClass="text wd2" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'txtLoStartDate\')}'})"></asp:TextBox><img
                        src="../../Images/btn_calendar.gif" onclick="WdatePicker({el:'txtLoEndDate',dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'txtLoStartDate\')}'})"
                        style="cursor: pointer; vertical-align: middle" />
                </td>
            </tr>
            <tr>
                <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                    <div class="hg3  pd7">
                        IP查询</div>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center" style="height:35px;">
                    注册地址：<asp:TextBox ID="txtRegIP" runat="server" CssClass="text wd3" MaxLength="15"></asp:TextBox>
                    注册机器：<asp:TextBox ID="txtRegMachine" runat="server" CssClass="text" Style="width: 195px; margin: 1px 2px 0 0;"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center" style="height:30px;">
                    登录地址：<asp:TextBox ID="txtLogIP" runat="server" CssClass="text wd3" MaxLength="15"></asp:TextBox>
                    登录机器：<asp:TextBox ID="txtLogMachine" runat="server" CssClass="text" Style="width: 195px; margin: 1px 2px 0 0;"></asp:TextBox>
                </td>
            </tr>
            <tr style="display: none;">
                <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                    <div class="hg3  pd7">
                        货币查询</div>
                </td>
            </tr>
            <tr style="display: none;">
                <td class="listTdLeft" style="width: 50px;">
                    现金余额：
                </td>
                <td>
                    <asp:DropDownList ID="ddlOperator" runat="server">
                        <asp:ListItem Value="0">=</asp:ListItem>
                        <asp:ListItem Value="1">></asp:ListItem>
                        <asp:ListItem Value="2"><</asp:ListItem>
                        <asp:ListItem Value="3">≥</asp:ListItem>
                        <asp:ListItem Value="4">≤</asp:ListItem>
                    </asp:DropDownList>
                    <input name="in_Nickname" type="text" class="text wd2" />
                    保险柜余额：
                    <asp:DropDownList ID="ddlOperator1" runat="server">
                        <asp:ListItem Value="0">=</asp:ListItem>
                        <asp:ListItem Value="1">></asp:ListItem>
                        <asp:ListItem Value="2"><</asp:ListItem>
                        <asp:ListItem Value="3">≥</asp:ListItem>
                        <asp:ListItem Value="4">≤</asp:ListItem>
                    </asp:DropDownList>
                    <input name="in_Nickname" type="text" class="text wd2" />
                </td>
            </tr>
            <tr>
                <td colspan="2" align="right" style="padding-bottom: 10px;">
                    <asp:Button ID="btnHightQuery" runat="server" Text="查询" CssClass="btn wd1" OnClick="btnHightQuery_Click" />
                    <input type="button" value="关闭" class="btn wd1" onclick="HideDiv()" />
                    <input type="hidden" name="QueryType" value="1" />
                </td>
            </tr>
        </table>
    </div>
    <div class="clear"></div>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="Tmg7">
        <tr>
            <td height="39" class="titleOpBg">
                <input type="button" value="新增" class="btn wd1" onclick="openWindowOwn('AddAccount.aspx','',850,600)" />
                <asp:Button ID="btnDelete" runat="server" Text="删除" CssClass="btn wd1" OnClick="btnDelete_Click" OnClientClick="return deleteop()"
                    Visible="false" />
                <input class="btnLine" type="button" />
                <asp:Button ID="btnDongjie" runat="server" Text="冻结" CssClass="btn wd1" OnClick="btnDongjie_Click" OnClientClick="return deleteop()" />
                <asp:Button ID="btnJiedong" runat="server" Text="解冻" CssClass="btn wd1" OnClick="btnJiedong_Click" OnClientClick="return deleteop()" />
                <asp:Button ID="btnSetting" runat="server" Text="设置机器人" CssClass="btn wd2" OnClick="btnSetting_Click" OnClientClick="return deleteop()" />
                <asp:Button ID="btnCancle" runat="server" Text="取消机器人" CssClass="btn wd2" OnClick="btnCancle_Click" OnClientClick="return deleteop()" />
                <input class="btnLine" type="button" />
                <input type="button" value="赠送会员" class="btn wd2" onclick="GrantManager('GrantMember')" />
                <input id="btnGrantTreasure" value="赠送游戏币" type="button" class="btn wd2" onclick="GrantManager('GrantTreasure')" />
                <input id="btnGrantExperience" value="赠送经验" type="button" class="btn wd2" onclick="GrantManager('GrantExperience')" />
                <input type="button" value="赠送积分" class="btn wd2" onclick="GrantManager('GrantScore')" />
                <input type="button" value="清零积分" class="btn wd2" onclick="GrantManager('GrantClearScore')" />
                <input type="button" value="清零逃率" class="btn wd2" onclick="GrantManager('GrantFlee')" />
                <%
                    if(AllowBattle=="1")
                    {
                %>
                        <input type="button" value="赠送房卡" class="btn wd2" onclick="GrantManager('GrantRoomCard')" />
                <%
                    }
                 %>
            </td>
        </tr>
    </table>
    <div id="content">
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="box" id="list">
            <tr align="center" class="bold">
                <td class="listTitle">
                    <input type="checkbox" name="chkAll" onclick="SelectAll(this.checked);" />
                </td>
                <td class="listTitle2">
                    用户标识
                </td>
                <td class="listTitle2">
                    游戏ID
                </td>
                <td class="listTitle2">
                    用户帐号
                </td>
                <td class="listTitle2">
                    昵称
                </td>
                <td class="listTitle2">
                    性别
                </td>
                <td class="listTitle2">
                    经验值
                </td>
                <td class="listTitle2">
                    魅力值
                </td>
                <td class="listTitle2">
                    已兑魅力
                </td>
                <%
                    if(AllowBattle=="1")
                    {
                %>
                        <td class="listTitle2">
                            房卡数
                        </td>
                <%
                    }
                 %>
                <td class="listTitle2">
                    会员级别
                </td>
                <td class="listTitle2">
                    推广人
                </td>
                <td class="listTitle2">
                    管理级别
                </td>
                <td class="listTitle2">
                    注册时间
                </td>
                <td class="listTitle2">
                    注册地址
                </td>
                <td class="listTitle2">
                    登录次数
                </td>
                <td class="listTitle2">
                    最后登录时间
                </td>
                <td class="listTitle2">
                    最后登录地址
                </td>
                <td class="listTitle1">
                    状态
                </td>
                <td class="listTitle1">
                    管理
                </td>
            </tr>
            <asp:Repeater ID="rptDataList" runat="server">
                <ItemTemplate>
                    <tr align="center" class="list" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td style="width: 30px;">
                            <input name='cid' type='checkbox' value='<%# Eval("UserID").ToString()%>' />
                        </td>
                        <td>
                            <%# Eval( "UserID" ).ToString( ) %>
                        </td>
                        <td>
                            <%# Eval( "GameID" ).ToString( ) %>
                        </td>
                        <td title="<%# Eval( "Accounts" ).ToString()%>">
                            <a class="l" href="javascript:void(0);" onclick="openWindowOwn('AccountsInfo.aspx?param=<%#Eval("UserID").ToString() %>','<%#Eval("UserID").ToString() %>',850,600);">
                                <%#Game.Utils.TextUtility.CutString( Eval( "Accounts" ).ToString(),0,10)%></a>
                        </td>
                        <td>
                            <%# Eval( "NickName" ).ToString( ) %>
                        </td>
                        <td>
                            <%# Eval( "Gender" ).ToString()=="1"?"男":"女"%>
                        </td>
                        <td>
                            <%#  Eval( "Experience" ).ToString( )%>
                        </td>
                        <td>
                            <%#  Eval( "LoveLiness" ).ToString( )%>
                        </td>
                        <td>
                            <%#  Eval( "Present" ).ToString( )%>
                        </td>
                        <%
                            if(AllowBattle=="1")
                            {
                        %>
                                <td>
                                    <%# GetRoomCard(Convert.ToInt32(Eval( "UserID" ))) %>
                                </td>
                        <%
                            }
                         %>
                        <td>
                            <%# GetMemberName(byte.Parse(  Eval( "MemberOrder" ).ToString( )))%>
                        </td>
                         <td>
                            <%# GetAccounts( Convert.ToInt32( Eval( "SpreaderID" ) ) )%>
                        </td>
                        <td>
                            <%# int.Parse( Eval( "MasterOrder" ).ToString( ) ) == 0 ? "普通玩家" : "<span style='color:#105399;font-weight:bold;'>管理员</span>"%>
                        </td>
                        <td>
                            <%# Eval( "RegisterDate" ).ToString()%>
                        </td>
                        <td>
                           <%# Eval("RegisterIP").ToString()%>
                        </td>
                        <td>
                            <%# Eval( "GameLogonTimes" ).ToString()%>
                        </td>
                        <td>
                            <%# Eval( "LastLogonDate" ).ToString()%>
                        </td>
                        <td>
                            <%# Eval( "LastLogonIP" ).ToString( ) %>
                        </td>
                        <td>
                            <%# GetNullityStatus((byte)Eval("Nullity"))%>
                        </td>
                        <td>
                            <a class="l" href="javascript:void(0)" onclick="javascript:openWindowOwn('GrantGameID.aspx?param=<%#Eval("UserID").ToString() %>','_GrantGameID',600,260);">
                                赠送靓号</a>
                        </td>
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr align="center" class="listBg" onmouseover="currentcolor=this.style.backgroundColor;this.style.backgroundColor='#caebfc';this.style.cursor='default';"
                        onmouseout="this.style.backgroundColor=currentcolor">
                        <td style="width: 30px;">
                            <input name='cid' type='checkbox' value='<%# Eval("UserID").ToString()%>' />
                        </td>
                        <td>
                            <%# Eval( "UserID" ).ToString( ) %>
                        </td>
                        <td>
                            <%# Eval( "GameID" ).ToString( ) %>
                        </td>
                        <td title="<%# Eval( "Accounts" ).ToString()%>">
                            <a class="l" href="javascript:void(0);" onclick="openWindowOwn('AccountsInfo.aspx?param=<%#Eval("UserID").ToString() %>','<%#Eval("UserID").ToString() %>',850,600);">
                                <%#Game.Utils.TextUtility.CutString( Eval( "Accounts" ).ToString(),0,10)%></a>
                        </td>
                        <td>
                            <%# Eval( "NickName" ).ToString( ) %>
                        </td>
                        <td>
                            <%# Eval( "Gender" ).ToString()=="1"?"男":"女"%>
                        </td>
                        <td>
                            <%#  Eval( "Experience" ).ToString( )%>
                        </td>
                        <td>
                            <%#  Eval( "LoveLiness" ).ToString( )%>
                        </td>
                        <td>
                            <%#  Eval( "Present" ).ToString( )%>
                        </td>
                        <%
                            if(AllowBattle=="1")
                            {
                        %>
                                <td>
                                    <%# GetRoomCard(Convert.ToInt32(Eval( "UserID" ))) %>
                                </td>
                        <%
                            }
                         %>
                        <td>
                            <%# GetMemberName(byte.Parse(  Eval( "MemberOrder" ).ToString( )))%>
                        </td>
                        <td>
                            <%# GetAccounts( Convert.ToInt32( Eval( "SpreaderID" ) ) )%>
                        </td>
                        <td>
                            <%# int.Parse( Eval( "MasterOrder" ).ToString( ) ) == 0 ? "普通玩家" : "<span style='color:#105399;font-weight:bold;'>管理员</span>"%>
                        </td>
                        <td>
                            <%# Eval( "RegisterDate" ).ToString()%>
                        </td>
                        <td>
                            <%# Eval("RegisterIP").ToString()%>
                        </td>
                        <td>
                            <%# Eval( "GameLogonTimes" ).ToString()%>
                        </td>
                        <td>
                            <%# Eval( "LastLogonDate" ).ToString()%>
                        </td>
                        <td>
                             <%# Eval( "LastLogonIP" ).ToString( ) %>
                        </td>
                        <td>
                            <%# GetNullityStatus((byte)Eval("Nullity"))%>
                        </td>
                        <td>
                            <a class="l" href="javascript:void(0)" onclick="javascript:openWindowOwn('GrantGameID.aspx?param=<%#Eval("UserID").ToString() %>','_GrantGameID',600,260);">
                                赠送靓号</a>
                        </td>
                    </tr>
                </AlternatingItemTemplate>
            </asp:Repeater>
            <asp:Literal runat="server" ID="litNoData" Visible="false" Text="<tr class='tdbg'><td colspan='100' align='center'><br>没有任何信息!<br><br></td></tr>"></asp:Literal>
        </table>
    </div>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td class="listTitleBg">
                <span>选择：</span>&nbsp;<a class="l1" href="javascript:SelectAll(true);">全部</a>&nbsp;-&nbsp;<a class="l1" href="javascript:SelectAll(false);">无</a>
            </td>
            <td align="right" class="page">
                <gsp:AspNetPager ID="anpPage" OnPageChanged="anpPage_PageChanged" runat="server" AlwaysShow="true" FirstPageText="首页" LastPageText="末页"
                    PageSize="20" NextPageText="下页" PrevPageText="上页" ShowBoxThreshold="0" ShowCustomInfoSection="Left" LayoutType="Table"
                    NumericButtonCount="5" CustomInfoHTML="总记录：%RecordCount%　页码：%CurrentPageIndex%/%PageCount%　每页：%PageSize%" UrlPaging="false">
                </gsp:AspNetPager>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" id="OpList">
        <tr>
            <td height="39" class="titleOpBg">
                <input type="button" value="新增" class="btn wd1" onclick="openWindowOwn('AddAccount.aspx','',850,600)" />
                <asp:Button ID="btnDelete1" runat="server" Text="删除" CssClass="btn wd1" OnClick="btnDelete_Click" OnClientClick="return deleteop()"
                    Visible="false" />
                <input class="btnLine" type="button" />
                <asp:Button ID="btnDongjie1" runat="server" Text="冻结" CssClass="btn wd1" OnClick="btnDongjie_Click" OnClientClick="return deleteop()" />
                <asp:Button ID="btnJiedong1" runat="server" Text="解冻" CssClass="btn wd1" OnClick="btnJiedong_Click" OnClientClick="return deleteop()" />
                <asp:Button ID="btnSetting1" runat="server" Text="设置机器人" CssClass="btn wd2" OnClick="btnSetting_Click" OnClientClick="return deleteop()" />
                <asp:Button ID="btnCancle1" runat="server" Text="取消机器人" CssClass="btn wd2" OnClick="btnCancle_Click" OnClientClick="return deleteop()" />
                <input class="btnLine" type="button" />
                <input type="button" value="赠送会员" class="btn wd2" onclick="GrantManager('GrantMember')" />
                <input id="btnGrantTreasure2" type="button" value="赠送游戏币" class="btn wd2" onclick="GrantManager('GrantTreasure')" />
                <input id="btnGrantExperience2" type="button" value="赠送经验" class="btn wd2" onclick="GrantManager('GrantExperience')" />
                <input type="button" value="赠送积分" class="btn wd2" onclick="GrantManager('GrantScore')" />
                <input type="button" value="清零积分" class="btn wd2" onclick="GrantManager('GrantClearScore')" />
                <input type="button" value="清零逃率" class="btn wd2" onclick="GrantManager('GrantFlee')" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

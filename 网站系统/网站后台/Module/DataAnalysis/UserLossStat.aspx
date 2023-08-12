<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserLossStat.aspx.cs" Inherits="Game.Web.Module.DataAnalysis.UserLossStat" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="/styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/scripts/common.js"></script>
    <script type="text/javascript" src="/scripts/comm.js"></script>
    <script type="text/javascript" src="/scripts/My97DatePicker/WdatePicker.js"></script>
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
                    你当前位置：数据分析 - 流失玩家
                </td>
            </tr>
        </table>
        <div style="height:30px; width:97%; margin-top:10px;">
            <div style="margin-left:10px;font-size:14px; font-weight:bold; float:left;">用户流失统计图</div>
            <div class="xuxian"></div>
        </div>
        <div style="margin-left:80px; clear:both;">
        <div>&nbsp;&nbsp;<asp:RadioButtonList ID="rblUserType" runat="server" RepeatDirection="Horizontal"
                    AutoPostBack="true" OnSelectedIndexChanged="rblUserType_SelectedIndexChanged" RepeatLayout="Flow">
                    <asp:ListItem Text="所有玩家" Value="0" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="充值玩家" Value="1"></asp:ListItem>
                </asp:RadioButtonList>&nbsp;&nbsp;&nbsp;
            日期时间：<asp:TextBox ID="txtStartDate" runat="server" CssClass="text wd2" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'txtEndDate\')}'})"></asp:TextBox><img
                            src="/Images/btn_calendar.gif" onclick="WdatePicker({el:'txtStartDate',dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'txtEndDate\')}'})"
                            style="cursor: pointer; vertical-align: middle" />&nbsp;&nbsp;
                    至&nbsp;&nbsp;<asp:TextBox ID="txtEndDate" runat="server" CssClass="text wd2" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'txtStartDate\')}',maxDate:'%y-%M-#{%d-1}'})"></asp:TextBox><img
                        src="/Images/btn_calendar.gif" onclick="WdatePicker({el:'txtEndDate',dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'txtStartDate\')}',maxDate:'%y-%M-#{%d-1}'})"
                        style="cursor: pointer; vertical-align: middle" />&nbsp;&nbsp;
                    <asp:DropDownList ID="ddlType" runat="server" Width="80">
                        <asp:ListItem Value="0" Text="曲线图"></asp:ListItem>
                        <asp:ListItem Value="1" Text="柱状图"></asp:ListItem>
                    </asp:DropDownList>&nbsp;&nbsp;
                    <asp:Button ID="btnQuery" runat="server" Text="查询" CssClass="btn wd1" OnClick="btnQuery_Click" />&nbsp;
                    <asp:Button ID="Button4" runat="server" Text="最近30天" CssClass="btn wd2" OnClick="Button4_Click" />&nbsp;
                    <input type="button" onclick="Redirect('UserLossStat.aspx');" class="btn wd1" value="刷新" />
        </div>
    </div>
        <div style="width:100%; float:left; height:280px; margin-top:5px;">
        <asp:Chart ID="Chart1" runat="server" Width="950" Height="300" BorderColor="26, 59, 105"
            Palette="BrightPastel" BorderDashStyle="Solid" BackGradientStyle="TopBottom"
            BackSecondaryColor="White" BorderWidth="2">
            <Series>
                <asp:Series>
                </asp:Series>
            </Series>
            <Titles>
                <asp:Title Text="【日流失玩家数—连续30天内未登陆的用户为流失玩家】" Font="Microsoft Sans Serif, 10pt">
                </asp:Title>
            </Titles>
            <ChartAreas>
                <asp:ChartArea Name="ChartArea1" BorderColor="64, 64, 64, 64" BorderDashStyle="Solid"
                    BackSecondaryColor="White" BackColor="#FFFFFF" ShadowColor="Transparent">
                    <AxisY LineColor="64, 64, 64, 64" IsLabelAutoFit="False" Title="人数" TitleAlignment="Far">
                        <LabelStyle Font="Trebuchet MS, 8.25pt, style=Bold" />
                        <MajorGrid Interval="Auto" LineColor="64, 64, 64, 64" />
                        <MajorTickMark Interval="1" Enabled="False" />
                    </AxisY>
                    <AxisX LineColor="64, 64, 64, 64" IsLabelAutoFit="False" IsMarginVisible="true" Interval="1" Title="日期" TitleAlignment="Far">
                        <LabelStyle Font="Trebuchet MS, 8.25pt, style=Bold" Interval="0" />
                        <MajorGrid Interval="1" LineColor="64, 64, 64, 64" />
                        <MajorTickMark Interval="1" Enabled="False" />
                    </AxisX>
                </asp:ChartArea>
            </ChartAreas>
        </asp:Chart>
      </div>
        <div style="width:100%; float:left;margin-top:10px;">
        <asp:Chart ID="Chart2" runat="server" Width="950" Height="250" BorderColor="26, 59, 105"
            Palette="BrightPastel" BorderDashStyle="Solid" BackGradientStyle="TopBottom"
            BackSecondaryColor="White" BorderWidth="2">
            <Series>
                <asp:Series Name="Series1">
                </asp:Series>
            </Series>
            <Titles>
                <asp:Title Text="【月平均每天流失玩家总数】" Font="Microsoft Sans Serif, 10pt">
                </asp:Title>
            </Titles>
            <ChartAreas>
                <asp:ChartArea Name="ChartArea1" BorderColor="64, 64, 64, 64" BorderDashStyle="Solid"
                    BackSecondaryColor="White" BackColor="#FFFFFF" ShadowColor="Transparent">
                    <AxisY LineColor="64, 64, 64, 64" IsLabelAutoFit="False" Title="人数" TitleAlignment="Far">
                        <LabelStyle Font="Trebuchet MS, 8.25pt, style=Bold" />
                        <MajorGrid Interval="Auto" LineColor="64, 64, 64, 64" />
                        <MajorTickMark Interval="1" Enabled="False" />
                    </AxisY>
                    <AxisX LineColor="64, 64, 64, 64" IsLabelAutoFit="False" IsMarginVisible="true" Interval="1" Title="月" TitleAlignment="Far">
                        <LabelStyle Font="Trebuchet MS, 8.25pt, style=Bold" Interval="0" />
                        <MajorGrid Interval="1" LineColor="64, 64, 64, 64" />
                        <MajorTickMark Interval="1" Enabled="False" />
                    </AxisX>
                </asp:ChartArea>
            </ChartAreas>
        </asp:Chart>
      </div>
       <div style="width:29%; float:left; overflow-y:scroll; display:none;">
            <table width="80%" border="0" align="center" cellpadding="0" cellspacing="0"  style="line-height:23px; margin:0 auto;">
                <asp:Repeater ID="rptData" runat="server" Visible="false">
                    <HeaderTemplate>
                        <tr class="bold">
                            <td align="center" style="width: 25%;">
                                统计时间
                            </td>
                            <td align="center" style="width: 25%;">
                                玩家流失数
                            </td>
                        </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td align="center">
                                <%# Eval( "key" )%>
                            </td>
                            <td align="center">
                                <%# Eval( "value" )%>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </table>
        </div>
        <div style="margin:5px 0 20px 0; clear:both; margin-left:30px;">
            <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2" style="background-color:White;">
                <tr>
                    <td class="listTdLeft">
                        流失用户数：
                    </td>
                    <td>
                        <asp:Literal ID="ltLossUserCounts" runat="server" Text="0"></asp:Literal> 人 <span class="green">连续30天内未登陆的流失用户总数</span>
                    </td>
                </tr>
                <tr>
                    <td class="listTdLeft">
                        用户流失率：
                    </td>
                    <td>
                        <asp:Literal ID="ltLossUserRate" runat="server" Text="0"></asp:Literal> 人 <span class="green">流失用户数/总注册用户</span>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>

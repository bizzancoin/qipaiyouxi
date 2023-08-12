<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserStatCenter.aspx.cs"
    Inherits="Game.Web.Module.DataAnalysis.UserStatCenter" %>

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
                    你当前位置：数据分析 - 汇总统计
                </td>
            </tr>
        </table>
    <div style="height:30px; width:97%; margin-top:10px;">
        <div style="margin-left:10px;font-size:14px; font-weight:bold; float:left;">用户付费欲望图</div>
        <div class="xuxian"></div>
    </div>
     <div style="margin-left:120px; clear:both;">
        日期：<asp:TextBox ID="txtStartDate" runat="server" CssClass="text wd2" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'txtEndDate\')}'})"></asp:TextBox><img
                            src="/Images/btn_calendar.gif" onclick="WdatePicker({el:'txtStartDate',dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'txtEndDate\')}'})"
                            style="cursor: pointer; vertical-align: middle" />&nbsp;
                    至&nbsp;<asp:TextBox ID="txtEndDate" runat="server" CssClass="text wd2" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'txtStartDate\')}',maxDate:'%y-%M-#{%d-1}'})"></asp:TextBox><img
                        src="/Images/btn_calendar.gif" onclick="WdatePicker({el:'txtEndDate',dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'txtStartDate\')}',maxDate:'%y-%M-#{%d-1}'})"
                        style="cursor: pointer; vertical-align: middle" />&nbsp;
                    <asp:DropDownList ID="ddlType" runat="server" Width="80">
                        <asp:ListItem Value="0" Text="曲线图"></asp:ListItem>
                        <asp:ListItem Value="1" Text="柱状图"></asp:ListItem>
                    </asp:DropDownList>&nbsp;
                    <asp:Button ID="btnQuery" runat="server" Text="查询" CssClass="btn wd1" OnClick="btnQuery_Click" />&nbsp;&nbsp;
                    <asp:Button ID="Button4" runat="server" Text="最近30天" CssClass="btn wd2" OnClick="Button4_Click" />
     </div>
     <div style="width:100%; float:left; height:280px; margin-top:5px;">
         <asp:Chart ID="Chart1" runat="server" Width="950" Height="300" BorderColor="26, 59, 105"
            Palette="BrightPastel" BorderDashStyle="Solid" BackGradientStyle="TopBottom"
            BackSecondaryColor="White" BorderWidth="2">
            <Series>
                <asp:Series>
                </asp:Series>
            </Series>
            <ChartAreas>
                <asp:ChartArea Name="ChartArea1" BorderColor="64, 64, 64, 64" BorderDashStyle="Solid"
                    BackSecondaryColor="White" BackColor="#FFFFFF" ShadowColor="Transparent">
                    <AxisY LineColor="64, 64, 64, 64" IsLabelAutoFit="False" Title="付费欲望" TitleAlignment="Far">
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
    <div class="clear"></div>
    <div style="height:30px; width:97%; margin-top:10px; float:left; ">
        <div style="margin-left:10px;font-size:14px; font-weight:bold; float:left;">用户汇总数据</div>
        <div class="xuxian"></div>
    </div>
    <div style="height:200px; margin-top:5px; clear:both; margin-left:30px;">
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2" style="background-color:White;">
            <tr>
                <td class="listTdLeft">
                    用户付费欲望：
                </td>
                <td>
                    <asp:Literal ID="ltPayDesire" runat="server" Text="0"></asp:Literal>
                </td>
                <td class="listTdLeft">
                    充值用户人数：
                </td>
                <td>
                    <asp:Literal ID="ltPayUserCounts" runat="server"></asp:Literal>
                    人
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">
                    二次充值人数：
                </td>
                <td>
                    <asp:Literal ID="ltPayTwoUserCounts" runat="server"></asp:Literal>
                    人
                </td>
                <td class="listTdLeft">
                    充值用户转化率：
                </td>
                <td>
                    <asp:Literal ID="ltPayRate" runat="server"></asp:Literal>
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">
                    充值用户流失数：
                </td>
                <td>
                    <asp:Literal ID="ltLossPayUserCounts" runat="server"></asp:Literal>
                </td>
                <td class="listTdLeft">
                    充值用户流失率：
                </td>
                <td>
                    <asp:Literal ID="ltLossPayUserRate" runat="server" Text="0"></asp:Literal>
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">
                    充值大户人数：
                </td>
                <td>
                    <asp:Literal ID="ltVIPPayUserTotal" runat="server"></asp:Literal>
                </td>
                  <td class="listTdLeft">注册用户总数：</td>
                <td>
                    <asp:Literal ID="ltUserCounts" runat="server"></asp:Literal> 人
                </td>
            </tr>
             <tr>
                <td class="listTdLeft">当月注册用户总数：</td>
                <td>
                    <asp:Literal ID="ltCurrentMonthRegUserCounts" runat="server"></asp:Literal> 人 
                </td>
                 <td class="listTdLeft">用户增长速率：</td>
                <td>
                    <asp:Literal ID="ltNewRate" runat="server" Text="0"></asp:Literal> <span class="green">当月新增用户数/总用户数</span>  
                </td>
            </tr>
             <tr>
                <td class="listTdLeft">日注册用户数最高值：</td>
                <td>
                    <asp:Literal ID="ltRegMaxCounts" runat="server"></asp:Literal> 人
                </td>
                  <td class="listTdLeft">活跃用户数：</td>
                <td>
                    <asp:Literal ID="ltActiveUserCounts" runat="server"></asp:Literal> 人
                </td>
            </tr>
            <!--
            <tr>
                <td class="listTdLeft">最高在线人数：</td>
                <td>
                    <asp:Literal ID="ltMaxOnlineUserCounts" runat="server"></asp:Literal> 人
                </td>
                 <td class="listTdLeft">平均在线人数：</td>
                <td>
                    <asp:Literal ID="ltAVGOnlineUserCounts" runat="server"></asp:Literal> 人 
                </td>
            </tr>
            -->
             <tr>
                <td class="listTdLeft">用户平均在线时长：</td>
                <td>
                    <asp:Literal ID="ltAVGOnlineTime" runat="server"></asp:Literal> 秒
                </td>
                  <td class="listTdLeft">活跃用户转化率：</td>
                <td>
                    <asp:Literal ID="ltActiveUserRate" runat="server" Text="0"></asp:Literal> <span class="green">活跃用户数/总注册人数</span>
                </td>
            </tr>
             <tr>
                <td class="listTdLeft">流失用户数：</td>
                <td>
                    <asp:Literal ID="ltLossUserCounts" runat="server"></asp:Literal> 
                </td>
                 <td class="listTdLeft">用户流失率：</td>
                <td>
                    <asp:Literal ID="ltLossUserRate" runat="server" Text="0"></asp:Literal> <span class="green">流失用户数/总注册用户</span>
                </td>
            </tr>
             <tr>
                <td class="listTdLeft">最高充值金额：</td>
                <td>
                    <asp:Literal ID="ltPayUserOutflowTotal" runat="server"></asp:Literal> 元
                </td>
                <td class="listTdLeft">今日最高充值金额：</td>
                <td>
                    <asp:Literal ID="ltPayUserOutflowRate" runat="server"></asp:Literal> 元
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">注册用户人均APRU值：</td>
                <td>
                    <asp:Literal ID="ltAPRUUser" runat="server" Text="0"></asp:Literal> 元
                </td>
                <td class="listTdLeft">充值用户人均APRU值：</td>
                <td>
                    <asp:Literal ID="ltAPRUPayUser" runat="server" Text="0"></asp:Literal> 元
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>

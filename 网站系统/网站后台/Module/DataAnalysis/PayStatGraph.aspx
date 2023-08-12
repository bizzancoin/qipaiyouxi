<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PayStatGraph.aspx.cs" Inherits="Game.Web.Module.DataAnalysis.PayStatGraph" %>

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
                你当前位置：数据分析 - 充值统计
            </td>
        </tr>
    </table>
    <div style="height:30px; width:97%; margin-top:10px;">
        <div style="margin-left:10px;font-size:14px; font-weight:bold; float:left;">充值统计图</div>
        <div class="xuxian"></div>
    </div>
    <div style="margin-left:80px; clear:both;">
      日期时间：<asp:TextBox ID="txtStartDate" runat="server" CssClass="text wd2" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'txtEndDate\')}'})"></asp:TextBox><img
                        src="/Images/btn_calendar.gif" onclick="WdatePicker({el:'txtStartDate',dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'txtEndDate\')}'})"
                        style="cursor: pointer; vertical-align: middle" />&nbsp;&nbsp;
                至&nbsp;&nbsp;<asp:TextBox ID="txtEndDate" runat="server" CssClass="text wd2" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'txtStartDate\')}',maxDate:'%y-%M-#{%d-1}'})"></asp:TextBox><img
                    src="/Images/btn_calendar.gif" onclick="WdatePicker({el:'txtEndDate',dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'txtStartDate\')}',maxDate:'%y-%M-#{%d}'})"
                    style="cursor: pointer; vertical-align: middle" />&nbsp;&nbsp;
                <asp:DropDownList ID="ddlType" runat="server" Width="80">
                    <asp:ListItem Value="0" Text="曲线图"></asp:ListItem>
                    <asp:ListItem Value="1" Text="柱状图"></asp:ListItem>
                </asp:DropDownList>&nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnQuery" runat="server" Text="查询" CssClass="btn wd1" OnClick="btnQuery_Click" />&nbsp;
                <asp:Button ID="Button4" runat="server" Text="最近30天" CssClass="btn wd2" OnClick="btnMonth_Click" />&nbsp;
                <input type="button" onclick="Redirect('PayStatGraph.aspx');" class="btn wd1" value="刷新" />
    </div>
    <div style="width:100%; float:left; height:280px; margin-top:5px;">
        <table width="100%" cellpadding="0" cellspacing="0" border="0">
            <tr>
                <td style="width: 100%; text-align: left; vertical-align: top;">
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
                                <AxisY LineColor="64, 64, 64, 64" IsLabelAutoFit="False" Title="充值金额" TitleAlignment="Far"
                                    ArrowStyle="none">
                                    <LabelStyle Font="Trebuchet MS, 8.25pt, style=Bold" />
                                    <MajorGrid Interval="Auto" LineColor="64, 64, 64, 64" />
                                    <MajorTickMark Interval="1" Enabled="False" />
                                </AxisY>
                                <AxisX LineColor="64, 64, 64, 64" IsLabelAutoFit="False" IsMarginVisible="true" Interval="1"
                                    Title="日期" TitleAlignment="Far" ArrowStyle="none">
                                    <LabelStyle Font="Trebuchet MS, 8.25pt, style=Bold" Interval="0" />
                                    <MajorGrid Interval="1" LineColor="64, 64, 64, 64" />
                                    <MajorTickMark Interval="1" Enabled="False" />
                                </AxisX>
                            </asp:ChartArea>
                        </ChartAreas>
                    </asp:Chart>
                </td>
            </tr>
        </table>
    </div>
    <div class="clear"></div>
    <div style="height:30px; width:97%; margin-top:10px; float:left; ">
        <div style="margin-left:10px;font-size:14px; font-weight:bold; float:left;">分析数据</div>
        <div class="xuxian"></div>
    </div>
    <div style="height:200px; margin-top:5px; clear:both; margin-left:30px;">
         <table width="70%" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td class="listTdLeft">
                    充值总人数：
                </td>
                <td style="width:20%;">
                    <asp:Literal ID="ltPayUserCounts" runat="server"></asp:Literal>
                    人
                </td>
                <td class="listTdLeft">
                    二次充值人数：
                </td>
                <td>
                    <asp:Literal ID="ltPayTwoUserCounts" runat="server"></asp:Literal>
                    人
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">
                    一次性最高充值金额：
                </td>
                <td>
                    <asp:Literal ID="ltPayMaxAmount" runat="server"></asp:Literal>
                    元
                </td>
                <td class="listTdLeft">
                    累计充值总金额：
                </td>
                <td>
                    <asp:Literal ID="ltPayTotalAmount" runat="server"></asp:Literal>
                    元
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">
                    使用最多的充值渠道：
                </td>
                <td>
                    <asp:Literal ID="ltMaxShareName" runat="server"></asp:Literal>
                </td>
                  <td class="listTdLeft">
                    今日充值最高金额：
                </td>
                <td>
                    <asp:Literal ID="ltCurrentDateMaxAmount" runat="server"></asp:Literal>
                    元
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">
                    充值最高金额日期：
                </td>
                <td>
                    <asp:Literal ID="ltPayMaxDate" runat="server"></asp:Literal>
                </td>
                 <td class="listTdLeft">
                    注册用户人均APRU值：
                </td>
                <td>
                    <asp:Literal ID="ltAPRUReg" runat="server"></asp:Literal>
                    元
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">
                    充值用户人均APRU值：
                </td>
                <td>
                    <asp:Literal ID="ltAPRUPay" runat="server"></asp:Literal>
                    元
                </td>
                  <td class="listTdLeft">
                    充值用户转换率：
                </td>
                <td>
                    <asp:Literal ID="ltPayUserRate" runat="server"></asp:Literal>
                </td>
            </tr>
            <tr>
                <td class="listTdLeft">
                    充值用户流失率：
                </td>
                <td>
                    <asp:Literal ID="ltPayUserOutflowRate" runat="server"></asp:Literal>
                </td>
                  <td class="listTdLeft">
                    充值大户可能转化人数：
                </td>
                <td>
                    <asp:Literal ID="ltVIPPayUserRate" runat="server"></asp:Literal>
                    人
                </td>
            </tr>
             <tr>
                <td class="listTdLeft">
                    充值用户流失数：
                </td>
                <td colspan="3">
                    <asp:Literal ID="ltPayUserOutflowTotal" runat="server"></asp:Literal>
                    人
                </td>
                <!--
                <td class="listTdLeft">
                    充值用户转换潜力：
                </td>
                <td>
                    <asp:Literal ID="ltPayUserRateWill" runat="server"></asp:Literal>
                </td>
                -->
            </tr>
        </table>
    </div>
    </form>
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StatOnlineGame.aspx.cs" Inherits="Game.Web.Module.AppManager.StatOnlineGame" %>

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
            <td width="1232" height="25" valign="top" align="left">你当前位置：系统维护 - 在线统计</td>
        </tr>
    </table>
    <!-- 头部菜单 End -->
    <div style="margin: 10px">
        &nbsp;&nbsp;&nbsp;&nbsp;<asp:Label ID="lblInfo" runat="server"></asp:Label>
        <br />
        <br />
        <asp:Chart ID="Chart1" runat="server" Width="750" Height="420" BackColor="#D3DFF0"
            BorderColor="26, 59, 105" Palette="BrightPastel" BorderDashStyle="Solid" BackGradientStyle="TopBottom"
            BackSecondaryColor="White" BorderWidth="2">
            <Legends>
                <asp:Legend Name="Default" BackColor="Transparent" IsTextAutoFit="False">
                </asp:Legend>
            </Legends>
            <BorderSkin SkinStyle="Emboss"></BorderSkin>
            <ChartAreas>
                <asp:ChartArea Name="ChartArea1" BorderColor="64, 64, 64, 64" BorderDashStyle="Solid"
                    BackSecondaryColor="White" BackColor="Transparent" ShadowColor="Transparent">                    
                    <AxisY LineColor="64, 64, 64, 64" IsLabelAutoFit="False">
                        <LabelStyle Font="Trebuchet MS, 8.25pt, style=Bold" />
                        <MajorGrid Interval="Auto" LineColor="64, 64, 64, 64" />
                        <MajorTickMark Interval="1" Enabled="False" />
                    </AxisY>
                    <AxisX LineColor="64, 64, 64, 64" IsLabelAutoFit="False" IsMarginVisible="true" Interval="1" Enabled="False">
                        <LabelStyle Font="Trebuchet MS, 8.25pt, style=Bold" Interval="0" />
                        <MajorGrid Interval="1" LineColor="64, 64, 64, 64" />
                        <MajorTickMark Interval="1" Enabled="False" />
                    </AxisX>
                </asp:ChartArea>
            </ChartAreas>
        </asp:Chart>
    </div>
    </form>
</body>
</html>

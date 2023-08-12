<%@ Page Language="C#" AutoEventWireup="true" ValidateRequest="false" CodeBehind="MallInfo.aspx.cs" Inherits="Game.Web.Module.MallManager.MallInfo" %>

<%@ Register Src="/Tools/ImageUploader.ascx" TagName="ImageUploader" TagPrefix="GameImg" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="/styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/scripts/common.js"></script>
    <script type="text/javascript" src="/scripts/comm.js"></script>
    <script type="text/javascript" src="/scripts/jquery.js"></script>
    <script type="text/javascript" src="/scripts/CJL.0.1.min.js"></script>
    <script type="text/javascript" src="/scripts/QuickUpload.js"></script>
    <script type="text/javascript" src="/scripts/ImagePreview.js"></script>
    <script type="text/javascript" src="/scripts/kindEditor/kindeditor.js"></script>
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
                        你当前位置：商城系统 - 商品管理
                    </td>
                </tr>
            </table>
           <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                    <td class="titleOpBg Lpd10">
                        <input id="btnReturn" type="button" value="返回" class="btn wd1" onclick="Redirect('MallInfoList.aspx')" />
                        <asp:Button ID="btnCreate" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
                    </td>
                </tr>
            </table>
           <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
                <tr>
                    <td height="35" colspan="2" class="f14 bold Lpd10 Rpd10">
                        <div class="hg3  pd7">
                            商品信息</div>
                    </td>
                </tr>
                <tr>
                    <td class="listTdLeft">商品类型：</td>
                    <td>
                        <asp:DropDownList ID="ddlTypeID" runat="server" Width="158px">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td class="listTdLeft">商品名称：</td>
                    <td>
                        <asp:TextBox ID="txtAwardName" runat="server" CssClass="text wd7"></asp:TextBox>
                        &nbsp;<span class="hong">*</span>
                        <asp:RequiredFieldValidator ID="rf4" runat="server" ForeColor="Red" Display="Dynamic" ControlToValidate="txtAwardName" ErrorMessage="商品名称不能为空"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td class="listTdLeft">商品价格：</td>
                    <td><asp:TextBox ID="txtPrice" runat="server" CssClass="text wd7"></asp:TextBox>
                        &nbsp;<span class="hong">*</span> 元宝
                        <asp:RequiredFieldValidator ID="rf" runat="server" ForeColor="Red" Display="Dynamic" ControlToValidate="txtPrice" ErrorMessage="商品价格不能为空"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="re" runat="server" ForeColor="Red" Display="Dynamic" ControlToValidate="txtPrice" ValidationExpression="^[0-9]\d*$" ErrorMessage="商品价格必须为正整数"></asp:RegularExpressionValidator>
                    </td>
                </tr>
                <tr>
                    <td class="listTdLeft">库存数量：</td>
                    <td><asp:TextBox ID="txtInventory" runat="server" CssClass="text wd7" Text="0"></asp:TextBox>
                    &nbsp;<span class="hong">*</span>
                        <asp:RequiredFieldValidator ID="rf2" runat="server" ForeColor="Red" Display="Dynamic" ControlToValidate="txtInventory" ErrorMessage="库存数量不能为空"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="re3" runat="server" ForeColor="Red" Display="Dynamic" ControlToValidate="txtInventory" ValidationExpression="^[0-9]\d*$" ErrorMessage="库存数量必须为正整数"></asp:RegularExpressionValidator>
                    </td>
                </tr>
                <tr>
                    <td class="listTdLeft">排列序号：</td>
                    <td><asp:TextBox ID="txtSortID" runat="server" CssClass="text wd7" Text="0"></asp:TextBox>
                    &nbsp;<span class="hong">*</span>
                        <asp:RequiredFieldValidator ID="rf3" runat="server" ForeColor="Red" Display="Dynamic" ControlToValidate="txtSortID" ErrorMessage="排序字段不能为空"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="re2" runat="server" ForeColor="Red" Display="Dynamic" ControlToValidate="txtSortID" ValidationExpression="^[0-9]\d*$" ErrorMessage="排序字段必须为正整数"></asp:RegularExpressionValidator>
                    </td>
                </tr>
                <tr>
                    <td class="listTdLeft">下单信息：</td>
                    <td>
                        <asp:CheckBoxList ID="cbNeedInfo" runat="server" RepeatDirection="Horizontal" 
                            RepeatLayout="Flow">
                        </asp:CheckBoxList>
                    </td>
                </tr>
                <tr>
                    <td class="listTdLeft">允许退货：</td>
                    <td>
                        <asp:RadioButtonList ID="rbIsReturn" runat="server" 
                            RepeatDirection="Horizontal" RepeatLayout="Flow">
                            <asp:ListItem Text="不允许" Value="0"></asp:ListItem>
                            <asp:ListItem Text="允许" Value="1" Selected="True"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
                <tr>
                    <td class="listTdLeft">商品状态：</td>
                    <td>
                        <asp:RadioButtonList ID="rbNullity" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow">
                            <asp:ListItem Text="上架" Value="0" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="下架" Value="1"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
                <tr>
                    <td class="listTdLeft">商品小图[190*114]：</td>
                    <td style="line-height:35px;">
                        <GameImg:ImageUploader ID="upSmallImage" runat="server" DeleteButtonClass="l2" DeleteButtonText="删除" Folder="/Upload/Match" ViewButtonClass="l2" ViewButtonText="查看" TextBoxClass="text"/> <span>[体积：不大于1M]</span>
                    </td>
                </tr>
                <tr>
                    <td class="listTdLeft">商品大图[310*310]：</td>
                    <td style="line-height:35px;">
                        <GameImg:ImageUploader ID="upBigImage" runat="server" DeleteButtonClass="l2" DeleteButtonText="删除" Folder="/Upload/Match" ViewButtonClass="l2" ViewButtonText="查看" TextBoxClass="text"/> <span>[体积：不大于1M]</span>
                    </td>
                </tr>
                <tr>
                    <td class="listTdLeft">商品描述：</td>
                    <td>
                        <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Height="350px"></asp:TextBox>
                    </td>
                </tr>
            </table>
            <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                    <td class="titleOpBg Lpd10">
                        <input id="btnReturn2" type="button" value="返回" class="btn wd1" onclick="Redirect('MallInfoList.aspx')" />
                        <asp:Button ID="btnSave2" runat="server" Text="保存" CssClass="btn wd1" OnClick="btnSave_Click" />
                    </td>
                </tr>
            </table>
    </form>
    <script type="text/javascript">
        KE.show({
            id: 'txtDescription',
            imageUploadJson: '/Tools/KindEditorUpload.ashx?type=shop',
            fileManagerJson: '/Tools/KindEditorFileManager.ashx?type=shop',
            allowFileManager: true
        });
    </script>
</body>
</html>

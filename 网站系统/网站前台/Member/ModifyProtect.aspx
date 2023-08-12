<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ModifyProtect.aspx.cs" Inherits="Game.Web.Member.ModifyProtect" %>
<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>
<%@ Register TagPrefix="qp" TagName="UserSidebar" Src="~/Themes/Standard/User_Sidebar.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <link href="/css/member/member-applyprotect.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/js/jquery.min.js"></script>
    <script src="/js/formvalidator/formValidator.js" type="text/javascript"></script>
    <script src="/js/formvalidator/formValidatorRegex.js" type="text/javascript"></script>
    
    <script type="text/javascript">
        $(document).ready(function(){
            //页面验证
            $.formValidator.initConfig({ formID: "fmStep1" });
            $("#txtResponse1").formValidator({ required: true, onFocus: "答案为4~40个字符，中文算两个字符" }).inputValidator({ min: 4, max: 40, onError: "你输入的答案格式有误" });
            $("#txtResponse2").formValidator({ required: true, onFocus: "答案为4~40个字符，中文算两个字符" }).inputValidator({ min: 4, max: 40, onError: "你输入的答案格式有误" });
            $("#txtResponse3").formValidator({ required: true, onFocus: "答案为4~40个字符，中文算两个字符" }).inputValidator({ min: 4, max: 40, onError: "你输入的答案格式有误" });
            //修改
            $.formValidator.initConfig({ formID: "fmStep2" });
            $("#ddlQuestion1").formValidator({required:true,onEmpty:"请选择问题",onFocus:"请选择问题"}).inputValidator({min:1,onError: "你是不是忘记选择问题了"})
                .functionValidator({
                    fun:function(val,elem) {
                        if(val != $("#ddlQuestion2").val() && val !=$("#ddlQuestion3").val()) {
                            return true;
                        } else {
                            return "不能选择相同的问题";
                        }
                    }
                });
            $("#txtMResponse1").formValidator({ required: true, onFocus: "答案为4~40个字符，中文算两个字符" }).inputValidator({ min: 4, max: 40, onError: "你输入的答案格式有误" });
            $("#ddlQuestion2").formValidator({required:true,onEmpty:"请选择问题",onFocus:"请选择问题"}).inputValidator({min:1,onError: "你是不是忘记选择问题了"})
                .functionValidator({
                    fun:function(val,elem) {
                        if(val != $("#ddlQuestion1").val() && val !=$("#ddlQuestion3").val()) {
                            return true;
                        } else {
                            return "不能选择相同的问题";
                        }
                    }
                });
            $("#txtMResponse2").formValidator({ required: true, onFocus: "答案为4~40个字符，中文算两个字符" }).inputValidator({ min: 4, max: 40, onError: "你输入的答案格式有误" });
            $("#ddlQuestion3").formValidator({required:true,onEmpty:"请选择问题",onFocus:"请选择问题"}).inputValidator({min:1,onError: "你是不是忘记选择问题了"})
                .functionValidator({
                    fun:function(val,elem) {
                        if(val != $("#ddlQuestion1").val()&&val !=$("#ddlQuestion2").val()) {
                            return true;
                        } else {
                            return "不能选择相同的问题";
                        }
                    }
                });
            $("#txtMResponse3").formValidator({ required: true, onFocus: "答案为4~40个字符，中文算两个字符" }).inputValidator({ min: 4, max: 40, onError: "你输入的答案格式有误" });
        });
    </script>
</head>
<body>
    <!--头部开始-->
    <qp:Header ID="sHeader" runat="server" PageID="4"/>
    <!--头部结束-->
    <div class="ui-banner">
      <div class="ui-banner-bg-1"></div>
      <div class="ui-banner-bg-2"></div>
      <div class="ui-carousel-right">
        <div class="ui-carousel-left">
          <div class="ui-banner-img">
            <a href="javascript:;"><img src="/images/banner_2.png" /></a>
          </div>
        </div>
      </div>
    </div>

    <div class="ui-content">
      <div class="ui-main">
        <div class="ui-page-title fn-clear">
          <a href="/index.aspx"><i class="ui-page-title-home"></i>首页</a>
          <i class="ui-page-title-current"></i>
          <a href="index.aspx">个人中心</a>
          <i class="ui-page-title-current"></i>
          <span>修改密码保护</span>
          <div class="ui-page-title-right"><span>MEMBER&nbsp;CENTER</span><strong>个人中心</strong></div>
        </div>
        <div class="fn-clear">
          <!--左边开始-->
          <qp:UserSidebar ID="sUserSidebar" runat="server" MemberID="8" />
          <!--左边结束-->
          <div class="ui-main-details fn-right">      
            <h2 class="ui-title-solid">修改密码保护</h2>      
            <form class="ui-member-applyprotect" runat="server" id="fmStep1">
              <ul class="">
                <li style="font-weight:bold;">
                    第一步：请回答下面问题：
                </li>
                <li class="ui-li-bg">
                  <label>问题：</label>
                  <asp:Label ID="lblQuestion1" runat="server"></asp:Label>
                </li>
                <li>
                  <label>答案：</label>
                  <asp:TextBox ID="txtResponse1" runat="server" Width="162" CssClass="ui-text-1"></asp:TextBox>
                </li>
                <li class="ui-li-bg">
                  <label>问题：</label>
                  <asp:Label ID="lblQuestion2" runat="server"></asp:Label>
                </li>
                <li>
                  <label>答案：</label>
                  <asp:TextBox ID="txtResponse2" runat="server" CssClass="ui-text-1" Width="162"></asp:TextBox>
                </li>
                <li class="ui-li-bg">
                  <label>问题：</label>
                  <asp:Label ID="lblQuestion3" runat="server"></asp:Label>
                </li>
                <li>
                  <label>答案：</label>
                  <asp:TextBox ID="txtResponse3" runat="server" CssClass="ui-text-1" Width="162"></asp:TextBox>
                </li>
                <li class="ui-submit-list">
                  <asp:Button ID="btnConfirm" Text="确 定" runat="server" CssClass="ui-btn-1" onclick="btnConfirm_Click" />
                  <input name="button243" type="reset" class="ui-btn-1" value="重置" hidefocus="true"/>
                </li>
              </ul>
            </form>

            <form class="ui-member-applyprotect" id="fmStep2" runat="server">
              <ul class="">
                <li style="font-weight:bold;">
                    第二步：请填写新的帐号保护信息
                </li>
                <li class="ui-li-bg">
                  <label>问题一：</label>
                  <asp:DropDownList ID="ddlQuestion1" runat="server" Width="170" CssClass="ui-select-1">                            
                  </asp:DropDownList>
                </li>
                <li>
                  <label>答案：</label>
                  <asp:TextBox ID="txtMResponse1" runat="server" Width="162" CssClass="ui-text-1"></asp:TextBox>
                </li>
                <li class="ui-li-bg">
                  <label>问题二：</label>
                  <asp:DropDownList ID="ddlQuestion2" runat="server" Width="170" CssClass="ui-select-1">
                            
                  </asp:DropDownList>
                </li>
                <li>
                  <label>答案：</label>
                  <asp:TextBox ID="txtMResponse2" runat="server" CssClass="ui-text-1" Width="162"></asp:TextBox>
                </li>
                <li class="ui-li-bg">
                  <label>问题三：</label>
                  <asp:DropDownList ID="ddlQuestion3" runat="server" Width="170" CssClass="ui-select-1">                            
                  </asp:DropDownList>
                </li>
                <li>
                  <label>答案：</label>
                  <asp:TextBox ID="txtMResponse3" runat="server" CssClass="ui-text-1" Width="162"></asp:TextBox>
                </li>
                <li class="ui-submit-list">
                  <asp:Button ID="btnUpdate" Text="确 定" runat="server" CssClass="ui-btn-1" onclick="btnUpdate_Click" />
                  <input name="button243" type="reset" class="ui-btn-1" value="重置" hidefocus="true"/>
                </li>
              </ul>
            </form>

            <form id="fmStep3" runat="server">                
        	     <div class="ui-result" style="padding-top:30px;">
                    <p>
                        <asp:Label ID="lblAlertIcon" runat="server"></asp:Label>
                        <asp:Label ID="lblAlertInfo" runat="server" Text="操作提示"></asp:Label>
                    </p>
                </div>
            </form>
          </div>
        </div>
      </div>
    </div>

    <!--尾部开始-->
    <qp:Footer ID="sFooter" runat="server" />
    <!--尾部结束-->
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InsureTransfer.aspx.cs" Inherits="Game.Web.Member.InsureTransfer" %>
<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>
<%@ Register TagPrefix="qp" TagName="UserSidebar" Src="~/Themes/Standard/User_Sidebar.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <link href="/css/member/member-transfer.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/js/jquery.min.js"></script>
    <script src="/js/formvalidator/formValidator.js" type="text/javascript"></script>
    <script src="/js/formvalidator/formValidatorRegex.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function() {
            var minScore = +$("#minScore").val();
            var maxScore = +$("#lblInsureScore").text();
            if($("input[name='radType']:checked").val()=="0"){
                $("#lblTitle").text("转入昵称：");
            }else{
                $("#lblTitle").text("转入ＩＤ：");
            }
            
            $("#radType1").bind("click",function(){$("#lblTitle").text("转入昵称：");});
            $("#radType2").bind("click",function(){$("#lblTitle").text("转入ＩＤ：");});
            
            //页面验证
            $.formValidator.initConfig({formID:"form1"});
            $("#txtUser").formValidator({required: true,onEmpty:"转入昵称不能为空"}).inputValidator({min:6,max:32,trim:{trimLeft:true,trimRight:true,trimError:"两边不能有空符号",rightEmptyError:"两边不能有空符号"},onError:"用户昵称6-32位"});
            $("#txtScore").formValidator({required: true,onEmpty:"转账金额不能为空"}).inputValidator({min:minScore,max:maxScore,type:"number",onErrorMin:"抱歉，您每笔转出数目最少"+minScore+"币",onErrorMax:"抱歉，转出数目不能大于存款"+maxScore,onError:"转账金额必须为数字"}).regexValidator({regExp:"num1",dataType:"enum",onError:"转出的游戏币必须为整数，并且不能大于银行数目！"});
            $("#txtInsurePass").formValidator({required: true, onEmpty:"密码不能为空"});
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
          <span>转账</span>
          <div class="ui-page-title-right"><span>MEMBER&nbsp;CENTER</span><strong>个人中心</strong></div>
        </div>
        <div class="fn-clear">
          <!--左边开始-->
          <qp:UserSidebar ID="sUserSidebar" runat="server" MemberID="15" />
          <!--左边结束-->
          <div class="ui-main-details fn-right">
            <form name="form1" id="form1" runat="server">
              <div class="ui-treasure">
                <h2 class="ui-title-solid">财富信息</h2>
                <p><span>银行存款：&nbsp;</span><asp:Label ID="lblInsureScore" CssClass="ui-color-red" runat="server" Text="0"></asp:Label>&nbsp;游戏币&nbsp;<a href="/Pay/Index.aspx">我要充值</a></p>
                <p><span>现金余额：&nbsp;</span><asp:Label ID="lblScore" runat="server" CssClass="ui-color-red" Text="0"></asp:Label>&nbsp;游戏币</p>
              </div>
              <div class="ui-deposit">
                <h2 class="ui-title-solid">游戏币转账</h2>
                <div class="ui-transfer-way">
                  <input type="radio" id="radType1" name="radType" value="0" checked="true" runat="server" />
                  <label for="radType1" hidefocus="true">按用户昵称</label>
                  <input type="radio" id="radType2" name="radType" value="1" runat="server" />
                  <label for="radType2" hidefocus="true">按ＩＤ号码</label>
                </div>
                <p><span id="lblTitle">转入昵称：</span><asp:TextBox ID="txtUser" runat="server" CssClass="ui-text-1"></asp:TextBox></p>
                <p><span>转账金额：</span><asp:TextBox ID="txtScore" runat="server" CssClass="ui-text-1"></asp:TextBox></p>
                <p><span>银行密码：</span><asp:TextBox ID="txtInsurePass" runat="server" TextMode="Password" CssClass="ui-text-1"></asp:TextBox></p>
                <p><span>备注信息：</span><asp:TextBox ID="txtNote" runat="server" TextMode="MultiLine"></asp:TextBox></p>
                <p><input type="hidden" value="<%= MinTradeScore %>" id="minScore"/><asp:Button ID="btnUpdate" Text="确定转账" runat="server" CssClass="ui-btn-1" OnClick="btnUpdate_Click"/></p>
              </div>
              <div class="ui-deposit-tips">
                <h2 class="ui-title-solid">温馨提示</h2>
                <p>1.您可以填写接收人的“用户昵称”或“游戏ID”进行赠送。</p>
                <p>2.您赠送给接收人的游戏币会在您银行的游戏币上面扣除。</p>
                <p>3.每次赠送，系统收取一定比例的服务费。</p>
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

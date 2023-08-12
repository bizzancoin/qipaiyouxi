<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="Game.Web.Register" %>
<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <link href="/css/member/register.css" rel="stylesheet" type="text/css" />
    <script src="/js/jquery.min.js"type="text/javascript"></script>
    <script src="/js/passwordStrength.js" type="text/javascript"></script>
    <script src="/js/inputCheck.js" type="text/javascript"></script>
    <script src="/js/Common.js" type="text/javascript"></script>

    <script src="/js/lhgdialog/lhgcore.min.js" type="text/javascript"></script>
    <script src="/js/lhgdialog/lhgdialog.js" type="text/javascript"></script>
    <link href="/js/lhgdialog/lhgdialog.css" rel="stylesheet" type="text/css" />
    <style>
        .onShow, .onFocus, .onError, .onCorrect, .onLoad {
            margin-left: 10px;
            width: 14px;
            font-size: 12px;
        }
        .onError {
            color: #cd1f00;
        }
        .onFocus {
            color: #007ac5;
        }

        .onShow {
            color: #007ac5;
        }
        .onCorrect {
            color: #4a7d00;
        }
    </style>
    <script type="text/javascript">
        function UpdateImage()
        {
            $("#picVerifyCode").attr("src", "/ValidateImage2.aspx?r=" + Math.random());
        }
        
        function hintMessage(hintObj,error,message){
            hintObj = $("#"+hintObj);
            //删除样式
            if(error=="error"){
	            hintObj.removeClass("onCorrect");
	            hintObj.removeClass("onFocus");
	            hintObj.addClass("onError");
	        }else if(error=="right"){
	            hintObj.removeClass("onError");
	            hintObj.removeClass("onFocus");
	            hintObj.addClass("onCorrect");
    	    }else if(error=="info"){
    	        hintObj.removeClass("onError");
	            hintObj.addClass("onFocus");
	            hintObj.removeClass("onCorrect");
    	    }
    	    // 替换内容
    	    hintObj.html(message);

    	    return error!="error";
        }
        
        function checkAccounts(){
            if($.trim($("#txtAccounts").val())==""){
                hintMessage("txtAccountsTip","error","请输入您的帐号");
                return false;
            }
            var reg = /^[a-zA-Z0-9_\u4e00-\u9fa5]+$/;
            if(!reg.test($("#txtAccounts").val())){
                hintMessage("txtAccountsTip","error","由字母、数字、下划线和汉字组合");
                return false;
            }
            if (GetByteLength($("#txtAccounts").val()) < 6 || GetByteLength($("#txtAccounts").val()) > 32) {
                hintMessage("txtAccountsTip","error","帐号的长度为6-32个字符");
                return false;
            }
            hintMessage("txtAccountsTip","right","此帐号可以注册!");
            return true;
        }
        
        function checkNickName(){
            if($.trim($("#txtNickname").val())==""){
                hintMessage("txtNicknameTip","error","请输入您的昵称");
                return false;
            }
            var reg = /^[a-zA-Z0-9_\u4e00-\u9fa5]+$/;
            if(!reg.test($("#txtNickname").val())){
                hintMessage("txtNicknameTip","error","由字母、数字、下划线和汉字组合");
                return false;
            }
            if (GetByteLength($("#txtNickname").val()) < 6 || GetByteLength($("#txtNickname").val()) > 32) {
                hintMessage("txtNicknameTip", "error", "昵称的长度为6-32个字符");
                return false;
            }
            hintMessage("txtNicknameTip","right","");
            return true;
        }
        
        //验证帐号是否存在
        var isExitsUserName = false;
        function checkUserName() {
            $.ajax({
                async: false,
                contentType: "application/json",
                url: "WS/WSAccount.asmx/CheckName",
                data: "{userName:'" + $("#txtAccounts").val() + "'}",
                type: "POST",
                dataType: "json",
                success: function (json) {
                    json = eval("(" + json.d + ")");

                    if (json.success == "error") {
                        hintMessage("txtAccountsTip", "error", json.msg);
                        isExitsUserName = true;
                    } else if (json.success == "success") {
                        hintMessage("txtAccountsTip", "right", "此帐号可以注册!");
                        isExitsUserName = false;
                    }
                }
            });
        }

        //验证昵称是否存在
        var isExitsNickName = false;
        function checkIsExitsNickName() {
            $.ajax({
                async: false,
                contentType: "application/json",
                url: "WS/WSAccount.asmx/CheckNickName",
                data: "{nickName:'" + $("#txtNickname").val() + "'}",
                type: "POST",
                dataType: "json",
                success: function (json) {
                    json = eval("(" + json.d + ")");
                    if (json.success == "error") {
                        hintMessage("txtNicknameTip", "error", json.msg);
                        isExitsNickName = true;
                    } else if (json.success == "success") {
                        hintMessage("txtNicknameTip", "right", "此昵称可以注册!");
                        isExitsNickName = false;
                    }
                }, error: function (err, ex) { alert("json") }
            });
        }
        
        function checkLoginPass(){
            if ($("#txtLogonPass").val() == ""){
                hintMessage("txtLogonPassTip","error","请输入您的登录密码");
                return false;
            }
            if($("#txtLogonPass").val().length<6||$("#txtLogonPass").val().length>32){
                hintMessage("txtLogonPassTip","error","登录密码长度为6到32个字符");
                return false;
            }
            hintMessage("txtLogonPassTip","right","");
            return true;
        }
        
        function checkLoginConPass(){
            if($("#txtLogonPass2").val()==""){
                 hintMessage("txtLogonPass2Tip","error","请输入登录确认密码");
                 return false;
            }
            if($("#txtLogonPass2").val() != $("#txtLogonPass").val()){
                hintMessage("txtLogonPass2Tip","error","登录确认密码与原密码不同");
                return false;
            }
            hintMessage("txtLogonPass2Tip","right","");
            return true;
        }        
        function checkVerifyCode(){
            if($("#txtCode").val()==""){
                hintMessage("txtCodeTip","error","请输入验证码");
                return false;
            }
            hintMessage("txtCodeTip","right","");
            return true;
        }
        function checkSpreader() {
            if ($("#txtSpreader").val() == undefined) {
                return true;
            }

            if ($("#txtSpreader").val() != "") {
                var reg = /^\d+$/;
                if (!reg.test($("#txtSpreader").val())) {
                    hintMessage("txtSpreaderTip", "error", "推荐人ID格式不正确");
                    return false;
                }
            }
            hintMessage("txtSpreaderTip","right","");
            return true;
        }
        
        function checkService(){
            if(!$("#chkAgree").attr("checked")){
                hintMessage("chkAgreeTip","error","请选中已阅读并同意服务条款");
                return false;
            }
            hintMessage("chkAgreeTip","right","");
            return true;
        }
        
        function checkInput() {
            if (!checkAccounts()) {
                $("#txtAccounts").focus(); return false;
            } else {
                if (isExitsUserName) {
                    $("#txtAccounts").focus();
                    hintMessage("txtAccountsTip", "error", "很遗憾，该帐号已经被注册");
                    return false;
                }
            }
            if (!checkNickName()) {
                $("#txtNickname").focus(); return false;
            } else {
                if (isExitsNickName) {
                    $("#txtNickname").focus();
                    hintMessage("txtNicknameTip", "error", "很遗憾，该昵称已经被注册");
                    return false;
                }
            }
            if(!checkLoginPass()){$("#txtLogonPass").focus(); return false; }
            if(!checkLoginConPass()){$("#txtLogonPass2").focus(); return false; }
            if(!checkSpreader()){$("#txtSpreader").focus(); return false; }           
            if(!checkVerifyCode()){ $("#txtCode").focus(); return false;}
            if(!checkService()){ return false;}
        }

        $(document).ready(function() {
            $("#txtAccounts").blur(function () {
                if (checkAccounts()) {
                    checkUserName();
                }
            });
            $("#txtNickname").blur(function () {
                if (checkNickName()) {
                    checkIsExitsNickName();
                }
            });
            $("#txtLogonPass").blur(function() { checkLoginPass(); });
            $("#txtLogonPass2").blur(function() { checkLoginConPass(); });

            $("#txtSpreader").blur(function() { checkSpreader(); });
            $("#txtCode").blur(function() { checkVerifyCode(); });

            $("#btnRegister").click(function() {
                return checkInput();
            });

            //密码强度
            strongRankBind($("#txtLogonPass"), $("#lblLogonPassSafeRank"));

            //弹出页面
            $('#btnSwitchFace,#picFace').dialog({
                id: 'winUserfaceList',
                title: '更换头像',
                width: 540,
                height: 385,
                content: 'url:/FaceList.aspx',
                min: false,
                max: false,
                top: "50%",
                fixed: true,
                drag:false,
                resize:false
            });
        });
    </script>
</head>
<body>
    <!--头部开始-->
    <qp:Header ID="sHeader" runat="server" PageID="1"/>
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
    <form id="form1" runat="server">
    <div class="ui-content">
      <div class="ui-main">
        <div class="ui-page-title fn-clear">
          <a href="index.aspx"><i class="ui-page-title-home"></i>首页</a>
          <i class="ui-page-title-current"></i>
          <span>注册帐号</span>
          <div class="ui-page-title-right"><span>REGISTER&nbsp;ACCOUNT</span><strong>注册帐号</strong></div>
        </div>
        <div class="ui-register">
          <div class="ui-number-create">
            <h2 class="ui-title-solid">创建帐号</h2>
            <ul class="ui-game-info">
              <li>
                <label>用户名：</label>
                <asp:TextBox runat="server" ID="txtAccounts" CssClass="ui-text-1"></asp:TextBox><i>*</i>                
                <span id="txtAccountsTip"></span>
              </li>
              <li>
                <label>昵称：</label>
                <asp:TextBox ID="txtNickname" runat="server" CssClass="ui-text-1"></asp:TextBox><i>*</i>
                <span id="txtNicknameTip"></span>
              </li>
              <li>
                <label>选择头像：</label>
                <asp:HiddenField  runat="server" Value="0" ID="hfFaceID" />
                <span class="ui-register-face"><img id="picFace" src="/gamepic/Avatar0.png" /></span>
                <input id="btnSwitchFace" type="button" value="更换头像" class="ui-btn-1" />
              </li>
              <li>
                <label>性别：</label>
                <asp:DropDownList ID="ddlGender" runat="server" CssClass="ui-select-1" TabIndex="4">
                    <asp:ListItem Text="男" Value="1" Selected="True" ></asp:ListItem>
                    <asp:ListItem Text="女" Value="0"></asp:ListItem>
                </asp:DropDownList>
              </li>
            </ul>
          </div>
          <div class="ui-number-safety">
            <h2 class="ui-title-solid">帐号安全</h2>
            <ul class="ui-game-info">
              <li>
                <label>安全等级：</label>
                <span class="ui-id-safe0" id="lblLogonPassSafeRank"></span>
              </li>
              <li>
                <label>密码：</label>
                <asp:TextBox ID="txtLogonPass" runat="server" TextMode="Password" CssClass="ui-text-1"></asp:TextBox><i>*</i>
                <span id="txtLogonPassTip"></span>
              </li>
              <li>
                <label>确认密码：</label>
                <asp:TextBox ID="txtLogonPass2" runat="server" TextMode="Password" CssClass="ui-text-1"></asp:TextBox><i>*</i>
                <span id="txtLogonPass2Tip"></span>
              </li>              
            </ul>
          </div>
          <div class="ui-number-other">
            <h2 class="ui-title-solid">其他资料</h2>
            <ul class="ui-game-info">
              <li id="liSpreader" runat="server">
                <label>推荐人：</label>
                <asp:TextBox ID="txtSpreader" runat="server" CssClass="ui-text-1"></asp:TextBox>
                  <span id="txtSpreaderTip"></span>
              </li>              
              <li class="ui-verify">
                <label>验证码：</label>
                <asp:TextBox ID="txtCode" runat="server" CssClass="ui-text-1"></asp:TextBox>
                <img src="/ValidateImage2.aspx" id="picVerifyCode" height="23" style=" height:26px;cursor:pointer;vertical-align:middle;" onclick="UpdateImage()" title="点击更换验证码图片!"/>
                <a href="javascript:void(0)" onclick="UpdateImage()">看不清？换一张</a>
                <span id="txtCodeTip"></span>
              </li>
            </ul>
          </div>
          <div class="ui-register-submit">
            <p><input id="chkAgree" checked="checked" type="checkbox" name="chkAgree" />&nbsp;我已阅读并同意&nbsp;<a href="/Agreement.aspx" target="_blank">用户服务条款</a></p>
            <p>
                <asp:Button ID="btnRegister" runat="server" Text="注 册" CssClass="ui-btn-2" onclick="btnRegister_Click" />

				<input name="reg" type="hidden" id="reg" value="true" />
            </p>
          </div>
        </div>
      </div>
    </div>
    </form>
    <!--尾部开始-->
    <qp:Footer ID="sFooter" runat="server" />
    <!--尾部结束-->
</body>
</html>

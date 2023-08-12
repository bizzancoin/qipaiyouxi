<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="User_Sidebar.ascx.cs" Inherits="Game.Web.Themes.Standard.User_Sidebar" %>
<div class="ui-main-speedy fn-left">
<ul class="ui-member-submenu">
    <!--帐号服务开始-->
    <li class="ui-submenu-1">
    <p><a href="javascript:;" id="S_1" class="ui-submenu-active" onclick="JavaScript:showHide(document.getElementById('M_1'));"><i></i>帐号服务</a></p>
    <ul class="ui-submenu-list" id="M_1">
        <li><a <%= MemberID==0?"class=\"ui-submenu-list-active\"":"" %> href="/Member/Index.aspx"><i></i>基本信息</a></li>
        <li><a <%= MemberID==1?"class=\"ui-submenu-list-active\"":"" %> href="/Member/ModifyNikeName.aspx"><i></i>修改昵称</a></li>
        <li><a <%= MemberID==2?"class=\"ui-submenu-list-active\"":"" %> href="/Member/ModifyUserInfo.aspx"><i></i>修改资料</a></li>
        <li><a <%= MemberID==3?"class=\"ui-submenu-list-active\"":"" %> href="/Member/ModifyFace.aspx"><i></i>修改头像</a></li>
        <li><a <%= MemberID==4?"class=\"ui-submenu-list-active\"":"" %> href="/Member/ModifyLogonPass.aspx"><i></i>修改登录密码</a></li>
        <li><a <%= MemberID==5?"class=\"ui-submenu-list-active\"":"" %> href="/Member/ModifyInsurePass.aspx"><i></i>修改银行密码</a></li>
        <li><a <%= MemberID==6?"class=\"ui-submenu-list-active\"":"" %> href="/Member/AccountAppeals.aspx"><i></i>帐号申述</a></li>
        <li><a <%= MemberID==32?"class=\"ui-submenu-list-active\"":"" %> href="/Member/AccountAppealsQ.aspx"><i></i>申述查询</a></li>
    </ul>
    </li>
    <!--帐号服务结束-->

    <!--帐号安全开始-->
    <li class="ui-submenu-2">
    <p><a href="javascript:;" id="S_2" onclick="JavaScript:showHide(document.getElementById('M_2'));"><i></i>帐号安全</a></p>
    <ul class="ui-submenu-list fn-hide" id="M_2">
        <li><a <%= MemberID==7?"class=\"ui-submenu-list-active\"":"" %> href="/Member/ApplyProtect.aspx"><i></i>申请密码保护</a></li>
        <li><a <%= MemberID==8?"class=\"ui-submenu-list-active\"":"" %> href="/Member/ModifyProtect.aspx"><i></i>修改密码保护</a></li>
        <li><a <%= MemberID==9?"class=\"ui-submenu-list-active\"":"" %> href="/Member/ReLogonPass.aspx"><i></i>找回登录密码</a></li>
        <li><a <%= MemberID==10?"class=\"ui-submenu-list-active\"":"" %> href="/Member/ReInsurePass.aspx"><i></i>找回银行密码</a></li>
        <li><a <%= MemberID==11?"class=\"ui-submenu-list-active\"":"" %> href="/Member/ApplyPasswordCard.aspx"><i></i>申请密保卡</a></li>
        <li><a <%= MemberID==12?"class=\"ui-submenu-list-active\"":"" %> href="/Member/ExitPasswordCard.aspx"><i></i>取消密保卡</a></li>
    </ul>
    </li>
    <!--帐号安全结束-->

    <!--银行服务开始-->				
    <li class="ui-submenu-3">
    <p><a href="javascript:;" id="S_3" onclick="JavaScript:showHide(document.getElementById('M_3'));"><i></i>银行服务</a></p>
    <ul class="ui-submenu-list fn-hide" id="M_3">
        <li><a <%= MemberID==13?"class=\"ui-submenu-list-active\"":"" %> href="/Member/InsureIn.aspx"><i></i>存款</a></li>
        <li><a <%= MemberID==14?"class=\"ui-submenu-list-active\"":"" %> href="/Member/InsureOut.aspx"><i></i>取款</a></li>
        <% if((!IsCloseTrade)||(IsCloseTrade&&agentID!=0)){ %>
        <li><a <%= MemberID==15?"class=\"ui-submenu-list-active\"":"" %> href="/Member/InsureTransfer.aspx"><i></i>转账</a></li>
        <%} %>
        <li><a <%= MemberID==16?"class=\"ui-submenu-list-active\"":"" %> href="/Member/InsureRecord.aspx"><i></i>交易明细</a></li>
        <li><a <%= MemberID==17?"class=\"ui-submenu-list-active\"":"" %> href="/Member/ConvertPresent.aspx"><i></i>魅力兑换</a></li>
        <li><a <%= MemberID==18?"class=\"ui-submenu-list-active\"":"" %> href="/Member/ConvertRecord.aspx"><i></i>魅力兑换记录</a></li>
        <li><a <%= MemberID==19?"class=\"ui-submenu-list-active\"":"" %> href="/Member/ConvertMedal.aspx"><i></i>元宝兑换</a></li>
        <li><a <%= MemberID==20?"class=\"ui-submenu-list-active\"":"" %> href="/Member/ConvertMedalRecord.aspx"><i></i>元宝兑换记录</a></li>
    </ul>
    </li>
    <!--银行服务结束-->				

    <!--充值中心开始-->	
    <li class="ui-submenu-4">
    <p><a href="javascript:;" id="S_4" onclick="JavaScript:showHide(document.getElementById('M_4'));"><i></i>充值中心</a></p>
    <ul class="ui-submenu-list fn-hide" id="M_4">
        <li><a <%= MemberID==21?"class=\"ui-submenu-list-active\"":"" %> href="/Pay/Index.aspx"><i></i>我要充值</a></li>
        <li><a <%= MemberID==22?"class=\"ui-submenu-list-active\"":"" %> href="/Member/PayRecord.aspx"><i></i>充值记录</a></li>
    </ul>
    </li>
    <!--充值中心结束-->	

    <!--推广中心开始-->	
    <li class="ui-submenu-5">
    <p><a href="javascript:;" id="S_5" onclick="JavaScript:showHide(document.getElementById('M_5'));"><i></i>推广服务</a></p>
    <ul class="ui-submenu-list fn-hide" id="M_5">
        <li><a <%= MemberID==23?"class=\"ui-submenu-list-active\"":"" %> href="/Member/SpreadIn.aspx"><i></i>业绩查询</a></li>
        <li><a <%= MemberID==24?"class=\"ui-submenu-list-active\"":"" %> href="/Member/SpreadBalance.aspx"><i></i>业绩结算</a></li>
        <li><a <%= MemberID==25?"class=\"ui-submenu-list-active\"":"" %> href="/Member/SpreadInfo.aspx"><i></i>推广明细查询</a></li>
        <li><a <%= MemberID==26?"class=\"ui-submenu-list-active\"":"" %> href="/Member/SpreadOut.aspx"><i></i>结算明细查询</a></li>
    </ul>
    </li>
    <!--推广中心结束-->	

    <% if(agentID!=0){ %>
    <!--代理中心开始-->	
    <li class="ui-submenu-5">
    <p><a href="javascript:;" id="S_6" onclick="JavaScript:showHide(document.getElementById('M_6'));"><i></i>代理中心</a></p>
    <ul class="ui-submenu-list fn-hide" id="M_6">
        <li><a <%= MemberID==27?"class=\"ui-submenu-list-active\"":"" %> href="/Member/AgentInfo.aspx"><i></i>代理信息</a></li>
        <li><a <%= MemberID==28?"class=\"ui-submenu-list-active\"":"" %> href="/Member/AgentChildInfo.aspx"><i></i>注册信息</a></li>
        <li><a <%= MemberID==29?"class=\"ui-submenu-list-active\"":"" %> href="/Member/AgentPayInfo.aspx"><i></i>充值信息</a></li>
        <li><a <%= MemberID==30?"class=\"ui-submenu-list-active\"":"" %> href="/Member/AgentRevenueInfo.aspx"><i></i>税收信息</a></li>
        <li><a <%= MemberID==31?"class=\"ui-submenu-list-active\"":"" %> href="/Member/AgentPayBackInfo.aspx"><i></i>返现信息</a></li>
    </ul>
    </li>
    <%} %>
    <!--代理中心结束-->	
</ul>
</div>
<script type="text/javascript">    
    function setCookie2(sName, sValue) {
        var expires = new Date();
        expires.setTime(expires.getTime() + 16 * 60 * 1000);
        document.cookie = sName + "=" + escape(sValue) + "; expires=" + expires.toGMTString() + "; path=/";
    }
    
    function getCookie (sName) {
	    var aCookie = document.cookie.split("; ");
	    for (var i=0; i < aCookie.length; i++) {
		    var aCrumb = aCookie[i].split("=");
		    if (sName == aCrumb[0])
			    return unescape(aCrumb[1]);
	    }
	    return null;
    }
    
    function showHide(obj) {
        // var oStyle = obj.style;
        var imgId = obj.id.replace("M","S");

        if(obj.className.indexOf("fn-hide") !== -1)
        {
            // oStyle.display = "block";
            obj.className = "ui-submenu-list";
            document.getElementById(imgId).className = "ui-submenu-active";
            setCookie2("U"+obj.id,"on")
        }
        else
        {
            // oStyle.display = "none";
            obj.className = "ui-submenu-list fn-hide";
            document.getElementById(imgId).className = "";
            setCookie2("U"+obj.id,"off")
        }
    }    
    window.onload = function () {
        for (var i = 1; i <= 6; i++) {
            var M = document.getElementById("M_" + i);
            var S = document.getElementById("S_" + i);

            if (getCookie("UM_" + i) == null || getCookie("UM_" + i) == undefined || getCookie("UM_" + i) == "on") {
                if(M){
                    // M.style.display = "block";
                    M.className = "ui-submenu-list"
                }

                if(S){
                    S.className = "ui-submenu-active";
                }
            }
            else {
                if(M){
                    // M.style.display = "none";
                    M.className = "ui-submenu-list fn-hide";
                }
                if(S){
                    S.className = "";
                }
            }
        }        
    }
</script>
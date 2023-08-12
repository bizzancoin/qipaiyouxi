<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Game_Sidebar.ascx.cs" Inherits="Game.Web.Themes.Standard.Game_Sidebar" %>
<div class="ui-main-speedy fn-left">
<ul class="ui-member-submenu">
    <asp:Repeater ID="rptGameTypes" runat="server" onitemdatabound="rptGameTypes_ItemDataBound">
        <ItemTemplate>
            <li class="ui-submenu-<%# Container.ItemIndex+1 %>">
            <p><a href="javascript:;" id="S_<%# Container.ItemIndex+1 %>" onclick="JavaScript:showHide(document.getElementById('M_<%# Container.ItemIndex+1 %>'));" class="fn-clear"><%# Eval("TypeName") %><i></i></a></p>
            <ul class="ui-submenu-list" id="M_<%# Container.ItemIndex+1 %>">
                <asp:Repeater ID="rptGameList" runat="server">
                    <ItemTemplate>
                        <li><a href="/GameRules.aspx?KindID=<%# Eval("KindID") %>" <%# kindID==Convert.ToInt32(Eval("KindID"))?"class='ui-submenu-list-active fn-clear'":"class='fn-clear'" %>><%#  Game.Utils.TextUtility.CutStringProlongSymbol( Eval( "KindName" ).ToString( ) , 30 )%><i></i></a></li>
                    </ItemTemplate>
                </asp:Repeater>
            </ul>
        </ItemTemplate>
    </asp:Repeater>    
</ul>
</div>
<input id="TCount" type="hidden" runat="server" value="3" />
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
        var oStyle = obj.style;
        var imgId = obj.id.replace("M","S");
        
        if(oStyle.display == "none")
        {
            oStyle.display = "block";
            document.getElementById(imgId).className = "ui-submenu-active fn-clear";
            setCookie2("G"+obj.id,"on")
        }
        else
        {
            oStyle.display = "none";
            document.getElementById(imgId).className = "fn-clear";
            setCookie2("G"+obj.id,"off")
        }
    }    
    window.onload = function() {
        var count = document.getElementById("<%= TCount.ClientID %>").value;
        for(var i=1;i<=count;i++)
        {
            if (getCookie("GM_"+i) == null || getCookie("GM_"+i) == undefined || getCookie("GM_"+i) == "on") 
            {
                document.getElementById("M_"+i).style.display = "block";
                document.getElementById("S_" + i).className = "ui-submenu-active fn-clear";
            }
            else
            {
                document.getElementById("M_"+i).style.display = "none";
                document.getElementById("S_" + i).className = "fn-clear";
            }
        }
    }
</script>
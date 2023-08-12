<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="TabSiteConfig.ascx.cs" Inherits="Game.Web.Themes.TabSiteConfig" %>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="listBg2">
    <tr>
        <td height="35" colspan="2" class="Lpd10 Rpd10">
            <div class="liebiao">
                <ul>
                    <li <%= IntParam==0?"class=\"current\"":""%> ><a href="LogoSet.aspx?param=0">网站LOGO设置</a></li>
                    <asp:Repeater ID="rptDataList" runat="server">
                        <ItemTemplate>
                           <li <%# Convert.ToInt32( Eval("ConfigID") )==IntParam?"class=\"current\"":""%>><a href="SiteConfig.aspx?param=<%#Eval("ConfigID").ToString() %>">
                                <%#Eval( "ConfigName" ).ToString()%></a></li> 
                        </ItemTemplate>
                    </asp:Repeater>
                </ul>
            </div>
        </td>
    </tr>
</table>
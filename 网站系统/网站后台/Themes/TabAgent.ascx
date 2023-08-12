<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="TabAgent.ascx.cs" Inherits="Game.Web.Themes.TabAgent" %>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="Tmg7">
    <tr>
        <td height="28">
            <ul>
                <% if (NavActivated == "A")
                    {
                    %>
                <li class="tab1" onclick="Redirect('AgentManager.aspx?param='+GetRequest('param',0))">代理信息</li>
                <%}
                    else { %>
                <li class="tab2" onclick="Redirect('AgentManager.aspx?param='+GetRequest('param',0))">代理信息</li>
                <%} %>

                <% if (NavActivated == "F")
                    {
                    %>
                <li class="tab1" onclick="Redirect('AgentStatInfo.aspx?param='+GetRequest('param',0))">分成信息</li>
                <%}
                    else { %>
                <li class="tab2" onclick="Redirect('AgentStatInfo.aspx?param='+GetRequest('param',0))">分成信息</li>
                <%} %>                
                    
                <% if (NavActivated == "B")
                    {
                    %>
                <li class="tab1" onclick="Redirect('AgentChildInfo.aspx?param='+GetRequest('param',0))">注册信息</li>
                <%}
                    else { %>
                <li class="tab2" onclick="Redirect('AgentChildInfo.aspx?param='+GetRequest('param',0))">注册信息</li>
                <%} %>
                    
                <% if (NavActivated == "C")
                    {
                    %>
                <li class="tab1" onclick="Redirect('AgentPayInfo.aspx?param='+GetRequest('param',0))">充值信息</li>
                <%}
                    else { %>
                <li class="tab2" onclick="Redirect('AgentPayInfo.aspx?param='+GetRequest('param',0))">充值信息</li>
                <%} %>

                <% if (NavActivated == "D")
                {
                %>
                <li class="tab1" onclick="Redirect('AgentRevenueInfo.aspx?param='+GetRequest('param',0))">税收信息</li>
                <%}
                    else { %>
                <li class="tab2" onclick="Redirect('AgentRevenueInfo.aspx?param='+GetRequest('param',0))">税收信息</li>
                <%} %>   
                  
                <% if (NavActivated == "E")
                {
                %>
                <li class="tab1" onclick="Redirect('AgentPayBackInfo.aspx?param='+GetRequest('param',0))">返现信息</li>
                <%}
                    else { %>
                <li class="tab2" onclick="Redirect('AgentPayBackInfo.aspx?param='+GetRequest('param',0))">返现信息</li>
                <%} %>                       
            </ul>
        </td>
    </tr>
</table>

<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="TabUser.ascx.cs" Inherits="Game.Web.Themes.TabUser" %>
  <table width="99%" border="0" align="center" cellpadding="0" cellspacing="0" class="Tmg7">
        <tr>
            <td height="28">
                <ul>
                    <% if (NavActivated == "A")
                       {
                        %>
                    <li class="tab1" onclick="Redirect('AccountsInfo.aspx?param='+GetRequest('param',0))">基本信息</li>
                    <%}
                       else { %>
                    <li class="tab2" onclick="Redirect('AccountsInfo.aspx?param='+GetRequest('param',0))">基本信息</li>
                    <%} %>
                    
                    <% if (NavActivated == "B")
                       {
                        %>
                    <li class="tab1" onclick="Redirect('AccountsDetailInfo.aspx?param='+GetRequest('param',0))">详细信息</li>
                    <%}
                       else { %>
                    <li class="tab2" onclick="Redirect('AccountsDetailInfo.aspx?param='+GetRequest('param',0))">详细信息</li>
                    <%} %>
                    
                    <% if (NavActivated == "C")
                       {
                        %>
                    <li class="tab1" onclick="Redirect('AccountsGoldInfo.aspx?param='+GetRequest('param',0))">财富信息</li>
                    <%}
                       else { %>
                    <li class="tab2" onclick="Redirect('AccountsGoldInfo.aspx?param='+GetRequest('param',0))">财富信息</li>
                    <%} %>
                      <% if (NavActivated == "D")
                       {
                        %>
                    <li class="tab1" onclick="Redirect('AccountsScoreInfo.aspx?param='+GetRequest('param',0))">积分信息</li>
                    <%}
                       else { %>
                    <li class="tab2" onclick="Redirect('AccountsScoreInfo.aspx?param='+GetRequest('param',0))">积分信息</li>
                    <%} %>       
                    
                    <% if (NavActivated == "E")
                       {
                        %>
                    <li class="tab1" onclick="Redirect('AccountsRecordInfo.aspx?param='+GetRequest('param',0))">记录信息</li>
                    <%}
                       else { %>
                    <li class="tab2" onclick="Redirect('AccountsRecordInfo.aspx?param='+GetRequest('param',0))">记录信息</li>
                    <%} %>
                    
                            
                    
                </ul>
            </td>
        </tr>
    </table>
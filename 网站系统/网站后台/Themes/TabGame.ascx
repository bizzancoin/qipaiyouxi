<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="TabGame.ascx.cs" Inherits="Game.Web.Themes.TabGame" %>
  <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="Tmg7">
        <tr>
            <td height="28">
                <ul>
                    <% if (NavActivated == "A")
                       {
                        %>
                    <li class="tab1" onclick="Redirect('GameGameItemList.aspx')">模块</li>
                    <%}
                       else { %>
                    <li class="tab2" onclick="Redirect('GameGameItemList.aspx')">模块</li>
                    <%} %>
                    
                    <% if (NavActivated == "C")
                       {
                        %>
                    <li class="tab1" onclick="Redirect('GameKindItemList.aspx')">游戏</li>
                    <%}
                       else { %>
                    <li class="tab2" onclick="Redirect('GameKindItemList.aspx')">游戏</li>
                    <%} %>

                    <% if (NavActivated == "B")
                       {
                        %>
                    <li class="tab1" onclick="Redirect('GameTypeItemList.aspx')">类型</li>
                    <%}
                       else { %>
                    <li class="tab2" onclick="Redirect('GameTypeItemList.aspx')">类型</li>
                    <%} %>
                    <% if (NavActivated == "D")
                       {
                        %>
                    <li class="tab1" onclick="Redirect('MobileKindList.aspx')">手游</li>
                    <%}
                       else { %>
                    <li class="tab2" onclick="Redirect('MobileKindList.aspx')">手游</li>
                    <%} %>
                    <%-- 
                      <% if (NavActivated == "D")
                       {
                        %>
                    <li class="tab1" onclick="Redirect('GameNodeItemList.aspx')">节点</li>
                    <%}
                       else { %>
                    <li class="tab2" onclick="Redirect('GameNodeItemList.aspx')">节点</li>
                    <%} %>       
                    
                    <% if (NavActivated == "E")
                       {
                        %>
                    <li class="tab1" onclick="Redirect('GamePageItemList.aspx')">自定义页</li>
                    <%}
                       else { %>
                    <li class="tab2" onclick="Redirect('GamePageItemList.aspx')">自定义页</li>
                    <%} %>
                    --%>
                </ul>
            </td>
        </tr>
    </table>
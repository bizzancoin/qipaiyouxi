<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="TopMobileNotice.ascx.cs" Inherits="Game.Web.Themes.TopMobileNotice" %>

<table width="99%" border="0" align="center" cellpadding="0" cellspacing="0" class="Tmg7">
    <tr>
        <td height="28">
            <ul>
                <li class="<%= NewsPageID==1?"tab1":"tab2" %>" onclick="Redirect('NewsList.aspx')">新闻公告</li>
                <li class="<%= NewsPageID==2?"tab1":"tab2" %>" onclick="Redirect('MobileNoticeList.aspx')">移动版公告</li>
                <% if(AllowRoomCard == "1")
                    { %>
                <li class="<%= NewsPageID == 3 ? "tab1" : "tab2" %>" onclick="Redirect('CardNoticeList.aspx')">房卡公告</li>
                <% } %>
            </ul>
        </td>
    </tr>
</table>
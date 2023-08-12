<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="TopPropRecord.ascx.cs" Inherits="Game.Web.Themes.TopPropRecord" %>
<table width="99%" border="0" align="center" cellpadding="0" cellspacing="0" class="Tmg7">
    <tr>
        <td height="28">
            <ul>
                <li class="<%= PropRecordPageID==1?"tab1":"tab2" %>" onclick="Redirect('RecordUseProp.aspx')">普通道具</li>
                <li class="<%= PropRecordPageID==2?"tab1":"tab2" %>" onclick="Redirect('RecordUsePresent.aspx')">礼物道具</li>
            </ul>
        </td>
    </tr>
</table>
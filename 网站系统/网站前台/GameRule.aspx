<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="Game.Utils" %>

<script type="text/C#" runat="server">
    protected override void OnInit(EventArgs e)
    {
        int kindID = GameRequest.GetQueryInt("GameID", 0);
        //string url="/guize/guize.html";
        string url = "/GameRules.aspx?KindID=" + kindID.ToString();
        Response.Redirect(url);
        Response.End();
    }
</script>

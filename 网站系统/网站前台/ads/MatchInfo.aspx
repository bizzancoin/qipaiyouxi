<%@ Page Language="C#" AutoEventWireup="true" %>

<%@ Import Namespace=" Game.Utils" %>

<script type="text/C#" runat="server">
    protected override void OnInit( EventArgs e )
    {
        base.OnInit( e );

        // 跳转
        int serverID = GameRequest.GetQueryInt( "ServerID" , -1 );
        if( serverID > 0 )
        {
            string DownloadUrl = string.Format( "/Ads/Match{0}.html" , serverID );
            Response.Redirect( DownloadUrl );
            return;
        }
    }
</script>


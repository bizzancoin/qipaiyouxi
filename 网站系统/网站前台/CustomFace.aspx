<%@ Page Language="C#" AutoEventWireup="true" %>

<%@ Import Namespace=" Game.Utils" %>
<%@ Import Namespace="Game.Entity.Accounts" %>

<script type="text/C#" runat="server">
    protected override void OnInit( EventArgs e )
    {
        base.OnInit( e );
        int customId = GameRequest.GetQueryInt( "CustomID", -1 );
        int userId = GameRequest.GetQueryInt( "UserID", -1 );
        if( userId < 0 || customId < 0 )
        {
            return;
        }
        StringBuilder sqlQuery = new StringBuilder();
        AccountsFace model = Game.Facade.FacadeManage.aideAccountsFacade.GetAccountsFace( customId, userId );
        if(model == null)
        {
            return;
        }
        byte[] faceByte = (byte[])model.CustomFace;
        Response.AddHeader( "Content-Disposition", "attachment;filename=face.txt" );
        Response.BinaryWrite( faceByte );
        Response.End();
    }
</script>
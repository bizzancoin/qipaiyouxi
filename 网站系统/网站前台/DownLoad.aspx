<%@ Page Language="C#" AutoEventWireup="true" %>

<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="Game.Utils" %>
<%@ Import Namespace="Game.Entity.Platform" %>
<%@ Import Namespace="Game.Facade" %>

<script type="text/C#" runat="server">
    protected override void OnInit(EventArgs e)
    {
        base.OnInit(e);
        int KindID = GameRequest.GetQueryInt("KindID", -1);
        if(KindID < 0)
            return;
        if(KindID == 0)
        {
            Response.Redirect("/Download/Plaza.exe");
            return;
        }
        
        //获取游戏下载路径
        StringBuilder sqlQuery = new StringBuilder();
        sqlQuery.AppendFormat("SELECT * FROM {0} WHERE KindID={1}", GameKindItem.Tablename, KindID);
        GameKindItem kindInfo = FacadeManage.aidePlatformFacade.GetEntity<GameKindItem>(sqlQuery.ToString());
        if(kindInfo == null)
            return;
        string DownloadUrl = string.IsNullOrEmpty(kindInfo.DownLoadUrl.Trim()) ? "/Download/" + kindInfo.ProcessName : kindInfo.DownLoadUrl;
        Response.Redirect(DownloadUrl);
    }
</script>

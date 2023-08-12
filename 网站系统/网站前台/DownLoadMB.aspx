<%@ Page Language="C#" AutoEventWireup="true" %>

<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="Game.Utils" %>
<%@ Import Namespace="Game.Entity.Platform" %>
<%@ Import Namespace="Game.Facade" %>

<script type="text/C#" runat="server">
    protected override void OnInit(EventArgs e)
    {
        base.OnInit(e);
        int KindID = GameRequest.GetQueryInt("KindID", 0);
        string iosDownloadURL = "http://" + Request.Url.Authority.ToString() + "/Index.aspx";
        //获取大厅地址
        Game.Entity.NativeWeb.ConfigInfo ci = FacadeManage.aideNativeWebFacade.GetConfigInfo(AppConfig.SiteConfigKey.GameIosConfig.ToString());
        if (ci != null)
        {
            iosDownloadURL = ci.Field1;
        }
        
        if(KindID == 0)
        {
            Response.Redirect(iosDownloadURL);
            return;
        }
        
        //获取游戏下载路径
        Game.Entity.NativeWeb.GameRulesInfo info = FacadeManage.aideNativeWebFacade.GetGameHelp(KindID);
        if (info == null)
        {
            Response.Redirect(iosDownloadURL);
            return;
        }
            
        string userAgent = Request.UserAgent.ToLower();
        if (userAgent.Contains("android"))
        {
            Response.Redirect(info.AndroidDownloadUrl);
        }
        else
        {
            Response.Redirect(info.IOSDownloadUrl);
        }
    }
</script>
<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="Game.Utils" %>
<%@ Import Namespace="Game.Entity.NativeWeb" %>
<%@ Import Namespace="Game.Facade" %>
<%@ Import Namespace="Game.Kernel" %>

<script type="text/C#" runat="server">
    //页面载入
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            int kindId = GameRequest.GetQueryInt("kindid", 0);
            int typeid = GameRequest.GetQueryInt("typeid", 0);

            if (kindId <= 0)
            {
                return;
            }            
            GameRulesInfo info = FacadeManage.aideNativeWebFacade.GetGameHelp(kindId);
            if (info != null)
            {
                Response.Write(Utility.HtmlDecode(typeid == 0 ? info.MobileIntro : info.RoomCardIntro));
            }
        }
    }
</script>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <style type="text/css">
        html {
            width:100%;
            padding:1rem;
        }
        body{
            width:100%;
            padding:1rem;
            /*background-color:#eddaa1;*/
        }
    </style>
</head>
<body>
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GameRules.aspx.cs" Inherits="Game.Web.GameRules" %>
<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>
<%@ Register TagPrefix="qp" TagName="GameSidebar" Src="~/Themes/Standard/Game_Sidebar.ascx" %>
<%@ Import Namespace="Game.Facade" %>
<%@ Import Namespace="Game.Utils" %>
<%@ Import Namespace="Game.Entity.NativeWeb" %>
<%@ Import Namespace="Game.Entity.Platform" %>
<%@ Import Namespace="Game.Data" %>

<script type="text/C#" runat="server">
    
    //定义变量
    protected int kindID = 0;
    protected string image = string.Empty;
    protected string intraduction = string.Empty;
    protected string rule = string.Empty;
    protected string score = string.Empty;
    protected string title = string.Empty;

    //页面载入
    protected void Page_Load(object sender, EventArgs e)
    {
        kindID = GameRequest.GetQueryInt("KindID", 0);
        if(kindID == 0)
        {
            kindID = GameRequest.GetQueryInt("GameID", 0);
        }

        //有自定义规则则跳转
        if(kindID != 0)
        {
            StringBuilder sqlQuery = new StringBuilder();
            sqlQuery.AppendFormat("SELECT * FROM {0} WHERE KindID={1}", GameKindItem.Tablename, kindID);
            GameKindItem kindInfo = FacadeManage.aidePlatformFacade.GetEntity<GameKindItem>(sqlQuery.ToString());
            if(kindInfo != null)
            {
                if(!string.IsNullOrEmpty(kindInfo.GameRuleUrl.Trim()))
                {
                    Response.Redirect(kindInfo.GameRuleUrl.Trim());
                    Response.End();
                }
            }
        }

        GameRulesInfo rules = FacadeManage.aideNativeWebFacade.GetGameHelp(kindID);
        if(rules != null)
        {
            image = Server.UrlPathEncode(rules.ImgRuleUrl);
            intraduction = Utility.HtmlDecode(rules.HelpIntro);
            rule = Utility.HtmlDecode(rules.HelpRule);
            score = Utility.HtmlDecode(rules.HelpGrade);
            title = Utility.HtmlDecode(rules.KindName);

            this.divNoData.Visible = false;
            this.divMain.Visible = true;
        }
        else
        {
            this.divMain.Visible = false;
            this.divNoData.Visible = true;
        }
    } 
</script>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <link href="/css/game/game-rules.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/js/jquery.min.js"></script>
</head>
<body>
    <!--头部开始-->
    <qp:Header ID="sHeader" runat="server" PageID="2"/>
    <!--头部结束-->

    <div class="ui-banner">
      <div class="ui-banner-bg-1"></div>
      <div class="ui-banner-bg-2"></div>
      <div class="ui-carousel-right">
        <div class="ui-carousel-left">
          <div class="ui-banner-img">
            <a href="javascript:;"><img src="/images/banner_2.png" /></a>
          </div>
        </div>
      </div>
    </div>
    <div class="ui-content">
      <div class="ui-main">
        <div class="ui-page-title fn-clear">
          <a href="/index.aspx"><i class="ui-page-title-home"></i>首页</a>
          <i class="ui-page-title-current"></i>
          <span>游戏中心</span>
          <i class="ui-page-title-current"></i>
          <span><%= title %>游戏规则</span>
          <div class="ui-page-title-right"><span>GAME&nbsp;CENTER</span><strong>游戏中心</strong></div>
        </div>
        <div class="ui-game-rules fn-clear">
          <!--头部开始-->
          <qp:GameSidebar ID="sGameSidebar" runat="server" />
          <!--头部开始-->
          <div class="ui-main-details fn-right" id="divMain" runat="server">
            <div class="ui-game-photo">
              <h2 class="ui-title-solid">游戏截图</h2>
              <p><img src="<%= Game.Facade.Fetch.GetUploadFileUrl( image ) %>"></p>
            </div>
            <div class="ui-game-intro">
              <h2 class="ui-title-solid">游戏介绍</h2>
              <p><%= intraduction %></p>
            </div>
            <div class="ui-game-rules">
              <h2 class="ui-title-solid">游戏规则</h2>
              <%= rule %>
            </div>
            <div class="ui-game-rules">
              <h2 class="ui-title-solid">游戏等级</h2>
              <%= score %>
            </div>
          </div>
            <div class="ui-adapt-bottom"></div>
            <div class="ui-main-details fn-right" id="divNoData" runat="server">
                <h2 class="ui-title-solid">抱歉，该游戏帮助还没有添加。</h2>
            </div>
          <div class="ui-adapt-bottom"></div>
        </div>
      </div>
    </div>
    <!--尾部开始-->
    <qp:Footer ID="sFooter" runat="server" />
    <!--尾部结束-->
</body>
</html>

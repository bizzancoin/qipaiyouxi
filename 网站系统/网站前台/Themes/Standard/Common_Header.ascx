<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Common_Header.ascx.cs" Inherits="Game.Web.Themes.Standard.Common_Header" %>
<div class="ui-guide">
    <ul>
    <li><img src="/images/guide.png"></li>
    <li><a href="/Register.aspx" class="ui-guide-pic-1"></a></li>
    <li><img src="/images/guide_5.png"></li>
    <li><a href="/Games/Index.aspx" class="ui-guide-pic-2"></a></li>
    <li><img src="/images/guide_5.png"></li>
    <li><a href="/Match/Index.aspx" class="ui-guide-pic-3"></a></li>
    <li><img src="/images/guide_5.png"></li>
    <li><a href="/Shop/Index.aspx" class="ui-guide-pic-4"></a></li>
    </ul>
</div>
<div class="ui-top-home">
    <a id="course-top" href="javascript:;" class="ui-top-home-1"><span>返回顶部</span></a>
    <a href="javascript:;" class="ui-top-home-2 bdsharebuttonbox" data-cmd="more"><span>分享</span></a>
    <a href="/Service/Contact.aspx" class="ui-top-home-3"><span>咨询</span></a>
    <a href="/Service/Feedback.aspx" class="ui-top-home-4"><span>反馈</span></a>
</div>
<div class="ui-top-header">
    <div class="ui-header fn-clear">
      <div class="ui-logo">
          <a href="javascript:;"><img src="<%= Game.Facade.Fetch.GetUploadFileUrl("/Site/Logo.png") %>"></a>
      </div>
      <div class="ui-nav fn-clear">
          <div class="ui-login fn-clear" id="headLogon"></div>
              <ul class="ui-menu fn-clear">
              <li><img src="/images/menu_line.png"></li>
              <li><a href="/index.aspx" <%= PageID==1?"class=\"ui-menu-active\"":"" %>>网站首页</a></li>
              <li><img src="/images/menu_line.png"></li>
              <li><a href="/Games/Index.aspx" <%= PageID==2?"class=\"ui-menu-active\"":"" %>>游戏下载</a></li>
              <li><img src="/images/menu_line.png"></li>
              <li><a href="/News/NewsList.aspx" <%= PageID==3?"class=\"ui-menu-active\"":"" %>>新闻公告</a></li>
              <li><img src="/images/menu_line.png"></li>
              <li><a href="/Member/Index.aspx" <%= PageID==4?"class=\"ui-menu-active\"":"" %>>个人中心</a></li>
              <li><img src="/images/menu_line.png"></li>
              <li><a href="/Pay/Index.aspx" <%= PageID==5?"class=\"ui-menu-active\"":"" %>>充值中心</a></li>
              <li><img src="/images/menu_line.png"></li>
              <li><a href="/Match/Index.aspx" <%= PageID==6?"class=\"ui-menu-active\"":"" %>>赛事活动</a></li>
              <li><img src="/images/menu_line.png"></li>
              <li><a href="/Shop/Index.aspx" <%= PageID==7?"class=\"ui-menu-active\"":"" %>>游戏商城</a></li>
              <li><img src="/images/menu_line.png"></li>
          </ul>
      </div>
      </div>
</div>

<script type="text/javascript">
    function GetHeadUserInfo() {
        $.ajax({
            contentType: "application/json",
            url: "/WS/WSAccount.asmx/GetHeadUserInfo",
            type: "POST",
            dataType: 'json',
            success: function(result) {
                result = eval("(" + result.d + ")");
                if (result.data.valid) {
                    $("#headLogon").html(result.data.html);
                }
            }
        });
    }

    $(function() {
        GetHeadUserInfo();

        var courseTop = $('#course-top');
        // 回到顶部
        courseTop.on('click', function (e){
            e.preventDefault();

            $('html, body').animate({
                scrollTop: 0
            }, 300);
        });

        var baiduSDK = document.createElement('script');

        baiduSDK.src = 'http://bdimg.share.baidu.com/static/api/js/share.js?cdnversion=' + ~(-new Date() / 36e5);

        (document.getElementsByTagName('head')[0]||document.body).appendChild(baiduSDK);
    });
</script>
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Feedback.aspx.cs" Inherits="Game.Web.Service.Feedback" %>
<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>
<%@ Register TagPrefix="qp" TagName="ServiceSidebar" Src="~/Themes/Standard/Service_Sidebar.ascx" %>
<%@ Register TagPrefix="qp" TagName="Download" Src="~/Themes/Standard/Common_Download.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <link href="/css/service/service-feedback.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/js/jquery.min.js"></script>
</head>
<body>
    <!--头部开始-->
    <qp:Header ID="sHeader" runat="server" PageID="1"/>
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
          <a href="/Service/Index.aspx">客服中心</a>
          <i class="ui-page-title-current"></i>
          <span>在线反馈</span>
          <div class="ui-page-title-right"><span>SERVICE&nbsp;CENTER</span><strong>客服中心</strong></div>
        </div>
        <div class="fn-clear">
          <div class="ui-main-speedy fn-left">
            <!--客服左边开始-->
            <qp:ServiceSidebar ID="sServiceSidebar" runat="server" ServicePageID="7" />
            <!--客服左边结束-->
            <!--游戏下载开始-->
            <qp:Download ID="sDownload" runat="server" />
            <!--游戏下载结束-->
          </div>
          <div class="ui-main-details fn-right">
            <form id="form1" runat="server">
              <h2 class="ui-title-solid">历史反馈</h2>
              <div class="ui-feedback">
                <h3><a href="/Service/Feedback.aspx" <%= string.IsNullOrEmpty( StrParam )?"class=\"ui-question-active\"":"" %>>全部提问</a>&nbsp;丨&nbsp;<a href="/Service/Feedback.aspx?param=self" <%= StrParam=="self"?"class=\"ui-question-active\"":"" %>>我的提问</a></h3>
                <ul class="ui-question-list" runat="server" id="divData">
                    <asp:Repeater ID="rptFeedBackList" runat="server">
                        <ItemTemplate>
                            <li>
                                <div class="ui-question-time fn-clear">
                                  <strong><%# (Convert.ToInt32(Eval("UserID")) == 0 ? "匿名提问" : GetNickNameByUserID(Convert.ToInt32(Eval("UserID"))))%>&nbsp;提问:</strong>
                                  <span>提问时间：&nbsp;<%# Eval("FeedbackDate","{0:yyyy-MM-dd}")%></span>
                                </div>
                                <div class="ui-question-detail">
                                  <p><%# Eval( "FeedbackContent" ).ToString()%></p>
                                </div>
                                <div class="ui-question-answer" <%# string.IsNullOrEmpty( Eval("RevertContent").ToString())?"style=\"display:none;\"":""%>>
                                  <p><%# Eval("RevertContent").ToString()%></p>
                                  <i><%# Eval("FeedbackDate","{0:yyyy-MM-dd HH:mm:ss}")%></i>
                                </div>
                            </li>
                        </ItemTemplate>
                    </asp:Repeater>
                </ul>
                <div class="ui-news-paging fn-clear">
                  <webdiyer:AspNetPager ID="anpPage" runat="server" AlwaysShow="true" FirstPageText="首页" FirstLastButtonClass="ui-news-paging-prev" NextPrevButtonClass="ui-news-paging-prev"  
                        LastPageText="末页" PageSize="20" NextPageText="下一页&nbsp;>" PrevPageText="<&nbsp;上一页" ShowBoxThreshold="0" 
                        LayoutType="Table" NumericButtonCount="5" CustomInfoHTML="共 %PageCount% 页" ShowPageIndexBox="Never"
                        UrlPaging="true" ShowCustomInfoSection="Never" CurrentPageButtonClass="null">
                    </webdiyer:AspNetPager>
                </div>
                <div class="ui-question-message">
                  <h2 class="ui-title-solid">发布留言</h2>
                  <p><span>提问用户：</span>&nbsp;<asp:Literal ID="lbAccounts" runat="server"></asp:Literal></p>
                  <p><span>内容：&nbsp;</span><asp:TextBox ID="txtContent" runat="server" Width="400" TextMode="MultiLine" Height="120"></asp:TextBox></p>
                  <p><asp:Button ID="btnPublish" runat="server" Text="发表留言" OnClientClick="return checkInput()" CssClass="ui-btn-1" OnClick="btnPublish_Click" /></p>
                </div>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>

    <!--尾部开始-->
    <qp:Footer ID="sFooter" runat="server" />
    <!--尾部结束-->
</body>
</html>
<script type="text/javascript">
    function checkInput() {
        if ($.trim($("#txtContent").val()) == "") {
            alert("请输入内容！");
            $("#txtContent").focus();
            return false;
        }
        if ($("#txtContent").val().length > 4000) {
            alert("内容长度不能超过4000个字符！");
            return false;
        }
    }

    var isExecute = true;
    var vFeedID = "";

    function GetMessage(obj) {
        if (!isExecute) return;

        if (vFeedID == obj) return;
        vFeedID = obj;

        isExecute = false;

        $.ajax({
            contentType: "application/json",
            url: "/WS/WSNativeWeb.asmx/GetFeedBack",
            data: "{feedID:'" + obj + "'}",
            type: "POST",
            dataType: "json",
            success: function(json) {
                json = eval("(" + json.d + ")");

                if (json.success == "error") {
                    $("#tblFeed").slideUp(200);
                    return;
                } else if (json.success == "success") {
                    $("#tblFeed").slideUp(100);
                    $("#tblFeed").slideDown(400);

                    $("#lblUser").html(json.userName);
                    $("#lblContent").html(json.fcon);
                    if (json.rcon == "")
                        $("#trMessage").hide();
                    else {
                        $("#trMessage").show();
                        $("#lblMessage").html(json.rcon);
                    }

                    $("#id" + obj).text(json.count);
                    window.setTimeout(function() { isExecute = true; }, 500);
                }
            },
            error: function(err, ex) {
                alert(err.responseText);
            }
        });
    }

    //更新验证码
    function UpdateImage() {
        document.getElementById("picVerifyCode").src = "/ValidateImage.aspx?r=" + Math.random();
    }
</script>